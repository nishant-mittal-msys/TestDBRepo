USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gurpreet Singh
-- Create date: 06/25/19
-- Description:	Get all bids details
-- =============================================
CREATE OR ALTER PROCEDURE [BM].[AvailableCrosses_GetBidStatus] (
	@BidId VARCHAR(100)
	)
AS
BEGIN
	SELECT [BidStatus]		
	FROM BM.Bid (NOLOCK)
	WHERE BidId = @BidId
END
