USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal	
-- Create date: 01/10/20
-- Description:	Get Bid Status Report
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[Reports_GetBidStatusReport] (
	@UserId NVARCHAR(100) = NULL
	,@UserRole VARCHAR(50) = NULL
	)
AS
BEGIN
-- Modified to dynamically pull the status report for now instead of scheduling through a job 

	--SELECT 
	--	 [Id]
	--	,[BidId]
	--	,[IsProspect]
	--	,[BidStatus]
	--	,[BidType]
	--	,[BidName]
	--	,[BidDescription]
	--	,[LaunchDate]
	--	,[Company]
	--	,[CustNumber]
	--	,[CustBranch]
	--	,[CustName]
	--	,[CustCorpId]
	--	,[CustCorpAccName]
	--	,[GroupId]
	--	,[GroupDesc]
	--	,[BidPartId]
	--	,[CustomerPartNumber]
	--	,[PartDescription]
	--	,[Manufacturer]
	--	,[ManufacturerPartNumber]
	--	,[CrossPartId]
	--	,[CrossPartNumber]
	--	,[CrossPoolNumber]
	--	,[CrossPartDescription]
	--	,[PriceToQuote]
	--	,[CrossPartInventoryId]
	--	,[Location]
	--	,[CustPartUOM]
	--	,[EstimatedAnnualUsage]
	--	,[NewPool]
	--	,[NewPartNo]
	--	,[NewPrice]
	--	,[IsActive]
	--	,[IType]		 
	--	,[NewIType]		 
	--	,[UpdatedBy]
	--	,[UpdatedOn]
	--	,[CrossPartLineReviewId]
	--	,[DCSafetyStock]
	--	,[NPPartType]
	--	,[NewNPPartType]
	--	,[CrossSupersedeNote]
	--	,[NewSupersedeNote]
	--	,[CategoryManagerID]
	--	,[CategoryManagerName]
	--	,[IsApproved]
	--FROM BM.BidStatusReport (nolock) 

	--	SELECT B.BidId
	--	,B.IsProspect
	--	,B.BidStatus
	--	,B.BidType
	--	,B.BidName
	--	,B.BidDescription
	--	,B.LaunchDate
	--	,B.Company
	--	,B.CustNumber
	--	,B.CustBranch
	--	,B.CustName
	--	,B.CustCorpId
	--	,B.CustCorpAccName
	--	,B.GroupId
	--	,B.GroupDesc
	--	,BP.BidPartId
	--	,BP.CustomerPartNumber
	--	,BP.PartDescription
	--	,BP.Manufacturer
	--	,BP.ManufacturerPartNumber
	--	,CP.CrossPartId
	--	,CP.PoolNumber as CrossPoolNumber
	--	,CP.PartNumber as CrossPartNumber
	--	,CP.PartDescription as CrossPartDescription
	--	,CP.PriceToQuote
	--	,CPI.CrossPartInventoryId
	--	,CPI.Location
	--	,CPI.CustPartUOM
	--	,CPI.EstimatedAnnualUsage
	--	,CPI.NewPool
	--	,CPI.NewPartNo
	--	,CPI.NewPrice
	--	,CPI.IsActive
	--	,CPINV.IType
	--	,NewINV.IType as NewIType
	--	,CPI.LastUpdatedBy as UpdatedBy
	--	,CPI.LastUpdatedOn as UpdatedOn
	--	,CPLR.Id as CrossPartLineReviewId
	--	,CPLR.DCStockCount as DCSafetyStock
	--	,DP.PartType as NPPartType
	--	,NewDP.PartType as NewNPPartType
	--	,CPINV.SupersedeNote as CrossSupersedeNote
	--	,NewINV.SupersedeNote as NewSupersedeNote
	--	,CPLR.CategoryManagerID
	--	,(SELECT DISTINCT TOP 1 ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '')
	--		FROM FPBIDW.EDW.DimEmployee (nolock) 
	--		WHERE UserName =  CPLR.CategoryManagerID) as CategoryManagerName
	--	,CPLR.IsApproved
	--FROM FPCAPPS.BM.Bid B(NOLOCK)
	--INNER JOIN FPCAPPS.BM.BidPart BP(NOLOCK) ON B.BidID = BP.BidID
	--INNER JOIN FPCAPPS.BM.CrossPart CP  (nolock) ON BP.BidPartId = CP.BidPartId
	--INNER JOIN FPCAPPS.BM.CrossPartInventory CPI  (nolock) ON CP.CrossPartId = CPI.CrossPartId
	--INNER JOIN FPCAPPS.BM.CrossPartLineReview CPLR  (nolock) ON CP.CrossPartId = CPLR.CrossPartId
	--LEFT JOIN [FPBIDW].edw.FactInventory CPINV  (nolock) 
	--ON ltrim(rtrim(CP.PartNumber)) = ltrim(rtrim(CPINV.PartNumber))
	--AND CP.PoolNumber = CPINV.Pool
	--AND CPI.Location = CPINV.Location
	--AND B.Company = CPINV.Company
	--LEFT JOIN [FPBIDW].edw.FactInventory NewINV  (nolock) 
	--ON ltrim(rtrim(CPI.NewPartNo)) = ltrim(rtrim(NewINV.PartNumber))
	--AND CPI.NewPool = NewINV.Pool
	--AND CPI.Location = NewINV.Location
	--AND B.Company = NewINV.Company
	--LEFT JOIN FPBIDW.EDW.DimProduct DP (nolock) 
	--	ON DP.Pool = CP.PoolNumber
	--	AND ltrim(rtrim(DP.PartNumber)) = ltrim(rtrim(CP.PartNumber))
	--	AND DP.Company = B.Company
	--LEFT JOIN FPBIDW.EDW.DimProduct NewDP  (nolock) 
	--	ON NewDP.Pool = CPI.NewPool
	--	AND ltrim(rtrim(NewDP.PartNumber)) = ltrim(rtrim(CPI.NewPartNo))
	--	AND NewDP.Company = B.Company
	--WHERE --B.LaunchDate >= DATEADD(day, - 180, GETDATE())
	--	B.BidStatus IN (
	--		'DataTeam'
	--		,'DemandTeam'
	--		)
	--	AND CPLR.IsApproved = 1
	--	AND CPI.IsActive = 'Yes'

	
	IF OBJECT_ID('tempdb..#TempBidStatusReport') IS NOT NULL
	DROP TABLE #TempBidStatusReport;

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
		,CP.PoolNumber as CrossPoolNumber
		,CP.PartNumber as CrossPartNumber
		,CP.PartDescription as CrossPartDescription
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
		,NewINV.IType as NewIType
		,CPI.LastUpdatedBy as UpdatedBy
		,CPI.LastUpdatedOn as UpdatedOn
		,CPLR.Id as CrossPartLineReviewId
		,CPLR.DCStockCount as DCSafetyStock
		,DP.PartType as NPPartType
		,NewDP.PartType as NewNPPartType
		,CPINV.SupersedeNote as CrossSupersedeNote
		,NewINV.SupersedeNote as NewSupersedeNote
		,CPLR.CategoryManagerID
		,(SELECT DISTINCT TOP 1 ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '')
			FROM FPBIDW.EDW.DimEmployee (nolock) 
			WHERE UserName =  CPLR.CategoryManagerID) as CategoryManagerName
		,CPLR.IsApproved
	INTO #TempBidStatusReport 
	FROM FPCAPPS.BM.Bid B(NOLOCK)
	INNER JOIN FPCAPPS.BM.BidPart BP(NOLOCK) ON B.BidID = BP.BidID
	INNER JOIN FPCAPPS.BM.CrossPart CP  (nolock) ON BP.BidPartId = CP.BidPartId
	INNER JOIN FPCAPPS.BM.CrossPartInventory CPI  (nolock) ON CP.CrossPartId = CPI.CrossPartId
	INNER JOIN FPCAPPS.BM.CrossPartLineReview CPLR  (nolock) ON CP.CrossPartId = CPLR.CrossPartId
	LEFT JOIN [FPBIDW_PRD].edw.FactInventory CPINV  (nolock) 
	ON ltrim(rtrim(CP.PartNumber)) = ltrim(rtrim(CPINV.PartNumber))
	AND CP.PoolNumber = CPINV.Pool
	AND CPI.Location = CPINV.Location
	AND B.Company = CPINV.Company
	LEFT JOIN [FPBIDW_PRD].edw.FactInventory NewINV  (nolock) 
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


	SELECT BidId
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
		,Location
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
	FROM #TempBidStatusReport

	UNION

	SELECT BidId
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
		,kit.KCPOOL AS CrossPoolNumber
		,kit.KCPARTNO AS CrossPartNumber
		,CrossPartDescription
		,PriceToQuote
		,CrossPartInventoryId
		,Location
		,CustPartUOM
		,EstimatedAnnualUsage
		,NULL AS NewPool
		,NULL AS NewPartNo
		,NULL AS NewPrice
		,IsActive
		,kit.KCTYPE as IType
		,NULL AS  NewIType
		,UpdatedBy
		,UpdatedOn
		,CrossPartLineReviewId
		,DCSafetyStock
		,NPPartType
		,NULL AS NewNPPartType
		,CrossSupersedeNote
		,NULL AS NewSupersedeNote
		,CategoryManagerID
		,CategoryManagerName
		,IsApproved
	FROM #TempBidStatusReport
	left join [FPBISTG_PRD].dbo.INMKIT kit  (nolock) on
		--CrossPartNumber  =  kit.KPARTNO 
		--and CrossPoolNumber  = kit.KPOOL 
		--and Location = kit.KLOCATE
		--WHERE IType = 'K'
		ISNULL(NewPool, CrossPoolNumber) =  kit.KPOOL
		AND ISNULL(NewPartNo, CrossPartNumber)  = kit.KPARTNO 
		AND Location = kit.KLOCATE
		WHERE NewIType = 'K' OR IType = 'K'

END
GO


