USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal
-- Create date: 07/08/19
-- Description:	get saved crosses for entry of a crowd sourced part
-- =============================================
CREATE
	OR

ALTER PROC [BM].[CrossValidation_GetCrossesForValidation] (
	@CrossValidationPartId INT
	,@UserId VARCHAR(50)
	)
AS
BEGIN
	IF (
			(
				SELECT TOP 1 ValidatorActionStatus
				FROM BM.UserAction  (nolock)
				WHERE BidPartId = @CrossValidationPartId
					AND ValidatorUserId <> @UserId
				) = 'PartiallyValidated'
			)
	BEGIN
		SELECT CP.CrossPartId
			,CP.PartNumber
			,CP.PoolNumber
			,CP.PartDescription
			,CP.PartCategory
			,CP.ValidationStatus
			,CP.IsFlip
			,CP.IsNonFP
		FROM BM.CrossPart CP
		WHERE (
				CP.BidPartId = @CrossValidationPartId
				AND CP.ValidationStatus IS NULL
				)
			OR (
				CP.BidPartId = @CrossValidationPartId
				AND CP.ValidatedBy = @UserId
				)
				AND [Source] = 'CrowdSourcing'
	END
	ELSE
	BEGIN
		SELECT CP.CrossPartId
			,CP.PartNumber
			,CP.PoolNumber
			,CP.PartDescription
			,CP.PartCategory
			,CP.ValidationStatus
			,CP.IsFlip
			,CP.IsNonFP
		FROM BM.CrossPart CP
		WHERE (
				CP.BidPartId = @CrossValidationPartId
				AND CP.ValidationStatus IS NULL
				)
			OR (
				CP.BidPartId = @CrossValidationPartId
				AND CP.ValidatedBy = @UserId
				)
				AND [Source] = 'CrowdSourcing'
	END
END
