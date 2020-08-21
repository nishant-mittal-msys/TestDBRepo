USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		VAQQAS	
-- Create date: 12/11/19
-- Description:	Get all won parts inventory list
-- =============================================
CREATE OR ALTER PROCEDURE [BM].[InventoryReview_GetAction] (
	@BidId INT
	,@UserId NVARCHAR(100) 
	,@UserRole VARCHAR(50) 
	)
AS
BEGIN
	IF @UserRole in ('CategoryManager', 'CategoryDirector', 'CategoryVP')
		SELECT top 1 ISNULL(ActionStatus, 0)
		FROM BM.InventoryReviewAction (nolock) 
		WHERE BidID = @BidId
		and UserRole = @UserRole
		AND UserId = @UserId
	ELSE IF @UserRole = 'SuperUser'
	BEGIN
		declare @BidStatus VARCHAR(255) 
		select @BidStatus = BidStatus from BM.Bid  (nolock) where BidID = @BidId;
		SELECT CASE WHEN @BidStatus in  ('LineReview_CM', 'LineReview_Dir', 'LineReview_VP') THEN 0 ELSE 1 END
	END 
END
