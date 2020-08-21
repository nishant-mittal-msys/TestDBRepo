USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal
-- Create date: 01/17/2020
-- Description:	Get Progress Summary
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[Summary_ProgressSummary] (
	@UserId VARCHAR(100)
	,@UserRole VARCHAR(100)
	)
AS
BEGIN
	;with cteCounts(BidID, 
		TotalParts, 
		CrossesFinalized)
	as (
	SELECT 
		BidID, 
		count(BidPartId) as TotalParts, 
		sum(case when IsFinalized = 1 then 1 else 0 end) as CrossesFinalized
	FROM BM.BidPart (nolock) 
	Group by BidID
	)

	SELECT B.[BidId]
		,B.[Company]
		,B.[BidStatus]
		,B.[BidType]
		,B.[BidName]
		,B.[BidDescription]
		,B.[DueDate]
		,B.[CalculatedDueDate]
		,B.[CurrentPhaseDueDate]
		,B.[LaunchDate]
		,B.[Company]
		,B.[CustNumber]
		,B.[CustBranch]
		,B.[CustName]
		,B.[CustCorpId]
		,B.[CustCorpAccName]
		,B.[GroupId]
		,B.[GroupDesc]
		,B.[CreatedBy]
		,B.[CreatedOn]
		,CrossesReviewedBy = STUFF((
				SELECT ',' + CMUserId
				FROM fpcapps.bm.CMaction a
				WHERE A.bidId = b.bidId
					AND a.CMActionStatus = 1
				FOR XML PATH('')
				), 1, 1, '')
		,CrossesNotReviewedBy = STUFF((
				SELECT ',' + CMUserId
				FROM fpcapps.bm.CMaction a
				WHERE A.bidId = b.bidId
					AND a.CMActionStatus IS NULL
					OR a.CMActionStatus = 0
				FOR XML PATH('')
				), 1, 1, '')
		,InventoryReviewedBy = STUFF((
				SELECT ',' + A.UserId
				FROM fpcapps.bm.InventoryReviewAction A
				WHERE A.bidId = b.bidId
					AND a.ActionStatus = 1
				FOR XML PATH('')
				), 1, 1, '')
		,InventoryNotReviewedBy = STUFF((
				SELECT ',' + A.UserId
				FROM fpcapps.bm.InventoryReviewAction A
				WHERE A.bidId = b.bidId
					AND a.ActionStatus IS NULL
					OR a.ActionStatus = 0
				FOR XML PATH('')
				), 1, 1, '')
		,TotalParts
		,CrossesFinalized
	FROM FPCAPPS.BM.Bid B (nolock) 
	inner join cteCounts c  (nolock) on B.BidId = c.BidId
	WHERE B.BidStatus IN (
			 'CategoryManager'
			,'Pricing'
			,'Completed'
			,'InventoryUpdate'
			,'InventoryReUpdate'
			,'LineReview_CM'
			,'LineReview_Dir'
			,'LineReview_VP'
			,'DataTeam'
			,'DemandTeam'
			)
		AND (
			(
				@UserRole = 'SuperUser'
				AND BidType IN (
					'National'
					,'Regional'
					)
				)
			OR (
				@UserRole IN (
					'NAMSupervisor'
					,'NAMValidator'
					)
				AND BidType = 'National'
				)
			OR (
				@UserRole = 'NAM'
				AND BidType = 'National'
				AND (
					CreatedBy = @UserId
					OR NAMUserId = @UserId
					)
				)
			OR (
				@UserRole IN (
					'CategoryManager'
					,'CategoryDirector'
					,'CategoryVP'
					,'DataTeam'
					,'DemandTeam'
					)
				AND BidType IN (
					'National'
					,'Regional'
					)
				)
			)
	ORDER BY B.CreatedOn DESC
END
