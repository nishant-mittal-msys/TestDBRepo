USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Vaqqas
-- Create date: 1/3/2019
-- Description:	Get all bids for the Data Team
-- =============================================
CREATE OR ALTER PROCEDURE [BM].[PartsNotSetup_GetBids] 
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
		WHERE b.BidStatus = 'DataTeam'
END

--test
--exec fpcapps.[BM].[InventoryReview_GetBids] 'TRoseman', 'CategoryDirector'
--update Fpcapps.bm.Bid set BidStatus = 'InventoryUpdate' where BidStatus in ('LineReview_CM', 'LineReview_Dir', 'LineReview_VP')
