USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		M Vaqqas
-- Create date: 1/3/2019
-- Description:	Get parts Not Won for a bid
-- =============================================
CREATE or ALTER PROCEDURE [BM].[Reports_GetRevisedParts] (
	@BidId INT
	)
AS
BEGIN
DECLARE @Company TINYINT = 1

	SET @Company = (
			SELECT Company
			FROM BM.Bid
			WHERE BidId = @BidId
			)

	;with cte(
		BidPartId
		,CustomerPartNumber
		,ManufacturerPartNumber
		,PartDescription
		,CrossPartId
		,CrossPoolNumber
		,CrossPartNumber
		,CrossPartDescription
		,CrossPrice
		,CrossICOST
		,CrossPartInventoryId
		,Location
		,CustPartUOM
		,EstimatedAnnualUsage
		,NewPool
		,NewPartNo
		,NewPrice
		,LastUpdatedBy
		,LastUpdatedOn
		,Comments
		,RevisedPool
		,RevisedPartNumber)
		--,--INV.IType AS StockingType)
	as(
		SELECT BP.BidPartId
		,BP.CustomerPartNumber
		,BP.ManufacturerPartNumber
		,BP.PartDescription
		,CP.CrossPartId
		,CP.PoolNumber AS CrossPoolNumber
		,CP.PartNumber AS CrossPartNumber
		,CP.PartDescription AS CrossPartDescription
		,CP.PriceToQuote AS CrossPrice
		,CP.ICOST AS CrossICOST
		,CPI.CrossPartInventoryId
		,CPI.[Location]
		,CPI.CustPartUOM
		,CPI.EstimatedAnnualUsage
		,isnull(CPI.NewPool, CP.PoolNumber) as NewPool
		,isnull(CPI.NewPartNo, CP.PartNumber) as NewPartNo
		,CPI.NewPrice
		,CPI.LastUpdatedBy
		,CPI.LastUpdatedOn
		,CPLR.Comments
		,CPLR.RevisedPool
		,CPLR.RevisedPartNumber
		--,INV.IType AS StockingType
	FROM 
		FPCAPPS.BM.Bid b (nolock) 
		inner join FPCAPPS.BM.BidPart BP  (nolock) on b.BidId = BP.BidId
		inner join FPCAPPS.BM.CrossPart CP  (nolock) ON BP.BidPartId = CP.BidPartId
		inner join FPCAPPS.BM.CrossPartInventory CPI  (nolock) ON CP.CrossPartId = CPI.CrossPartId
		inner join FPCAPPS.BM.CrossPartLineReview cplr (nolock)  on CPI.CrossPartId = cplr.CrossPartId		
	WHERE
		B.BidId = @BidId
		AND CPI.IsActive = 'Yes'
		AND cplr.IsApproved = 0
		)
	SELECT 
		BidPartId
		,CustomerPartNumber
		,ManufacturerPartNumber
		,PartDescription
		,CrossPartId
		,CrossPoolNumber
		,CrossPartNumber
		,CrossPartDescription
		,CrossPrice
		,CrossICOST
		,CrossPartInventoryId
		,c.Location
		,CustPartUOM
		,EstimatedAnnualUsage
		,NewPool
		,NewPartNo
		,NewPrice
		,LastUpdatedBy
		,LastUpdatedOn
		,Comments
		,INV.IType AS StockingType
		,RevisedPool
		,RevisedPartNumber
	FROM CTE C
	left join [FPBIDW].edw.FactInventory inv  (nolock) 
	on C.NewPartNo = inv.PartNumber
			and C.NewPool = inv.Pool 
			and c.Location = inv.Location
	WHERE 
	(inv.Company = @Company  or inv.Company is null) 
END
GO

--EXEC [BM].[Reports_GetRevisedParts] 2282
