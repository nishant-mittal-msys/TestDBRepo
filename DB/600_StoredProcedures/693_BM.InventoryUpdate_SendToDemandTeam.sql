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
CREATE OR ALTER PROCEDURE [BM].InventorySetup_SendToDemandTeam (
	@BidId int
	,@UserId NVARCHAR(100) 
	,@UserRole NVARCHAR(100) 
	)
AS
BEGIN
	UPDATE BM.Bid
			SET BidStatus = 'DemandTeam'
			WHERE BidID = @BidId;
END

