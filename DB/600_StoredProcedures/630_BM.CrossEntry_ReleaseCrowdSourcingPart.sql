USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal
-- Create date: 07/08/19
-- Description:	to release the crowd sourced part from users's queue
-- =============================================
CREATE
	OR

ALTER PROC [BM].[CrossEntry_ReleaseCrowdSourcingPart] (
	@CrowdSourcingPartId INT
	,@ReleasedUser VARCHAR(50)
	)
AS
BEGIN
	UPDATE BM.UserAction
	SET CrossUserId = @ReleasedUser
		,CrossActionStatus = 'Unaware'
		,CrossActionOn = GETDATE()
	WHERE BidPartId = @CrowdSourcingPartId
		AND CrossUserId = @ReleasedUser
END
