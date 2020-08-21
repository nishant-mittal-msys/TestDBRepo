USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gurpreet Singh
-- Create date: 08/19/19
-- Description:	get a CM action status for a bid
-- =============================================
CREATE
	OR

ALTER PROC [BM].[CrossReport_GetCMActionStatusForBid] (
	@BidId INT
	,@CMUserId NVARCHAR(100)
	,@Result INT = NULL OUTPUT
	)
AS
BEGIN
	SET @Result = (
			SELECT (
					CASE 
						WHEN CMActionStatus = 1
							THEN 1
						ELSE 0
						END
					)
			FROM FPCAPPS.BM.CMAction (nolock)
			WHERE BidId = @BidId
				AND CMUserId = @CMUserId
			)

	IF (@Result IS NULL)
	BEGIN
		SET @Result = 0
	END
END
