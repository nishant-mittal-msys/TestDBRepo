USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		M Vaqqas
-- Create date: 11/19/2019
-- Description:	save all the changes made on the cross report
-- =============================================
CREATE OR ALTER PROC [BM].[CrossReport_SaveAll] (
	@FinalizedCrossesUDT BM.CrossReportUpdatesUDT readonly
	,@UserId NVARCHAR(100)
	,@UserRole NVARCHAR(100)
	)
AS
BEGIN
	UPDATE cp
	SET cp.FinalPreference = (CASE WHEN r.FinalPreference = 'NA' THEN NULL else r.FinalPreference END)
	FROM FPCAPPS.BM.CrossPart CP
	inner join @FinalizedCrossesUDT r on cp.CrossPartId = r.CrossPartId

	UPDATE bp	
	SET bp.IsFinalized = (CASE WHEN r.FinalPreference = 'Decline' THEN 0 else 1 END),
	bp.FinalizedBy = @UserId,
	bp.FinalizedOn = GETDATE(),
	bp.IsVerified = (CASE WHEN r.FinalPreference != 'Decline' AND @UserRole = 'CategoryManager' THEN  1 Else r.IsVerified END), 
	bp.VerifiedBy = (CASE WHEN r.FinalPreference != 'Decline' AND @UserRole = 'CategoryManager' THEN  @UserId Else NULL END) 
	from
	FPCAPPS.BM.BidPart bp
	inner join @FinalizedCrossesUDT r on bp.BidPartId = r.BidPartId
END
