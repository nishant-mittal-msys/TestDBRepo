USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Vaqqas
-- Create date: 07/02/2019
-- Description:	Get all the crosses for the given bid part
-- =============================================
-- =============================================
-- Author:		Gurpreet Singh
-- Update date: 7/17/19
-- Description:	Get all validated & system generated crosses for a given bid part at cross report page 
-- =============================================
CREATE OR ALTER PROCEDURE [BM].[CrossReport_GetAllCrosses] (
	@BidId INT
	)
AS
BEGIN
	SELECT CrossPartId
		,CP.BidPartId AS BidPartId
		,CrossRank
		,ReferenceTableName
		,Source
		,Company
		,PartNumber
		,PoolNumber
		,CP.PartDescription AS PartDescription
		,PartCategory
		,VendorNumber
		,VendorColor
		,VendorColorDefinition
		,VendorName
		,CP.Manufacturer AS Manufacturer
		,IsFlip
		,IsNonFP
		,ValidationStatus
		,CP.ValidatedBy AS ValidatedBy
		,CP.ValidatedOn AS ValidatedOn
		,CP.CreatedBy AS CreatedBy
		,CP.CreatedOn AS CreatedOn
		,FinalPreference
		,CP.Comments AS Comments
		,PriceToQuote
		,SuggestedPrice
		,ICOST
		,Margin
		,AdjustedICost
		,AdjustedMargin
		,IsWon
		,LR.[DC Stock Count] AS DCStockCount
		,LR.[S] AS StoresStockCount
		,LR.[Natl Count L12 Stores Sold] AS NationalL12StoresSold
		,LR.[Local Count L12 Stores Sold] AS LocalL12StoresSold
		,LR.[L12 Units] As L12Units
		,LR.[L12 Revenue] As L12Revenue
		,LR. [Current NPM Part Type] As NPMPartType
		,CASE WHEN Priority IS NULL THEN 100 ELSE Priority END as PartPriority
	FROM 
	[FPCAPPS].BM.BidPart bp  (nolock)
	INNER JOIN [FPCAPPS].BM.CrossPart  CP (nolock) on bp.BidPartId = cp.BidPartId
	LEFT JOIN FPCAPPS.SICF.ALLCATS_LineReview101 LR (nolock) ON  CP.PartNumber = LR.[Part Number] and CP.PoolNumber = LR.Pool
	LEFT JOIN FPCAPPS.BM.VendorPriority VP (nolock) ON CP.VendorColor = VP.Color
	WHERE
	bp.BidId = @BidId
	AND ValidationStatus = 'A'
	Order by PartPriority 
END
