USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Vaqqas
-- Create date: 12/27/19
-- Description:	Save the approval of the parts
-- =============================================
CREATE OR ALTER PROCEDURE [BM].InventoryReview_Update (
	@CrossPartInventoryId int
	,@RevisedPool int
	,@RevisedPartNumber varchar(100)
	,@Comments varchar(2000)
	,@UserId varchar(100)
	,@Role varchar(100)
	)
AS
BEGIN
		UPDATE BM.CrossPartLineReview
		SET 
			RevisedPool = @RevisedPool
			,RevisedPartNumber = @RevisedPartNumber
			,LastUpdatedby = @UserId
			,LastUpdatedOn = getdate()
			,Comments = @Comments
		WHERE ID = @CrossPartInventoryId

END
