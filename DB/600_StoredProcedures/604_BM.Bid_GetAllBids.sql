USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gurpreet Singh
-- Create date: 06/25/19
-- Description:	Get all bids details
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[Bid_GetAllBids] (
	@UserId VARCHAR(100)
	,@UserRole VARCHAR(100)
	)
AS
BEGIN
	IF (@UserRole = 'RegionalUser')
	BEGIN
		SET @UserRole = (
				SELECT TOP 1 [Role]
				FROM FPCAPPS.PEM.UserHierarchy (nolock)
				WHERE UserId = @UserId
				)

		SELECT distinct [BidId]
			,[IsProspect]
			,[BidStatus]
			,[BidType]
			,[BidName]
			,[BidDescription]
			,[DueDate]
			,[LaunchDate]
			,[CalculatedDueDate]
			,[CurrentPhaseDueDate]
			,[Rank]
			,B.[Company]
			,B.[CustNumber]
			,B.[CustBranch]
			,B.[CustName]
			,B.[CustCorpId]
			,B.[CustCorpAccName]
			,B.[GroupId]
			,B.[GroupDesc]
			,[RequestType]
			,[SubmittedDate]
			,[FPFacingLocations]
			,[TotalValueOfBid]
			,[ProjectedGPDollar]
			,[ProjectedGPPerc]
			,[IsFPPriceHold]
			,[HoldDate]
			,[IsCustomerAllowSubstitutions]
			,[BrandPreference]
			,[IsCustomerInventoryPurchaseGuarantee]
			,[LevelOfInvetoryDetailCustomerCanProvide]
			,[SourceExcelFileName]
			,[CreatedByRole]
			,[NAMUserID]
			,[CreatedBy]
			,[CreatedOn]
			,[Comments]
			,NULL As CrossActionStatus
			,NULL As InventoryActionStatus
		FROM FPCAPPS.BM.Bid B (nolock)
		WHERE B.BidType = 'Regional'
			AND (
				(
					(
						@UserRole <> 'RVP'
						OR @UserRole IS NULL
						)
					AND B.CreatedBy = @UserId
					)
				OR (@UserRole = 'RVP')
				)
		ORDER BY [Rank]
	END
	ELSE IF (@UserRole = 'CategoryManager')
	BEGIN
		SELECT distinct b.[BidId]
			,[IsProspect]
			,[BidStatus]
			,[BidType]
			,[BidName]
			,[BidDescription]
			,[DueDate]
			,[LaunchDate]
			,[CalculatedDueDate]
			,[CurrentPhaseDueDate]
			,[Rank]
			,[Company]
			,[CustNumber]
			,[CustBranch]
			,[CustName]
			,[CustCorpId]
			,[CustCorpAccName]
			,[GroupId]
			,[GroupDesc]
			,[RequestType]
			,[SubmittedDate]
			,[FPFacingLocations]
			,[TotalValueOfBid]
			,[ProjectedGPDollar]
			,[ProjectedGPPerc]
			,[IsFPPriceHold]
			,[HoldDate]
			,[IsCustomerAllowSubstitutions]
			,[BrandPreference]
			,[IsCustomerInventoryPurchaseGuarantee]
			,[LevelOfInvetoryDetailCustomerCanProvide]
			,[SourceExcelFileName]
			,[CreatedByRole]
			,[NAMUserID]
			,[CreatedBy]
			,[CreatedOn]
			,[Comments]
			, CA.CMActionStatus as CrossActionStatus
			, 0 as InventoryActionStatus
		FROM BM.Bid b (nolock)
		inner  JOIN bm.CMAction CA (nolock)
			on b.bidId = CA.BidId and BidStatus = 'CategoryManager' and (CA.CMUserId = @UserId ) 
	union 
		SELECT distinct b.[BidId]
			,[IsProspect]
			,[BidStatus]
			,[BidType]
			,[BidName]
			,[BidDescription]
			,[DueDate]
			,[LaunchDate]
			,[CalculatedDueDate]
			,[CurrentPhaseDueDate]
			,[Rank]
			,[Company]
			,[CustNumber]
			,[CustBranch]
			,[CustName]
			,[CustCorpId]
			,[CustCorpAccName]
			,[GroupId]
			,[GroupDesc]
			,[RequestType]
			,[SubmittedDate]
			,[FPFacingLocations]
			,[TotalValueOfBid]
			,[ProjectedGPDollar]
			,[ProjectedGPPerc]
			,[IsFPPriceHold]
			,[HoldDate]
			,[IsCustomerAllowSubstitutions]
			,[BrandPreference]
			,[IsCustomerInventoryPurchaseGuarantee]
			,[LevelOfInvetoryDetailCustomerCanProvide]
			,[SourceExcelFileName]
			,[CreatedByRole]
			,[NAMUserID]
			,[CreatedBy]
			,[CreatedOn]
			,[Comments]
			, (select top 1 CMActionStatus from bm.CMAction  where bidId = b.BidId and CMUserId = @UserId) as CrossActionStatus
			, IA.ActionStatus as InventoryActionStatus
		FROM BM.Bid b (nolock)
		inner JOIN bm.InventoryReviewAction IA (nolock)
			on b.bidId = IA.BidId and BidStatus = 'LineReview_CM' and 	  (IA.UserId = @UserId )
	END
	ELSE
	BEGIN
		SELECT [BidId]
			,[IsProspect]
			,[BidStatus]
			,[BidType]
			,[BidName]
			,[BidDescription]
			,[DueDate]
			,[LaunchDate]
			,[CalculatedDueDate]
			,[CurrentPhaseDueDate]
			,[Rank]
			,[Company]
			,[CustNumber]
			,[CustBranch]
			,[CustName]
			,[CustCorpId]
			,[CustCorpAccName]
			,[GroupId]
			,[GroupDesc]
			,[RequestType]
			,[SubmittedDate]
			,[FPFacingLocations]
			,[TotalValueOfBid]
			,[ProjectedGPDollar]
			,[ProjectedGPPerc]
			,[IsFPPriceHold]
			,[HoldDate]
			,[IsCustomerAllowSubstitutions]
			,[BrandPreference]
			,[IsCustomerInventoryPurchaseGuarantee]
			,[LevelOfInvetoryDetailCustomerCanProvide]
			,[SourceExcelFileName]
			,[CreatedByRole]
			,[NAMUserID]
			,[CreatedBy]
			,[CreatedOn]
			,[Comments]
			,NULL As CrossActionStatus
			,NULL As InventoryActionStatus
		FROM BM.Bid (nolock)
		WHERE (
				@UserRole = 'SuperUser'
				AND BidType IN (
					'National'
					,'Regional'
					)
				)
			OR (
				@UserRole IN ('NAMSupervisor')
				AND BidType = 'National'
				AND BidStatus NOT IN ('DataTeam')
				)
			OR (
				@UserRole IN ('NAMValidator')
				AND BidType = 'National'
				AND BidStatus NOT IN ('DataTeam')
				)
			OR (
				@UserRole = 'NAM'
				AND BidType = 'National'
				AND (
					CreatedBy = @UserId
					OR NAMUserId = @UserId
					)
				AND BidStatus NOT IN (
					'InventoryUpdate'
					,'InventoryReUpdate'
					,'LineReview_CM'
					,'LineReview_Dir'
					,'LineReview_VP'
					,'DataTeam'
					,'DemandTeam'
					)
				)
			OR (
				@UserRole = 'CategoryManager'
				AND BidStatus IN (
					'CategoryManager'
					,'LineReview_CM'
					)
				)
			OR (
				@UserRole = 'PricingTeam'
				AND BidStatus = 'PricingTeam'
				)
			OR (
				@UserRole IN ('CategoryDirector')
				AND BidStatus IN ('LineReview_Dir')
				)
			OR (
				@UserRole IN ('CategoryVP')
				AND BidStatus IN ('LineReview_VP')
				)
			OR (
				@UserRole IN ('DataTeam')
				AND BidStatus IN ('DataTeam','DemandTeam')
				)
			OR (
				@UserRole IN ('DemandTeam')
				AND BidStatus IN ('DemandTeam')
				)
		ORDER BY [Rank]
	END
END
