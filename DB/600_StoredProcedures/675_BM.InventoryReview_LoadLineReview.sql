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

---- ICOST is not available at Product level. It is available only at Location level
---- so in this query mediancost is used as ICost... until we get a product level Icost from DimProduct.. which is not available today.
CREATE OR ALTER PROCEDURE [BM].[InventoryReview_LoadLineReview] (
	@BidID int
	)
AS
BEGIN
--clean the slate LineReview
DELETE FROM BM.[CrossPartLineReview]
WHERE BidID = @BidID

 ;with effectivePoolPart As (
Select b.company, 
cpi.CrossPartId , 
bp.BidPartId, 
bp.BidId, 
isnull(cpi.newpool, cp.PoolNumber) as pool, 
isnull(cpi.newpartNo, cp.PartNumber) as PartNumber, 
cpi.IsActive, 
cpi.Location, 
dbo.isNUllorZero(newprice, PriceToQuote) as Price , 
cpi.EstimatedAnnualUsage
 from fpcapps.bm.CrossPartInventory cpi (nolock)
 inner join fpcapps.bm.CrossPart cp (nolock) on cp.CrossPartId = cpi.CrossPartId
 INNER JOIN bm.bidpart bp (nolock) ON bp.bidpartid = cp.bidpartid 
 INNER JOIN bm.bid b (nolock) ON b.bidid = bp.bidid 
 where bp.BidId = @bidId and cpi.IsActive = 'Yes')
 ,ctemediancost ( company, partnumber, pool, mediancost ) AS 
(
   SELECT DISTINCT
      epp.company,
      epp.partnumber,
      epp.pool,
      Percentile_cont(0.5) within GROUP (
   ORDER BY
      inv.[CostForCalculation]) OVER (partition BY inv.company, inv.pool, inv.partnumber) AS mediancost 
   FROM
      effectivePoolPart epp 
      LEFT JOIN
         FPBIDW.edw.factinventory inv (nolock)
         ON inv.pool = epp.pool 
         AND inv.partnumber = epp.PartNumber 
         AND inv.company = epp.Company 
   WHERE
      epp.isactive = 'Yes' 
)
,ctedatabyloacation ( company, pool, partnumber, location, AlreadyStockingLocation, mediancost, icost, price, salespack, Estimated3MonthUsageWithoutSalesPack, Estimated3MonthUsageWithSalesPack, EstimatedMonthlyUsage, estimatedannualusage, gp, investment ) AS 
(
   SELECT
      epp.company,
      epp.pool,
      epp.partnumber,
      epp.location,
	  (case when isnull(inv.IType, '') = 'S' then 1 else 0 end) as AlreadyStockingLocation,
      mc.mediancost,
	  mc.mediancost as icost,
      epp.Price,
      COALESCE(SalesPack , 1.0) AS SALESPACK,
	  Ceiling(epp.[EstimatedAnnualUsage] / (4.0)) As Estimated3MonthUsageWithoutSalesPack,
      Ceiling(Ceiling(epp.[EstimatedAnnualUsage] / (4.0)) / COALESCE(SalesPack , 1.0)) * COALESCE(SalesPack, 1.0) AS Estimated3MonthUsageWithSalesPack,
	  Ceiling(epp.estimatedannualusage/12.0) as EstimatedMonthlyUsage,
      epp.estimatedannualusage,
      (Isnull(epp.price, 0) - COALESCE(inv.CostforCalculation, mc.mediancost,0)) * Isnull(epp.[EstimatedAnnualUsage], 0) AS gp,
      (COALESCE(inv.CostforCalculation,mc.mediancost, 0) * (Ceiling(Ceiling(epp.[EstimatedAnnualUsage] / (4.0)) / COALESCE(SalesPack, 1.0)) * COALESCE(Salespack , 1.0)))
   FROM
      effectivePoolPart epp   
      INNER JOIN
         ctemediancost MC 
         ON mc.pool = epp.pool
         AND mc.partnumber = epp.partnumber 
         AND mc.company = epp.company 
      LEFT JOIN
         FPBIDW.edw.factinventory inv (nolock)
         ON inv.pool = epp.pool
         AND inv.partnumber = epp.partnumber 
         AND inv.company = epp.company 
         AND inv.location = epp.location 
   WHERE
      epp.isactive = 'Yes')
INSERT INTO [BM].[CrossPartLineReview]
           ([CrossPartId]
		   ,BidId
		   ,BidPartId
		   ,NewPool
		   ,NewPartNumber
           ,[ExistingStockingLocations]
		   ,AlreadyStockingLocation
           ,[DCStockCount]
           ,[L12Units]
		   ,[L12Revenue]
           ,[NewStockingLocations]
           ,[ProjectedL12Units]
           ,[ProjectedL12GP]
           ,[ProjectedInvestment]
           ,[ICost]
		   ,[MedianCost]
           ,[StockingType]
		   ,IsApproved
		   ,ProjectedL12Revenue
		   ,EstimatedMonthlyUsage
		   ,Estimated3MonthUsageWithoutSalesPack
		   ,Estimated3MonthUsageWithSalesPack
		   ,PRICE
		   ,SalesPack
		   ,CategoryManagerID
		   ,CategoryDirectorID
		   ,CategoryCMOID 
		   ,CreatedOn
		   )
 SELECT
   epp.[CrossPartId], --[CrossPartId]
   epp.bidid, --BidId
   epp.bidpartid, --BidPartId
   epp.pool, --NewPool
   epp.PartNumber, --NewPartNumber
   Max(lr.s) AS [ExistingStockingLocations], --[ExistingStockingLocations]
   sum(dl.AlreadyStockingLocation), --AlreadyStockingLocation
   Max(lr.[DC Stock Count]) AS [DCStockCount], --[DCStockCount]
   Max(lr.[L12 Units]) AS [L12Units], --[L12Units]
   max(lr.[L12 Revenue]) as L12Revenue, --[L12Revenue]
   Count(epp.location) AS [NewStockingLocations], --[NewStockingLocations]
   Sum(epp.estimatedannualusage) AS ProjectedL12Units, --[ProjectedL12Units]
   Sum(dl.gp) AS ProjectedL12GP, --[ProjectedL12GP]
   Sum(dl.investment) AS ProjectedInvestentFor3Months, --[ProjectedInvestment]
   isnull(max(dl.mediancost), 0) AS ICOST, --[ICost]
   Isnull(MAX(dl.mediancost), 0) AS MedianCost, --[MedianCost]
   CONVERT(VARCHAR, Max(DP.PartType)) AS StockingType, --[StockingType]
   1 AS isapproved, --IsApproved
   Sum(Isnull(epp.price, 0) * epp.estimatedannualusage) AS projectedl12revenue , --ProjectedL12Revenue
   sum(dl.EstimatedMonthlyUsage) as EstimatedMonthlyUsage, --EstimatedMonthlyUsage
   SUM(dl.Estimated3MonthUsageWithoutSalesPack) as Estimated3MonthUsageWithoutSalesPack , --EstimatedMonthlyUsage
   SUM(dl.Estimated3MonthUsageWithSalesPack) as Estimated3MonthUsageWithSalesPack,
   Max(epp.price) AS PRICE, --PRICE
   MAX(dl.salespack) as salespack, --SalesPack
   dp.CategoryManager, --CategoryManagerID
   (Select max(CategoryDirectorID) from fpcapps.sicf.CategoryHierarchy (nolock) where CategoryManagerID = DP.CategoryManager)  AS CategoryDirectorID, --CategoryCMOID
   (Select max(CategoryCMOID) from fpcapps.sicf.CategoryHierarchy (nolock))  AS CategoryCMOID, --CreatedOn
   getdate()	  
FROM
   effectivePoolPart epp 
   INNER JOIN
      ctedatabyloacation DL 
      ON dl.company = epp.company 
      AND dl.pool = epp.pool
      AND dl.partnumber = epp.partnumber 
      AND dl.location = epp.location 
   LEFT JOIN
      sicf.[ALLCATS_LineReview101] lr (nolock)
      ON CONVERT(VARCHAR, epp.pool) = lr.pool 
      AND CONVERT(VARCHAR, epp.partnumber) = Ltrim(Rtrim(lr.[Part Number])) 
	LEFT JOIN FPBIDW.EDW.DimProduct DP (nolock)
		ON DP.Pool = dl.Pool
		AND DP.PartNumber = dl.PartNumber
		AND dp.Company = epp.Company 
GROUP BY
   epp.bidid,
   epp.bidpartid,
   epp.crosspartid,
   dp.CategoryManager,
    epp.pool,
   epp.PartNumber
end

---select top 1 * from fpcapps.sicf.[ALLCATS_LineReview101] 


--test
--exec fpcapps.[BM].[InventoryReview_LoadLineReview] 1130
