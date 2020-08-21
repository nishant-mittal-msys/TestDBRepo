USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal
-- Create date: 06/24/19
-- Description:	Get logged in user details
-- =============================================
CREATE OR ALTER PROCEDURE [BM].[Authorization_GetUserDetails] (@UserId VARCHAR(100) = NULL)
AS
BEGIN

IF EXISTS( SELECT TOP 1 DelegateUserId
	FROM BM.DelegateUser
	WHERE DelegateUserId = @UserId)
BEGIN
	SELECT TOP 1 DelegateUserId, PrincipalUserId, UserRole, EmailAddress
	FROM BM.DelegateUser
	WHERE DelegateUserId = @UserId
END
ELSE
BEGIN
	SELECT TOP 1 
	e.[ADUserID] as DelegateUserId, 
	e.[ADUserID] as PrincipalUserId, 
	r.[Role] as UserRole,
	e.[EmployeeEmail] as EmailAddress
	from [FPBIDW].edw.[DimEmployee] e (nolock)
	inner join fpcapps.bm.roles r (nolock)
		on e.JobCode = r.JobCode
	WHERE e.[ADUserID] = @UserId
END
END
