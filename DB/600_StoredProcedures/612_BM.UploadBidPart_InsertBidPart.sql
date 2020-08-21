USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal	
-- Create date: 07/01/19
-- Description:	Insert bid part
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[UploadBidPart_InsertBidPart] (
	@BidId INT
	,@CustomerPartNumber NVARCHAR(30)  = NULL
	,@CleanCustomerPartNumber NVARCHAR(30)  = NULL
	,@PartDescription NVARCHAR(300) = NULL
	,@Manufacturer NVARCHAR(50) = NULL
	,@ManufacturerPartNumber NVARCHAR(30) = NULL
	,@CleanManufacturerPartNumber NVARCHAR(30)  = NULL
	,@Note NVARCHAR(300) = NULL
	,@EstimatedAnnualUsage INT = NULL
	,@CreatedBy NVARCHAR(100) = NULL
	,@AffectedRowId INT = NULL OUTPUT
	)
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
	VALUES (
		@BidId
		,@CustomerPartNumber
		,REPLACE(REPLACE(@CustomerPartNumber, '-', ''), '.', '')
		,@PartDescription
		,@Manufacturer
		,@ManufacturerPartNumber
		,REPLACE(REPLACE(@ManufacturerPartNumber, '-', ''), '.', '')
		,@Note
		,@EstimatedAnnualUsage
		,@CreatedBy
		,GETDATE()
		)

	SET @AffectedRowId = SCOPE_IDENTITY()
END
