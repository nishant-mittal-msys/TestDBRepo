USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Vaqqas
-- Create date: 7/10/19
-- Description:	Get bids details for the given BidId
-- =============================================
CREATE OR ALTER PROCEDURE [BM].[Bid_GetBid] (@BidId int)
AS
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
		,[LaunchDate]
	FROM BM.Bid (nolock)
	WHERE BidId = @BidId
END
