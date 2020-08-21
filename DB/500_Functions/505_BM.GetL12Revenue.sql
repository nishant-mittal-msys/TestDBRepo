USE FPCAPPS
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Vaqqas
-- Create date: 3/9/2020
-- Description:	Find the L12 Revinue
-- =============================================
CREATE OR ALTER FUNCTION BM.GetL12Revenue (
	@Cmpy NUMERIC(3, 0)
	,@Pool NUMERIC(5, 0)
	,@PartNo VARCHAR(20)
	)
RETURNS NUMERIC(19, 4)
AS
BEGIN
	DECLARE @Rvnu AS NUMERIC(19, 4)

	SELECT @Rvnu = SUM(B.SalesAmount)
	FROM FPBIDW.EDW.DimProduct A (nolock)
	INNER JOIN FPBIDW.EDW.FactSales B (nolock) ON A.ProductKey = B.ProductKey
	INNER JOIN FPBIDW.EDW.DimDate D (nolock) ON D.DateKey = B.DatePostedKey
	WHERE A.Company = @Cmpy
		AND A.Pool = @Pool
		AND A.PartNumber = @PartNo
		AND D.CalendarDate BETWEEN DATEADD(DAY, - 366, GETDATE()) AND DATEADD(DAY, - 1, GETDATE())
		AND B.IsRevenue = 'Y'
		AND B.PreFleetPride <> 'Y'

	RETURN ISNULL(@Rvnu, 0)
END
GO

