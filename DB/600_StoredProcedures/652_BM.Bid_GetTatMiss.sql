USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Vaqqas
-- Create date: 7/10/19
-- Description:	Get bids missing the TAT
-- =============================================
CREATE OR ALTER PROCEDURE [BM].[Bid_GetTatMiss]
AS
BEGIN
	--DECLARE @EmailMessage NVARCHAR(2000) = 'The Bid may need your immediate attention as the expected turn around date for the current phase has passed.';
	DECLARE @tmp AS TABLE (
		BidId INT
		,BidStatus VARCHAR(255) 
		,BidType VARCHAR(10)
		,BidName VARCHAR(255)
		,CreatedBy VARCHAR(255) 
		,RVPEmail VARCHAR(2000)
		,CreatorEmail VARCHAR(2000) 
		,CMEmail VARCHAR(2000) 
		,NAMEmail VARCHAR(255) 
		,CmoEmail VARCHAR(255)
		)

	INSERT INTO @tmp
	SELECT 
		bid.BidId
		,bid.BidStatus
		,bid.BidType
		,bid.BidName
		,bid.CreatedBy
		,'' AS RVPEmail
		,'' AS CreatorEmail
		,'' AS CMEmail
		,'' AS NAMEmail
		,'' AS CmoEmail
	FROM [FPCAPPS].BM.Bid  (nolock)
	WHERE bid.BidType = 'National'
	AND BidStatus in ( 'CrossFinalization', 'PricingTeam' )
		AND [CurrentPhaseDueDate] < getdate()

	UNION ALL
	
	SELECT DISTINCT
		bid.BidId
		,bid.BidStatus
		,bid.BidType
		,bid.BidName
		,bid.CreatedBy
		,'' AS [RVPEmail]
		,'' AS [CreatorEmail]
		,DE.[EmployeeEmail] AS CMEmail
		,'' AS NAMEmail
		,'' AS CmoEmail
	FROM [FPCAPPS].BM.Bid bid (nolock)
	INNER JOIN BM.BidPart BP (nolock) ON bid.BidId = BP.bidId
	INNER JOIN BM.CMAction CMA (nolock) ON CMA.BidId = BP.bidId
	INNER JOIN FPBIDW.EDW.DimEmployee DE (nolock) ON DE.UserName = CMA.CMUserId
	WHERE  bid.BidType = 'National'
		AND bid.BidStatus = 'CategoryManager'
		AND bid.[CurrentPhaseDueDate] < getdate()
		AND CMA.CMActionStatus IS NULL
	UNION ALL
	SELECT 
		bid.BidId
		,bid.BidStatus
		,bid.BidType
		,bid.BidName
		,bid.CreatedBy
		,reg.RVPEmail AS RVPEmail
		,'' AS CreatorEmail
		,'' AS CMEmail
		,'' AS NAMEmail
		,'' AS CmoEmail
	FROM [FPCAPPS].BM.Bid bid (nolock)
	INNER JOIN FPBIDW.EDW.DimCustomer CUST (nolock) ON bid.Company = cust.Company AND convert(nvarchar(50), BID.CustNumber) = cust.CustNumber AND Bid.CustBranch = cust.CustBranch
	INNER JOIN FPBIDW.EDW.DimRegion reg (nolock) on cust.RegionKey = reg.RegionKey and RVPEmail not in ('', 'Unknown')
	WHERE  bid.BidType = 'Regional'
		AND bid.BidStatus in ('CategoryManager', 'CrowdSourcing', 'CrossFinalization', 'PricingTeam' )
		AND bid.[CurrentPhaseDueDate] < getdate()
	UNION ALL
	SELECT DISTINCT
		bid.BidId
		,bid.BidStatus
		,bid.BidType
		,bid.BidName
		,bid.CreatedBy
		,'' AS RVPEmail
		,'' AS CreatorEmail
		,DE.EmployeeEmail AS CMEmail
		,'' AS NAMEmail
		,'' AS CmoEmail
	FROM [FPCAPPS].BM.Bid bid (nolock)
	INNER JOIN BM.BidPart BP (nolock) ON bid.BidId = BP.bidId
	INNER JOIN BM.CMAction CMA (nolock) ON CMA.BidId = BP.bidId
	INNER JOIN FPBIDW.EDW.DimEmployee DE (nolock) ON DE.UserName = CMA.CMUserId
	WHERE  bid.BidType = 'Regional'
		AND bid.BidStatus = 'CategoryManager'
		AND bid.[CurrentPhaseDueDate] < getdate()	
		AND CMA.CMActionStatus IS NULL

	UNION ALL
	
	SELECT DISTINCT
		bid.BidId
		,bid.BidStatus
		,bid.BidType
		,bid.BidName
		,bid.CreatedBy
		,'' AS [RVPEmail]
		,'' AS [CreatorEmail]
		,DE.[EmployeeEmail] AS CMEmail
		,'' AS NAMEmail
		,'' AS CmoEmail
	FROM [FPCAPPS].BM.Bid bid (nolock)
	INNER JOIN BM.BidPart BP (nolock) ON bid.BidId = BP.bidId
	INNER JOIN BM.InventoryReviewAction ira (nolock) ON ira.BidId = BP.bidId
	INNER JOIN FPBIDW.EDW.DimEmployee DE (nolock) ON DE.UserName = ira.UserId
	WHERE  bid.BidType = 'National'
		AND bid.BidStatus = 'LineReview_CM'
		AND bid.[CurrentPhaseDueDate] < getdate()
		AND ira.ActionStatus IS NULL

	UNION ALL
	
	SELECT DISTINCT
		bid.BidId
		,bid.BidStatus
		,bid.BidType
		,bid.BidName
		,bid.CreatedBy
		,'' AS [RVPEmail]
		,'' AS [CreatorEmail]
		,'' AS CMEmail
		,'' AS NAMEmail
		,DE.[EmployeeEmail] AS CmoEmail
	FROM [FPCAPPS].BM.Bid bid (nolock)
	INNER JOIN BM.BidPart BP (nolock) ON bid.BidId = BP.bidId
	INNER JOIN BM.InventoryReviewAction ira (nolock) ON ira.BidId = BP.bidId
	INNER JOIN FPBIDW.EDW.DimEmployee DE (nolock) ON DE.UserName = ira.UserId
	WHERE  bid.BidType = 'National'
		AND bid.BidStatus = 'LineReview_VP'
		AND bid.[CurrentPhaseDueDate] < getdate()
		AND ira.ActionStatus IS NULL

	UPDATE t
	SET t.CreatorEmail = isnull(DE.EmployeeEmail, DU.[EmailAddress])
	FROM @tmp t
	LEFT OUTER JOIN FPBIDW.EDW.DimEmployee DE (nolock) on t.CreatedBy = DE.UserName
	LEFT OUTER JOIN [BM].[DelegateUser] DU (nolock) on t.CreatedBy = DU.[DelegateUserId]

	SELECT 
		BidId 
		,BidStatus 
		,BidType 
		,BidName 
		,(SELECT top 1 RVPEmail FROM @tmp t WHERE t.BidId = t1.BidId) AS RVPEmail
		,(SELECT top 1 CreatorEmail FROM @tmp t WHERE t.BidId = t1.BidId) as CreatorEmail
		,isnull(STUFF((
			SELECT ',' + t.CMEmail
			FROM @tmp t
			WHERE t.BidId = t1.BidId and t.CMEmail <> ''
			FOR XML PATH('')
		),1,1,''), '') AS CMEmail
		,(SELECT top 1 NAMEmail FROM @tmp t WHERE t.BidId = t1.BidId) AS NAMEmail 
		,(SELECT top 1 CmoEmail FROM @tmp t WHERE t.BidId = t1.BidId) AS CmoEmail 
	FROM @tmp t1
	GROUP BY BidId 
		,BidStatus 
		,BidType 
		,BidName 
		
END

--exec [FPCAPPS].[BM].[Bid_GetTatMiss]