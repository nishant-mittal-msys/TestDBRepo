USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal
-- Create date: 08/08/19
-- Description:	Upload Parts mark as won
-- =============================================
CREATE
	OR

ALTER PROC [BM].[CompletedBids_UploadPartMarkWon] (
	@PartsMarkWon AS BM.PartsMarkWonUDT READONLY
	,@BidId INT
	)
AS
BEGIN
	
	UPDATE CP
	SET CP.IsWon = NULL
	FROM FPCAPPS.BM.CrossPart CP  
	INNER JOIN FPCAPPS.BM.BidPart BP  (nolock) ON BP.BidPartId =  CP.BidPartId	 
	WHERE BP.BidId = @BidId AND CP.FinalPreference in ('Primary', 'Alternate1', 'Alternate2')
		--added below condition to show 'Do Not Use' parts only when CM verified
		AND(  (UPPER(ltrim(rtrim(CP.VendorColorDefinition))) = 'DO NOT USE'AND BP.IsVerified = 1) 
		     OR (UPPER(ltrim(rtrim(CP.VendorColorDefinition))) != 'DO NOT USE')
			  --To handle few cases where VendorColorDefinition in null
			 OR (CP.VendorColorDefinition IS NULL)
		   )

	
	UPDATE CP
	SET CP.IsWon = CPP.IsPartWon
	FROM FPCAPPS.BM.BidPart BP (nolock)
	INNER JOIN FPCAPPS.BM.CrossPart CP ON BP.BidPartId = CP.BidPartId
	INNER JOIN @PartsMarkWon CPP ON CP.BidPartId = CPP.BidPartId
		AND CP.CrossPartId = CPP.CrossPartId
	WHERE BidId = @BidId
		AND CP.FinalPreference in ('Primary', 'Alternate1', 'Alternate2')
		--added below condition to show 'Do Not Use' parts only when CM verified
		AND(  (UPPER(ltrim(rtrim(CP.VendorColorDefinition))) = 'DO NOT USE'AND BP.IsVerified = 1) 
		     OR (UPPER(ltrim(rtrim(CP.VendorColorDefinition))) != 'DO NOT USE')
			  --To handle few cases where VendorColorDefinition in null
			 OR (CP.VendorColorDefinition IS NULL)
		   )
END
GO