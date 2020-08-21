USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Vaqqas
-- Create date: 8/26/2019
-- Description:	Get all the holidays from dbo.Holidays table
-- =============================================
CREATE OR ALTER PROC BM.CalcualtePricingParams(@BidId INT) 
AS
BEGIN
		DECLARE @projectedsales numeric(19,2)
		DECLARE @projectedGP numeric(19,2)
		DECLARE @projectedGPPercent numeric(19,2)
		SELECT @projectedsales=  Sum(Isnull(pricetoquote,0) * ( CASE WHEN estimatedannualusage IS NULL THEN 1 ELSE estimatedannualusage END )) 
		   ,@projectedGP = Sum(Isnull(pricetoquote,0) * ( CASE WHEN estimatedannualusage IS NULL THEN 1 ELSE estimatedannualusage END ) - Isnull(adjustedIcost,isnull(Icost,0)) * ( CASE WHEN estimatedannualusage IS NULL THEN 1 ELSE estimatedannualusage END )) 
		   ,@projectedGPPercent = (( Sum(Isnull(pricetoquote,0) * ( CASE WHEN estimatedannualusage IS NULL THEN 1 ELSE estimatedannualusage END ) - Isnull(adjustedIcost,isnull(ICost,0)) * ( CASE WHEN estimatedannualusage IS NULL THEN 1 ELSE estimatedannualusage END )) / Sum( Isnull(pricetoquote,0) * ( CASE WHEN estimatedannualusage IS NULL THEN 1 ELSE estimatedannualusage END ))) * 100) 
		FROM bm.bidpart b (nolock)
		INNER JOIN bm.crosspart c (nolock)
		ON b.bidpartid = c.bidpartid AND b.bidid = @BidId AND c.finalpreference = 'Primary' 

		UPDATE bm.bid set TotalValueOfBid = @projectedsales, ProjectedGPDollar = @projectedGP, ProjectedGPPerc = @projectedGPPercent WHERE BidId = @BidId
END
GO