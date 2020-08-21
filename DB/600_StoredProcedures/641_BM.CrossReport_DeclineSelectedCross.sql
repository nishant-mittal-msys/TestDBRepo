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

ALTER PROC [BM].[CrossReport_DeclineSelectedCross] (
	@BidPartId INT
	,@UserId NVARCHAR(100)
	,@AffectedRowId INT = NULL OUTPUT
	)
AS
BEGIN
	UPDATE FPCAPPS.BM.BidPart
	SET IsFinalized = 0,
	FinalizedBy = @UserId,
	FinalizedOn = GETDATE()
	WHERE BidPartId = @BidPartId

	SET @AffectedRowId = @BidPartId
END