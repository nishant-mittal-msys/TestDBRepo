﻿USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal
-- Create date: 07/18/19
-- Description:	get the Check Locked Validation Part For User
--=============================================
CREATE
	OR

ALTER PROC [BM].[CrossValidation_CheckLockedValidationPartForUser] (
	@UserId NVARCHAR(50)
	,@Result INT = NULL OUTPUT
	)
AS
BEGIN
	SET @Result = (
			SELECT COUNT(1)
			FROM BM.UserAction (nolock)
			WHERE ValidatorUserId = @UserId
				AND ValidatorActionStatus = 'Locked'
			)
END
