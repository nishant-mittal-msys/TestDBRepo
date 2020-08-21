USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal	
-- Create date: 07/01/19
-- Description:	Delete bid part
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[UploadBidPart_DeleteBidPart] (
	@BidPartId INT
	,@AffectedRowId INT = NULL OUTPUT
	)
AS
BEGIN
	DELETE
	FROM BM.BidPart
	WHERE BidPartId = @BidPartId

	SET @AffectedRowId = @BidPartId
END
