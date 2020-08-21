USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal
-- Create date: 07/08/19
-- Description:	get the part for crowd sourcing part
-- =============================================
-- exec [BM].[CrossEntry_GetPartForCrowdSourcing] 'Nishant.Mittal'
CREATE
	OR

ALTER PROC [BM].[CrossEntry_GetPartForCrowdSourcing] (@UserId NVARCHAR(50))
AS
BEGIN
	SET NOCOUNT ON;

	IF NOT EXISTS (
			SELECT 1
			FROM BM.Bid AS bid (nolock)
			INNER JOIN BM.BidPart AS BP  (nolock) ON bid.BidId = BP.BidId
			INNER JOIN BM.UserAction UA  (nolock) ON BP.BidPartId = UA.BidPartId
			WHERE UA.CrossUserId = @UserId
				AND UA.CrossActionStatus = 'Locked'
				AND bid.BidStatus IN ('CrowdSourcing')
				AND bid.[Rank] > 0
			)
	BEGIN
		INSERT INTO BM.UserAction (
			BidPartId
			,CrossUserId
			,CrossActionStatus
			,CrossActionOn
			)
		SELECT TOP 1 BP.BidPartId
			,@UserId
			,'Locked'
			,GETDATE()
		FROM BM.Bid AS bid  (nolock)
		INNER JOIN BM.BidPart AS BP  (nolock) ON bid.BidId = BP.BidId
		WHERE BP.IsCrowdSourcingEligible = 1
			AND BP.IsSubmitted = 0
			AND (
				BP.BidPartId NOT IN (
					SELECT BidPartId
					FROM BM.UserAction  (nolock)
					WHERE (
							CrossActionStatus IN (
								'Locked'
								,'Submitted'
								)
							)
						OR (
							CrossActionStatus = 'Unaware'
							AND CrossUserId = @UserId
							)
					)
				)
			AND bid.BidStatus IN ('CrowdSourcing')
			AND bid.[Rank] > 0
		ORDER BY bid.[Rank]
	END

	SELECT Bid.BidId
		,BP.BidPartId
		,(
			CASE 
				WHEN BP.ManufacturerPartNumber IS NULL
					OR BP.ManufacturerPartNumber = ''
					THEN BP.CustomerPartNumber
				ELSE BP.ManufacturerPartNumber
				END
			) AS CustomerPartNumber
		,BP.PartDescription
		,BP.Manufacturer
		,BP.Note
	FROM BM.Bid AS bid  (nolock)
	INNER JOIN.BM.BidPart AS BP  (nolock) ON bid.BidId = BP.BidId
	INNER JOIN BM.UserAction UA  (nolock) ON BP.BidPartId = UA.BidPartId
	WHERE UA.CrossUserId = @UserId
		AND CrossActionStatus = 'Locked'
		AND bid.BidStatus IN ('CrowdSourcing')
		AND bid.[Rank] > 0
	ORDER BY bid.[Rank]
END
