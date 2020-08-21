USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gurpreet Singh
-- Create date: 07/29/19
-- Description:	Get all bids details for Cross Report
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[CrossReport_GetBids] (
	@UserId VARCHAR(100)
	,@UserRole VARCHAR(100)
	)
AS
BEGIN
	IF (@UserRole = 'RegionalUser')
	BEGIN
		SET @UserRole = (
				SELECT TOP 1 [Role]
				FROM FPCAPPS.PEM.UserHierarchy  (nolock)
				WHERE UserId = @UserId
				)

		SELECT [BidId]
			,[IsProspect]
			,[BidStatus]
			,[BidType]
			,[BidName]
			,[BidDescription]
			,[DueDate]
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
		FROM FPCAPPS.BM.Bid B  (nolock)
		WHERE B.BidType = 'Regional'
			AND BidStatus IN (
				'CrossFinalization'
				,'CategoryManager'
				,'PricingTeam'
				,'Completed'
				,'Won'
				,'Lost'
				,'InventoryUpdate'
				,'InventoryReUpdate'
				,'LineReview_CM'
				,'LineReview_Dir'
				,'LineReview_VP'
				,'LineReview_CMO'
				,'DataTeam'
				,'DemandTeam'
				)
			AND (
				(
					(
						@UserRole <> 'RVP'
						OR @UserRole IS NULL
						)
					AND B.CreatedBy = @UserId
					)
				OR (
					@UserRole = 'RVP'
					)
				)
			--ORDER BY [Rank]
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
		FROM BM.Bid  (nolock)
		WHERE (
				@UserRole = 'NAM'
				AND BidType = 'National'
				AND (
					CreatedBy = @UserId
					OR NAMUserId = @UserId
					)
				AND BidStatus IN (
					'CrossFinalization'
					,'CategoryManager'
					,'PricingTeam'
					,'Completed'
					,'Won'
					,'Lost'
					,'InventoryUpdate'
					,'InventoryReUpdate'
					,'LineReview_CM'
					,'LineReview_Dir'
					,'LineReview_VP'
					,'LineReview_CMO'
					,'DataTeam'
					,'DemandTeam'
					)
				)
			OR (
				@UserRole IN (
					'NAMSupervisor'
					,'NAMValidator'
					)
				AND BidType = 'National'
				AND BidStatus IN (
					'CrossFinalization'
					,'CategoryManager'
					,'PricingTeam'
					,'Completed'
					,'Won'
					,'Lost'
				    ,'InventoryUpdate'
					,'InventoryReUpdate'
					,'LineReview_CM'
					,'LineReview_Dir'
					,'LineReview_VP'
					,'LineReview_CMO'
					,'DataTeam'
					,'DemandTeam'
					)
				)
			OR (
				@UserRole = 'SuperUser'
				AND BidType IN (
					'National'
					,'Regional'
					)
				AND BidStatus IN (
					'CrossFinalization'
					,'CategoryManager'
					,'PricingTeam'
					,'Completed'
					,'Won'
					,'Lost'
				    ,'InventoryUpdate'
					,'InventoryReUpdate'
					,'LineReview_CM'
					,'LineReview_Dir'
					,'LineReview_VP'
					,'LineReview_CMO'
					,'DataTeam'
					,'DemandTeam'
					)
				)
			OR (
				@UserRole = 'CategoryManager'
				AND BidStatus IN (
					'CategoryManager'					
					)
				)
			--ORDER BY [Rank]
	END
END
	--SELECT [BidId]
	--	,[IsProspect]
	--	,[BidStatus]
	--	,[BidType]
	--	,[BidName]
	--	,[BidDescription]
	--	,[DueDate]
	--	,[CurrentPhaseDueDate]
	--	,[Rank]
	--	,[Company]
	--	,[CustNumber]
	--	,[CustBranch]
	--	,[CustName]
	--	,[CustCorpId]
	--	,[CustCorpAccName]
	--	,[GroupId]
	--	,[GroupDesc]
	--	,[RequestType]
	--	,[SubmittedDate]
	--	,[FPFacingLocations]
	--	,[TotalValueOfBid]
	--	,[IsFPPriceHold]
	--	,[HoldDate]
	--	,[IsCustomerAllowSubstitutions]
	--	,[BrandPreference]
	--	,[IsCustomerInventoryPurchaseGuarantee]
	--	,[LevelOfInvetoryDetailCustomerCanProvide]
	--	,[SourceExcelFileName]
	--	,[CreatedByRole]
	--	,[NAMUserID]
	--	,[CreatedBy]
	--	,[CreatedOn]
	--	,[Comments]
	--FROM BM.Bid
	--WHERE (
	--		@UserRole = 'RegionalUser'
	--		AND BidType = 'Regional'
	--		AND CreatedBy = @UserId
	--		AND BidStatus IN (
	--			'CrossFinalization'
	--			,'CategoryManager'
	--			,'PricingTeam'
	--			,'Completed'
	--			,'Won'
	--			,'Lost'
	--			)
	--		)
	--	OR (
	--		@UserRole = 'NAM'
	--		AND BidType = 'National'
	--		AND (
	--			CreatedBy = @UserId
	--			OR NAMUserId = @UserId
	--			)
	--		AND BidStatus IN (
	--			'CrossFinalization'
	--			,'CategoryManager'
	--			,'PricingTeam'
	--			,'Completed'
	--			,'Won'
	--			,'Lost'
	--			)
	--		)
	--	OR (
	--		@UserRole IN (
	--			'NAMSupervisor'
	--			,'NAMValidator'
	--			)
	--		AND BidType = 'National'
	--		AND BidStatus IN (
	--			'CrossFinalization'
	--			,'CategoryManager'
	--			,'PricingTeam'
	--			,'Completed'
	--			,'Won'
	--			,'Lost'
	--			)
	--		)
	--	OR (
	--		@UserRole = 'SuperUser'
	--		AND BidStatus IN (
	--			'CrossFinalization'
	--			,'CategoryManager'
	--			,'PricingTeam'
	--			,'Completed'
	--			,'Won'
	--			,'Lost'
	--			)
	--		)
	--	OR (
	--		@UserRole = 'CategoryManager'
	--		AND BidStatus IN ('CategoryManager')
	--		)
	--ORDER BY [Rank]
