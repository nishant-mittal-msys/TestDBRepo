USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gurpreet Singh
-- Create date: 06/25/19
-- Description:	Create a Bid
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[Bid_CreateBid] (
	@BidType VARCHAR(100) = NULL
	,@IsProspect BIT = NULL
	,@BidStatus VARCHAR(100) = NULL
	,@Company INT = NULL
	,@CustNumber INT = NULL
	,@CustBranch INT = NULL
	,@CustName VARCHAR(100) = NULL
	,@CustCorpId INT = NULL
	,@CustCorpAccName VARCHAR(100) = NULL
	,@BidName VARCHAR(100) = NULL
	,@RequestType VARCHAR(100) = NULL
	,@SubmittedDate DATETIME = NULL
	,@BidDescription VARCHAR(MAX) = NULL
	,@FPFacingLocations INT = NULL
	,@IsFPPriceHold BIT = NULL
	,@DueDate DATETIME = NULL
	,@TotalValueOfBid NUMERIC(19, 2) = NULL
	,@IsCustomerInventoryPurchaseGuarantee BIT = NULL
	,@HoldDate DATETIME = NULL
	,@LevelOfInvetoryDetailCustomerCanProvide VARCHAR(200) = NULL
	,@IsCustomerAllowSubstitutions BIT = NULL
	,@BrandPreference VARCHAR(200) = NULL
	,@UserId VARCHAR(100) = NULL
	,@UserRole VARCHAR(100) = NULL
	,@Result INT = NULL OUTPUT
	)
AS
BEGIN
	DECLARE @Rank INT = NULL
	DECLARE @NAMUserId VARCHAR(50) = NULL
	DECLARE @GroupId INT = NULL
	DECLARE @GroupDesc VARCHAR(200) = NULL

	SET @Rank = CASE 
			WHEN (
					SELECT TOP (1) [Rank]
					FROM BM.Bid (nolock)
					ORDER BY [Rank] DESC
					) IS NULL
				THEN 1
			ELSE (
					(
						SELECT TOP (1) [Rank]
						FROM BM.Bid (nolock)
						ORDER BY [Rank] DESC
						) + 1
					)
			END

	IF EXISTS (
			SELECT 1
			FROM BM.Bid (nolock)
			WHERE BidName = @BidName
			)
	BEGIN
		SET @Result = -1
	END
	ELSE
	BEGIN
		IF (@BidType = 'National' AND @IsProspect = 0)
		BEGIN
			SELECT DISTINCT @GroupId = DC.GroupId
				,@GroupDesc = DC.GroupDesc
				,@NAMUserId = DS.UserId
			FROM FPBIDW.EDW.DimCustomer DC (nolock)
			INNER JOIN FPBIDW.EDW.DimSalesman DS (nolock)
				ON DC.NatAccMngrKey = DS.SalesmanKey
			WHERE DC.CustCorpId = @CustCorpId
				AND DC.IsNatAccount = 'Y'
		END

		INSERT INTO BM.Bid (
			BidType
			,IsProspect
			,BidStatus
			,[Rank]
			,Company
			,CustNumber
			,CustBranch
			,CustName
			,CustCorpId
			,CustCorpAccName
			,GroupId
			,GroupDesc
			,BidName
			,RequestType
			,SubmittedDate
			,BidDescription
			,FPFacingLocations
			,IsFPPriceHold
			,CurrentPhaseDueDate
			,DueDate
			,[CalculatedDueDate]
			,TotalValueOfBid
			,IsCustomerInventoryPurchaseGuarantee
			,HoldDate
			,LevelOfInvetoryDetailCustomerCanProvide
			,IsCustomerAllowSubstitutions
			,BrandPreference
			,CreatedByRole
			,NAMUserID
			,CreatedBy
			,CreatedOn
			)
		VALUES (
			@BidType
			,@IsProspect
			,@BidStatus
			,@Rank
			,@Company
			,@CustNumber
			,@CustBranch
			,@CustName
			,@CustCorpId
			,@CustCorpAccName
			,@GroupId
			,@GroupDesc
			,@BidName
			,@RequestType
			,@SubmittedDate
			,@BidDescription
			,@FPFacingLocations
			,@IsFPPriceHold
			,@DueDate
			,@DueDate
			,@DueDate
			,@TotalValueOfBid
			,@IsCustomerInventoryPurchaseGuarantee
			,(CASE WHEN @IsFPPriceHold = 1 THEN @HoldDate ELSE NULL END)
			,@LevelOfInvetoryDetailCustomerCanProvide
			,@IsCustomerAllowSubstitutions
			,@BrandPreference
			,@UserRole
			,@NAMUserId
			,@UserId
			,GETDATE()
			)

		SET @Result = SCOPE_Identity()
	END
END
