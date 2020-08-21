USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant
-- Create date: 8/14/2019
-- Description:	Complete/Won/Loss mark bid
-- =============================================
CREATE OR ALTER PROCEDURE [BM].[Bid_Complete] (
	@BidId int,
	@NewStatus varchar(50),
	@Comments nvarchar(max)
	)
AS
BEGIN
	IF @NewStatus = 'LineReview_CM' 
	BEGIN
		DECLARE @TatDays int = 0
		set @TatDays = isnull((select top 1 TatDays from bm.Tat where BidStatus = @NewStatus), 0)

		UPDATE BM.Bid
		SET BidStatus = 'LoadingInventoryReview'
		WHERE BidId = @BidId;

		EXEC [BM].[InventoryReview_LoadLineReview] @BidId

		UPDATE BM.Bid
		SET BidStatus = @NewStatus,
			CurrentPhaseDueDate = dateadd(day, @TatDays, GETDATE()),
			Comments = Comments + char(10) + @Comments
		WHERE BidId = @BidId;
	END
	ELSE
	BEGIN
		UPDATE BM.Bid
		SET BidStatus = @NewStatus,
			Comments = Comments + char(10) + @Comments
		WHERE BidId = @BidId;
	END

	SELECT OpportunityID FROM BM.Bid  (nolock) WHERE BidId = @BidId
END

--exec [BM].[Bid_Complete]  1129, 'LineReview_CM', 'Testing tat'