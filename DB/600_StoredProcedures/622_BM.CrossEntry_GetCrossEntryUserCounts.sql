USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal
-- Create date: 07/08/19
-- Description:	get the monthly user entry and validation count for an entry user
-- =============================================
CREATE
	OR

ALTER PROC [BM].[CrossEntry_GetCrossEntryUserCounts] (
	@UserId NVARCHAR(50)
	,@CrossMTDEnteredCount INT OUTPUT
	,@CrossMTDValidatedCount INT OUTPUT
	,@CrossTodayEnteredCount INT OUTPUT
	)
AS
SET @CrossMTDEnteredCount = (
		SELECT COUNT(*)
		FROM BM.CrossPart CP (nolock)
		WHERE CP.CreatedBy = @UserId
			AND CP.[Source] = 'CrowdSourcing'
			AND MONTH(CP.CreatedOn) = MONTH(GETDATE())
			AND YEAR(CP.CreatedOn) = YEAR(GETDATE())
		)
SET @CrossMTDValidatedCount = (
		SELECT COUNT(*)
		FROM BM.CrossPart CP (nolock)
		WHERE CP.ValidatedBy = @UserId
			AND CP.ValidationStatus IS NOT NULL
			AND MONTH(CP.ValidatedOn) = MONTH(GETDATE())
			AND YEAR(CP.ValidatedOn) = YEAR(GETDATE())
		)
SET @CrossTodayEnteredCount = (
		SELECT COUNT(*)
		FROM BM.CrossPart CP (nolock)
		WHERE CP.CreatedBy = @UserId
			AND CP.CreatedOn >= CONVERT(DATETIME, DATEDIFF(DAY, 0, GETDATE()))
		)
