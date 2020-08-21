USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gurpreet Singh
-- Create date: 06/25/19
-- Description:	update Excel FileName in Bid
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[Bid_UpdateExcelFileName] (
	@BidId INT
	,@FileName VARCHAR(250)
	)
AS
BEGIN
	UPDATE BM.Bid
	SET SourceExcelFileName = @FileName
	WHERE BidId = @BidId
END
