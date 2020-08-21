USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gurpreet Singh	
-- Create date: 07/18/19
-- Description:	Get all CM for a Bid
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[CrossReport_GetCMForBid] (@BidId INT)
AS
BEGIN

WITH CMData AS (
	SELECT DISTINCT DE.UserName AS UserId
		,DE.EmployeeName AS Name
		,DE.[EmployeeEmail] AS Email
	FROM  BM.BidPart BP  (nolock)
	INNER JOIN BM.CrossPart CP  (nolock) ON BP.BidPartId = CP.BidPartId
	INNER JOIN FPBIDW.EDW.DimProduct DP  (nolock) ON DP.Category = CP.PartCategory and DP.Pool = CP.PoolNumber and DP.PartNumber = CP.PartNumber
	INNER JOIN FPBIDW.EDW.DimEmployee DE  (nolock) ON DP.CategoryManager = DE.UserName
	WHERE BP.BidId = @BidId AND  (BP.IsFinalized is null or BP.IsFinalized = 0) ---- Get CM of all cross part categories if part is finalized
    UNION
	SELECT DISTINCT DE.UserName AS UserId
		,DE.EmployeeName AS Name
		,DE.[EmployeeEmail] AS Email
	FROM  BM.BidPart BP
	INNER JOIN BM.CrossPart CP  (nolock) ON BP.BidPartId = CP.BidPartId
	INNER JOIN FPBIDW.EDW.DimProduct DP  (nolock) ON DP.Category = CP.PartCategory and DP.Pool = CP.PoolNumber and DP.PartNumber = CP.PartNumber and CP.FinalPreference is not null
	INNER JOIN FPBIDW.EDW.DimEmployee DE  (nolock) ON DP.CategoryManager = DE.UserName
	Where bp.BidId = @BidId AND bp.IsFinalized = 1) -- If part is finalized, get CM of only those cross part categories which are finalized

	SELECT DISTINCT UserId, NAME, EMail from CMData  
END
