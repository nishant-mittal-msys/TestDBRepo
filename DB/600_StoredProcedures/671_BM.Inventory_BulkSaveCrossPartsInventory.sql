USE [FPCAPPS]
GO

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal	
-- Create date: 12/11/19
-- Description:	Save Cross Parts Inventory
-- =============================================
CREATE OR ALTER PROCEDURE [BM].[Inventory_BulkSaveCrossPartsInventory] (
	@BidId INT
	,@CrossPartInventoryUDT AS BM.[CrossPartInventoryUDT] READONLY
	,@UserId NVARCHAR(100) = NULL
	,@UserRole VARCHAR(50) = NULL
	)
AS
BEGIN
	DECLARE @Company TINYINT = 1

	SET @Company = (
			SELECT top 1 Company
			FROM BM.Bid
			WHERE BidId = @BidId
			)

	DECLARE @PartsToBeUpdated AS BM.[CrossPartInventoryUDT]
	DECLARE @PartsToBeInserted AS BM.[CrossPartInventoryUDT]

	---COLLECT THE LIST OF PARTS TO BE UPDATED
	INSERT INTO @PartsToBeUpdated(
			BidId
			,BidPartId
			,CrossPartId
			,CustomerPartNumber 
			,ManufacturerPartNumber 
			,CrossPoolNumber 
			,CrossPartNumber
			,CrossPrice 
			,Location 
			,CustPartUOM 
			,EstimatedAnnualUsage 
			,NewPool
			,NewPartNo
			,NewPrice
			,IsActive)
	SELECT distinct
			cpi.BidId
			,bp.BidPartId
			,cp.CrossPartId
			,cpiUDT.CustomerPartNumber 
			,cpiUDT.ManufacturerPartNumber 
			,cpiUDT.CrossPoolNumber 
			,cpiUDT.CrossPartNumber
			,cpiUDT.CrossPrice 
			,cpiUDT.Location 
			,cpiUDT.CustPartUOM 
			,cpiUDT.EstimatedAnnualUsage 
			,cpiUDT.NewPool
			,cpiUDT.NewPartNo
			,cpiUDT.NewPrice
			,cpiUDT.IsActive
	FROM 
		@CrossPartInventoryUDT cpiUDT	
		INNER JOIN FPCAPPS.BM.CrossPart CP  (nolock) ON CP.PoolNumber = cpiUDT.CrossPoolNumber
			AND CP.PartNumber = cpiUDT.CrossPartNumber
			AND CP.IsWon = 1
		INNER JOIN FPCAPPS.BM.BidPart BP  (nolock) ON BP.BidPartId = CP.BidPartId
			AND isnull(BP.CustomerPartNumber, '') = isnull(cpiUDT.CustomerPartNumber, '')
			AND isnull(BP.ManufacturerPartNumber, '') = isnull(cpiUDT.ManufacturerPartNumber, '')
		INNER JOIN BM.CrossPartInventory CPI  (nolock) 
			ON cp.CrossPartId = CPI.CrossPartId 
			AND cpiUDT.Location  = CPI.Location 
			AND BP.BidId = cpi.BidId
		WHERE CPI.BidId = @BidId

	--select * from @PartsToBeUpdated

	--DECIDE THE PARTS TO BE INSERTED
	INSERT INTO @PartsToBeInserted(
			CustomerPartNumber 
			,ManufacturerPartNumber 
			,CrossPoolNumber 
			,CrossPartNumber
			,CrossPrice 
			,Location 
			,CustPartUOM 
			,EstimatedAnnualUsage 
			,NewPool
			,NewPartNo
			,NewPrice
			,IsActive)
	SELECT distinct
			cpiUDT.CustomerPartNumber as [cpiUDT.CustomerPartNumber]
			,cpiUDT.ManufacturerPartNumber 
			,cpiUDT.CrossPoolNumber 
			,cpiUDT.CrossPartNumber
			,cpiUDT.CrossPrice 
			,cpiUDT.Location 
			,cpiUDT.CustPartUOM 
			,cpiUDT.EstimatedAnnualUsage 
			,cpiUDT.NewPool
			,cpiUDT.NewPartNo
			,cpiUDT.NewPrice
			,cpiUDT.IsActive
	FROM 
		@CrossPartInventoryUDT cpiUDT
		LEFT JOIN @PartsToBeUpdated pu
			ON ISNULL(cpiUDT.CustomerPartNumber, '') = ISNULL(pu.CustomerPartNumber, '')
			AND ISNULL(cpiUDT.ManufacturerPartNumber, '')  = ISNULL(pu.ManufacturerPartNumber, '')
			AND isnull(cpiUDT.CrossPoolNumber, 0)  = isnull(pu.CrossPoolNumber, 0)
			AND isnull(cpiUDT.CrossPartNumber, '') = isnull(pu.CrossPartNumber, '')
			AND isnull(cpiUDT.CrossPrice, 0) = isnull(pu.CrossPrice, 0)
			AND isnull(cpiUDT.Location, '') = isnull(pu.Location, '')
			AND isnull(cpiUDT.CustPartUOM, 0) = isnull(pu.CustPartUOM, 0)
			AND isnull(cpiUDT.EstimatedAnnualUsage, 0) = isnull(pu.EstimatedAnnualUsage, 0)
			AND isnull(cpiUDT.NewPool, 0) = isnull(pu.NewPool, 0)
			AND isnull(cpiUDT.NewPartNo, '') = isnull(pu.NewPartNo, '') 
			AND isnull(cpiUDT.NewPrice, 0) = isnull(pu.NewPrice, 0)
			AND isnull(cpiUDT.IsActive, 0) = isnull(pu.IsActive, 0) 
	WHERE
		pu.CustomerPartNumber IS NULL
			AND pu.ManufacturerPartNumber IS NULL
			AND pu.CrossPoolNumber  IS NULL
			AND pu.CrossPartNumber IS NULL
			AND pu.CrossPrice IS NULL
			AND pu.Location IS NULL
			AND pu.CustPartUOM IS NULL
			AND pu.EstimatedAnnualUsage IS NULL
			AND pu.NewPool IS NULL
			AND pu.NewPartNo IS NULL
			AND pu.NewPrice IS NULL
			AND pu.IsActive IS NULL;

	--select * from @PartsToBeInserted;

	UPDATE CPI  SET
		CPI.BidId = @BidId
		,CPI.CustPartUOM = cpiUDT.CustPartUOM
		,CPI.EstimatedAnnualUsage = cpiUDT.EstimatedAnnualUsage
		,CPI.NewPool = cpiUDT.NewPool
		,CPI.NewPartNo = cpiUDT.NewPartNo
		,CPI.NewPrice = cpiUDT.NewPrice
		,CPI.NewStockingType = newpartINV.IType
		,CPI.IsActive = cpiUDT.IsActive
		,CPI.StockingType = cpINV.IType
		,CPI.LastUpdatedBy = @UserId
		,CPI.LastUpdatedOn = GETDATE()
	FROM 
		@PartsToBeUpdated cpiUDT
		INNER JOIN BM.CrossPartInventory CPI  (nolock) ON CPI.CrossPartId = cpiUDT.CrossPartId
			AND ISNULL(CPI.Location, '') = ISNULL(cpiUDT.Location, '')
		left JOIN [FPBIDW].edw.FactInventory newpartINV  (nolock) ON ltrim(rtrim(cpiUDT.NewPartNo)) = ltrim(rtrim(newpartINV.PartNumber))
			AND cpiUDT.NewPool = newpartINV.Pool
			AND cpiUDT.Location = newpartINV.Location
			and @Company = newpartINV.Company
		left JOIN [FPBIDW].edw.FactInventory cpINV  (nolock) ON ltrim(rtrim(ISNULL(cpiUDT.CrossPartNumber, ''))) = ltrim(rtrim(ISNULL(cpINV.PartNumber, '')))
			AND cpiUDT.CrossPoolNumber = cpINV.Pool
			AND cpiUDT.Location = cpINV.Location
			AND @Company = cpINV.Company
	WHERE cpi.BidId = @BidId

	INSERT INTO BM.CrossPartInventory (
		BidId
		,CrossPartId
		,[Location]
		,CustPartUOM
		,EstimatedAnnualUsage
		,NewPool
		,NewPartNo
		,NewPrice
		,NewStockingType
		,IsActive
		,StockingType
		,LastUpdatedBy
		,LastUpdatedOn
		)
	SELECT @BidId
		,CP.CrossPartId
		,cpiUDT.[Location]
		,cpiUDT.CustPartUOM
		,cpiUDT.EstimatedAnnualUsage
		,cpiUDT.NewPool
		,cpiUDT.NewPartNo
		,cpiUDT.NewPrice
		,newpartINV.IType AS NewStockingType
		,cpiUDT.IsActive
		,cpINV.IType AS StockingType
		,@UserId
		,GETDATE()
	FROM @PartsToBeInserted cpiUDT
	INNER JOIN FPCAPPS.BM.CrossPart CP  (nolock) ON CP.PoolNumber = cpiUDT.CrossPoolNumber
		AND ISNULL(CP.PartNumber, '') = ISNULL(cpiUDT.CrossPartNumber, '')
		AND CP.IsWon = 1
	INNER JOIN FPCAPPS.BM.BidPart BP  (nolock) ON BP.BidPartId = CP.BidPartId
		AND isnull(BP.CustomerPartNumber, '') = isnull(cpiUDT.CustomerPartNumber, '')
		AND isnull(BP.ManufacturerPartNumber, '') = isnull(cpiUDT.ManufacturerPartNumber, '')
	left JOIN [FPBIDW].edw.FactInventory newpartINV  (nolock) ON ltrim(rtrim(cpiUDT.NewPartNo)) = ltrim(rtrim(newpartINV.PartNumber))
		AND cpiUDT.NewPool = newpartINV.Pool
		AND cpiUDT.Location = newpartINV.Location
		and @Company = newpartINV.Company
	left JOIN [FPBIDW].edw.FactInventory cpINV  (nolock) ON ltrim(rtrim(cpiUDT.CrossPartNumber)) = ltrim(rtrim(cpINV.PartNumber))
		AND cpiUDT.CrossPoolNumber = cpINV.Pool
		AND cpiUDT.Location = cpINV.Location
		AND @Company = cpINV.Company
	WHERE BP.BidId = @BidId
		
END

-- test udt

	--SET ANSI_NULLS OFF
	--declare @BidId INT = 1131
	--DECLARE @Company int = 1
	--declare @UserId NVARCHAR(100) = 'Nishant.Mittal'
	--declare @UserRole VARCHAR(50) = 'SuperUser'
	--Declare @CrossPartInventoryUDT AS BM.[CrossPartInventoryUDT]
	--insert into @CrossPartInventoryUDT(CustomerPartNumber, CrossPoolNumber, CrossPartNumber, Location, EstimatedAnnualUsage, IsActive) values(55,604,26502,'ABQ',102,'Yes')
	--insert into @CrossPartInventoryUDT(CustomerPartNumber, CrossPoolNumber, CrossPartNumber, Location, EstimatedAnnualUsage, IsActive) values(55,604,26502,'ABV',100,'Yes')
	--insert into @CrossPartInventoryUDT(CustomerPartNumber, CrossPoolNumber, CrossPartNumber, Location, EstimatedAnnualUsage, IsActive) values(33,6830,33,'ABQ',100,'Yes')
	--insert into @CrossPartInventoryUDT(CustomerPartNumber, CrossPoolNumber, CrossPartNumber, Location, EstimatedAnnualUsage, IsActive) values(33,6830,33,'ABV',100,'Yes')
	--insert into @CrossPartInventoryUDT(CustomerPartNumber, CrossPoolNumber, CrossPartNumber, Location, EstimatedAnnualUsage, IsActive) values(33,6830,33,'AA',100,'Yes')
	--select * from @CrossPartInventoryUDT

	--exec [BM].[Inventory_BulkSaveCrossPartsInventory] @BidId, @CrossPartInventoryUDT, @UserId, @UserRole

	--	DECLARE @PartsToBeUpdated AS BM.[CrossPartInventoryUDT]
	--DECLARE @PartsToBeInserted AS BM.[CrossPartInventoryUDT]

	---COLLECT THE LIST OF PARTS TO BE UPDATED
	--INSERT INTO @PartsToBeUpdated(
	--		BidId
	--		,BidPartId
	--		,CrossPartId
	--		,CustomerPartNumber 
	--		,ManufacturerPartNumber 
	--		,CrossPoolNumber 
	--		,CrossPartNumber
	--		,CrossPrice 
	--		,Location 
	--		,CustPartUOM 
	--		,EstimatedAnnualUsage 
	--		,NewPool
	--		,NewPartNo
	--		,NewPrice
	--		,IsActive)
	--SELECT distinct
	--		cpi.BidId
	--		,bp.BidPartId
	--		,cp.CrossPartId
	--		,cpiUDT.CustomerPartNumber 
	--		,cpiUDT.ManufacturerPartNumber 
	--		,cpiUDT.CrossPoolNumber 
	--		,cpiUDT.CrossPartNumber
	--		,cpiUDT.CrossPrice 
	--		,cpiUDT.Location 
	--		,cpiUDT.CustPartUOM 
	--		,cpiUDT.EstimatedAnnualUsage 
	--		,cpiUDT.NewPool
	--		,cpiUDT.NewPartNo
	--		,cpiUDT.NewPrice
	--		,cpiUDT.IsActive
	--FROM 
	--	@CrossPartInventoryUDT cpiUDT		
	--	INNER JOIN FPCAPPS.BM.CrossPart CP ON CP.PoolNumber = cpiUDT.CrossPoolNumber
	--		AND CP.PartNumber = cpiUDT.CrossPartNumber
	--		AND CP.IsWon = 1
	--	INNER JOIN FPCAPPS.BM.BidPart BP ON BP.BidPartId = CP.BidPartId
	--		AND isnull(BP.CustomerPartNumber, '') = isnull(cpiUDT.CustomerPartNumber, '')
	--		AND isnull(BP.ManufacturerPartNumber, '') = isnull(cpiUDT.ManufacturerPartNumber, '')
	--	INNER JOIN BM.CrossPartInventory CPI 
	--		ON cp.CrossPartId = CPI.CrossPartId 
	--		AND cpiUDT.Location  = CPI.Location 
	--		AND BP.BidId = cpi.BidId
	--	WHERE CPI.BidId = @BidId

	--select * from @PartsToBeUpdated

	--DECIDE THE PARTS TO BE INSERTED
	--INSERT INTO @PartsToBeInserted(
	--		CustomerPartNumber 
	--		,ManufacturerPartNumber 
	--		,CrossPoolNumber 
	--		,CrossPartNumber
	--		,CrossPrice 
	--		,Location 
	--		,CustPartUOM 
	--		,EstimatedAnnualUsage 
	--		,NewPool
	--		,NewPartNo
	--		,NewPrice
	--		,IsActive)
	--SELECT distinct
	--		cpiUDT.CustomerPartNumber 
	--		,cpiUDT.ManufacturerPartNumber 
	--		,cpiUDT.CrossPoolNumber 
	--		,cpiUDT.CrossPartNumber
	--		,cpiUDT.CrossPrice 
	--		,cpiUDT.Location 
	--		,cpiUDT.CustPartUOM 
	--		,cpiUDT.EstimatedAnnualUsage 
	--		,cpiUDT.NewPool
	--		,cpiUDT.NewPartNo
	--		,cpiUDT.NewPrice
	--		,cpiUDT.IsActive
	--FROM 
	--	@CrossPartInventoryUDT cpiUDT
	--	LEFT JOIN @PartsToBeUpdated pu
	--		ON cpiUDT.CustomerPartNumber = pu.CustomerPartNumber 
	--		AND cpiUDT.ManufacturerPartNumber  = pu.ManufacturerPartNumber 
	--		AND cpiUDT.CrossPoolNumber  = pu.CrossPoolNumber 
	--		AND cpiUDT.CrossPartNumber = pu.CrossPartNumber
	--		AND cpiUDT.CrossPrice = pu.CrossPrice
	--		AND cpiUDT.Location = pu.Location 
	--		AND cpiUDT.CustPartUOM = pu.CustPartUOM 
	--		AND cpiUDT.EstimatedAnnualUsage = pu.EstimatedAnnualUsage 
	--		AND cpiUDT.NewPool = pu.NewPool 
	--		AND cpiUDT.NewPartNo = pu.NewPartNo 
	--		AND cpiUDT.NewPrice = pu.NewPrice 
	--		AND cpiUDT.IsActive = pu.IsActive 
	--WHERE
	--	pu.CustomerPartNumber IS NULL
	--		AND pu.ManufacturerPartNumber IS NULL
	--		AND pu.CrossPoolNumber  IS NULL
	--		AND pu.CrossPartNumber IS NULL
	--		AND pu.CrossPrice IS NULL
	--		AND pu.Location IS NULL
	--		AND pu.CustPartUOM IS NULL
	--		AND pu.EstimatedAnnualUsage IS NULL
	--		AND pu.NewPool IS NULL
	--		AND pu.NewPartNo IS NULL
	--		AND pu.NewPrice IS NULL
	--		AND pu.IsActive IS NULL;

	--select * from @PartsToBeInserted;
	
	--select * from bm.[CrossPartInventory] where bidId = 1131
	--DELETE from bm.[CrossPartInventory] where bidId = 1131 
			
