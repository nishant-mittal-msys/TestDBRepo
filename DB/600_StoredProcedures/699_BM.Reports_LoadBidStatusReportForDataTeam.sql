USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		M Vaqqas
-- Create date: 02/20/2020
-- Description:	Load Bid Status Report daily job for the data team
-- =============================================
CREATE OR ALTER PROCEDURE [BM].[Reports_LoadBidStatusReportForDataTeam]
AS
BEGIN
	--truncate Bid Status Report table
	TRUNCATE TABLE FPCAPPS.BM.[BidStatusReportForDataTeam]

	--insert latest data in Bid Status Report table
	;with cte(
		BidId
		,IsProspect
		,BidStatus
		,BidType
		,BidName
		,BidDescription
		,LaunchDate
		,Company
		,CustNumber
		,CustBranch
		,CustName
		,CustCorpId
		,CustCorpAccName
		,GroupId
		,GroupDesc
		,BidPartId
		,CustomerPartNumber
		,PartDescription
		,Manufacturer
		,ManufacturerPartNumber
		,CrossPartId
		,CrossPoolNumber
		,CrossPartNumber
		,CrossPartDescription
		,PriceToQuote
		,CrossPartInventoryId
		,[Location]
		,CustPartUOM
		,EstimatedAnnualUsage
		,NewPool
		,NewPartNo
		,NewPrice
		,IsActive
		,IType
		,NewIType
		,UpdatedBy
		,UpdatedOn
		,CrossPartLineReviewId
		,DCSafetyStock
		,NPPartType
		,NewNPPartType
		,CrossSupersedeNote
		,NewSupersedeNote
		,CategoryManagerID
		,CategoryManagerName
		,IsApproved
	)
	AS(
		SELECT B.BidId
			,B.IsProspect
			,B.BidStatus
			,B.BidType
			,B.BidName
			,B.BidDescription
			,B.LaunchDate
			,B.Company
			,B.CustNumber
			,B.CustBranch
			,B.CustName
			,B.CustCorpId
			,B.CustCorpAccName
			,B.GroupId
			,B.GroupDesc
			,BP.BidPartId
			,BP.CustomerPartNumber
			,BP.PartDescription
			,BP.Manufacturer
			,BP.ManufacturerPartNumber
			,CP.CrossPartId
			,CP.PoolNumber
			,CP.PartNumber
			,cp.PartDescription
			,CP.PriceToQuote
			,CPI.CrossPartInventoryId
			,CPI.Location
			,CPI.CustPartUOM
			,CPI.EstimatedAnnualUsage
			,ISNULL(CPI.NewPool, CP.PoolNumber) 
			,ISNULL(CPI.NewPartNo, CP.PartNumber)
			,ISNULL(CPI.NewPrice, CP.PriceToQuote)
			,CPI.IsActive
			,NULL
			,NULL
			,CPI.LastUpdatedBy
			,CPI.LastUpdatedOn
			,CPLR.Id
			,CPLR.DCStockCount
			,null
			,null
			,null
			,null
			,CPLR.CategoryManagerID
			,(SELECT DISTINCT TOP 1 ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '')
				FROM FPBIDW.EDW.DimEmployee
				WHERE UserName =  CPLR.CategoryManagerID)
			,CPLR.IsApproved
	FROM FPCAPPS.BM.Bid B(NOLOCK)
		INNER JOIN FPCAPPS.BM.BidPart BP(NOLOCK) ON B.BidID = BP.BidID
		INNER JOIN FPCAPPS.BM.CrossPart CP  (nolock) ON BP.BidPartId = CP.BidPartId
		INNER JOIN FPCAPPS.BM.CrossPartInventory CPI  (nolock) ON CP.CrossPartId = CPI.CrossPartId
		INNER JOIN FPCAPPS.BM.CrossPartLineReview CPLR  (nolock) ON CP.CrossPartId = CPLR.CrossPartId	
	)

	INSERT INTO FPCAPPS.[BM].[BidStatusReportForDataTeam] (
		BidId
		,IsProspect
		,BidStatus
		,BidType
		,BidName
		,BidDescription
		,LaunchDate
		,Company
		,CustNumber
		,CustBranch
		,CustName
		,CustCorpId
		,CustCorpAccName
		,GroupId
		,GroupDesc
		,BidPartId
		,CustomerPartNumber
		,PartDescription
		,Manufacturer
		,ManufacturerPartNumber
		,CrossPartId
		,CrossPoolNumber
		,CrossPartNumber
		,CrossPartDescription
		,PriceToQuote
		,CrossPartInventoryId
		,[Location]
		,CustPartUOM
		,EstimatedAnnualUsage
		,NewPool
		,NewPartNo
		,NewPrice
		,IsActive
		,IType
		,NewIType
		,UpdatedBy
		,UpdatedOn
		,CrossPartLineReviewId
		,DCSafetyStock
		,NPPartType
		,NewNPPartType
		,CrossSupersedeNote
		,NewSupersedeNote
		,CategoryManagerID
		,CategoryManagerName
		,IsApproved
		)
	SELECT cte.BidId
		,cte.IsProspect
		,cte.BidStatus
		,cte.BidType
		,cte.BidName
		,cte.BidDescription
		,cte.LaunchDate
		,cte.Company
		,cte.CustNumber
		,cte.CustBranch
		,cte.CustName
		,cte.CustCorpId
		,cte.CustCorpAccName
		,cte.GroupId
		,cte.GroupDesc
		,cte.BidPartId
		,cte.CustomerPartNumber
		,cte.PartDescription
		,cte.Manufacturer
		,cte.ManufacturerPartNumber
		,cte.CrossPartId
		,cte.CrossPoolNumber
		,cte.CrossPartNumber
		,cte.CrossPartDescription
		,cte.PriceToQuote
		,cte.CrossPartInventoryId
		,cte.Location
		,cte.CustPartUOM
		,cte.EstimatedAnnualUsage
		,cte.NewPool
		,cte.NewPartNo
		,cte.NewPrice
		,cte.IsActive
		,null
		,NewINV.IType
		,cte.UpdatedBy
		,cte.UpdatedOn
		,cte.CrossPartLineReviewId
		,cte.DCSafetyStock
		,null
		,NewDP.PartType
		,null
		,NewINV.SupersedeNote
		,cte.CategoryManagerID
		,cte.CategoryManagerName
		,cte.IsApproved
	FROM cte cte
	LEFT JOIN [FPBIDW].edw.FactInventory NewINV  (nolock) 
		ON cte.NewPartNo = NewINV.PartNumber
		AND cte.NewPool = NewINV.Pool
		AND cte.Location = NewINV.Location
		AND cte.Company = NewINV.Company
	LEFT JOIN FPBIDW.EDW.DimProduct NewDP  (nolock) 
		ON cte.NewPool = newDP.Pool
		AND cte.NewPartNo = newDP.PartNumber
		AND cte.Company = newDP.Company
	WHERE cte.LaunchDate >= DATEADD(day, - 180, GETDATE())
		AND cte.BidStatus IN (
			'DataTeam'
			,'DemandTeam'
			)
		AND cte.IsApproved = 1
		AND cte.IsActive = 'Yes'
		AND ( NewINV.IType is null or NewINV.IType <> 'S')

END

--testing queries
--EXEC BM.Reports_LoadBidStatusReportForDataTeam
--SELECT * FROM BM.[BidStatusReportForDataTeam]