USE FPCAPPS
GO

--drop trigger BM.CrossPartInventoryAfterUpdate   ON BM.CrossPartInventory

CREATE 
OR 
ALTER 
TRIGGER BM.CrossPartInventoryInsteadOfUpdate ON BM.CrossPartInventory
	INSTEAD OF UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @BidId INT
	DECLARE @CrossPartInventoryId INT

	SELECT 
		@BidId = INSERTED.[BidId], 
		@CrossPartInventoryId = INSERTED.CrossPartInventoryId 
	FROM INSERTED
	
	DECLARE @ActionType varchar(100) = BM.GetInventoryActionType(@BidId)
	DECLARE @ColumnsUpdated varchar(max) = ''

	---------DECIDE WHAT CHANGED SINCE LAST TIME-------------------------
	DECLARE @Location nvarchar(50)
	DECLARE @StockingType varchar(3)
	DECLARE @CustPartUOM nvarchar(50)
	DECLARE @EstimatedAnnualUsage int
	DECLARE @NewPool int
	DECLARE @NewPartNo nvarchar(50)
	DECLARE @NewStockingType varchar(3)
	DECLARE @NewPrice numeric(9, 2)
	DECLARE @IsActive nvarchar(10)

	SELECT 
		@Location = [Location],
		@StockingType = [StockingType],
		@CustPartUOM = [CustPartUOM],
		@EstimatedAnnualUsage = [EstimatedAnnualUsage],
		@NewPool = [NewPool],
		@NewPartNo = [NewPartNo],
		@NewStockingType = [NewStockingType],
		@NewPrice = [NewPrice],
		@IsActive = [IsActive]
	FROM 
		[BM].[CrossPartInventory]
	WHERE
		[CrossPartInventoryId] = @CrossPartInventoryId

	SET @ColumnsUpdated = (SELECT 
        CASE WHEN isnull(@Location, '') <> isnull(INSERTED.[Location], '') THEN ',Location' ELSE '' END
        + CASE WHEN isnull(@StockingType, '') <> isnull(INSERTED.[StockingType], '') THEN ',StockingType' ELSE '' END
        + CASE WHEN isnull(@CustPartUOM, '') <> isnull(INSERTED.[CustPartUOM], '') THEN ',CustPartUOM' ELSE '' END
        + CASE WHEN isnull(@EstimatedAnnualUsage, 0) <> isnull(INSERTED.[EstimatedAnnualUsage], '') THEN ',EstimatedAnnualUsage' ELSE '' END
        + CASE WHEN isnull(@NewPool, 0) <> INSERTED.[NewPool]  THEN ',NewPool' ELSE '' END
        + CASE WHEN isnull(@NewPartNo, '') <> INSERTED.[NewPartNo] THEN ',NewPartNo' ELSE '' END
        + CASE WHEN isnull(@NewStockingType, '') <> INSERTED.[NewStockingType] THEN ',NewStockingType' ELSE '' END
        + CASE WHEN isnull(@NewPrice, 0) <> INSERTED.[NewPrice] THEN ',NewPrice' ELSE '' END
        + CASE WHEN @IsActive <> INSERTED.[IsActive] THEN ',IsActive' ELSE '' END
	FROM INSERTED)

	
	------------UPDATE THE TARGETTED RECORD----------------------
	UPDATE cpi 
	SET
        cpi.[BidId] = INSERTED.[BidId],
        cpi.[CrossPartId] = INSERTED.[CrossPartId],
		cpi.Location = INSERTED.[Location],
		cpi.StockingType = INSERTED.[StockingType],
		cpi.CustPartUOM = INSERTED.[CustPartUOM],
		cpi.EstimatedAnnualUsage = INSERTED.[EstimatedAnnualUsage],
		cpi.NewPool = INSERTED.[NewPool],
		cpi.NewPartNo = INSERTED.[NewPartNo],
		cpi.NewStockingType = INSERTED.[NewStockingType],
		cpi.NewPrice = INSERTED.[NewPrice],
		cpi.IsActive = INSERTED.[IsActive]
	FROM 
		[BM].[CrossPartInventory] cpi
		INNER JOIN INSERTED ON CPI.[CrossPartInventoryId] = INSERTED.[CrossPartInventoryId]
	WHERE
		CPI.[CrossPartInventoryId] = @CrossPartInventoryId

	----------IF THIS IS A RE-UPDATE THEN MARK THE PART AS APPROVED IN THE InventoryReview Table------------
	IF 'InventoryReUpdate' = (SELECT top 1 BidStatus FROM BM.BID where BidId = @BidId)
	BEGIN
		DECLARE @CrossPartId int

		select @CrossPartId = INSERTED.[CrossPartId] from INSERTED

		UPDATE [BM].CrossPartLineReview
		SET IsApproved = 1
		where BidID = @BidId and CrossPartId = @CrossPartId
	END

	------------ADD THE NEW VERSION OF THE RECORD TO THE HISTORY TABLE----------------------
	IF @ColumnsUpdated <> ''
	SET @ColumnsUpdated = substring(@ColumnsUpdated, 2, len(@ColumnsUpdated)-1);
	INSERT INTO [BM].[CrossPartInventoryHistory]
           ([CrossPartInventoryId]
           ,[BidId]
           ,[CrossPartId]
           ,[Location]
           ,[StockingType]
           ,[CustPartUOM]
           ,[EstimatedAnnualUsage]
           ,[NewPool]
           ,[NewPartNo]
           ,[NewStockingType]
           ,[NewPrice]
           ,[IsActive]
           ,[LastUpdatedBy]
           ,[LastUpdatedOn]
           ,[EventType]
           ,[ActionType]
           ,[ColumnsUpdated])
     SELECT 
			INSERTED.CrossPartInventoryId
           ,INSERTED.[BidId]
           ,INSERTED.[CrossPartId]
           ,INSERTED.[Location]
           ,INSERTED.[StockingType]
           ,INSERTED.[CustPartUOM]
           ,INSERTED.[EstimatedAnnualUsage]
           ,INSERTED.[NewPool]
           ,INSERTED.[NewPartNo]
           ,INSERTED.[NewStockingType]
           ,INSERTED.[NewPrice]
           ,INSERTED.[IsActive]
           ,INSERTED.[LastUpdatedBy]
           ,INSERTED.[LastUpdatedOn]
           ,'UPDATE'
           ,@ActionType
           ,@ColumnsUpdated
		FROM INSERTED
END
GO

--select top 100 substring(columnsupdated, 2, len(columnsupdated)-1), * from bm.[CrossPartInventoryHistory] where columnsupdated <> 'ALL'
--update  bm.[CrossPartInventoryHistory] set columnsupdated = substring(columnsupdated, 2, len(columnsupdated)-1)   where columnsupdated <> 'ALL'
--select columnsupdated from bm.[CrossPartInventoryHistory] where columnsupdated <> 'ALL'


