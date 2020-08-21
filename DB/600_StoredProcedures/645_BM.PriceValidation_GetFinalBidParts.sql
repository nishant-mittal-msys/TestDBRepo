USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gurpreet Singh	
-- Create date: 08/08/19
-- Description:	Get all final bid part details
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[PriceValidation_GetFinalBidParts] (
	@BidId INT
	,@UserId NVARCHAR(100) = NULL
	,@UserRole VARCHAR(50) = NULL
	)
AS
BEGIN
	SELECT BidPartId
		,BidId
		,CustomerPartNumber
		,PartDescription
		,Manufacturer
		,ManufacturerPartNumber
		,Note
		,EstimatedAnnualUsage
		,IsFinalized
		,CreatedBy
		,CreatedOn
	FROM BM.BidPart  (nolock)
	WHERE BidId = @BidId
	AND IsFinalized = 1
END
