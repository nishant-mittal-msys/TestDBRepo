USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gurpreet Singh
-- Create date: 06/25/19
-- Description:	update Bid details 
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[Bid_SaveOpId] (
	@BidId INT
	,@OpportunityID varchar(100)
	)
AS
BEGIN
		UPDATE BM.Bid
		SET OpportunityID = @OpportunityID
		WHERE BidId = @BidId
END