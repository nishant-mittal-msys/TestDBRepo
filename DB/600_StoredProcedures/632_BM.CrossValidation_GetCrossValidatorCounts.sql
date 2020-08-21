USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal
-- Create date: 07/08/19
-- Description:	to get the monthly user entry and validation count for a validator
-- =============================================
CREATE
	OR

ALTER PROC [BM].[CrossValidation_GetCrossValidatorCounts] (
	@UserId VARCHAR(50)
	,@CrossMTDEnteredCount INT OUTPUT
	,@CrossMTDValidatedCount INT OUTPUT
	,@CrossTodayValidatedCount INT OUTPUT
	)
AS
SET @CrossMTDEnteredCount = (
		SELECT COUNT(*)
		FROM BM.CrossPart CP  (nolock) 
		WHERE CP.CreatedBy = @UserId
			AND MONTH(CP.Createdon) = MONTH(GETDATE())
			AND YEAR(CP.CreatedOn) = YEAR(GETDATE())
		)
SET @CrossMTDValidatedCount = (
		SELECT COUNT(*)
		FROM BM.CrossPart CP  (nolock) 
		WHERE CP.ValidatedBy = @UserId
			AND CP.ValidationStatus IS NOT NULL
			AND MONTH(CP.ValidatedOn) = MONTH(GETDATE())
			AND YEAR(CP.ValidatedOn) = YEAR(GETDATE())
		)
SET @CrossTodayValidatedCount = (
		SELECT COUNT(*)
		FROM BM.CrossPart CP  (nolock) 
		WHERE CP.ValidatedBy = @UserId
			AND CP.ValidationStatus IS NOT NULL
			AND CP.CreatedOn >= CONVERT(DATETIME, DATEDIFF(DAY, 0, GETDATE()))
		)
