USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal
-- Create date: 07/08/19
-- Description:	submit the crowd sourced part from user
-- =============================================
CREATE
	OR

ALTER PROC [BM].[CrossEntry_SubmitCrowdSourcingPart] (
	@CrowdSourcingPartId INT
	,@SubmittedBy VARCHAR(50)
	,@IsSubmitted BIT
	)
AS
BEGIN
	UPDATE BM.BidPart
	SET IsSubmitted = @IsSubmitted
		,SubmittedOn = GETDATE()
		,SubmittedBy = @SubmittedBy
	WHERE BidPartId = @CrowdSourcingPartId

	UPDATE BM.UserAction
	SET CrossUserId = @SubmittedBy
		,CrossActionStatus = 'Submitted'
		,CrossActionOn = GETDATE()
	WHERE BidPartId = @CrowdSourcingPartId
END
