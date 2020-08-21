USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gurpreet Singh
-- Create date: 08/07/19
-- Description:	Get bids summary
-- =============================================
CREATE
	OR

ALTER PROCEDURE [dbo].[LoadECatalogCrosses] 
AS
BEGIN
	TRUNCATE TABLE fpcapps.dbo.EcatalogCrosses
	
	INSERT INTO fpcapps.dbo.EcatalogCrosses
	SELECT fpcapps.dbo.removespecialcharacters(WPI.InterchangePartNo) As FromPartNo, WPS.Value_1 as ToPartNo, WPS.Value_4 as ToPoolNo
	FROM FPECOM.STG.WebAPI_PartsInterchanges WPI (nolock), FPECOM.stg.WebAPI_PartSpecValues WPS (nolock)
	WHERE WPI.PartNo=WPS.PartNo and specid='TAXONOMY' and IsNumeric(WPS.Value_4) = 1
END
