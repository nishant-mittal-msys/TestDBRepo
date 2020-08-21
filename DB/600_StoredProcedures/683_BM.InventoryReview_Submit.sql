USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Vaqqas
-- Create date: 12/27/19
-- Description:	Save the approval of the parts
-- =============================================
CREATE OR ALTER PROCEDURE [BM].[InventoryReview_Submit] (
	@BidId int
	,@UserId NVARCHAR(100) 
	,@UserRole NVARCHAR(100) 
	,@NewStatus VARCHAR(50) = NULL OUTPUT
	)
AS
BEGIN
declare @BidStatus VARCHAR(255) 
DECLARE @ApprovalRole varchar(100)
select @BidStatus = BidStatus from BM.Bid where BidID = @BidId;

DECLARE @ProjectedInvestment DECIMAL 
SELECT @ProjectedInvestment = SUM(ProjectedInvestment) FROM [BM].[CrossPartLineReview]  (nolock) WHERE BidId = @BidId

SET @NewStatus = @BidStatus

if( @BidStatus = 'LineReview_CM') 
BEGIN
	UPDATE BM.InventoryReviewAction
		SET ActionStatus = 1,
		ActionTakenOn = GETDATE()
		WHERE BidID = @BidId
		and UserId = (CASE WHEN @UserRole not in ('SuperUser', 'NAMSupervisor') THEN @UserId ELSE UserId END) --Match the user ID if UserRole is not SuperUser

	--if all CMs have approved the inventory for this bid then assign the bid to the Category VP
	IF NOT EXISTS(SELECT ID FROM BM.InventoryReviewAction  (nolock) WHERE BidID = @BidId AND ActionStatus IS NULL AND UserRole = @UserRole)
	BEGIN
		SET @NewStatus = 'LineReview_VP'

		SELECT @ApprovalRole = [Role] FROM BM.InvestmentThresholds it  (nolock)  WHERE it.Minimum <= @ProjectedInvestment AND @ProjectedInvestment <= it.Maximum
		if( @ApprovalRole = 'CategoryManager' )
			SET @NewStatus = 'DemandTeam'
		ELSE 
			--assign the bid to the category director
			INSERT INTO FPCAPPS.BM.InventoryReviewAction (
				BidId
				,UserId
				,UserRole
				)
			SELECT TOP 1 
				@BidId
				,CategoryCMOID
				,'CategoryVP'
			FROM [BM].CrossPartLineReview cplr (nolock) 
			WHERE cplr.BidId = @BidId and CategoryCMOID is not null
	END
END
ELSE IF(@BidStatus = 'LineReview_Dir') --- We are removing the Director from hierarchy.. this condition will never be met
BEGIN
	UPDATE BM.InventoryReviewAction
		SET ActionStatus = 1,
		ActionTakenOn = GETDATE()
		WHERE BidID = @BidId
		and UserId = (CASE WHEN @UserRole not in ('SuperUser', 'NAMSupervisor') THEN @UserId ELSE UserId END) --Match the user ID if UserRole is not SuperUser

	--if all Directors have approved the inventory for this bid then assign the bid to the Category VP
	IF NOT EXISTS(SELECT ID FROM BM.InventoryReviewAction  (nolock) WHERE BidID = @BidId AND ActionStatus IS NULL AND UserRole = @UserRole)
	BEGIN
		SELECT @ApprovalRole = [Role] FROM BM.InvestmentThresholds it  (nolock) WHERE it.Minimum <= @ProjectedInvestment AND @ProjectedInvestment <= it.Maximum
		if( @ApprovalRole = 'CategoryManager' or @ApprovalRole = 'CategoryDirector')
			SET @NewStatus = 'DemandTeam'
		ELSE 
			SET @NewStatus = 'LineReview_VP' 
			--assign the bid to the category vp
			INSERT INTO FPCAPPS.BM.InventoryReviewAction (
				BidId
				,UserId
				,UserRole
				)
			SELECT DISTINCT
				@BidId
				,CategoryCMOID
				,'CategoryVP'
			FROM [BM].CrossPartLineReview cplr
	END
END
ELSE IF(@BidStatus = 'LineReview_VP' OR @BidStatus = 'InventoryReUpdate') 
BEGIN
	UPDATE BM.InventoryReviewAction
	SET ActionStatus = 1,
	ActionTakenOn = GETDATE()
	WHERE BidID = @BidId
	and UserRole = 'CategoryVP'
	and UserId = (CASE WHEN @UserRole not in ('SuperUser', 'NAMSupervisor') THEN @UserId ELSE UserId END) --Match the user ID if UserRole is not SuperUser

	--if all VPs have approved the inventory for this bid then assign the data/demand team
	IF NOT EXISTS(SELECT ID FROM BM.InventoryReviewAction  (nolock) WHERE BidID = @BidId AND ActionStatus IS NULL AND UserRole = @UserRole)
		SET @NewStatus = 'DemandTeam'
END

IF @NewStatus = 'DemandTeam'
BEGIN
--if any of the parts at any of the locations is not setup then the bid needs to be assigned to the data team before it goes to the Demand Team
		declare @CountUnStocked as int = 0
		;with cte(Company, PartNumber, PoolNumber, Location)
			as(
			select
			cp.Company,
			isnull(CPI.NewPartNo, cp.PartNumber),
			isnull(CPI.NewPool, cp.PoolNumber),
			cpi.Location
			FROM [BM].[CrossPartInventory] cpi (nolock) 
						inner join BM.CrossPartLineReview cplr  (nolock) on cpi.CrossPartID = cplr.CrossPartID
						inner join BM.CrossPart cp  (nolock) on cpi.CrossPartId = cp.CrossPartId
						WHERE cplr.IsApproved = 1 and cpi.IsActive = 'Yes' and  cplr.BidId = @BidId
			)
			select top 1
			@CountUnStocked = count(*)
			from 
			cte 
			left join [FPBIDW].edw.FactInventory oldinv  (nolock) on cte.Company = oldinv.Company 
							and cte.PartNumber = oldinv.PartNumber
							and cte.PoolNumber = oldinv.Pool 
							and cte.Location = oldinv.Location
			where oldinv.IType is null or oldinv.IType <> 'S'
		
			if @CountUnStocked > 0
				SET @NewStatus = 'DataTeam'
END
IF @BidStatus != @NewStatus
BEGIN
	declare @TatDays as int = 0
	set @TatDays = isnull((select top 1 TatDays from bm.Tat  (nolock) where BidStatus = @NewStatus), 0)

	--set the next status of the bid
	UPDATE BM.Bid
		SET BidStatus = @NewStatus,
			[CurrentPhaseDueDate] = dateadd(day, @TatDays, getdate())
		WHERE BidID = @BidId;
END
END

--[BM].[InventoryReview_Submit] 1129, 'klynch', 'SuperUser'