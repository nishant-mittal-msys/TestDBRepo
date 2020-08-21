USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal
-- Create date: 07/08/19
-- Description:	to save the validation status as approvd/rejected for a cross
-- =============================================
CREATE
	OR

ALTER PROC [BM].[CrossValidation_UpdateCrossValidationStatus] (
	@CrossPartId INT
	,@CrossValidationStatus CHAR
	,@UserId VARCHAR(50)
	,@AffectedRowId INT = NULL OUTPUT
	)
AS
BEGIN
	UPDATE BM.CrossPart
	SET ValidationStatus = @CrossValidationStatus
		,ValidatedBy = @UserId
		,ValidatedOn = GETDATE()
	WHERE CrossPartId = @CrossPartId

	SET @AffectedRowId = @CrossPartId
END
