USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal
-- Create date: 07/08/19
-- Description:	save the crosses found in product master table
-- =============================================
CREATE
	OR

ALTER PROC [BM].[CrossEntry_SaveDbFoundPoolPart] (
	@CrowdSourcingPartId INT
	,@PartNo NVARCHAR(30)
	,@SSFlip BIT
	,@Pool INT = NULL
	,@ProductKey INT
	,@IsCrossReport INT
	,@Source NVARCHAR(50) = NULL
	,@UserId NVARCHAR(50)
	,@AffectedRowId INT = NULL OUTPUT
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Compy INT = NULL

	SET @Compy = (
			SELECT Bid.Company
			FROM BM.Bid Bid  (nolock)
			INNER JOIN BM.BidPart BP  (nolock) ON Bid.BidId = BP.BidId
			WHERE BidPartId = @CrowdSourcingPartId
			)

	IF (@IsCrossReport = 1)
		SET @CrowdSourcingPartId = (
				SELECT TOP 1 BidPartId
				FROM BM.BidPart  (nolock)
				WHERE BidPartId = @CrowdSourcingPartId
				)

	IF EXISTS (
			SELECT PartNumber
			FROM BM.CrossPart  (nolock)
			WHERE PartNumber = @PartNo
				AND BidPartId = @CrowdSourcingPartId
				AND PoolNumber = @Pool
			)
	BEGIN
		SET @AffectedRowId = - 1
	END
	ELSE
	BEGIN
		INSERT INTO BM.CrossPart (
			BidPartId
			,CrossRank
			,Company
			,ReferenceTableName
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
			,IsFlip
			,[Source]
			--,IsFinalized
			,CreatedBy
			,CreatedOn
			)
		SELECT TOP 1 @CrowdSourcingPartId
			,0
			,@Compy
			,'INMNPM'
			,prod.PartNumber
			,prod.[Pool]
			,prod.PartDesciption
			,prod.Category
			,dv.VendorNumber
			,CASE 
				WHEN prod.PrivateBrand NOT IN (
						'NA'
						,'N/A'
						,'Unknown'
						)
					AND prod.PrivateBrand IS NOT NULL
					THEN 'Private Brand -' + PrivateBrand
				ELSE dv.VendorName
				END
			,isnull(vg.ColorCode, 'Y')
			,vg.[DEFINITION]
			,prod.ManufactureName
			,0
			,@SSFlip
			,@Source
			--,0
			,@UserId
			,GETDATE()
		FROM [FPBIDW].[EDW].[DimProduct] prod  (nolock)
		LEFT JOIN [FPBIDW].[EDW].[DimVendor] dv WITH (NOLOCK) ON dv.vendorkey = prod.vendorkey
		LEFT JOIN FPCAPPS.BM.VendorGrade vg WITH (NOLOCK) ON dv.VendorNumber = cast(vg.VendorNumber AS DECIMAL(9, 0))
			AND prod.Category = vg.Category
		WHERE prod.ProductKey = @ProductKey

		SET @AffectedRowId = SCOPE_IDENTITY()

		IF (@IsCrossReport = 1)
			UPDATE BM.CrossPart
			SET ValidationStatus = 'A'
			WHERE CrossPartId = @AffectedRowId
	END
END
