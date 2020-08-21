USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Vaqqas
-- Create date: 12/09/19
-- Description:	Get bids for the Invenotry Review
-- =============================================
CREATE OR ALTER PROCEDURE [BM].[InventoryReview_GetBids] (
	@UserId VARCHAR(100)
	,@UserRole VARCHAR(100)
	)
AS
BEGIN
	DECLARE @sql nvarchar(MAX) = 'SELECT DISTINCT B.[BidId]
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
		FROM BM.Bid b  (nolock) 
		inner join BM.InventoryReviewAction ir  (nolock)  on b.BidID = ir.BidId';

		DECLARE @Condition nvarchar(1000)

		IF( @UserRole = 'SuperUser' )
			SET @Condition = 'WHERE b.BidStatus in (''LineReview_CM'', ''LineReview_Dir'', ''LineReview_VP'')'
		ELSE IF( @UserRole = 'NAMSupervisor' )
			SET @Condition = 'WHERE b.BidType = ''National'' AND b.BidStatus in (''LineReview_CM'', ''LineReview_Dir'', ''LineReview_VP'')'
		ELSE IF( @UserRole = 'CategoryManager' )
			SET @Condition = 'WHERE b.BidStatus = ''LineReview_CM'' AND IR.UserRole = ''CategoryManager'' and IR.UserId =  @UserId '
		ELSE IF( @UserRole = 'CategoryDirector' )
			SET @Condition = 'WHERE b.BidStatus = ''LineReview_Dir'' AND IR.UserRole = ''CategoryDirector'' and IR.UserId =  @UserId  '
		ELSE IF( @UserRole = 'CategoryVP' )
			SET @Condition = 'WHERE b.BidStatus = ''LineReview_VP'' AND IR.UserRole = ''CategoryVP'' and IR.UserId =   @UserId '

		SET @sql = @sql + ' ' + @Condition

		EXECUTE sp_executesql @sql, N'@UserId VARCHAR(100)', @UserId = @UserId
END

--test
--exec fpcapps.[BM].[InventoryReview_GetBids] 'JSaunders', 'CategoryManager'
--update Fpcapps.bm.Bid set BidStatus = 'InventoryUpdate' where BidStatus in ('LineReview_CM', 'LineReview_Dir', 'LineReview_VP')

--SELECT * FROM  BM.InventoryReviewAction
