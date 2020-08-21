USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Vaqqas
-- Create date: 8/26/2019
-- Description:	Get all the holidays from dbo.Holidays table
-- =============================================
CREATE OR ALTER PROC BM.GenerateCrosses_GetBidPartsCount(@BidId INT) 
AS
BEGIN
	--Get the Bid parts which are waiting for a cross.		
		SELECT DISTINCT
			count(bp.BidPartID) as Part
		FROM FPCAPPS.BM.Bid b(NOLOCK)
		INNER JOIN FPCAPPS.BM.BidPart bp(NOLOCK) ON b.BidID = bp.BidID
		LEFT JOIN BM.CrossPart CP  (nolock) ON BP.BidPartId = CP.BidPartId
		WHERE b.BidID = @BidId
			AND CP.BidPartId IS NULL		
END
GO