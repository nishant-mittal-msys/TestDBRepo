﻿USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal
-- Create date: 08/19/19
-- Description:	Get all bids details for Completed Bids
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[CompletedBids_GetBids] (
	@UserId VARCHAR(100)
	,@UserRole VARCHAR(100)
	)
AS
BEGIN
	IF (@UserRole = 'RegionalUser')
	BEGIN
		SET @UserRole = (
				SELECT TOP 1 [Role]
				FROM FPCAPPS.PEM.UserHierarchy
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
		FROM FPCAPPS.BM.Bid B (nolock)
		WHERE B.BidType = 'Regional'
			AND BidStatus IN (
				'Completed'
				,'Won'
				,'Lost'
				,'InventoryUpdate'
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
		FROM BM.Bid (nolock)
		WHERE BidStatus IN (
				'Completed'
				,'Won'
				,'Lost'
				,'InventoryUpdate'
				)
			AND (
				(
					@UserRole = 'NAM'
					AND BidType = 'National'
					AND (
						CreatedBy = @UserId
						OR NAMUserId = @UserId
						)
					)
				OR (
					@UserRole = 'NAMSupervisor'
					AND BidType = 'National'
					)
				OR (
					@UserRole IN ('SuperUser')
					AND BidType IN (
						'National'
						,'Regional'
						)
					)
				)
			--ORDER BY [Rank]
	END
END
