USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gurpreet Singh
-- Create date: 08/16/19
-- Description:	add all CM action for a bid 
-- =============================================
CREATE
	OR

ALTER PROC [BM].[CrossReport_AddCMAction] (
	@BidId INT
	,@CMUserId NVARCHAR(100)
	,@Result INT = NULL OUTPUT
	)
AS
BEGIN
	IF EXISTS (
			SELECT 1
			FROM FPCAPPS.BM.CMAction
			WHERE BidId = @BidId
				AND CMUserID = @CMUserId
			)
	BEGIN
		SET @Result = 1
	END
	ELSE
	BEGIN
		INSERT INTO FPCAPPS.BM.CMAction (
			BidId
			,CMUserId
			)
		VALUES (
			@BidId
			,@CMUserId
			)

		SET @Result = Scope_Identity()
	END
END
