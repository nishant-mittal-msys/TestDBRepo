-----------------------------Update Delegate user -----------------------------------------------------

update FPCAPPS.BM.DelegateUser set PrincipalUserId = 'RGABMLE', [UserRole] = 'SuperUser' where DelegateUserId = 'pure-mvaq'

insert into FPCAPPS.[BM].[DelegateUser] values(
	 'pure-vsingh'--[DelegateUserId] [varchar](100) NOT NULL
	,'pure-vsingh'--[PrincipalUserId] [varchar](100) NOT NULL
	,'SuperUser'--[UserRole] [varchar](100) NOT NULL
	,'Vijay.Singh@fleetpride.com'--[EmailAddress] [varchar](500) NULL
	) 
GO

delete from FPCAPPS.[BM].[DelegateUser] where PrincipalUserId = 'pure-nmittal'

select * from FPCAPPS.[BM].[DelegateUser] where UserRole = 'CategoryManager'
update FPCAPPS.BM.DelegateUser set PrincipalUserId = 'lballe' where DelegateUserId = 'pure-gsingh'
update FPCAPPS.BM.DelegateUser set PrincipalUserId = 'lballe' where DelegateUserId = 'pure-nmittal'
update FPCAPPS.BM.DelegateUser set PrincipalUserId = 'lballe' where DelegateUserId = 'pure-mvaq'
update FPCAPPS.BM.DelegateUser set PrincipalUserId = 'gurpreet.singh1' where DelegateUserId = 'gurpreet.singh1'
update FPCAPPS.BM.DelegateUser set PrincipalUserId = 'Nishant.Mittal' where DelegateUserId = 'Nishant.Mittal'
update FPCAPPS.BM.DelegateUser set UserRole = 'CategoryManager' where PrincipalUserId = 'BWATSON'
update FPCAPPS.BM.DelegateUser set UserRole = 'SuperUser' where DelegateUserId = 'Nishant.Mittal'
update FPCAPPS.BM.DelegateUser set UserRole = 'SuperUser' where DelegateUserId = 'pure-nmittal'

select * from fpcapps.bm.DelegateUser
insert into fpcapps.bm.DelegateUser values('pure-mvaq', 'vkandukuri', 'SuperUser', 'md.vaqqas@puresoftware.com')

update FPCAPPS.BM.DelegateUser set PrincipalUserId = 'RGAMBLE', UserRole = 'SuperUser' where DelegateUserId in ('md.vaqqas', 'pure-mvaq')

update FPCAPPS.BM.DelegateUser set PrincipalUserId = 'KWilson', UserRole = 'CategoryManager' where DelegateUserId in ('md.vaqqas', 'pure-mvaq')
update FPCAPPS.BM.DelegateUser set PrincipalUserId = 'MFisher', UserRole = 'CategoryManager' where DelegateUserId in ('md.vaqqas', 'pure-mvaq')
update FPCAPPS.BM.DelegateUser set PrincipalUserId = 'JSAUNDERS', UserRole = 'CategoryManager' where DelegateUserId in ('md.vaqqas', 'pure-mvaq')
update FPCAPPS.BM.DelegateUser set PrincipalUserId = 'jbuysse', UserRole = 'CategoryManager' where DelegateUserId in ('md.vaqqas', 'pure-mvaq')
update FPCAPPS.BM.DelegateUser set PrincipalUserId = 'RSammons', UserRole = 'CategoryVP' where DelegateUserId in ('md.vaqqas', 'pure-mvaq')
update FPCAPPS.BM.DelegateUser set PrincipalUserId = 'RGAMBLE', UserRole = 'SuperUser' where DelegateUserId in ('md.vaqqas', 'pure-mvaq')

select top 100 DP.Category from FPBIDW.EDW.DimProduct DP ON 

select *
from fpcapps.bm.bid
where BidName = 'Test Bid'
where bidId = 1182
where BidStatus = 'LineReview_CM'

select * from fpcapps.bm.InventoryReviewAction 
--where ActionStatus is null and userRole = 'CategoryManager'
where bidid in (
1129)

truncate table fpcapps.bm.CrossPartLineReview

select * from fpcapps.bm.InventoryReviewAction where role = 'CategoryManager'

SELECT 
		CPI.CrossPartId AS CrossPartId
		,count(CPI.Location) AS AlreadyStockingLocations
	FROM 
	FPCAPPS.BM.Bid b
		inner join FPCAPPS.BM.BidPart BP on b.BidId = BP.BidId
		inner join FPCAPPS.BM.CrossPart CP ON BP.BidPartId = CP.BidPartId
		INNER JOIN FPCAPPS.[BM].[CrossPartInventory] CPI ON CPI.CrossPartID = CP.CrossPartId
	WHERE CPI.StockingType in ('C','K','O''S') AND b.BidID = 1129
	GROUP BY CPI.CrossPartId


----------------------------------------------------------------------------------------------------------
select * from FPCAPPS.BM.DelegateUser 
update FPCAPPS.BM.DelegateUser set PrincipalUserId = 'Nishant.Mittal' where DelegateUserId = 'Nishant.Mittal'
update FPCAPPS.BM.DelegateUser set userrole = 'SuperUser' where delegateuserid = 'Nishant.Mittal'

------------------Select Master tables/views -----------------------------

select top 10 * from fpbistg.dbo.inmcross
select top 100 * from fpbidw.edw.dimproduct where partnumber = '2339131-552'
select top 100 * from fpbidw.edw.dimproduct where productkey = 31284

select top 100 * from fpbidw.edw.dimemployee where username in ('jroberts2', 'ihernandez')
select top 10 * from fpbidw.edw.dimcustomer where IsNatAccount = 'N'

select top 100 ADUserId, * from fpbidw.edw.dimemployee where lastname = 'Roth'

select * from FPCAPPS.BM.DelegateUser
select * from FPCAPPS.BM.Bid where bidid in (1072,1105)
select * from FPCAPPS.BM.Bid order by bidid desc
select * from FPCAPPS.BM.BidPart where bidpartid = 1245
select * from FPCAPPS.BM.BidPart where IsSubmitted = 1 or IsValidated = 1
select top 10  * from FPCAPPS.BM.BidPart order by BidPartId desc

select * from FPCAPPS.BM.CrossPart where bidpartid = 1245
select * from FPCAPPS.BM.CrossPart where crosspartid in (598988)
select * from FPCAPPS.BM.CrossPart where [Source] = 'CrowdSourcing'
select * from FPCAPPS.BM.CrossPart where [Source] = 'System'
select * from FPCAPPS.BM.CrossPart where BidPartId = 1095 and [Source] = 'CrowdSourcing'
select top 1  * from FPCAPPS.BM.CrossPart order by CrossPartId desc

select top 100 * from  FPCAPPS.BM.VendorGrade order by vendornumber desc
select top 100 * from  FPCAPPS.BM.VendorGrade_backup order by vendornumber desc

select count(*) FROM FPCAPPS.BM.VendorGrade
select count(*) FROM FPCAPPS.BM.VendorGrade_backup



select * from FPCAPPS.BM.TAT
select * from FPCAPPS.BM.UserAction

SELECT * FROM FPCAPPS.BM.BID WHERE BIDnAME LIKE 'tEST NATIONAL%'
select TOP 10 * from FPCAPPS.BM.CrossPartInventory --WHERE BIDiD = 2255
order by CrossPartInventoryId desc

select * from FPCAPPS.BM.CrossPartInventory  WHERE BIDiD = 2255
order by Id desc

select * from FPCAPPS.BM.CrossPartInventoryHistory  WHERE BIDiD = 2255 and CrossPartInventoryId = 4781
order by lastupdatedby desc
order by Id desc

select top 10 * from FPCAPPS.BM.CrossPart

SELECT PartNumber
	,COUNT(PartNumber) AS count_partNo
	,DateValue = STUFF((
			SELECT ', ' + CONVERT(VARCHAR, convert(DATE, createdon))
			FROM FPCAPPS.BM.CrossPart CP2
			WHERE (
					convert(DATE, createdon) = '2019-08-23'
					OR convert(DATE, createdon) = '2019-08-24'
					)
				AND CP2.PartNumber = CP1.PartNumber
			FOR XML PATH('')
			), 1, 2, '')
FROM FPCAPPS.BM.CrossPart CP1
WHERE (
		convert(DATE, createdon) = '2019-08-23'
		OR convert(DATE,createdon) = '2019-08-24'
		)
GROUP BY PartNumber







select * from FPCAPPS.BM.CrossPartInventory CPI
INNER JOIN FPCAPPS.BM.CrossPartInventoryHistory CPIH
ON CPI.CrossPartInventoryId = CPIH.CrossPartInventoryId
WHERE CPIH.BidId  = 2255 
and 
CPIH.CrossPartInventoryId = 4781
ORDER BY CPIH.lastupdatedby DESC





select * from FPCAPPS.BM.InventoryReviewAction where BidId = 2244
select * from FPCAPPS.BM.InventoryReviewAction where UserRole = 'CategoryVP' or UserRole = 'CategoryVP'

select * from FPCAPPS.BM.CrossPartLineReview

select * FROM BM.[CrossPartLineReview]
	WHERE CrossPartId IN (
			SELECT CrossPartId
			FROM BM.CrossPart cp
			INNER JOIN BM.BidPart bp ON cp.BidPartId = bp.BidPartId
			WHERE bp.BidID = 1131
			)

--DELETE from FPCAPPS.BM.InventoryReviewAction

--DELETE from FPCAPPS.BM.CrossPartInventory where CrossPartInventoryId = 6


--Update FPCAPPS.BM.UserAction set validatoractionon = getdate() - 3 where ValidatorActionStatus = 'Locked'


--sp_help 'FPBIDW.EDW.DimLocation'

SELECT *  FROM [FPCAPPS].[BM].[BID] where BidId = 1129
SELECT top 10 *  FROM [FPCAPPS].[BM].[BIDPart] order by bidpartid desc
SELECT top 100 *  FROM [FPCAPPS].[BM].[crossPart] order by crosspartid desc
select top 10 * from BM.CrossPart where bidpartid = 1248
select top 10 * from BM.BidPart where IsSubmitted = 1
select count(CP.CrossPartId) from BM.CrossPart CP
INNER JOIN BM.BidPart BP
ON CP.BidPartId = BP.BidPartId
where BP.BidId = 1045

select count(*) from fpcapps.bm.errorlogging order by errorloggingid desc

--------------------------------------------------------------------------


-------------Update/delete Master tables/views ---------------

--update  FPCAPPS.BM.Bid set bidstatus = 'Won' where BidId = 2349
--update  FPCAPPS.BM.Bid set Company = 1 where Company = 0
--update  FPCAPPS.BM.UserAction set CrossActionStatus = 'Submitted' where BidPartId = 1019
--update  FPCAPPS.BM.UserAction set ValidatorActionStatus = 'PartiallyValidated' where BidPartId = 1020
--update  FPCAPPS.BM.UserAction set CrossUserId = 'Nishant.Mittal' where BidPartId = 1
--update  FPCAPPS.BM.BidPart set isSubmitted = 0 where BidPartId IN(1018,1019)
--update  FPCAPPS.BM.BidPart set IsSubmitted = 0, IsValidated = 0, SubmittedBy = NULL, SubmittedOn= NULL, ValidatedBy = NULL, ValidatedOn= NULL where IsSubmitted = 1 or IsValidated = 1
--update  FPCAPPS.BM.CrossPart set IsWon = 0 where CrossPartId = 599039
--DELETE from FPCAPPS.BM.UserAction where BidPartId = 1
--DELETE from FPCAPPS.BM.CrossPart where [Source] = 'CrowdSourcing'
--DELETE from FPCAPPS.BM.CrossPart where CrossPartId = 531522
--DELETE from FPCAPPS.BM.BidPart
--DELETE from FPCAPPS.BM.Bid
--TRUNCATE TABLE FPCAPPS.BM.UserAction
--------------------------------------------------------------------------- 


--------------Testing Data and queries---------------

	SELECT CP.FinalPreference,CP.VendorColorDefinition,bp.IsVerified,bp.CustomerPartNumber, bp.*,Cp.*
	FROM FPCAPPS.BM.Bid b(NOLOCK)
	INNER JOIN FPCAPPS.BM.BidPart bp(NOLOCK) ON b.BidID = bp.BidID
	LEFT JOIN FPCAPPS.BM.CrossPart CP ON BP.BidPartId = CP.BidPartId
	WHERE
	b.BidID = 2349 
	AND CP.FinalPreference IS NOT NULL


SELECT distinct bp.customerpartnumber --,bp.*, cp.*
--max (bp.bidpartid),count(cp.bidpartid),count(cp.source)
	FROM FPCAPPS.BM.Bid b(NOLOCK)
	INNER JOIN FPCAPPS.BM.BidPart bp(NOLOCK) ON b.BidID = bp.BidID
	INNER JOIN FPCAPPS.BM.CrossPart CP ON BP.BidPartId = CP.BidPartId
	WHERE Bp.BidId = 1129 
	and cp.source != 'system'

	group by cp.bidpartid  



SELECT DISTINCT 
		b.Company
		,bp.BidPartID
		,bp.CustomerPartNumber
		,bp.ManufacturerPartNumber
	FROM FPCAPPS.BM.Bid b(NOLOCK)
	INNER JOIN FPCAPPS.BM.BidPart bp(NOLOCK) ON b.BidID = bp.BidID
	LEFT JOIN FPCAPPS.BM.CrossPart CP ON BP.BidPartId = CP.BidPartId
	WHERE b.BidID = 1078 AND CP.BidPartId IS NULL 

	SELECT bp.*,Cp.*
	FROM FPCAPPS.BM.Bid b(NOLOCK)
	INNER JOIN FPCAPPS.BM.BidPart bp(NOLOCK) ON b.BidID = bp.BidID
	LEFT JOIN FPCAPPS.BM.CrossPart CP ON BP.BidPartId = CP.BidPartId
	WHERE
	--b.BidID = 1078
	--AND 
	BP.IsFinalized IS NULL
	AND CP.FinalPreference IS NOT NULL

	SELECT CP.FinalPreference,CP.VendorColorDefinition,bp.IsVerified,bp.CustomerPartNumber, bp.*,Cp.*
	FROM FPCAPPS.BM.Bid b(NOLOCK)
	INNER JOIN FPCAPPS.BM.BidPart bp(NOLOCK) ON b.BidID = bp.BidID
	LEFT JOIN FPCAPPS.BM.CrossPart CP ON BP.BidPartId = CP.BidPartId
	WHERE
	b.BidID = 2347 
	AND CP.FinalPreference IS NOT NULL
	order by Bp.IsVerified desc
	AND 
	BP.IsVerified = 1


	select * from BM.CrossPartLineReview where BidId = 2249

--Fix	--https://fleetpride.atlassian.net/browse/WEBAPPS-1290

--UPDATE CP
--SET CP.FinalPreference = NULL
--	FROM FPCAPPS.BM.Bid b(NOLOCK)
--	INNER JOIN FPCAPPS.BM.BidPart bp(NOLOCK) ON b.BidID = bp.BidID
--	LEFT JOIN FPCAPPS.BM.CrossPart CP ON BP.BidPartId = CP.BidPartId
--	WHERE
--	--b.BidID = 1078
--	--AND 
--	BP.IsFinalized IS NULL
--	AND CP.FinalPreference IS NOT NULL

SELECT top 10 DC.*, DS.*
			FROM FPBIDW.EDW.DimCustomer DC
			INNER JOIN FPBIDW.EDW.DimSalesman DS ON DC.NatAccMngrKey = DS.SalesmanKey
			WHERE DC.CustNumber NOT IN (
					'NA'
					,'Unknown'
					)
				AND DC.IsNatAccount = 'Y'
				AND DS.UserId = 'FTINSLEY'

-------------------------------------------------------------------

 SELECT 
 *
	FROM FPCAPPS.BM.BidPart BP
	INNER JOIN FPCAPPS.BM.CrossPart CP ON CP.BidPartId = BP.BidPartId
	WHERE BP.BidId = 1183
		

	Select CP.*	 	
	FROM FPCAPPS.BM.CrossPart CP 
	INNER JOIN FPCAPPS.BM.BidPart BP ON BP.BidPartId =  CP.BidPartId	 
	WHERE BP.BidId = 1105 AND CP.FinalPreference ='Primary'

	Select CP.*	 	
	FROM FPCAPPS.BM.CrossPart CP 
	INNER JOIN FPCAPPS.BM.BidPart BP ON BP.BidPartId =  CP.BidPartId	 
	WHERE BP.BidId = 1105 AND CP.FinalPreference is not null

	Select CP.*	 	
	FROM FPCAPPS.BM.CrossPart CP 
	INNER JOIN FPCAPPS.BM.BidPart BP ON BP.BidPartId =  CP.BidPartId
	INNER JOIN FPCAPPS.BM.Bid B ON B.BidId =  BP.BidId	  
	WHERE BP.BidId = 2203 AND CP.IsWon = 0

     
	--UPDATE CP
	--SET CP.IsWon = NULL
	--FROM FPCAPPS.BM.CrossPart CP 
	--INNER JOIN FPCAPPS.BM.BidPart BP ON BP.BidPartId =  CP.BidPartId	 
	--WHERE BP.BidId = @BidId AND CP.FinalPreference IS NOT NULL

	--UPDATE CP
	--SET CP.PriceToQuote = 44
	--FROM FPCAPPS.BM.CrossPart CP 
	--INNER JOIN FPCAPPS.BM.BidPart BP ON BP.BidPartId =  CP.BidPartId
	--INNER JOIN FPCAPPS.BM.Bid B ON B.BidId =  BP.BidId	  
	--WHERE BP.BidId = 2199 AND IsWon = 1

	Select CP.*	 	
	FROM FPCAPPS.BM.CrossPart CP 
	INNER JOIN FPCAPPS.BM.BidPart BP ON BP.BidPartId =  CP.BidPartId	 
	WHERE BP.BidId = 1129
	AND CP.Source ='system'

	--UPDATE CP
	--SET  CP.Source ='system'
	--FROM FPCAPPS.BM.CrossPart CP 
	--INNER JOIN FPCAPPS.BM.BidPart BP ON BP.BidPartId =  CP.BidPartId	 
	--WHERE BP.BidId = @Bidid 
	--AND CP.Source ='CrowdSourcing'

	SELECT CPI.*
	FROM FPCAPPS.BM.Bid B
	LEFT JOIN FPCAPPS.BM.BidPart BP ON B.BidID = BP.BidID
	LEFT JOIN FPCAPPS.BM.CrossPart CP ON BP.BidPartId = CP.BidPartId
	LEFT JOIN FPCAPPS.BM.CrossPartInventory CPI ON CP.CrossPartId = CPI.CrossPartId
	

	--UPDATE CPI
	--SET  CPI.BidId = B.BidId
	--FROM FPCAPPS.BM.Bid B
	--INNER JOIN FPCAPPS.BM.BidPart BP ON B.BidID = BP.BidID
	--INNER JOIN FPCAPPS.BM.CrossPart CP ON BP.BidPartId = CP.BidPartId
	--INNER JOIN FPCAPPS.BM.CrossPartInventory CPI ON CP.CrossPartId = CPI.CrossPartId

	
	--Delete cross entry locked bid parts and its cross parts

	SELECT *
	FROM FPCAPPS.BM.CrossPart
	WHERE BidPartId IN (
			SELECT BidPartId
			FROM FPCAPPS.BM.UseRAction
			WHERE (datediff(hour, CrossActionOn, GETDATE())) > 24
				AND CrossActionStatus = 'Locked'
			)
		AND Source = 'CrowdSourcing'

	SELECT *
	FROM FPCAPPS.BM.UserAction
	WHERE (datediff(hour, CrossActionOn, GETDATE())) > 24
		AND CrossActionStatus = 'Locked'

		

--Update validation entry locked bid parts

	SELECT *
	FROM FPCAPPS.BM.UserAction
	WHERE (datediff(hour, ValidatorActionOn, GETDATE())) > 24
		AND ValidatorActionStatus = 'Locked'


		select * from FPCAPPS.BM.Bid

select top 2000 * from FPBIDW.edw.DimProduct where ProductKey > 0 and partNumber != '' and partNumber is not null
select * from FPCAPPS.BM.BID WHERE BidName like '100%'
SELECT * FROM FPCAPPS.BM.BidPart bp
inner join fpcapps.bm.CrossPart cp on bp.BidPartID = cp.BidPartID
where bp.BidID = 1166

select * from FPCAPPS.BM.CMAction where bidid = 1188

exec  fpcapps.BM.GenerateCrosses_GetBidPartsCount 1163 

select cpi.CrossPartId, count(distinct b.BidId) from 
fpcapps.bm.CrossPartLineReview cpi
inner join fpcapps.bm.CrossPart cp on cpi.CrossPartId = cp.CrossPartId
inner join fpcapps.bm.BidPart bp on bp.BidPartId = cp.BidPartId
inner join fpcapps.bm.Bid b on b.BidId = bp.BidId
group by cpi.CrossPartId
having count(distinct b.BidId) > 1

select cpi.*
from 
fpcapps.bm.CrossPartInventory cpi
inner join fpcapps.bm.CrossPart cp on cpi.CrossPartId = cp.CrossPartId
inner join fpcapps.bm.BidPart bp on bp.BidPartId = cp.BidPartId
inner join fpcapps.bm.Bid b on b.BidId = bp.BidId 
where b.BidId = 2227

select top 1 * from fpcapps.bm.CrossPartLineReview
--delete from fpcapps.bm.CrossPartLineReview

declare @NewStatus VARCHAR(50) 
exec fpcapps.[BM].[InventoryReview_Submit] 1129, 'RGAMBLE', 'SuperUser', @NewStatus output
print @NewStatus

select * from fpcapps.bm.bid 
where BidStatus like 'LineReview_%'
use fpcapps
select top 10 * from sicf.[ALLCATS_LineReview101]

--get all stocking types.
select distinct IType, ITypeDesc  from [FPBIDW].edw.FactInventory
select top 10 *  from [FPBIDW_PRD].edw.FactInventory where SupersedeNote <> NULL
select top 1 * from fpcapps.bm.CrossPartInventory where 

use fpcapps

 SELECT 
			CPI.[CrossPartId]
			,bp.BidId
			,bp.BidPartId
           ,sum(LR.S) --ExistingStockingLocations
           ,sum(LR.[DC Stock Count]) --<DCStockCount, int,>
           ,sum(LR.[L12 Units]) --<L12Units, int,>
           ,count(cpi.[Location]) --<NewStockingLocations, int,>
           ,sum(cpi.[EstimatedAnnualUsage])  --<ProjectedL12Units, int,>
           ,0--<NewPrice, int,>
           ,(isnull(cp.PriceToQuote, 0) - isnull(cp.ICost, 0)) * sum(cpi.[EstimatedAnnualUsage]) --<ProjectedL12GP, decimal(18,0),>
           ,isnull(cp.ICost, 0) * sum(ceiling(cpi.[EstimatedAnnualUsage])/12)   --<ProjectedInvestment, decimal(18,0),>
           ,isnull(cp.ICost, 0) --<ICost, decimal(18,0),>
           ,convert(varchar, LR.[Current NPM Part Type]) --<StockingStatus, datetime,>
		   ,1 --by default consider all record as approved
		   ,sum(isnull(cp.PriceToQuote, 0) * isnull(LR.[L12 Units], 0))
		   --,max(cath.CategoryManagerID)
		   --,max(cath.CategoryDirectorID)
		   --,max(cath.CategoryCMOID)
  FROM 
	bm.CrossPartInventory cpi
	INNER JOIN bm.CrossPart cp on cp.CrossPartId = cpi.CrossPartID
	INNER JOIN bm.BidPart bp on bp.BidPartId = cp.BidPartId
	INNER JOIN bm.Bid b on b.BidId = bp.BidId
	--INNER JOIN sicf.[ALLCATS_LineReview101] lr on CONVERT(VARCHAR, cp.PoolNumber) = lr.Pool AND convert(varchar, cp.PartNumber) = ltrim(rtrim(lr.[Part Number]))
	--INNER JOIN FPBIDW.EDW.DimProduct DP ON DP.Category = CP.PartCategory
	--	AND DP.Pool = CP.PoolNumber
	--	AND DP.PartNumber = CP.PartNumber
	--	AND b.Company = dp.Company
	--LEFT OUTER JOIN  fpcapps.sicf.CategoryHierarchy cath on dp.Category = cath.CategoryCode
	WHERE bp.BidID = 1129 
		and cpi.IsActive = 'Yes'
		and cpi.StockingType <> 'O'
	GROUP BY bp.BidId ,bp.BidPartId, cpi.CrossPartID, cp.PriceToQuote, cp.ICost, LR.[Current NPM Part Type]


	select cpi.StockingType, *  FROM 
	bm.CrossPartInventory cpi
	INNER JOIN bm.CrossPart cp on cp.CrossPartId = cpi.CrossPartID
	INNER JOIN bm.BidPart bp on bp.BidPartId = cp.BidPartId
	INNER JOIN bm.Bid b on b.BidId = bp.BidId
	--INNER JOIN sicf.[ALLCATS_LineReview101] lr on CONVERT(VARCHAR, cp.PoolNumber) = lr.Pool AND convert(varchar, cp.PartNumber) = ltrim(rtrim(lr.[Part Number]))
	--INNER JOIN FPBIDW.EDW.DimProduct DP ON DP.Category = CP.PartCategory
	--	AND DP.Pool = CP.PoolNumber
	--	AND DP.PartNumber = CP.PartNumber
	--	AND b.Company = dp.Company
	--LEFT OUTER JOIN  fpcapps.sicf.CategoryHierarchy cath on dp.Category = cath.CategoryCode
	WHERE bp.BidID = 1129 
		--and cpi.IsActive = 'Yes'
		and (cpi.StockingType is null OR cpi.StockingType != 'O')

--------------------- Refersh sicf Line review and Category Hierarchy tables-----------------
--Select * from [FPCAPPS].[sicf].[CategoryHierarchy] where categorymanagerid = ''
--exec [sicf].[stp_Refresh_CategoryHierarchy_Temp]
--select distinct CategoryDirectorID from [FPCAPPS].[sicf].[CategoryHierarchy] 
--select distinct CategoryCMOID from [FPCAPPS].[sicf].[CategoryHierarchy] 
--Select count(*) from[FPCAPPS].[sicf].[ALLCATS_LineReview101] -- old 1037472 - new 1039696
--exec [sicf].[stp_Load_ALLCATS_LineReview101_Temp]
--------------------------------------------------------------------------------------------------

