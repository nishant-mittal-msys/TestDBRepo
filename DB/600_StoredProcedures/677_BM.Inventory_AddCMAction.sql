USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================================
-- Author:		Nishant Mittal
-- Create date: 12/18/19
-- Description:	add all CM inventory review action for a bid 
-- ==============================================================
CREATE
	OR

ALTER PROC [BM].[Inventory_AddCMAction] (
	@BidId INT
	,@BidLaunchDate DATE = NULL
	,@CMUserId NVARCHAR(100)
	,@Result INT = NULL OUTPUT
	)
AS
BEGIN
	--// update launch date of bid //--
	UPDATE BM.Bid
	SET LaunchDate = @BidLaunchDate
	WHERE BidId = @BidId

	IF EXISTS (
			SELECT 1
			FROM FPCAPPS.BM.InventoryReviewAction (nolock) 
			WHERE BidId = @BidId
				AND UserID = @CMUserId
			)
	BEGIN
		SET @Result = 1
	END
	ELSE
	BEGIN
		INSERT INTO FPCAPPS.BM.InventoryReviewAction (
			BidId
			,UserId
			,UserRole
			)
		VALUES (
			@BidId
			,@CMUserId
			,'CategoryManager'
			)

		SET @Result = Scope_Identity()
	END
END
