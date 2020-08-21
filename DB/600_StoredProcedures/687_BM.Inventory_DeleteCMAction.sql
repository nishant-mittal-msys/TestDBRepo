USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ====================================================================================
-- Author:		Nishant Mittal
-- Create date: 01/06/19
-- Description:	Delete all CM inventory review action for a bid when bid is pulled back
-- ====================================================================================
CREATE
	OR

ALTER PROC [BM].[Inventory_DeleteCMAction] (@BidId INT)
AS
BEGIN
	--// update launch date of bid to null //--
	UPDATE BM.Bid
	SET LaunchDate = NULL
	WHERE BidId = @BidId

	--// delete all records for the bid //--
	DELETE
	FROM FPCAPPS.BM.InventoryReviewAction 
	WHERE BidId = @BidId

	--clean the CrossPartLineReview records for this bid
	DELETE
	FROM BM.[CrossPartLineReview] 
	WHERE CrossPartId IN (
			SELECT CrossPartId
			FROM BM.CrossPart cp (nolock) 
			INNER JOIN BM.BidPart bp  (nolock) ON cp.BidPartId = bp.BidPartId
			WHERE bp.BidID = @BidID
			)
END
