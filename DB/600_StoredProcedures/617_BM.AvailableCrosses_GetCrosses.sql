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
CREATE
	OR

ALTER PROCEDURE [BM].[AvailableCrosses_GetCrosses] (
	@BidPartId INT
	,@IsCrossReport BIT = 0
	)
AS
BEGIN
	SELECT CrossPartId
		,BidPartId
		,CrossRank
		,ReferenceTableName
		,Source
		,Company
		,PartNumber
		,PoolNumber
		,PartDescription
		,PartCategory
		,VendorNumber
		,VendorColor
		,VendorColorDefinition
		,VendorName
		,Manufacturer
		,IsFlip
		,IsNonFP
		,ValidationStatus
		,ValidatedBy
		,ValidatedOn
		,CreatedBy
		,CreatedOn
		,FinalPreference
		,CP.Comments
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
	FROM [FPCAPPS].BM.CrossPart  CP(NOLOCK)
	LEFT JOIN FPCAPPS.SICF.ALLCATS_LineReview101 LR (nolock) ON  CP.PartNumber = LR.[Part Number] and CP.PoolNumber = LR.Pool
	LEFT JOIN FPCAPPS.BM.VendorPriority VP(NOLOCK) ON CP.VendorColor = VP.Color
	WHERE (
			@IsCrossReport = 0
			AND BidPartId = @BidPartId
			)
		OR (
			@IsCrossReport = 1
			AND BidPartId = @BidPartId
			AND ValidationStatus = 'A'
			)
	Order by PartPriority 
END
