USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal	
-- Create date: 07/01/19
-- Description:	Get all bids details
-- =============================================
CREATE OR ALTER PROCEDURE [BM].[UploadBidPart_GetBidPartsList] (
	@BidId INT
	,@UserId NVARCHAR(100) = NULL
	,@UserRole VARCHAR(50) = NULL
	)
AS
BEGIN
	IF (@UserRole = 'CategoryManager')
	BEGIN
		WITH CMPARTS
		AS (
			SELECT DISTINCT BP.BidPartId
				,BP.BidId
				,BP.CustomerPartNumber
				,BP.PartDescription
				,BP.Manufacturer
				,BP.ManufacturerPartNumber
				,BP.Note
				,BP.EstimatedAnnualUsage
				,BP.IsFinalized
				,BP.IsVerified
				,BP.CreatedBy
				,BP.CreatedOn
			FROM BM.BidPart BP (nolock)
			INNER JOIN BM.CrossPart CP  (nolock) ON BP.BidPartId = CP.BidPartId
			INNER JOIN FPBIDW.EDW.DimProduct DP  (nolock) ON CP.PoolNumber = DP.Pool
				AND CP.PartNumber = DP.PartNumber
				AND DP.Category = CP.PartCategory
			INNER JOIN FPBIDW.EDW.DimEmployee DE  (nolock) ON DP.CategoryManager = DE.UserName
			WHERE BP.BidId = @BidId
				AND (
					BP.IsFinalized IS NULL
					OR BP.IsFinalized = 0
					)
				AND DP.CategoryManager = @UserId
			
			UNION
			
			SELECT DISTINCT BP.BidPartId
				,BP.BidId
				,BP.CustomerPartNumber
				,BP.PartDescription
				,BP.Manufacturer
				,BP.ManufacturerPartNumber
				,BP.Note
				,BP.EstimatedAnnualUsage
				,BP.IsFinalized
				,BP.IsVerified
				,BP.CreatedBy
				,BP.CreatedOn
			FROM BM.BidPart BP (nolock) 
			INNER JOIN BM.CrossPart CP  (nolock) ON BP.BidPartId = CP.BidPartId
			INNER JOIN FPBIDW.EDW.DimProduct DP  (nolock)  ON CP.PoolNumber = DP.Pool
				AND CP.PartNumber = DP.PartNumber
				AND DP.Category = CP.PartCategory
				AND CP.FinalPreference in ('Primary','Alternate1', 'Alternate2')
			INNER JOIN FPBIDW.EDW.DimEmployee DE  (nolock) ON DP.CategoryManager = DE.UserName
			WHERE BP.BidId = @BidId
				AND BP.IsFinalized = 1
				AND DP.CategoryManager = @UserId
			)
		SELECT DISTINCT
			--bid part details
			bp.BidPartId
			,bp.BidId
			,bp.CustomerPartNumber
			,bp.PartDescription
			,bp.Manufacturer
			,bp.ManufacturerPartNumber
			,bp.Note
			,bp.EstimatedAnnualUsage
			,bp.IsFinalized
			,bp.IsVerified
			,bp.CreatedBy
			,bp.CreatedOn
			--primary cross part details		
			,cp.CrossPartId
			,cp.BidPartId
			,cp.CrossRank
			,cp.ReferenceTableName
			,cp.Source
			,cp.Company
			,cp.PartNumber
			,cp.PoolNumber
			,cp.PartDescription
			,cp.PartCategory
			,cp.VendorNumber
			,cp.VendorColor
			,cp.VendorColorDefinition
			,cp.VendorName
			,cp.Manufacturer
			,cp.IsFlip
			,cp.IsNonFP
			,cp.ValidationStatus
			,cp.ValidatedBy
			,cp.ValidatedOn
			,cp.CreatedBy
			,cp.CreatedOn
			,cp.FinalPreference
			,CP.Comments
			,cp.PriceToQuote
			,cp.SuggestedPrice
			,cp.ICOST
			,cp.Margin
			,cp.AdjustedICost
			,cp.AdjustedMargin
			,cp.IsWon
			,LR.[DC Stock Count] AS DCStockCount
			,LR.[S] AS StoresStockCount
			,LR.[Natl Count L12 Stores Sold] AS NationalL12StoresSold
			,LR.[Local Count L12 Stores Sold] AS LocalL12StoresSold
			,LR.[L12 Units] AS L12Units
			,LR.[L12 Revenue] AS L12Revenue
			,LR.[Current NPM Part Type] AS NPMPartType
			,CASE 
				WHEN vp.Priority IS NULL
					THEN 100
				ELSE vp.Priority
				END AS PartPriority
		FROM CMPARTS bp  (nolock) 
		LEFT JOIN [FPCAPPS].BM.CrossPart CP(NOLOCK) ON bp.BidPartId = cp.BidPartId
			AND FinalPreference = 'Primary'
		LEFT JOIN FPCAPPS.SICF.ALLCATS_LineReview101 LR(NOLOCK) ON CP.PartNumber = LR.[Part Number]
			AND CP.PoolNumber = LR.Pool
		LEFT JOIN FPCAPPS.BM.VendorPriority VP  (nolock) ON CP.VendorColor = VP.Color
	END
	ELSE
	BEGIN
		SELECT DISTINCT
			--bid part details
			bp.BidPartId
			,bp.BidId
			,bp.CustomerPartNumber
			,bp.PartDescription
			,bp.Manufacturer
			,bp.ManufacturerPartNumber
			,bp.Note
			,bp.EstimatedAnnualUsage
			,bp.IsFinalized
			,bp.IsVerified
			,bp.CreatedBy
			,bp.CreatedOn
			--primary cross part details		
			,cp.CrossPartId
			,cp.BidPartId
			,cp.CrossRank
			,cp.ReferenceTableName
			,cp.Source
			,cp.Company
			,cp.PartNumber
			,cp.PoolNumber
			,cp.PartDescription
			,cp.PartCategory
			,cp.VendorNumber
			,cp.VendorColor
			,cp.VendorColorDefinition
			,cp.VendorName
			,cp.Manufacturer
			,cp.IsFlip
			,cp.IsNonFP
			,cp.ValidationStatus
			,cp.ValidatedBy
			,cp.ValidatedOn
			,cp.CreatedBy
			,cp.CreatedOn
			,cp.FinalPreference
			,CP.Comments
			,cp.PriceToQuote
			,cp.SuggestedPrice
			,cp.ICOST
			,cp.Margin
			,cp.AdjustedICost
			,cp.AdjustedMargin
			,cp.IsWon
			,LR.[DC Stock Count] AS DCStockCount
			,LR.[S] AS StoresStockCount
			,LR.[Natl Count L12 Stores Sold] AS NationalL12StoresSold
			,LR.[Local Count L12 Stores Sold] AS LocalL12StoresSold
			,LR.[L12 Units] AS L12Units
			,LR.[L12 Revenue] AS L12Revenue
			,LR.[Current NPM Part Type] AS NPMPartType
			,CASE 
				WHEN vp.Priority IS NULL
					THEN 100
				ELSE vp.Priority
				END AS PartPriority
		FROM  [FPCAPPS].BM.BidPart bp  (nolock) 
		LEFT JOIN [FPCAPPS].BM.CrossPart CP(NOLOCK) ON bp.BidPartId = cp.BidPartId
			AND FinalPreference = 'Primary'
		LEFT JOIN FPCAPPS.SICF.ALLCATS_LineReview101 LR(NOLOCK) ON CP.PartNumber = LR.[Part Number]
			AND CP.PoolNumber = LR.Pool
		LEFT JOIN FPCAPPS.BM.VendorPriority VP (nolock)  ON CP.VendorColor = VP.Color
		WHERE bp.BidId = @BidId
	END
END
