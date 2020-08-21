USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal
-- Create date: 07/08/19
-- Description:	to submit the crowd sourced part from validator
-- =============================================
CREATE
	OR

ALTER PROC [BM].[CrossValidation_SubmitValidatedPart] (
	@ValidatedCrossPartId INT
	,@ValidatedUser VARCHAR(50)
	,@IsValidated BIT
	)
AS
DECLARE @EnteredCross INT
DECLARE @ValidatedCross INT

SELECT @EnteredCross = COUNT(CP.BidPartId)
FROM BM.CrossPart CP  (nolock)
WHERE BidPartId = @ValidatedCrossPartId
	AND [Source] = 'CrowdSourcing'

SELECT @ValidatedCross = COUNT(CASE 
			WHEN ValidationStatus IN (
					'A'
					,'R'
					)
				THEN 1
			END)
FROM BM.CrossPart CP  (nolock)
WHERE BidPartId = @ValidatedCrossPartId
	AND [Source] = 'CrowdSourcing'

IF (@EnteredCross = @ValidatedCross)
BEGIN
	UPDATE BM.BidPart
	SET IsValidated = @IsValidated
		,ValidatedOn = GETDATE()
		,ValidatedBy = @ValidatedUser
	WHERE BidPartId = @ValidatedCrossPartId

	UPDATE BM.UserAction
	SET ValidatorUserId = @ValidatedUser
		,ValidatorActionStatus = 'Validated'
		,ValidatorActionOn = GETDATE()
	WHERE BidPartId = @ValidatedCrossPartId
		AND ValidatorUserId = @ValidatedUser
END
ELSE
BEGIN
	UPDATE BM.UserAction
	SET ValidatorUserId = @ValidatedUser
		,ValidatorActionStatus = 'PartiallyValidated'
		,ValidatorActionOn = GETDATE()
	WHERE BidPartId = @ValidatedCrossPartId
		AND ValidatorUserId = @ValidatedUser
END

DECLARE @BidId INT

SET @BidId = (
		SELECT B.BidId
		FROM BM.Bid B
		INNER JOIN BM.BidPart BP ON BP.BidId = b.BidId
		WHERE BP.BidPartId = @ValidatedCrossPartId
		)

DECLARE @PartsCount INT
DECLARE @ValidatedPartsCount INT
DECLARE @IDontKnowPart INT

SET @IDontKnowPart = (
		SELECT COUNT(DISTINCT UA.BidPartId)
		FROM BM.Bid B
		INNER JOIN BM.BidPart BP ON BP.BidId = b.BidId
		INNER JOIN BM.UserAction UA ON UA.BidPartId = BP.BidPartId
		WHERE B.BidId = @BidId
			AND CrossActionStatus = 'Unaware'
		)

SELECT @PartsCount = COUNT(CASE 
			WHEN BP.IsCrowdSourcingEligible = 1
				THEN 1
			END)
	,@ValidatedPartsCount = COUNT(CASE 
			WHEN BP.IsValidated = 1
				THEN 1
			END)
FROM BM.Bid B
INNER JOIN BM.BidPart BP ON BP.BidId = b.BidId
WHERE B.BidId = @BidId


--Commented, not required to update bid rank to 0 at this time, need to use this when bid will be completed after price finalization

--	DECLARE @OldBidRank INT

--	SET @OldBidRank = (
--			SELECT [Rank]
--			FROM BM.Bid
--			WHERE BidId = @BidId
--			)

--	UPDATE BM.Bid
--	SET BidStatus = 'CrossFinalization'
--		,[Rank] = 0
--	WHERE BidId = @BidId

--	UPDATE BM.Bid
--	SET [Rank] = [Rank] - 1
--	WHERE BidId <> @BidId
--		AND [Rank] > @OldBidRank
