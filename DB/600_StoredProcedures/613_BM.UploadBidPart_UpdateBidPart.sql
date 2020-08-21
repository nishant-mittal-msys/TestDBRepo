USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal	
-- Create date: 07/01/19
-- Description:	Update bid part
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[UploadBidPart_UpdateBidPart] (
	@BidPartId INT
	,@CustomerPartNumber NVARCHAR(30)
	,@PartDescription NVARCHAR(300) = NULL
	,@Manufacturer NVARCHAR(50) = NULL
	,@ManufacturerPartNumber NVARCHAR(30) = NULL
	,@Note NVARCHAR(300) = NULL
	,@EstimatedAnnualUsage INT = NULL
	,@CreatedBy NVARCHAR(100) = NULL
	,@AffectedRowId INT = NULL OUTPUT
	)
AS
BEGIN
	UPDATE BM.BidPart
	SET CustomerPartNumber = @CustomerPartNumber
		,PartDescription = @PartDescription
		,Manufacturer = @Manufacturer
		,ManufacturerPartNumber = @ManufacturerPartNumber
		,Note = @Note
		,EstimatedAnnualUsage = @EstimatedAnnualUsage
		,CreatedBy = @CreatedBy
		,CreatedOn = GetDate()
	WHERE BidPartId = @BidPartId

	SET @AffectedRowId = @BidPartId
END
