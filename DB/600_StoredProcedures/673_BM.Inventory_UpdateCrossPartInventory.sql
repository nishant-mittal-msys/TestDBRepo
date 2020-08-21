USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal	
-- Create date: 12/16/19
-- Description:	Update CrossPart Inventory
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[Inventory_UpdateCrossPartInventory] (
	@BidId INT
	,@CrossPartId INT = NULL
	,@CrossPartInventoryId INT = NULL
	,@CustomerPartNumber NVARCHAR(100) = NULL
	,@ManufacturerPartNumber NVARCHAR(100) = NULL
	,@CrossPoolNumber INT = NULL
	,@CrossPartNumber NVARCHAR(100) = NULL
	,@CrossPrice NUMERIC(9, 2) = NULL
	,@Location NVARCHAR(10)
	,@CustPartUOM NVARCHAR(50) = NULL
	,@EstimatedAnnualUsage INT
	,@NewPool INT = NULL
	,@NewPartNo NVARCHAR(100) = NULL
	,@NewPrice NUMERIC(9, 2) = NULL
	,@IsActive NVARCHAR(10) = NULL
	,@UserId NVARCHAR(100) = NULL
	,@AffectedRowId INT = NULL OUTPUT
	)
AS
BEGIN
	DECLARE @StockingType NVARCHAR(10) = NULL
	DECLARE @NewStockingType NVARCHAR(10) = NULL
	DECLARE @Company TINYINT = 1

	SET @AffectedRowId = 0
	SET @Company = (
			SELECT Company
			FROM BM.Bid(NOLOCK)
			WHERE BidId = @BidId
			)

	--Validate the Location
	IF NOT EXISTS (SELECT TOP 1 Location
			FROM [FPBIDW].[EDW].[DimLocation](NOLOCK)
			WHERE Company = @Company
				AND [Location] = @Location
			)
		SET @AffectedRowId = -1 --Location invalid
	ELSE
	BEGIN
	--get the crossPartId (for excel upload cross part id is null)
		IF (@CrossPartId IS NULL OR @CrossPartId = 0)
			SET @CrossPartId = (
				SELECT TOP 1 cp.CrossPartId
				FROM FPCAPPS.BM.CrossPart CP(NOLOCK)
				INNER JOIN FPCAPPS.BM.BidPart BP(NOLOCK) ON BP.BidPartId = CP.BidPartId
					AND isnull(BP.CustomerPartNumber, '') = isnull(@CustomerPartNumber, '')
					AND isnull(BP.ManufacturerPartNumber, '') = isnull(@ManufacturerPartNumber, '')
				WHERE CP.PoolNumber = @CrossPoolNumber
					AND ISNULL(CP.PartNumber, '') = ISNULL(@CrossPartNumber, '')
					AND CP.IsWon = 1
					AND BP.BidId = @BidId
				)

		IF @CrossPartInventoryId IS NOT NULL AND @CrossPartInventoryId > 0 AND EXISTS (SELECT TOP 1 CrossPartInventoryid
			FROM BM.CrossPartInventory CPI(NOLOCK)
			WHERE CPI.CrossPartInventoryId <> @CrossPartInventoryId
				AND CPI.CrossPartID = @CrossPartID
				AND CPI.BidID = @BidID
				AND CPI.Location = @Location
			)
			SET @AffectedRowId = -2 --Location already added with the part
		ELSE --LOCATION IS VALID PROCEED WITH THE INSERT/UPDATE
		BEGIN
			SET @StockingType = (
				SELECT TOP 1 INV.IType AS StockingType
				FROM [FPBIDW].edw.FactInventory INV(NOLOCK)
				WHERE INV.Company = @Company
					AND ltrim(rtrim(INV.PartNumber)) = @CrossPartNumber
					AND @CrossPoolNumber = INV.Pool
					AND @Location = INV.Location
				)

			IF (@NewPartNo IS NOT NULL)
			SET @NewStockingType = (
					SELECT TOP 1 INV.IType AS NewStockingType
					FROM [FPBIDW].edw.FactInventory INV(NOLOCK)
					WHERE ltrim(rtrim(INV.PartNumber)) = ltrim(rtrim(@NewPartNo))
						AND INV.Pool = @NewPool
						AND INV.Location = @Location
						AND INV.Company = @Company
					)

			IF (@CrossPartInventoryId IS NULL OR @CrossPartInventoryId <= 0)
			SELECT @CrossPartInventoryId = CPI.CrossPartInventoryId
				FROM BM.CrossPartInventory CPI(NOLOCK)
				INNER JOIN FPCAPPS.BM.CrossPart CP(NOLOCK) ON cp.CrossPartId = CPI.CrossPartId
				WHERE CPI.BidId = @BidId
				AND CP.PoolNumber = @CrossPoolNumber
				AND CP.PartNumber = @CrossPartNumber
				AND CPI.Location = @Location
				AND CP.IsWon = 1

			IF @CrossPartInventoryId IS NOT NULL AND @CrossPartInventoryId > 0
			BEGIN
			UPDATE CrossPartInventory
			SET BidId = @BidId
				,[Location] = @Location
				,CustPartUOM = @CustPartUOM
				,EstimatedAnnualUsage = @EstimatedAnnualUsage
				,StockingType = @StockingType
				,NewPool = @NewPool
				,NewPartNo = @NewPartNo
				,NewStockingType = @NewStockingType
				,NewPrice = @NewPrice
				,IsActive = @IsActive
				,LastUpdatedBy = @UserId
				,LastUpdatedOn = GETDATE()
			WHERE CrossPartInventoryId = @CrossPartInventoryId

			SET @AffectedRowId = @CrossPartInventoryId
			
			END
			ELSE
			BEGIN
			INSERT INTO BM.CrossPartInventory (
				BidId
				,CrossPartId
				,[Location]
				,StockingType
				,CustPartUOM
				,EstimatedAnnualUsage
				,NewPool
				,NewPartNo
				,NewStockingType
				,NewPrice
				,IsActive
				,LastUpdatedBy
				,LastUpdatedOn
				)
			VALUES (
				@BidId
				,@CrossPartId
				,@Location
				,@StockingType
				,@CustPartUOM
				,@EstimatedAnnualUsage
				,@NewPool
				,@NewPartNo
				,@NewStockingType
				,@NewPrice
				,@IsActive
				,@UserId
				,GETDATE()
				)

			SET @AffectedRowId = SCOPE_IDENTITY()
			END
		END
	END
END
