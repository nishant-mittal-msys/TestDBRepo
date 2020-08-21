USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal
-- Create date: 07/08/19
-- Description:	to get the part for validation
-- =============================================
CREATE
	OR

ALTER PROC [BM].[CrossValidation_GetPartForValidation] (@UserId NVARCHAR(50))
AS
BEGIN
	SET NOCOUNT ON;

	IF NOT EXISTS (
			SELECT 1
			FROM BM.Bid AS bid (nolock)
			INNER JOIN BM.BidPart AS BP (nolock) ON bid.BidId = BP.BidId
			INNER JOIN BM.UserAction UA (nolock) ON BP.BidPartId = UA.BidPartId
			WHERE UA.ValidatorUserId = @UserId
				AND UA.ValidatorActionStatus = 'Locked'
				AND bid.BidStatus IN ('CrowdSourcing')
				AND bid.[Rank] > 0
			)
	BEGIN
		UPDATE BM.UserAction
		SET ValidatorUserId = @UserId
			,ValidatorActionStatus = 'Locked'
			,ValidatorActionOn = GETDATE()
		WHERE BidPartId = (
				SELECT TOP 1 BP.BidPartId
				FROM BM.Bid AS Bid
				INNER JOIN BM.BidPart AS BP ON Bid.BidId = BP.BidId
				LEFT JOIN BM.UserAction AS UA ON UA.BidPartId = BP.BidPartId
				WHERE BP.IsCrowdSourcingEligible = 1
					AND BP.IsSubmitted = 1
					AND BP.IsValidated = 0
					AND (
						BP.SubmittedBy <> @UserId
						AND (
							UA.ValidatorActionStatus = 'PartiallyValidated'
							AND UA.ValidatorUserId <> @UserId
							)
						)
					AND bid.BidStatus IN ('CrowdSourcing')
					AND bid.[Rank] > 0
				ORDER BY bid.[Rank]
				)
	END

	SELECT BP.BidPartId
		,(CASE WHEN BP.ManufacturerPartNumber IS NULL OR BP.ManufacturerPartNumber = '' THEN BP.CustomerPartNumber ELSE BP.ManufacturerPartNumber END) AS CustomerPartNumber
		,BP.PartDescription
		,BP.Manufacturer
		,BP.Note
	FROM BM.Bid AS bid
	INNER JOIN.BM.BidPart AS BP ON bid.BidId = BP.BidId
	INNER JOIN BM.UserAction UA ON BP.BidPartId = UA.BidPartId
	WHERE UA.ValidatorUserId = @UserId
		AND ValidatorActionStatus = 'Locked'
		AND bid.BidStatus IN ('CrowdSourcing')
		AND bid.[Rank] > 0
	ORDER BY bid.[Rank]
END
