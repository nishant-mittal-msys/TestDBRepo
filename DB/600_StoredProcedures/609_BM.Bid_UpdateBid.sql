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

ALTER PROCEDURE [BM].[Bid_UpdateBid] (
	@BidId INT
	,@NewRank INT
	,@OldRank INT = NULL
	,@DueDate DATE = NULL
	,@PhaseDueDate DATE = NULL
	,@TotalValueOfBid NUMERIC(19, 2) = NULL
	,@ProjectedGPDollar NUMERIC(19, 2) = NULL
	,@ProjectedGPPerc NUMERIC(19, 2) = NULL
	,@Result INT = NULL OUTPUT
	)
AS
BEGIN
	IF (@NewRank = 0)
	BEGIN
		SET @OldRank = (
				SELECT [Rank]
				FROM BM.Bid
				WHERE BidId = @BidId
				)

		UPDATE BM.Bid
		SET [Rank] = @NewRank
		WHERE BidId = @BidId

		UPDATE BM.Bid
		SET [Rank] = [Rank] - 1
		WHERE BidId <> @BidId
			AND [Rank] > @OldRank

		SET @Result = 1
	END
	ELSE
	BEGIN
		IF (@OldRank = @NewRank)
		BEGIN
			UPDATE BM.Bid
			SET [DueDate] = @DueDate
				,[CurrentPhaseDueDate] = @PhaseDueDate
				,[TotalValueOfBid] = @TotalValueOfBid
				,[ProjectedGPDollar] = @ProjectedGPDollar
				,[ProjectedGPPerc] = @ProjectedGPPerc
			WHERE BidId = @BidId

			SET @Result = 1
		END
		ELSE
		BEGIN
			IF (@NewRank < @OldRank)
			BEGIN
				UPDATE BM.Bid
				SET [Rank] = @NewRank
					,[DueDate] = @DueDate
					,[CurrentPhaseDueDate] = @PhaseDueDate
					,[TotalValueOfBid] = @TotalValueOfBid
					,[ProjectedGPDollar] = @ProjectedGPDollar
					,[ProjectedGPPerc] = @ProjectedGPPerc
				WHERE BidId = @BidId

				UPDATE BM.Bid
				SET [Rank] = [Rank] + 1
				WHERE BidId <> @BidId
					AND [Rank] >= @NewRank
					AND [Rank] < @OldRank
			END
			ELSE
			BEGIN
				UPDATE BM.Bid
				SET [Rank] = @NewRank
					,[DueDate] = @DueDate
					,[CurrentPhaseDueDate] = @PhaseDueDate
					,[TotalValueOfBid] = @TotalValueOfBid
					,[ProjectedGPDollar] = @ProjectedGPDollar
					,[ProjectedGPPerc] = @ProjectedGPPerc
				WHERE BidId = @BidId

				UPDATE BM.Bid
				SET [Rank] = [Rank] - 1
				WHERE BidId <> @BidId
					AND [Rank] > @OldRank
					AND [Rank] < @NewRank + 1
			END

			SET @Result = 1
		END
	END
END
