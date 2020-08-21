USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal
-- Create date: 07/08/19
-- Description:	save the crosses found in product master table
-- =============================================
CREATE
	OR

ALTER PROC [BM].[CrossReport_FinalizeSelectedCross] (
	@BidPartId INT
	,@CrossPartId INT
	,@FinalPreference NVARCHAR(100) = NULL
	,@UserId NVARCHAR(100)
	,@UserRole NVARCHAR(100)
	,@AffectedRowId INT = NULL OUTPUT
	)
AS
BEGIN
	UPDATE FPCAPPS.BM.CrossPart
	SET FinalPreference = (CASE WHEN @FinalPreference = 'NA' THEN NULL else @FinalPreference END)
	WHERE CrossPartId = @CrossPartId

	UPDATE FPCAPPS.BM.BidPart
	SET IsFinalized = 1,
	FinalizedBy = @UserId,
	FinalizedOn = GETDATE(),
	IsVerified = (CASE WHEN @UserRole = 'CategoryManager' THEN  1 Else IsVerified END), 
	VerifiedBy = (CASE WHEN @UserRole = 'CategoryManager' THEN  @UserId Else VerifiedBy END) 
	WHERE BidPartId = @BidPartId

	

	SET @AffectedRowId = @BidPartId
END
