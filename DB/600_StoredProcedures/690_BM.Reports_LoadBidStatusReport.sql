USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal	
-- Create date: 01/14/2020
-- Description:	Load Bid Status Report weekly job
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[Reports_LoadBidStatusReport]
AS
BEGIN
	--truncate Bid Status Report table
	TRUNCATE TABLE FPCAPPS.BM.[BidStatusReport]

	--insert latest data in Bid Status Report table
	INSERT INTO FPCAPPS.[BM].[BidStatusReport] (
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
		,CP.PartDescription
		,CP.PriceToQuote
		,CPI.CrossPartInventoryId
		,CPI.Location
		,CPI.CustPartUOM
		,CPI.EstimatedAnnualUsage
		,CPI.NewPool
		,CPI.NewPartNo
		,CPI.NewPrice
		,CPI.IsActive
		,CPINV.IType
		,NewINV.IType
		,CPI.LastUpdatedBy
		,CPI.LastUpdatedOn
		,CPLR.Id
		,CPLR.DCStockCount
		,DP.PartType
		,NewDP.PartType
		,CPINV.SupersedeNote
		,NewINV.SupersedeNote
		,CPLR.CategoryManagerID
		,(SELECT DISTINCT TOP 1 ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '')
			FROM FPBIDW.EDW.DimEmployee (nolock) 
			WHERE UserName =  CPLR.CategoryManagerID)
		,CPLR.IsApproved
	FROM FPCAPPS.BM.Bid B(NOLOCK)
	INNER JOIN FPCAPPS.BM.BidPart BP(NOLOCK) ON B.BidID = BP.BidID
	INNER JOIN FPCAPPS.BM.CrossPart CP  (nolock) ON BP.BidPartId = CP.BidPartId
	INNER JOIN FPCAPPS.BM.CrossPartInventory CPI  (nolock) ON CP.CrossPartId = CPI.CrossPartId
	INNER JOIN FPCAPPS.BM.CrossPartLineReview CPLR  (nolock) ON CP.CrossPartId = CPLR.CrossPartId
	LEFT JOIN [FPBIDW].edw.FactInventory CPINV  (nolock) 
	ON ltrim(rtrim(CP.PartNumber)) = ltrim(rtrim(CPINV.PartNumber))
	AND CP.PoolNumber = CPINV.Pool
	AND CPI.Location = CPINV.Location
	AND B.Company = CPINV.Company
	LEFT JOIN [FPBIDW].edw.FactInventory NewINV  (nolock) 
	ON ltrim(rtrim(CPI.NewPartNo)) = ltrim(rtrim(NewINV.PartNumber))
	AND CPI.NewPool = NewINV.Pool
	AND CPI.Location = NewINV.Location
	AND B.Company = NewINV.Company
	LEFT JOIN FPBIDW.EDW.DimProduct DP (nolock) 
		ON DP.Pool = CP.PoolNumber
		AND ltrim(rtrim(DP.PartNumber)) = ltrim(rtrim(CP.PartNumber))
		AND DP.Company = B.Company
	LEFT JOIN FPBIDW.EDW.DimProduct NewDP  (nolock) 
		ON NewDP.Pool = CPI.NewPool
		AND ltrim(rtrim(NewDP.PartNumber)) = ltrim(rtrim(CPI.NewPartNo))
		AND NewDP.Company = B.Company
	WHERE --B.LaunchDate >= DATEADD(day, - 180, GETDATE())
		B.BidStatus IN (
			'DataTeam'
			,'DemandTeam'
			)
		AND CPLR.IsApproved = 1
		AND CPI.IsActive = 'Yes'
END

--testing queries
--EXEC BM.Reports_LoadBidStatusReport
--SELECT * FROM BM.BidStatusReport