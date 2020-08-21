USE FPCAPPS
GO

CREATE OR ALTER TRIGGER BM.CrossPartInventoryAfterInsert ON BM.CrossPartInventory
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @BidId INT
	SELECT @BidId = INSERTED.[BidId] FROM INSERTED
	
	DECLARE @ActionType varchar(100) = BM.GetInventoryActionType(@BidId)

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
           ,'INSERT'
           ,@ActionType
           ,'ALL'
		FROM INSERTED
END
GO


