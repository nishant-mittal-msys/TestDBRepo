USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gurpreet Singh
-- Create date: 08/12/19
-- Description:	Update Cross Price
-- =============================================
CREATE
	OR

ALTER PROC [BM].[PriceValidation_UpdateCrossPrice] (
	@BidPartId INT
	,@CrossPartId INT
	,@PriceToQuote NUMERIC(9, 2) = NULL
	,@SuggestedPrice NUMERIC(9, 2) = NULL
	,@ICOST NUMERIC(9, 2) = NULL
	,@Margin NUMERIC(9, 2) = NULL
	,@AdjustedICost NUMERIC(9, 2) = NULL
	,@AdjustedMargin NUMERIC(9, 2) = NULL
	,@AffectedRowId INT = NULL OUTPUT
	)
AS
BEGIN
	UPDATE FPCAPPS.BM.CrossPart
	SET PriceToQuote = @PriceToQuote
		,SuggestedPrice = @SuggestedPrice
		,ICOST = @ICOST
		,Margin = @Margin
		,AdjustedICost = @AdjustedICost
		,AdjustedMargin = @AdjustedMargin
	WHERE BidPartId = @BidPartId
		AND CrossPartId = @CrossPartId
		AND FinalPreference IS NOT NULL

		SET @AffectedRowId = @CrossPartId
		---- Calculate Pricing Params on every update
		Declare @BidId INT 
		Select @BidId = BidId from BM.BidPart  (nolock) where BidPartId = @BidPartId
		EXEC BM.CalcualtePricingParams @BidId
END
GO