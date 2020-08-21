USE [FPCAPPS]
GO

/****** Object:  StoredProcedure [BM].[CrossReport_DownloadCrosses]    Script Date: 7/25/2019 6:05:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Vaqqas	
-- Create date: 07/22/19
-- Description:	Get Final crosses for a Bid for Price Validation
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[PriceValidation_GetFinalCrosses] (@BidPartId INT)
AS
BEGIN
	SELECT CP.CrossPartId
		,CP.BidPartId
		,CP.CrossRank
		,CP.ReferenceTableName
		,CP.Source
		,CP.Company
		,CP.PartNumber
		,CP.PoolNumber
		,CP.PartDescription
		,CP.PartCategory
		,CP.VendorNumber
		,CP.VendorColor
		,CP.VendorColorDefinition
		,CP.VendorName
		,CP.Manufacturer
		,CP.IsFlip
		,CP.IsNonFP
		,CP.ValidationStatus
		,CP.ValidatedBy
		,CP.ValidatedOn
		,CP.CreatedBy
		,CP.CreatedOn
		,CP.FinalPreference
		,CP.Comments
		,CP.PriceToQuote
		,CP.SuggestedPrice
		,CP.ICOST
		,CP.Margin
		,CP.AdjustedICOST
		,CP.AdjustedMargin
		,CP.IsWon
		,NULL AS DCStockCount
		,NULL AS StoresStockCount
		,NULL AS NationalL12StoresSold
		,NULL AS LocalL12StoresSold
		,NULL AS L12Units
		,NULL AS L12Revenue
		,NULL AS NPMPartType
	FROM [FPCAPPS].BM.CrossPart CP (nolock)
	INNER JOIN [FPCAPPS].BM.BidPart BP  (nolock) ON CP.BidPartId = BP.BidPartId
	WHERE CP.BidPartId = @BidPartId
		AND CP.FinalPreference in ('Primary', 'Alternate1', 'Alternate2')
		--added below condition to show 'Do Not Use' parts only when CM verified
		AND(  (UPPER(ltrim(rtrim(CP.VendorColorDefinition))) = 'DO NOT USE'AND BP.IsVerified = 1) 
		     OR (UPPER(ltrim(rtrim(CP.VendorColorDefinition))) != 'DO NOT USE')
			  --To handle few cases where VendorColorDefinition in null
			 OR (CP.VendorColorDefinition IS NULL)
		   )
	ORDER BY CASE FinalPreference
			WHEN 'Primary'
				THEN 1
			WHEN 'Alternate1'
				THEN 2
			WHEN 'Alternate2'
				THEN 3
			END
END
