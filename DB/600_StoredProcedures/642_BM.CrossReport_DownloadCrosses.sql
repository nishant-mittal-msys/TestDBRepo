USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gurpreet Singh	
-- Create date: 07/22/19
-- Description:	Download crosses in excel on cross report page
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[CrossReport_DownloadCrosses] (@BidId INT)
AS
BEGIN
	SELECT BP.CustomerPartNumber
	     ,BP.ManufacturerPartNumber
		 ,BP.PartDescription
		 ,BP.Manufacturer
		 ,BP.EstimatedAnnualUsage
		,CP.ReferenceTableName AS [Reference Table]
		, CP.FinalPreference AS [Preference]
		,Case WHEN CP.PartNumber IS NULL OR CP.PartNumber = '' THEN 'No Cross Found' ELSE CP.PartNumber END AS [Cross Part]
		,cast(CP.PoolNumber AS VARCHAR) AS [Cross Pool]
		,CP.PartDescription AS [Cross Description]
		,CP.PartCategory AS [Cross Category]
		,CP.VendorName AS [Vendor Name]
		,CP.VendorColorDefinition AS [Vendor Status]
		,LR.[DC Stock Count] AS DCStockCount
		,LR.[S] AS StoresStockCount
		,LR.[Natl Count L12 Stores Sold] AS NationalL12StoresSold
		,LR.[Local Count L12 Stores Sold] AS LocalL12StoresSold
		,LR.[L12 Units] As L12Units
		,LR.[L12 Revenue] As L12Revenue
		,LR. [Current NPM Part Type] As NPMPartType
	FROM FPCAPPS.BM.BidPart BP (nolock)
	LEFT JOIN FPCAPPS.BM.CrossPart CP (nolock) ON CP.BidPartId = BP.BidPartId
	LEFT JOIN FPCAPPS.SICF.ALLCATS_LineReview101 LR (nolock) ON  CP.PartNumber = LR.[Part Number] and CP.PoolNumber = LR.Pool
	LEFT JOIN FPCAPPS.BM.VendorPriority VP (nolock) ON CP.VendorColor = VP.Color
	WHERE BP.BidId = @BidId
	ORDER BY BP.BidPartId
		,CASE 
			WHEN Priority IS NULL
				THEN 100
			ELSE Priority
			END 
END
