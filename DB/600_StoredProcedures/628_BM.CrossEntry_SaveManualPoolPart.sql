USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal
-- Create date: 07/08/19
-- Description:	save the manual crosses entered from user
-- =============================================
CREATE
	OR

ALTER PROC [BM].[CrossEntry_SaveManualPoolPart] (
	@CrowdSourcingPartId INT
	,@PartNo NVARCHAR(30)
	,@PoolNo INT = NULL
	,@Description NVARCHAR(50) = NULL
	,@Category VARCHAR(20) = NULL
	,@IsCrossReport INT
	,@UserId VARCHAR(50)
	,@AffectedRowId INT = NULL OUTPUT
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Compy INT = NULL

	SET @Compy = (SELECT Bid.Company FROM BM.Bid Bid  (nolock) 
	INNER JOIN BM.BidPart BP (nolock) 
		ON Bid.BidId = BP.BidId 
	WHERE BidPartId = @CrowdSourcingPartId)

	IF (@IsCrossReport = 1)
		SET @CrowdSourcingPartId = (
				SELECT TOP 1 BidPartId
				FROM BM.BidPart  (nolock) 
				WHERE BidPartId = @CrowdSourcingPartId
				)

	IF EXISTS (
			SELECT PartNumber
			FROM BM.CrossPart
			WHERE PartNumber = @PartNo
				AND BidPartId = @CrowdSourcingPartId
			)
	BEGIN
		SET @AffectedRowId = - 1
	END
	ELSE
	BEGIN
		INSERT INTO BM.CrossPart (
			BidPartId
			,CrossRank
			,Company
			,PartNumber
			,PoolNumber
			,PartDescription
			,PartCategory
			,IsNonFP
			,IsFlip
			,[Source]
			--,IsFinalized
			,CreatedBy
			,CreatedOn
			)
		VALUES (
			@CrowdSourcingPartId
			,0
			,@Compy
			,@PartNo
			,@PoolNo
			,@Description
			,@Category
			,1
			,0
			,'CrowdSourcing'
			--,0
			,@UserId
			,GETDATE()
			);

		SET @AffectedRowId = SCOPE_IDENTITY()

		IF (@IsCrossReport = 1)
			UPDATE BM.CrossPart
			SET ValidationStatus = 'A'
			WHERE CrossPartId = @AffectedRowId
	END
END
