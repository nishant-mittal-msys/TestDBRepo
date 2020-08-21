USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal	
-- Create date: 08/20/19
-- Description:	Mark All Primary Won
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[CompletedBids_MarkAllPrimaryWon] (@BidId INT)
AS
BEGIN
	UPDATE CP
	SET IsWon = (
			CASE 
				WHEN CP.FinalPreference in ('Primary', 'Alternate1', 'Alternate2')
					AND(  (UPPER(ltrim(rtrim(CP.VendorColorDefinition))) = 'DO NOT USE'AND BP.IsVerified = 1) 
						   OR (UPPER(ltrim(rtrim(CP.VendorColorDefinition))) != 'DO NOT USE')
						  --To handle few cases where VendorColorDefinition in null
						   OR (CP.VendorColorDefinition IS NULL)
						)
					THEN 1
				ELSE NULL
				END
			)
	FROM FPCAPPS.BM.CrossPart CP (nolock)
	INNER JOIN FPCAPPS.BM.BidPart BP (nolock)
	 ON BP.BidPartId = CP.BidPartId
	WHERE BP.BidId = @BidId
END