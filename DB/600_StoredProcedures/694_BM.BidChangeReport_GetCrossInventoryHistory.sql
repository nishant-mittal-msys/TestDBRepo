USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Nishant Mittal	
-- Create date: 12/11/19
-- Description:	Get all won parts inventory list
-- =============================================
CREATE or ALTER PROCEDURE [BM].[BidChangeReport_GetCrossInventoryHistory] (
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

	;WITH CTE(
		ID
		,CrossPartInventoryId
		,BidPartId
		,CustomerPartNumber
		,ManufacturerPartNumber
		,PartDescription
		,CrossPartId
		,CrossPoolNumber
		,CrossPartNumber
		,CrossPartDescription
		,CrossPrice
		,CrossICOST		
		,Location
		,StockingType
		,CustPartUOM
		,EstimatedAnnualUsage
		,NewPool
		,NewPartNo
		,NewPrice
		,IsActive		
		,LastUpdatedBy
		,LastUpdatedOn
		,EventType
		,ActionType
		,ColumnsUpdated
		,[Rank])
		AS(
	SELECT 
		ID
		,CPIH.CrossPartInventoryId
		,BP.BidPartId
		,BP.CustomerPartNumber
		,BP.ManufacturerPartNumber
		,BP.PartDescription
		,CP.CrossPartId
		,CP.PoolNumber AS CrossPoolNumber
		,CP.PartNumber AS CrossPartNumber
		,CP.PartDescription AS CrossPartDescription
		,CP.PriceToQuote AS CrossPrice
		,CP.ICOST AS CrossICOST		
		,CPIH.[Location]		
		,''--inv.IType As StockingType
		,CPIH.CustPartUOM
		,CPIH.EstimatedAnnualUsage
		,ISNULL(CPIH.NewPool, cp.PoolNumber) AS NewPool
		,ISNULL(CPIH.NewPartno, CP.PartNumber) AS NewPartNo
		,(CASE WHEN CPIH.NewPartno is null then cp.PriceToQuote else CPIH.NewPrice end) AS NewPrice
		,CPIH.IsActive		
		,CPIH.LastUpdatedBy
		,CPIH.LastUpdatedOn
		,CASE WHEN CPIH.EventType = 'INSERT' THEN 'ADDED' 
			WHEN CPIH.EventType = 'UPDATE' THEN 'UPDATED'
			WHEN CPIH.EventType = 'DELETE' THEN 'DELETED' 
			END AS EventType
		,CPIH.ActionType
		,CPIH.ColumnsUpdated
		,ROW_NUMBER() OVER (PARTITION BY CPIH.CrossPartInventoryId, CPIH.[Location] ORDER BY CPIH.LastUpdatedOn DESC ) as [Rank]
	FROM 
	FPCAPPS.BM.CrossPartInventoryHistory CPIH (nolock)
	LEFT JOIN FPCAPPS.BM.CrossPart CP (nolock) ON CP.CrossPartId = CPIH.CrossPartId
	LEFT JOIN FPCAPPS.BM.BidPart BP (nolock) ON BP.BidPartId = CP.BidPartId
	WHERE CPIH.BidId = @BidId AND CPIH.EventType in ('INSERT', 'UPDATE')
	--AND CPIH.CrossPartInventoryId IN 
	--(SELECT DISTINCT --AT LEAST ONE RECORD SHOULD BE UPDATE RECORD
	--		CTE.CrossPartInventoryId
	--	FROM FPCAPPS.BM.CrossPartInventoryHistory CTE 
	--	WHERE CTE.BidId = @BidId and CTE.EventType = 'UPDATE') 
		)
	SELECT 
		C.ID
		,C.CrossPartInventoryId
		,c.BidPartId
		,c.CustomerPartNumber
		,c.ManufacturerPartNumber
		,c.PartDescription
		,c.CrossPartId
		,c.CrossPoolNumber
		,c.CrossPartNumber
		,c.CrossPartDescription
		,c.CrossPrice
		,c.CrossICOST		
		,c.[Location]		
		,inv.IType As StockingType
		,c.CustPartUOM
		,c.EstimatedAnnualUsage
		,C.NewPool
		,C.NewPartNo
		,C.NewPrice
		,c.IsActive		
		,c.LastUpdatedBy
		,c.LastUpdatedOn
		,C.EventType
		,c.ActionType
		,c.ColumnsUpdated
		,C.[Rank]
	FROM
		CTE C
		LEFT JOIN [FPBIDW].edw.FactInventory inv (nolock) on 
			c.NewPartNo = inv.PartNumber
			AND c.NewPool = inv.Pool 
			AND c.Location = inv.Location
			AND inv.Company = @Company
END
GO

--select CrossPartInventoryId, count(*) from FPCAPPS.BM.CrossPartInventoryHistory where EventType = 'update' group by CrossPartInventoryId having count(*) > 1
--select * from FPCAPPS.BM.CrossPartInventoryHistory where CrossPartInventoryId = 1386 order by 

--select * from bm.Bid where bidname = 'test bid'
--select * from FPCAPPS.BM.CrossPartInventoryHistory where bidid = 1129 

--SELECT DISTINCT
--			CTE.CrossPartInventoryId
--		FROM FPCAPPS.BM.CrossPartInventoryHistory CTE 
--		WHERE CTE.BidId = 1129 and CPIH.EventType = 'UPDATE'
