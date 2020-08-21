USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gurpreet Singh
-- Create date: 08/26/19
-- Description:	mark bid part as verified BY CM
-- =============================================
CREATE
	OR

ALTER PROC [BM].[CrossReport_UpdateBidPartVerificationAction] (
	@BidPartId INT
	,@IsVerified BIT
	,@UserId NVARCHAR(100)
	,@AffectedRowId INT = NULL OUTPUT
	)
AS
BEGIN
	UPDATE FPCAPPS.BM.BidPart
	SET IsVerified = @IsVerified,
	VerifiedBy = @UserId,
	VerifiedOn = GETDATE()
	WHERE BidPartId = @BidPartId

	SET @AffectedRowId = @BidPartId
END