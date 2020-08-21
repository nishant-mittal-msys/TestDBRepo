USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal
-- Create date: 06/24/19
-- Description:	Insert errors generated from application
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[ErrorLogging_Insert] (
	@vErrorDateTime VARCHAR(100)
	,@vErrorMessage VARCHAR(2000) = NULL
	,@vErrorStackTrace VARCHAR(max) = NULL
	,@vDeployedEnvironment VARCHAR(10) = NULL
	,@vUserId VARCHAR(50) = NULL
	,@vNew_identity INT = NULL OUTPUT
	)
AS
BEGIN
	INSERT INTO BM.ErrorLogging (
		ErrorDateTime
		,ErrorMessage
		,ErrorStackTrace
		,DeployedEnvironment
		,UserId
		,id
		)
	VALUES (
		@vErrorDateTime
		,@vErrorMessage
		,@vErrorStackTrace
		,@vDeployedEnvironment
		,@vUserId
		);

	SET @vNew_identity = SCOPE_IDENTITY()
END
