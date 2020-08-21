USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gurpreet Singh
-- Create date: 08/08/19
-- Description:	Upload Cross Price
-- =============================================
CREATE
	OR

ALTER PROC [BM].[PriceValidation_UploadCrossPrice] (
	@CrossPartsPrice AS BM.CrossPartsPriceUDT READONLY
	,@BidId INT
	)
AS
BEGIN
	UPDATE CP
	SET CP.PriceToQuote = CPP.PriceToQuote
		,CP.SuggestedPrice = CPP.SuggestedPrice
		,CP.ICOST = CPP.ICOST
		,CP.Margin = CPP.Margin
		,CP.AdjustedICost = CPP.AdjustedICOST
		,CP.AdjustedMargin = CPP.AdjustedMargin
	FROM FPCAPPS.BM.BidPart BP (nolock)
	INNER JOIN FPCAPPS.BM.CrossPart CP (nolock) ON BP.BidPartId = CP.BidPartId
	INNER JOIN @CrossPartsPrice CPP ON CP.BidPartId = CPP.BidPartId
		AND CP.CrossPartId = CPP.CrossPartId
	WHERE BidId = @BidId
			AND CP.FinalPreference in ('Primary', 'Alternate1', 'Alternate2')
		--added below condition to show 'Do Not Use' parts only when CM verified
		AND(  (UPPER(ltrim(rtrim(CP.VendorColorDefinition))) = 'DO NOT USE'AND BP.IsVerified = 1) 
		     OR (UPPER(ltrim(rtrim(CP.VendorColorDefinition))) != 'DO NOT USE')
			  --To handle few cases where VendorColorDefinition in null
			 OR (CP.VendorColorDefinition IS NULL)
		   )
    --- Calculate pricing params on price update
	EXEC BM.CalcualtePricingParams @BidId
END
GO


