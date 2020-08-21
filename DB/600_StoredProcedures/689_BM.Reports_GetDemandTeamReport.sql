USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal	
-- Create date: 01/10/20
-- Description:	Get demand report
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[Reports_GetDemandTeamReport] (
	@BidId INT
	,@ApprovalType BIT = NULL
	,@UserId NVARCHAR(100) = NULL
	,@UserRole VARCHAR(50) = NULL
	)
AS
BEGIN
	DECLARE @Company TINYINT = 1

	SET @Company = (
			SELECT Company
			FROM BM.Bid
			WHERE BidId = @BidId
			)

	IF OBJECT_ID('tempdb..#TempDemandTeamReport') IS NOT NULL
	DROP TABLE #TempDemandTeamReport;

	;WITH cteCPI (
		BidPartId
		,CustomerPartNumber
		,ManufacturerPartNumber
		,PartDescription
		,CrossPartId
		,CrossPoolNumber
		,CrossPartNumber
		,CrossPartDescription
		,CrossPrice
		,CrossPartInventoryId
		,Location
		,CustPartUOM
		,EstimatedAnnualUsage
		,NewPool
		,NewPartNo
		,NewPrice
		,IsActive
		,StockingType
		,NewStockingType
		,CategoryManagerID
		,LastUpdatedBy
		,LastUpdatedOn
		,EventType
		,ActionType
		,RowNumber
		)
	AS (
		SELECT BP.BidPartId
			,BP.CustomerPartNumber
			,BP.ManufacturerPartNumber
			,BP.PartDescription
			,CP.CrossPartId
			,CP.PoolNumber AS CrossPoolNumber
			,CP.PartNumber AS CrossPartNumber
			,CP.PartDescription AS CrossPartDescription
			,CP.PriceToQuote AS CrossPrice
			,CPI.CrossPartInventoryId
			,CPI.[Location]
			,CPI.CustPartUOM
			,CPI.EstimatedAnnualUsage
			,CPI.NewPool
			,CPI.NewPartNo
			,CPI.NewPrice
			,CPI.IsActive
			--,CPI.StockingType
			--,CPI.NewStockingType
			,NULL
			,NULL
			,CPLR.CategoryManagerID
			,CPI.LastUpdatedBy
			,CPI.LastUpdatedOn
			,NULL AS EventType
			,NULL AS ActionType
			,NULL AS RowNumber
		FROM FPCAPPS.BM.BidPart BP (nolock) 
		LEFT JOIN FPCAPPS.BM.CrossPart CP  (nolock) ON BP.BidPartId = CP.BidPartId
		LEFT JOIN FPCAPPS.BM.CrossPartInventory CPI  (nolock) ON CP.CrossPartId = CPI.CrossPartId
		LEFT JOIN FPCAPPS.BM.CrossPartLineReview CPLR  (nolock) ON CPLR.CrossPartId = CPI.CrossPartId
		WHERE BP.BidId = @BidId
			AND CPLR.IsApproved = @ApprovalType
		)
		,cteCPIH (
		CrossPartInventoryId
		,NewPool
		,NewPartNo
		,NewPrice
		,NewStockingType
		,RowNumber
		,PriceRowNumber
		)
	AS (
		SELECT 
			cpih.CrossPartInventoryId
			,CPIH.NewPool
			,CPIH.NewPartNo
			,CPIH.NewPrice
			--,max(cpih.NewStockingType)
			,NULL
			,rank() OVER (
				PARTITION BY CPIH.CrossPartInventoryId ORDER BY CPIH.LastUpdatedOn DESC
				) AS RowNumber
			,rank() OVER (
				PARTITION BY CPIH.NewPartNo ORDER BY CPIH.NewPrice DESC
				) AS PriceRowNumber
		FROM FPCAPPS.BM.BidPart BP (nolock) 
		LEFT JOIN FPCAPPS.BM.CrossPart CP  (nolock) ON BP.BidPartId = CP.BidPartId
		LEFT JOIN FPCAPPS.BM.CrossPartInventoryHistory CPIH  (nolock) ON CP.CrossPartId = CPIH.CrossPartId
		LEFT JOIN FPCAPPS.BM.CrossPartLineReview CPLR  (nolock) ON CPLR.CrossPartId = CPIH.CrossPartId
		WHERE BP.BidId = @BidId
			AND CPLR.IsApproved = @ApprovalType
			AND CPIH.EventType IN ('UPDATE')
		group by cpih.CrossPartInventoryId, cpih.NewPool, cpih.NewPartNo, cpih.NewPrice, CPIH.LastUpdatedOn
		)
	,cteCPIH_LastVersion(			
		CrossPartInventoryId
		,NewPool
		,NewPartNo
		,NewPrice
		,NewStockingType
		,RowNumber
		,PriceRowNumber
		)
	AS (
		SELECT CrossPartInventoryId
		,NewPool
		,NewPartNo
		,NewPrice
		,NULL
		,RowNumber
		,PriceRowNumber
		FROM cteCPIH CPIH (nolock) 
		WHERE CPIH.RowNumber = 2 and CPIH.PriceRowNumber = 1
		)
	,cteParts(BidPartId
		,CustomerPartNumber
		,ManufacturerPartNumber
		,PartDescription
		,CrossPartId
		,Pool
		,PartNumber
		,Price
		,StockingType
		,CrossPartInventoryId
		,Location
		,CustPartUOM
		,EstimatedAnnualUsage
		,OldPool
		,OldPartNumber
		,OldPrice
		,OldStockingType
		,CategoryManagerID
		,IsActive
		,LastUpdatedBy
		,LastUpdatedOn)
	AS(
	SELECT 
		v1.BidPartId As BidPartId
		,v1.CustomerPartNumber As CustomerPartNumber
		,v1.ManufacturerPartNumber As ManufacturerPartNumber
		,v1.PartDescription As PartDescription
		,v1.CrossPartId As CrossPartId
		,isnull(v1.NewPool, v1.CrossPoolNumber) AS Pool
		,isnull(v1.NewPartNo, v1.CrossPartNumber) as PartNumber
		,(case WHEN v1.NewPartNo IS NULL then v1.CrossPrice ELSE  V1.NewPrice END) AS Price
		,'' AS StockingType
		,v1.CrossPartInventoryId
		,v1.Location
		,v1.CustPartUOM
		,v1.EstimatedAnnualUsage
		,case when v1.NewPool is not null then isnull(v2.NewPool, v1.CrossPoolNumber) else null end as OldPool
		,case when v1.NewPartNo is not null then isnull(v2.NewPartNo, v1.CrossPartNumber) else null end as OldPartNumber
		,case when v1.NewPrice is not null then isnull(v2.NewPrice, v1.CrossPrice) else null end as OldPrice
		,'' AS OldStockingType
		,v1.CategoryManagerID AS CategoryManagerID
		,v1.IsActive AS IsActive
		,v1.LastUpdatedBy AS LastUpdatedBy
		,v1.LastUpdatedOn AS LastUpdatedOn
	FROM cteCPI v1
	LEFT JOIN cteCPIH_LastVersion v2  (nolock) ON v1.CrossPartInventoryId = v2.CrossPartInventoryId
	)
	--SELECT 
	--BidPartId
	--	,CustomerPartNumber
	--	,ManufacturerPartNumber
	--	,PartDescription
	--	,CrossPartId
	--	,c.Pool
	--	,c.PartNumber
	--	,Price
	--	,newpartInv.IType as StockingType
	--	,CrossPartInventoryId
	--	,c.Location
	--	,CustPartUOM
	--	,EstimatedAnnualUsage
	--	,OldPool
	--	,OldPartNumber
	--	,OldPrice
	--	,cpINV.IType as OldStockingType
	--	,CategoryManagerID
	--	,IsActive
	--	,LastUpdatedBy
	--	,LastUpdatedOn
	--From cteParts c
	--left JOIN [FPBIDW].edw.FactInventory newpartINV  (nolock) 
	--		ON c.PartNumber = newpartINV.PartNumber
	--		AND c.Pool = newpartINV.Pool
	--		AND c.Location = newpartINV.Location
	--		AND (@Company = newpartINV.Company  OR newpartINV.Company is null) 
	--	left JOIN [FPBIDW].edw.FactInventory cpINV  (nolock) 
	--		ON c.OldPartNumber  = cpINV.PartNumber
	--		AND c.OldPool  = cpINV.Pool
	--		AND c.Location = cpINV.Location
	--		AND (@Company = cpINV.Company  OR cpINV.Company is null)

	SELECT 
		BidPartId
		,CustomerPartNumber
		,ManufacturerPartNumber
		,PartDescription
		,CrossPartId
		,c.Pool
		,c.PartNumber
		,Price
		,newpartInv.IType as StockingType
		,CrossPartInventoryId
		,c.Location
		,CustPartUOM
		,EstimatedAnnualUsage
		,OldPool
		,OldPartNumber
		,OldPrice
		,cpINV.IType as OldStockingType
		,CategoryManagerID
		,IsActive
		,LastUpdatedBy
		,LastUpdatedOn 
	INTO #TempDemandTeamReport
	From cteParts c
	left JOIN [FPBIDW_PRD].edw.FactInventory newpartINV  (nolock) 
			ON c.PartNumber = newpartINV.PartNumber
			AND c.Pool = newpartINV.Pool
			AND c.Location = newpartINV.Location
			AND (@Company = newpartINV.Company  OR newpartINV.Company is null) 
		left JOIN [FPBIDW_PRD].edw.FactInventory cpINV  (nolock) 
			ON c.OldPartNumber  = cpINV.PartNumber
			AND c.OldPool  = cpINV.Pool
			AND c.Location = cpINV.Location
			AND (@Company = cpINV.Company  OR cpINV.Company is null)
	
	SELECT 
		BidPartId
		,CustomerPartNumber
		,ManufacturerPartNumber
		,PartDescription
		,CrossPartId
		,[Pool]
		,PartNumber
		,Price
		,StockingType
		,CrossPartInventoryId
		,[Location]
		,CustPartUOM
		,EstimatedAnnualUsage
		,OldPool
		,OldPartNumber
		,OldPrice
		,OldStockingType
		,CategoryManagerID
		,IsActive
		,LastUpdatedBy
		,LastUpdatedOn 
	FROM #TempDemandTeamReport

	UNION

	SELECT 
		BidPartId
		,CustomerPartNumber
		,ManufacturerPartNumber
		,PartDescription
		,CrossPartId
		,kit.KCPOOL AS [Pool]
		,kit.KCPARTNO AS PartNumber
		,NULL AS Price
		,kit.KCTYPE as StockingType
		,CrossPartInventoryId
		,[Location]
		,CustPartUOM
		,EstimatedAnnualUsage
		,NULL AS OldPool
		,NULL AS OldPartNumber
		,NULL AS OldPrice
		,'' AS OldStockingType
		,CategoryManagerID
		,IsActive
		,LastUpdatedBy
		,LastUpdatedOn 
	FROM #TempDemandTeamReport
	left join [FPBISTG_PRD].dbo.INMKIT kit  (nolock) on
		PartNumber  =  kit.KPARTNO 
		and [Pool]  = kit.KPOOL 
		and Location = kit.KLOCATE
		WHERE StockingType = 'K'
	
END
GO

--test query
--exec [BM].[Reports_GetDemandTeamReport]  2417, 1
