USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Vaqqas
-- Create date: 7/12/2019
-- Description:	Get the Tat for a bid
-- =============================================
CREATE OR ALTER PROCEDURE [BM].[Bid_GetTat] (
	@BidId INT
	,@NewStatus VARCHAR(50)
	)
AS
BEGIN
	DECLARE @BidSize AS INT
	DECLARE @TotalTat as int
	DECLARE @PhaseTat as int

	SELECT @BidSize = COUNT(BidPartID)
	FROM BM.BidPart (nolock)
	WHERE BidID = @BidId

	SELECT @PhaseTat = isnull(TatDays, 0)
	FROM BM.Tat  (nolock)
	WHERE BidStatus = @NewStatus
		AND @BidSize BETWEEN BidSizeStart
			AND BidSizeEnd

	SELECT @TotalTat = sum(TatDays)
	FROM BM.Tat  (nolock)
	WHERE @BidSize BETWEEN BidSizeStart
			AND BidSizeEnd

	SELECT @PhaseTat as PhaseTat, @TotalTat as TotalTat
END
