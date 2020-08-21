USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal
-- Create date: 03/09/19
-- Description:	get all the parts for cross entry/report
-- =============================================
CREATE
	OR

ALTER PROC [BM].[CrossEntry_GetAllPartInfo] (
	@UserId VARCHAR(100)
	,@UserRole VARCHAR(100)
	,@BidId INT = NULL
	)
AS
BEGIN
	DECLARE @Compy INT = 1

	IF (
			@BidId IS NOT NULL
			OR @BidId <> 0
			)
	BEGIN
		SET @Compy = (
				SELECT Company
				FROM BM.Bid
				WHERE BidId = @BidId
				)
	END;

	WITH PRODUCT
	AS (
		SELECT CAST(prod.Pool AS VARCHAR(100)) + ' - ' + CAST(prod.PartNumber AS VARCHAR(100)) + ' - ' + prod.PartDesciption AS PartInfo
			,prod.ProductKey
			,0 AS IsFlip
		FROM [FPBIDW].[EDW].[DimProduct] AS prod (nolock) 
		WHERE prod.Company = @Compy
			AND prod.pool NOT IN (
				555
				,556
				,0
				)
		
		UNION
		
		SELECT CAST(super.NewPool AS VARCHAR(100)) + ' - ' + CAST(super.NewPartnumber AS VARCHAR(100)) + ' - ' + new.PartDesciption AS PartInfo
			,super.NewProductKey
			,1 AS IsFlip
		FROM FPBIDW.EDW.DimProduct old (nolock) 
		INNER JOIN FPBIDW.EDW.DimSuperSessions AS super  (nolock) ON super.OldProductKey = old.ProductKey
		LEFT JOIN FPBIDW.EDW.DimProduct AS new  (nolock) ON super.NewProductKey = new.ProductKey
			AND new.pool NOT IN (
				555
				,556
				,0
				)
		WHERE old.Company = new.Company
			AND old.Company = @Compy
		)
	SELECT P.PartInfo
		,P.ProductKey
		,P.IsFlip
	FROM PRODUCT P
	ORDER BY P.ProductKey
END
