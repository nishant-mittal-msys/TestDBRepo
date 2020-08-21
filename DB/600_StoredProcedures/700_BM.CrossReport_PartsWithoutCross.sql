USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal
-- Create date: 02/19/20
-- Description:	get parts without crosses
-- =============================================
CREATE
	OR

ALTER PROC [BM].[CrossReport_PartsWithoutCross] (@BidId INT)
AS
BEGIN
	SELECT DISTINCT bp.customerpartnumber AS [Parts Without Crosses]
	FROM FPCAPPS.BM.BidPart bp(NOLOCK)
	LEFT JOIN FPCAPPS.BM.CrossPart CP  (nolock) ON BP.BidPartId = CP.BidPartId
	WHERE BP.BidId = @BidId
	AND CP.CrossPartId IS NULL
END
