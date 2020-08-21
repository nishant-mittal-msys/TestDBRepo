USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ====================================================================
-- Author:		Nishant Mittal	
-- Create date: 08/20/19
-- Description:	CrowdSourcing - Clear Locked Parts after specific time
-- ===================================================================
CREATE
	OR

ALTER PROCEDURE [BM].[CrowdSourcing_ClearLockedParts] 
AS
BEGIN
    Declare @Hours INT = 24
	--Delete cross entry locked bid parts and its cross parts
	DELETE
	FROM FPCAPPS.BM.CrossPart
	WHERE BidPartId IN (
			SELECT BidPartId
			FROM FPCAPPS.BM.UserAction (nolock)
			WHERE (datediff(hour, CrossActionOn, GETDATE())) > @Hours
				AND CrossActionStatus = 'Locked'
			)
		AND [Source] = 'CrowdSourcing'

	DELETE
	FROM FPCAPPS.BM.UserAction 
	WHERE (datediff(hour, CrossActionOn, GETDATE())) > @Hours
		AND CrossActionStatus = 'Locked'

	--Update validation entry locked bid parts
	UPDATE FPCAPPS.BM.UserAction
	SET ValidatorUserId = NULL
		,ValidatorActionOn = NULL
		,ValidatorActionStatus = NULL
	WHERE (datediff(hour, ValidatorActionOn, GETDATE())) > @Hours
		AND ValidatorActionStatus = 'Locked'
END
