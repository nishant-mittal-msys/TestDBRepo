USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal
-- Create date: 12/18/19
-- Description:	Get all CM for a Bid for inventory
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[Inventory_GetCMForBid] (@BidId INT)
AS
BEGIN
	SELECT DISTINCT DE.UserName AS UserId
		,DE.EmployeeName AS Name
		,DE.[EmployeeEmail] AS Email
	FROM 
	BM.Bid B (nolock) 
	INNER JOIN BM.BidPart BP  (nolock) ON B.BidId = BP.BidId
	INNER JOIN BM.CrossPart CP  (nolock) ON BP.BidPartId = CP.BidPartId
	INNER JOIN BM.CrossPartInventory CPI  (nolock) ON CP.CrossPartId = CPI.CrossPartId
	INNER JOIN FPBIDW.EDW.DimProduct DP  (nolock) ON DP.Category = CP.PartCategory
		AND DP.Pool = CP.PoolNumber
		AND DP.PartNumber = CP.PartNumber
		AND DP.Company = b.Company
	INNER JOIN FPBIDW.EDW.DimEmployee DE  (nolock) ON DP.CategoryManager = DE.UserName
	WHERE BP.BidId = @BidId
		AND CP.IsWon = 1
		AND CPI.IsActive = 'Yes'
END
