USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Vaqqas
-- Create date: 7/14/2019
-- Description:	Get users in the given role
-- =============================================
CREATE OR ALTER PROCEDURE [BM].[Authorization_GetUsersInRole] (@role VARCHAR(100) = NULL)
AS
BEGIN
	SELECT
	 [DelegateUserId]
	,[PrincipalUserId]
	,[UserRole]
	,[EmailAddress]
	FROM BM.DelegateUser (NOLOCK)
	WHERE [UserRole] = @role
END
