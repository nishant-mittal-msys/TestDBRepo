USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal
-- Create date: 12/20/19
-- Description:	Get all locations
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[Inventory_GetLocations] (@BidId INT)
AS
BEGIN
	SELECT [Location]
		,LocationName
		,TerritoryId
		,PriceRegion
	FROM [FPBIDW].[EDW].[DimLocation] (nolock) 
	WHERE Company = (
			SELECT Company
			FROM BM.Bid
			WHERE BidId = @BidId
			)
		AND STATUS = 'A'
		AND [Location] NOT IN (
			'N/A'
			,'Unknown'
			)
END
