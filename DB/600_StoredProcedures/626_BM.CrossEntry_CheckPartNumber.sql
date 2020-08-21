USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal
-- Create date: 07/08/19
-- Description:	get the part for crowd sourcing part
-- =============================================
--EXEC [BM].[CrossEntry_CheckPartNumber] '11', 1129
CREATE OR ALTER PROC [BM].[CrossEntry_CheckPartNumber] (
	@PartNo NVARCHAR(30)
	,@BidId INT = NULL
	,@MatchPartial BIT = 0
	)
AS
BEGIN
	DECLARE @Compy INT = 1
	SET @PartNo = REPLACE(REPLACE(REPLACE(@PartNo, '-', ''), '.', ''), '/','')
	IF (@BidId IS NOT NULL OR @BidId <> 0)
	BEGIN
		SET @Compy = (
				SELECT Company
				FROM BM.Bid  (nolock)
				WHERE BidId = @BidId
				)
	END

	IF @MatchPartial = 1
	BEGIN
		;WITH PRODUCT
		AS (
			SELECT DISTINCT prod.ProductKey
				,prod.Pool
				,prod.PartNumber
				,prod.PartDesciption
				,prod.Category
				,0 AS IsFlip
			FROM [FPBIDW].[EDW].[DimProduct] AS prod  (nolock)
			WHERE prod.PartNumber Like '%'+@PartNo+'%'
				AND prod.Company = @Compy
				AND prod.pool NOT IN (
					555
					,556
					,0
					)		
			UNION		
			SELECT DISTINCT super.NewProductKey
				,super.NewPool
				,super.NewPartnumber
				,new.PartDesciption
				,new.Category
				,1 AS IsFlip
			FROM FPBIDW.EDW.DimProduct old  (nolock)
			INNER JOIN FPBIDW.EDW.DimSuperSessions AS super  (nolock) ON super.OldProductKey = old.ProductKey
			LEFT JOIN FPBIDW.EDW.DimProduct AS new  (nolock) ON super.NewProductKey = new.ProductKey
				AND new.pool NOT IN (
					555
					,556
					,0
					)
			WHERE old.PartNumber Like '%'+@PartNo+'%'
				AND old.Company = new.Company
				AND old.Company = @Compy
			)
		SELECT DISTINCT TOP 100 P.ProductKey
			,P.Pool
			,P.PartNumber
			,P.PartDesciption
			,P.Category
			,P.IsFlip
			,LR.[DC Stock Count] AS DCStockCount
			,LR.[S] AS StoresStockCount
			,LR.[Natl Count L12 Stores Sold] AS NationalL12StoresSold
			,LR.[Local Count L12 Stores Sold] AS LocalL12StoresSold
			,LR.[L12 Units] AS L12Units
			,LR.[L12 Revenue] AS L12Revenue
			,LR.[Current NPM Part Type] AS NPMPartType
		FROM PRODUCT P  (nolock)
		LEFT JOIN FPCAPPS.SICF.ALLCATS_LineReview101 LR (nolock) ON P.PartNumber = LR.[Part Number]
			AND P.Pool = LR.Pool ORDER BY P.ProductKey
	END
	ELSE
	BEGIN
		;WITH PRODUCT
		AS (
			SELECT DISTINCT prod.ProductKey
				,prod.Pool
				,prod.PartNumber
				,prod.PartDesciption
				,prod.Category
				,0 AS IsFlip
			FROM [FPBIDW].[EDW].[DimProduct] AS prod  (nolock)
			WHERE prod.PartNumber = @PartNo
				AND prod.Company = @Compy
				AND prod.pool NOT IN (
					555
					,556
					,0
					)		
			UNION		
			SELECT DISTINCT super.NewProductKey
				,super.NewPool
				,super.NewPartnumber
				,new.PartDesciption
				,new.Category
				,1 AS IsFlip
			FROM FPBIDW.EDW.DimProduct old  (nolock)
			INNER JOIN FPBIDW.EDW.DimSuperSessions AS super  (nolock) ON super.OldProductKey = old.ProductKey
			LEFT JOIN FPBIDW.EDW.DimProduct AS new (nolock) ON super.NewProductKey = new.ProductKey
				AND new.pool NOT IN (
					555
					,556
					,0
					)
			WHERE old.PartNumber = @PartNo
				AND old.Company = new.Company
				AND old.Company = @Compy
			)
		SELECT P.ProductKey
			,P.Pool
			,P.PartNumber
			,P.PartDesciption
			,P.Category
			,P.IsFlip
			,LR.[DC Stock Count] AS DCStockCount
			,LR.[S] AS StoresStockCount
			,LR.[Natl Count L12 Stores Sold] AS NationalL12StoresSold
			,LR.[Local Count L12 Stores Sold] AS LocalL12StoresSold
			,LR.[L12 Units] AS L12Units
			,LR.[L12 Revenue] AS L12Revenue
			,LR.[Current NPM Part Type] AS NPMPartType
		FROM PRODUCT P  (nolock)
		LEFT JOIN FPCAPPS.SICF.ALLCATS_LineReview101 LR (nolock) ON P.PartNumber = LR.[Part Number]
			AND P.Pool = LR.Pool ORDER BY P.ProductKey
	END
END
