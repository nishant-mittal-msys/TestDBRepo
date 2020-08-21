USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal
-- Create date: 02/11/20
-- Description:	update bid part note
-- =============================================
CREATE
	OR

ALTER PROC [BM].[CrossReport_UpdateBidPartNote] (
	@BidPartId INT
	,@Note NVARCHAR(300) = NULL
	,@UserId NVARCHAR(100)
	,@AffectedRowId INT = NULL OUTPUT
	)
AS
BEGIN
	UPDATE FPCAPPS.BM.BidPart
	SET Note = @Note
	WHERE BidPartId = @BidPartId

	SET @AffectedRowId = @BidPartId
END