USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal
-- Create date: 07/08/19
-- Description:	get saved crosses for entry of a crowd sourced part
-- =============================================
CREATE
	OR

ALTER PROC [BM].[CrossEntry_GetCrossesForEntry] (@BidPartId INT)
AS
BEGIN
	SELECT CrossPartId
		,PartNumber
		,PoolNumber
		,PartDescription
		,PartCategory
		,ValidationStatus
		,IsNonFP
		,IsFlip
	FROM BM.CrossPart  (nolock)
	WHERE BidPartId = @BidPartId
		AND [Source] = 'CrowdSourcing'
END
