USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		M Vaqqas
-- Create date: 12/09/19
-- Description:	Load the line review table with the data
-- =============================================
CREATE OR ALTER PROCEDURE [BM].[MarkFirstPartPrimeAndWon] (
	@BidID int,
	@UserId varchar(100)
	)
AS
BEGIN
	DROP TABLE IF EXISTS #TempBidParts;

	;with cte as(
	select cp.BidPartId, cp.CrossPartID, ROW_NUMBER() over(partition by cp.BidPartId order by cp.CrossPartID asc ) as rownum
	from bm.Bid b (nolock)
	inner join bm.BidPart bp (nolock)on bp.BidId = b.BidId
	inner join bm.CrossPart cp (nolock)on bp.BidPartId = cp.BidPartId
	where
	b.BidId = @BidID
	)
	select BidPartId, CrossPartID into #TempBidParts from cte where rownum = 1

	update bm.CrossPart set FinalPreference = 'Primary', IsWon = 1
	where CrossPartId in (select CrossPartID from #TempBidParts)

	update bm.BidPart
	set IsFinalized = 1, FinalizedBy = @UserId, isVerified = 1, VerifiedBy = @UserId
	where BidPartid in (select BidPartId from #TempBidParts)

	DROP TABLE IF EXISTS #TempBidParts;
end
