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
CREATE OR ALTER PROCEDURE [BM].[InventoryReview_SaveInventoryApproval] (
	@IsApproved bit
	,@CrossPartInventoryIds BM.IDs readonly
	--,@Comments NVARCHAR(100) = NULL
	,@UserId NVARCHAR(100) 
	,@UserRole NVARCHAR(100) 
	,@AffectedRowId INT = NULL OUTPUT
	)
AS
BEGIN
		UPDATE BM.CrossPartLineReview
		SET IsApproved = @IsApproved
		--,Comments = @Comments
		WHERE ID in (Select ID from @CrossPartInventoryIds)
		SET @AffectedRowId = @@ROWCOUNT
END
