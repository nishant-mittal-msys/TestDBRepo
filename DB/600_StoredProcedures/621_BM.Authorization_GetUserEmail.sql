USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		M VAqqas
-- Create date: 07/31/19
-- Description:	Get user's email address
-- =============================================
CREATE OR ALTER PROCEDURE [BM].[Authorization_GetUserEmail] (@UserId VARCHAR(100) = NULL)
AS
BEGIN

DECLARE @DelegateUserId AS VARCHAR(100)
DECLARE @Email as varchar(500)

SELECT TOP 1
@DelegateUserId = DelegateUserId,
@Email = [EmailAddress]
	FROM BM.DelegateUser (nolock)
	WHERE DelegateUserId = @UserId

--IF USER IS NOT IN THE DELEGATE TABLE THEN FETCH THE INFO FROM THE EMPLOYEE TABLE.
if( @DelegateUserId is null )
		SELECT TOP 1 @Email = EmployeeEmail
		FROM FPBIDW.EDW.DimEmployee emp (nolock)
		WHERE emp.EmploymentStatus IN ('A','L')
			AND emp.UserName = @UserId

select @Email as Email

End

--EXEC [FPCAPPS].BM.[Authorization_GetUserEmail] 'md.vaqqas'