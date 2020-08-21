USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal
-- Create date: 06/28/19
-- Description:	Bulk Insert uploaded bid parts
-- =============================================
--DROP PROCEDURE  [BM].[UploadBidPart_BulkInsertBidParts]
CREATE
	OR

ALTER PROC [BM].[UploadBidPart_BulkInsertBidParts] (@BidParts AS BM.BidPartsUDT READONLY)
AS
BEGIN
	INSERT INTO BM.BidPart (
		BidId
		,CustomerPartNumber
		,CleanCustomerPartNumber
		,PartDescription
		,Manufacturer
		,ManufacturerPartNumber
		,CleanManufacturerPartNumber
		,Note
		,EstimatedAnnualUsage
		,CreatedBy
		,CreatedOn
		)
	SELECT BidId
		,CustomerPartNumber
		,REPLACE(REPLACE(CustomerPartNumber, '-', ''), '.', '')
		,PartDescription
		,Manufacturer
		,ManufacturerPartNumber
		,REPLACE(REPLACE(ManufacturerPartNumber, '-', ''), '.', '')
		,Note
		,EstimatedAnnualUsage
		,UserId
		,GETDATE()
	FROM @BidParts
END
GO
