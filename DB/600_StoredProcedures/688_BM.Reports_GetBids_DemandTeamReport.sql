USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal
-- Create date: 1/10/2019
-- Description:	Get all bids for the demand team report
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[Reports_GetBids_DemandTeamReport] (
	@UserId VARCHAR(100)
	,@UserRole VARCHAR(100)
	)
AS
BEGIN
	SELECT DISTINCT B.[BidId]
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
	FROM BM.Bid b (nolock) 
	WHERE b.BidStatus IN ('DemandTeam')
END
