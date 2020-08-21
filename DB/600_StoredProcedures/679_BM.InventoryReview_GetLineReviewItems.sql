USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		VAQQAS	
-- Create date: 12/11/19
-- Description:	Get all won parts inventory list
-- =============================================
CREATE OR ALTER PROCEDURE [BM].[InventoryReview_GetLineReviewItems] (
	@BidId INT
	,@UserId NVARCHAR(100) = NULL
	,@UserRole VARCHAR(50) = NULL
	)
AS
BEGIN
	
DECLARE @sql nvarchar(MAX) = 'SELECT distinct
		CPLR.ID as ID
		,CPLR.[CrossPartId] as CrossPartId
		,CPLR.BidId as BidId
		,CPLR.BidPartId as BidPartId
		,CPLR.NewPool AS CrossPoolNumber
		,CPLR.NewPartNumber AS CrossPartNumber		
		,CP.PartDescription as CrossPartDescription
		,cp.PartCategory as CrossPartCategory
		,cp.VendorName as CrossPartVendor
		,isNull(CPLR.[ExistingStockingLocations], 0) as ExistingStockingLocations
		,isNull(CPLR.[DCStockCount], 0) as DCStockCount
		,isnull(CPLR.[L12Units], 0) as L12Units
		,isNull(CPLR.[NewStockingLocations], 0) as NewStockingLocations
		,isNull(CPLR.[ProjectedL12Units], 0) as ProjectedL12Units
		,IsNull(CPLR.[ProjectedL12GP], 0) as ProjectedL12GP
		,IsNull(CPLR.[ProjectedInvestment], 0) as ProjectedInvestment
		,IsNull(CPLR.[ICost], 0) as ICost
		,IsNull(CPLR.[MedianCost], 0) as MedianCost
		,CPLR.[StockingType] as StockingType
		,CPLR.IsApproved as IsApproved
		,CPLR.ProjectedL12Revenue AS ProjectedL12Revenue
		,isnull(CPLR.AlreadyStockingLocation, 0) AS AlreadyStockingLocations
		,CPLR.CategoryManagerID AS CategoryManagerID
		,CPLR.CategoryDirectorID AS CategoryDirectorID
		,CPLR.CategoryCMOID AS CategoryCMOID
		,CPLR.CreatedOn as CreatedOn
		,CPLR.Comments as Comments
		,isnull(CPLR.L12Revenue, 0) as CurrentL12Revenue
		,CPLR.Price
		,CPLR.SalesPack
		,CPLR.RevisedPool
		,CPLR.RevisedPartNumber
		,CPLR.EstimatedMonthlyUsage
		,CPLR.Estimated3MonthUsageWithoutSalesPack
		,CPLR.Estimated3MonthUsageWithSalesPack
	FROM FPCAPPS.BM.CrossPartLineReview CPLR  (nolock) 
	INNER JOIN FPCAPPS.BM.CrossPart cp  (nolock) ON CPLR.CrossPartId = cp.CrossPartId
	WHERE CPLR.BidId = @BidId'
	
	DECLARE @Condition nvarchar(1000)
	
	IF( @UserRole in ('SuperUser', 'NAMSupervisor') )
			SET @Condition = ''
		ELSE IF( @UserRole = 'CategoryManager' )
			SET @Condition = 'AND CPLR.CategoryManagerID = @UserId'
		ELSE IF( @UserRole = 'CategoryDirector' )
			SET @Condition = 'AND CPLR.CategoryDirectorID = @UserId'
		ELSE IF( @UserRole = 'CategoryVP' )
			SET @Condition = 'AND CPLR.CategoryCMOID = @UserId'
		
		SET @sql = @sql + ' ' + @Condition
		
		EXECUTE sp_executesql @sql, N'@BidId INT, @UserId VARCHAR(100)', @BidId = @BidId, @UserId = @UserId
END

--exec fpcapps.bm.InventoryReview_GetLineReviewItems 2248, 'jbuysse', 'SuperUser'
--exec fpcapps.bm.[InventoryReview_LoadLineReview]  1130