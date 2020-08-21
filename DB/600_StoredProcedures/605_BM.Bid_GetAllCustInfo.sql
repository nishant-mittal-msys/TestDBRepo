USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gurpreet Singh
-- Create date: 06/25/19
-- Description:	Get all customer details for UserRole
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[Bid_GetAllCustInfo] (
	@UserId VARCHAR(100)
	,@Company int
	,@UserRole VARCHAR(100)
	,@BidType VARCHAR(100)
	)
AS
BEGIN
	IF (@BidType = 'National')
	BEGIN
		IF (
				@UserRole IN (
					'SuperUser'
					,'NAMSupervisor'
					)
				)
		BEGIN
			SELECT DISTINCT CAST(CustCorpId AS VARCHAR(50)) + ' - ' + CustCorpAccName AS CustInfo
			FROM FPBIDW.EDW.DimCustomer cust (nolock)
			WHERE cust.Company = @Company 
			and CustNumber NOT IN (
					'NA'
					,'Unknown'
					)
				AND IsNatAccount = 'Y'
		END
		ELSE
		BEGIN
			SELECT DISTINCT CAST(CustCorpId AS VARCHAR(50)) + ' - ' + CustCorpAccName AS CustInfo
			FROM FPBIDW.EDW.DimCustomer DC (nolock)
			INNER JOIN FPBIDW.EDW.DimSalesman DS (nolock) 
				ON DC.NatAccMngrKey = DS.SalesmanKey
			WHERE DC. Company = @Company 
			and DC.CustNumber NOT IN (
					'NA'
					,'Unknown'
					)
				AND DC.IsNatAccount = 'Y'
				AND DS.UserId = @UserId
		END
	END
	ELSE
	BEGIN
		SELECT DISTINCT CustNumber + ' - ' + CustBranch + ' - ' + CustName AS CustInfo
		FROM FPBIDW.EDW.DimCustomer DC (nolock)
		WHERE DC.Company = @Company 
			and CustNumber NOT IN (
				'NA'
				,'Unknown'
				)
			AND IsNatAccount = 'N'
	END
END
