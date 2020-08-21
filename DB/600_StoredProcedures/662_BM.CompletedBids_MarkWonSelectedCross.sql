USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal	
-- Create date: 08/19/19
-- Description:	Update bid part
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[CompletedBids_MarkWonSelectedCross] (
	@BidId INT
	,@BidPartId INT
	,@CrossPartId INT
	,@AffectedRowId INT = NULL OUTPUT
	)
AS
BEGIN
    UPDATE BM.CrossPart
	SET IsWon = null		 
	WHERE BidPartId = @BidPartId

	UPDATE BM.CrossPart
	SET IsWon = 1		 
	WHERE CrossPartId = @CrossPartId
	SET @AffectedRowId = @CrossPartId
END
