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
CREATE or ALTER PROCEDURE [BM].[Inventory_GetWonPartsInventoryList] (
	@BidId INT
	,@UserId NVARCHAR(100) = NULL
	,@UserRole VARCHAR(50) = NULL
	)
AS
BEGIN
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
		,CPI.StockingType
		,CPI.CustPartUOM
		,CPI.EstimatedAnnualUsage
		,CPI.NewPool
		,CPI.NewPartNo
		,CPI.NewStockingType
		,CPI.NewPrice
		,CPI.IsActive		
		,CPI.LastUpdatedBy
		,CPI.LastUpdatedOn
	FROM FPCAPPS.BM.BidPart BP (nolock) 
	LEFT JOIN FPCAPPS.BM.CrossPart CP  (nolock) ON BP.BidPartId = CP.BidPartId
	LEFT JOIN FPCAPPS.BM.CrossPartInventory CPI  (nolock) ON CP.CrossPartId = CPI.CrossPartId
	WHERE BP.BidId = @BidId
		AND CP.IsWon = 1
END
GO


