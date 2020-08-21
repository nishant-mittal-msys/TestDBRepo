USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gurpreet Singh
-- Create date: 08/19/19
-- Description:	update CM action for a bid 
-- =============================================
CREATE
	OR

ALTER PROC [BM].[CrossReport_UpdateCMAction] (
	@BidId INT
	,@CMUserId NVARCHAR(100)
	,@Result INT = NULL OUTPUT
	)
AS
BEGIN
	UPDATE FPCAPPS.BM.CMAction
	SET CMActionStatus = 1
		,CMActionOn = GETDATE()
	WHERE BidId = @BidId
		AND CMUserId = @CMUserId

	SET @Result = 1

	DECLARE @CMCount INT
		,@CMActionCount INT

	SELECT @CMCount = COUNT(CMUserId)
		,@CMActionCount = SUM(CASE 
				WHEN CMActionStatus = 1
					THEN 1
				ELSE 0
				END)
	FROM FPCAPPS.BM.CMAction (nolock)
	WHERE BidId = @BidId

	IF (@CMCount = @CMActionCount)
	BEGIN
	    --Assign Bid to PricingTeam as all CM have taken action
		SET @Result = 2
	END
END
