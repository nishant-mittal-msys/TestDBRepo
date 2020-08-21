USE [FPCAPPS]
GO

/****** Object:  StoredProcedure [com].[SP_BidLoad_ValidateParts]    Script Date: 6/24/2019 4:11:32 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ==============================================
-- Author:		Vaqqas
-- Create date: 07/01/19
-- Description:	Generate crosses for the bid part
-- ==============================================


CREATE OR ALTER PROC BM.[UploadBidPart_GenerateCrosses] (
	@BidId INT
	,@UserId VARCHAR(200)
	)
AS
BEGIN
	DECLARE @source VARCHAR(100) = 'system'

	UPDATE BM.Bid
	SET BidStatus = 'GeneratingCrosses'
	WHERE BidID = @BidId

	BEGIN TRY
		 IF OBJECT_ID('tempdb..#TempBidParts') IS NOT NULL
         DROP TABLE #TempBidParts;
		--temp table used to keep track of bidparts for which crosses have already been found.
		         
		--Get the Bid parts which are waiting for a cross.		
		SELECT DISTINCT b.Company
			,bp.BidPartID
			,CASE WHEN bp.CleanCustomerPartNumber = '' THEN NULL ELSE  bp.CleanCustomerPartNumber END  AS CleanCustomerPartNumber
			,CASE WHEN bp.CleanManufacturerPartNumber = '' THEN NULL ELSE bp.CleanManufacturerPartNumber END AS CleanManufacturerPartNumber
			,CASE WHEN bp.CustomerPartNumber = '' THEN  NULL ELSE bp.CustomerPartNumber END AS CustomerPartNumber
			,CASE WHEN bp.ManufacturerPartNumber = '' THEN NULL ELSE bp.ManufacturerPartNumber END AS ManufacturerPartNumber
		INTO #TempBidParts
		FROM FPCAPPS.BM.Bid b(NOLOCK)
		INNER JOIN FPCAPPS.BM.BidPart bp(NOLOCK) ON b.BidID = bp.BidID
		LEFT JOIN BM.CrossPart CP ON BP.BidPartId = CP.BidPartId
		WHERE b.BidID = @BidId
			AND CP.BidPartId IS NULL
			
		--proceed if there still some lonely bid parts
		IF EXISTS (
				SELECT TOP 1 BidPartID
				FROM #TempBidParts
				)
		BEGIN
			---------------------------------------------------------------------------
			--1. Get the already finalized crosses from BM.Crosses
			---------------------------------------------------------------------------
			INSERT INTO BM.CrossPart (
				BidPartId
				,CrossRank
				,ReferenceTableName
				,Source
				,PartNumber
				,PoolNumber
				,PartDescription
				,PartCategory
				,VendorNumber
				,VendorName
				,VendorColor
				,VendorColorDefinition
				,Manufacturer
				,IsFlip
				,IsNonFP
				,ValidationStatus
				,ValidatedBy
				,ValidatedOn
				,CreatedBy
				,CreatedOn
				--,FinalPreference // commented as its marking many parts as Primary automatically 
				,Comments
				,Company				
				)
			SELECT DISTINCT bp.BidPartId
				,cpOld.CrossRank
				,'BidManagementSystem'
				,@source
				,cpOld.PartNumber
				,cpOld.PoolNumber
				,cpOld.PartDescription
				,cpOld.PartCategory
				,cpOld.VendorNumber
				,cpOld.VendorName
				,vg.ColorCode
				,vg.DEFINITION
				,cpOld.Manufacturer
				,cpOld.IsFlip
				,cpOld.IsNonFP
				,cpOld.ValidationStatus
				,'system'
				,getdate()
				,@UserId
				,getdate()
				--,cpOld.FinalPreference // commented as its marking many parts as Primary automatically 
				,cpOld.Comments
				,cpOld.Company
			FROM #TempBidParts bp
			INNER JOIN FPCAPPS.BM.BidPart bpOld(NOLOCK) ON 
					(bpOld.CleanManufacturerPartNumber = BP.CleanManufacturerPartNumber
					OR bpOld.CleanCustomerPartNumber = bp.CleanCustomerPartNumber)					
			INNER JOIN FPCAPPS.BM.CrossPart cpOld(NOLOCK) ON cpOld.Company = bp.Company
				AND cpOld.BidPartId = bpOld.BidPartId
			LEFT OUTER JOIN FPCAPPS.BM.VendorGrade vg WITH (NOLOCK) ON cpOld.VendorNumber = cast(vg.VendorNumber AS DECIMAL(9, 0)) AND cpOld.PartCategory = vg.Category AND cpOld.PartCategory = vg.Category
			WHERE cpOld.FinalPreference IS NOT NULL
		 --remove the BidParts from the list for which crosses have been found 
		 -- (for now we will search in both BMS and Ecatalog, so commenting below two lines)
		--DELETE #TempBidParts
		--	FROM #TempBidParts B INNER JOIN BM.CrossPart CP ON B.BidPartId = CP.BidPartId

		END
		
		--proceed if there still some lonely bid parts
		IF EXISTS (
					SELECT TOP 1 BidPartID
					FROM #TempBidParts
					)
			BEGIN
				---------------------------------------------------------------------------
				--2. Get the matching parts from ECatalog with the matching part number--
				---------------------------------------------------------------------------
				INSERT INTO BM.CrossPart (
					BidPartId
					,CrossRank
					,ReferenceTableName
					,Source
					,PartNumber
					,PoolNumber
					,PartDescription
					,PartCategory
					,VendorNumber
					,VendorName
					,VendorColor
					,VendorColorDefinition
					,Manufacturer
					,IsNonFP
					,CreatedBy
					,CreatedOn
					,Company
					,ValidationStatus
					,ValidatedBy
					)
				SELECT DISTINCT bp.BidPartId
					,0
					,'ECatalog'
					,@source
					,prod.PartNumber
					,prod.Pool
					,prod.PartDesciption
					,prod.Category
					,dv.VendorNumber
					,CASE WHEN prod.PrivateBrand NOT IN ('NA','N/A', 'Unknown') AND prod.PrivateBrand IS NOT NULL Then 'Private Brand -' + PrivateBrand
					 ELSE dv.VendorName END 
					,vg.ColorCode
					,vg.DEFINITION
					,prod.ManufactureName
					,0
					,@UserId
					,getdate()
					,prod.Company
					,'A'
					,'system'
				FROM #TempBidParts bp
				INNER JOIN [FPCAPPS].[DBO].[ECatalogCrosses] ECat WITH (NOLOCK) ON 
					(ECat.FromPartNo = BP.CleanManufacturerPartNumber
						OR ECat.FromPartNo = BP.CleanCustomerPartNumber) 
				INNER JOIN [FPBIDW].[EDW].[DimProduct] prod WITH (NOLOCK) ON  bp.Company = prod.Company and prod.partnumber = Ecat.ToPartNo  AND prod.pool = ecat.toPoolNo and prod.pool not in ('555','556','0') 
				LEFT JOIN [FPBIDW].[EDW].[DimVendor] dv WITH (NOLOCK) ON dv.vendorkey = prod.vendorkey
				LEFT OUTER JOIN FPCAPPS.BM.VendorGrade vg WITH (NOLOCK) ON dv.VendorNumber = cast(vg.VendorNumber AS DECIMAL(9, 0))
					AND prod.Category = vg.Category 

			--remove the BidParts from the list for which crosses have been found
			DELETE #TempBidParts
			FROM #TempBidParts B INNER JOIN BM.CrossPart CP ON B.BidPartId = CP.BidPartId
	   END
				
			--proceed if there still some lonely bid parts
		IF EXISTS (
				SELECT TOP 1 BidPartID
				FROM #TempBidParts
				)
		BEGIN
				---------------------------------------------------------------------------
				--3. Get the matching parts from DimProduct with the matching part number--
				---------------------------------------------------------------------------
				INSERT INTO BM.CrossPart (
					BidPartId
					,CrossRank
					,ReferenceTableName
					,Source
					,PartNumber
					,PoolNumber
					,PartDescription
					,PartCategory
					,VendorNumber
					,VendorName
					,VendorColor
					,VendorColorDefinition
					,Manufacturer
					,IsNonFP
					,CreatedBy
					,CreatedOn
					,Company
					,ValidationStatus
					,ValidatedBy
					)
				SELECT DISTINCT bp.BidPartId
					,0
					,'INMNPM'
					,@source
					,prod.PartNumber
					,prod.Pool
					,prod.PartDesciption
					,prod.Category
					,dv.VendorNumber
					,CASE WHEN prod.PrivateBrand NOT IN ('NA','N/A', 'Unknown') AND prod.PrivateBrand IS NOT NULL Then 'Private Brand -' + PrivateBrand
					 ELSE dv.VendorName END 
					,vg.ColorCode
					,vg.DEFINITION
					,prod.ManufactureName
					,0
					,@UserId
					,getdate()
					,prod.Company
					,'A'
					,'system'
				FROM #TempBidParts bp
				INNER JOIN [FPBIDW].[EDW].[DimProduct] prod WITH (NOLOCK) ON prod.Company = bp.Company and prod.pool not in ('555','556','0')
					AND (prod.PartNumber = BP.CleanManufacturerPartNumber
						OR prod.PartNumber = BP.CleanCustomerPartNumber)
				LEFT JOIN [FPBIDW].[EDW].[DimVendor] dv WITH (NOLOCK) ON dv.vendorkey = prod.vendorkey
				LEFT OUTER JOIN FPCAPPS.BM.VendorGrade vg WITH (NOLOCK) ON dv.VendorNumber = cast(vg.VendorNumber AS DECIMAL(9, 0))
					AND prod.Category = vg.Category 
			--remove the BidParts from the list for which crosses have been found
			DELETE #TempBidParts
			FROM #TempBidParts B INNER JOIN BM.CrossPart CP ON B.BidPartId = CP.BidPartId
		END	

		

		IF EXISTS (
				SELECT TOP 1 BidPartID
				FROM #TempBidParts
				)
		BEGIN
				---------------------------------------------------------------------------
				--5. get the matching parts from INMVCROSS
				---------------------------------------------------------------------------
				INSERT INTO BM.CrossPart (
					BidPartId
					,CrossRank
					,ReferenceTableName
					,Source
					,PartNumber
					,PoolNumber
					,PartDescription
					,PartCategory
					,VendorNumber
					,VendorName
					,VendorColor
					,VendorColorDefinition
					,Manufacturer
					,IsNonFP
					,CreatedBy
					,CreatedOn
					,Company
					,ValidationStatus
					,ValidatedBy
					)
				SELECT DISTINCT BP.BidPartId
					,0
					,'INMVCROSS'
					,@source
					,prod.PartNumber
					,prod.Pool
					,prod.PartDesciption
					,prod.Category
					,dv.VendorNumber
					,CASE WHEN prod.PrivateBrand NOT IN ('NA','N/A', 'Unknown') AND prod.PrivateBrand IS NOT NULL Then 'Private Brand -' + PrivateBrand
					 ELSE dv.VendorName END 
					,vg.ColorCode
					,vg.DEFINITION
					,prod.ManufactureName
					,0
					,@UserId
					,getdate()
					,prod.Company
					,'A'
					,'system'
				FROM #TempBidParts bp
				INNER JOIN FPBISTG.dbo.INMVCROSS inm(NOLOCK) ON (inm.INMVCPART = bp.CleanManufacturerPartNumber
									OR inm.INMVCPART = bp.CleanCustomerPartNumber)
				INNER JOIN FPBIDW.EDW.DimProduct prod(NOLOCK) ON inm.INMVPART = prod.PartNumber 
					AND prod.Company = bp.Company and prod.pool not in ('555','556','0')
				LEFT JOIN [FPBIDW].[EDW].[DimVendor] dv WITH (NOLOCK) ON dv.vendorkey = prod.vendorkey
				LEFT OUTER JOIN FPCAPPS.BM.VendorGrade vg WITH (NOLOCK) ON dv.VendorNumber = cast(vg.VendorNumber AS DECIMAL(9, 0))
					AND prod.Category = vg.Category
			--remove the BidParts from the list for which crosses have been found
		DELETE #TempBidParts
			FROM #TempBidParts B INNER JOIN BM.CrossPart CP ON B.BidPartId = CP.BidPartId
		END
		

		IF EXISTS (
				SELECT TOP 1 BidPartID
				FROM #TempBidParts
				)
		BEGIN
				---------------------------------------------------------------------------
				--6. get the matching parts from INMCROSS
				---------------------------------------------------------------------------
				INSERT INTO BM.CrossPart (
					BidPartId
					,CrossRank
					,ReferenceTableName
					,Source
					,PartNumber
					,PoolNumber
					,PartDescription
					,PartCategory
					,VendorNumber
					,VendorName
					,VendorColor
					,VendorColorDefinition
					,Manufacturer
					,IsNonFP
					,CreatedBy
					,CreatedOn
					,Company
					,ValidationStatus
					,ValidatedBy
					)
				SELECT DISTINCT BP.BidPartId
					,0
					,'INMCROSS'
					,@source
					,prod.PartNumber
					,prod.Pool
					,prod.PartDesciption
					,prod.Category
					,dv.VendorNumber
					,CASE WHEN prod.PrivateBrand NOT IN ('NA','N/A', 'Unknown') AND prod.PrivateBrand IS NOT NULL Then 'Private Brand -' + PrivateBrand
						ELSE dv.VendorName END 
					,vg.ColorCode
					,vg.DEFINITION
					,prod.ManufactureName
					,0
					,@UserId
					,getdate()
					,prod.Company
					,'A'
					,'system'
				FROM #TempBidParts bp
				INNER JOIN FPBISTG.dbo.INMCROSS inm(NOLOCK) ON (
						(inm.FromPart = bp.CleanManufacturerPartNumber)
						OR (inm.FromPart = bp.CleanCustomerPartNumber)
						)
				INNER JOIN FPBIDW.EDW.DimProduct prod(NOLOCK) ON inm.TOPART = prod.PartNumber 
					AND prod.Company = bp.Company and prod.pool not in ('555','556','0')
				LEFT JOIN [FPBIDW].[EDW].[DimVendor] dv WITH (NOLOCK) ON dv.vendorkey = prod.vendorkey
				LEFT OUTER JOIN FPCAPPS.BM.VendorGrade vg WITH (NOLOCK) ON dv.VendorNumber = cast(vg.VendorNumber AS DECIMAL(9, 0))
				
					AND prod.Category = vg.Category

				--remove the BidParts from the list for which crosses have been found
		DELETE #TempBidParts
			FROM #TempBidParts B INNER JOIN BM.CrossPart CP ON B.BidPartId = CP.BidPartId
		END
	

		IF EXISTS (
				SELECT TOP 1 BidPartID
				FROM #TempBidParts
				)
		BEGIN
			---------------------------------------------------------------------------
			--7. get the matching parts from PSMCUSCRS
			---------------------------------------------------------------------------
			INSERT INTO BM.CrossPart (
				BidPartId
				,CrossRank
				,ReferenceTableName
				,Source
				,PartNumber
				,PoolNumber
				,PartDescription
				,PartCategory
				,VendorNumber
				,VendorName
				,VendorColor
				,VendorColorDefinition
				,Manufacturer
				,IsNonFP
				,CreatedBy
				,CreatedOn
				,Company
				,ValidationStatus
				,ValidatedBy
				)
			SELECT DISTINCT bp.BidPartId
				,0
				,'PSMCUSCRS'
				,@source
				,prod.PartNumber
				,prod.Pool
				,prod.PartDesciption
				,prod.Category
				,dv.VendorNumber
				,CASE WHEN prod.PrivateBrand NOT IN ('NA','N/A', 'Unknown') AND prod.PrivateBrand IS NOT NULL Then 'Private Brand -' + PrivateBrand
				  ELSE dv.VendorName END 
				,vg.ColorCode
				,vg.DEFINITION
				,prod.ManufactureName
				,0
				,@UserId
				,getdate()
				,prod.Company
				,'A'
				,'system'
			FROM #TempBidParts bp
			INNER JOIN FPBISTG.dbo.PSMCUSCRS psm(NOLOCK) ON (
					(psm.CPART# = CleanManufacturerPartNumber)
					OR (psm.CPART# = bp.CleanCustomerPartNumber)
					)
			INNER JOIN FPBIDW.EDW.DimProduct prod(NOLOCK) ON psm.Compy = prod.Company
				AND psm.PARTNO = prod.PartNumber and prod.pool not in ('555','556','0')
			LEFT JOIN [FPBIDW].[EDW].[DimVendor] dv WITH (NOLOCK) ON dv.vendorkey = prod.vendorkey
				LEFT OUTER JOIN FPCAPPS.BM.VendorGrade vg WITH (NOLOCK) ON dv.VendorNumber = cast(vg.VendorNumber AS DECIMAL(9, 0))				
				AND prod.Category = vg.Category
		END
						 

		IF OBJECT_ID('tempdb..#TempBidParts') IS NOT NULL
         DROP TABLE #TempBidParts;


		UPDATE BM.Bid
		SET BidStatus = 'CrossesGenerated'
		WHERE BidID = @BidId
	END TRY

	BEGIN CATCH
		DECLARE @vErrorMessage VARCHAR(2000);
		DECLARE @datetime AS VARCHAR(100) = convert(VARCHAR, getdate(), 20)

		SELECT @vErrorMessage = ERROR_MESSAGE();

		EXEC [BM].[ErrorLogging_Insert] @datetime
			,@vErrorMessage
			,NULL
			,'db'
			,@UserId
			,NULL;

		UPDATE BM.Bid
		SET BidStatus = 'Created'
			,Comments = 'Error occured while creating crosses for the Bid. Please try again.'
		WHERE BidID = @BidId
	END CATCH
END
	--Unit Test
	--exec BM.[UploadBidPart_GenerateCrosses] 1045, 'md.vaqqas'
