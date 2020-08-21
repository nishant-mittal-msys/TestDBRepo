USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal	
-- Create date: 12/16/19
-- Description:	Delete Cross Part Inventory
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[Inventory_DownloadLocationInventory] (
	@BidId INT
	,@LocationsUDT AS BM.[LocationsUDT] READONLY
	)
AS
BEGIN
	SELECT BP.CustomerPartNumber AS [Customer Part Number]
		,BP.ManufacturerPartNumber AS [Manufacturer Part Number]
		,BP.PartDescription AS [Part Description]
		,CP.PoolNumber AS [FP Pool]
		,CP.PartNumber AS [FP Part No]
		,CP.PartDescription AS [FP Part Description]
		--,CP.PriceToQuote AS [Price]
		,Loc.[Location] AS [Location]
		,CPI.EstimatedAnnualUsage AS [Estimated Annual Usage]
		,CPI.CustPartUOM AS [Cust Part UOM]
		,CPI.NewPool AS [New Pool]
		,CPI.NewPartNo AS [New Part No]			  
		,CPI.NewPrice AS [New Price]
		,ISNULL(CPI.IsActive, 'Yes') AS [IsActive(Yes/No)]
	FROM FPCAPPS.BM.BidPart BP (nolock) 
	LEFT JOIN FPCAPPS.BM.CrossPart CP  (nolock) ON BP.BidPartId = CP.BidPartId	
	CROSS JOIN @LocationsUDT Loc
	LEFT JOIN FPCAPPS.BM.CrossPartInventory CPI  (nolock) ON CPI.CrossPartId = CP.CrossPartId AND Loc.Location = CPI.Location
	WHERE BP.BidId = @BidId
		AND CP.IsWon = 1
END
