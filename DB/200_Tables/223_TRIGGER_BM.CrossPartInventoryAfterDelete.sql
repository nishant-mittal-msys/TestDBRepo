USE FPCAPPS
GO

CREATE OR ALTER TRIGGER BM.CrossPartInventoryAfterDelete ON BM.CrossPartInventory
	AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @BidId INT
	SELECT @BidId = DELETED.[BidId] FROM DELETED
	
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
			DELETED.CrossPartInventoryId
           ,DELETED.[BidId]
           ,DELETED.[CrossPartId]
           ,DELETED.[Location]
           ,DELETED.[StockingType]
           ,DELETED.[CustPartUOM]
           ,DELETED.[EstimatedAnnualUsage]
           ,DELETED.[NewPool]
           ,DELETED.[NewPartNo]
           ,DELETED.[NewStockingType]
           ,DELETED.[NewPrice]
           ,DELETED.[IsActive]
           ,DELETED.[LastUpdatedBy]
           ,DELETED.[LastUpdatedOn]
           ,'DELETE'
           ,@ActionType
           ,'ALL'
		FROM DELETED
END
GO


