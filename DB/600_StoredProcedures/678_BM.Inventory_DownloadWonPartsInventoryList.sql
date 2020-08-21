USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal	
-- Create date: 12/19/19
-- Description:	Download excel won parts inventory list
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[Inventory_DownloadWonPartsInventoryList] (@BidId INT)
AS
BEGIN
	SELECT BP.CustomerPartNumber AS [Customer Part Number]
		,BP.ManufacturerPartNumber AS [Manufacturer Part Number]
		,BP.PartDescription AS [Part Description]
		,CP.PoolNumber AS [FP Pool]
		,CP.PartNumber AS [FP Part No]
		,CP.PartDescription AS [FP Part Description]
		,CP.PriceToQuote AS [Price]
		,CPI.[Location] AS [Location]
		,CPI.EstimatedAnnualUsage AS [Estimated Annual Usage]
		,CPI.CustPartUOM AS [Cust Part UOM]
		,CPI.NewPool AS [New Pool]
		,CPI.NewPartNo AS [New Part No]
		,CPI.NewPrice AS [New Price]
		,CPI.IsActive AS [IsActive(Yes/No)]
	FROM FPCAPPS.BM.BidPart BP (nolock) 
	LEFT JOIN FPCAPPS.BM.CrossPart CP  (nolock) ON BP.BidPartId = CP.BidPartId
	LEFT JOIN FPCAPPS.BM.CrossPartInventory CPI  (nolock) ON CP.CrossPartId = CPI.CrossPartId
	WHERE BP.BidId = @BidId
		AND CP.IsWon = 1
END
