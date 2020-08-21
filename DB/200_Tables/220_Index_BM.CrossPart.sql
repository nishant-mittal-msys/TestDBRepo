USE [FPCAPPS]
GO
CREATE NONCLUSTERED INDEX [ix_CrossPart_IsWon]
ON [BM].[CrossPart] ([IsWon])
INCLUDE ([BidPartId],[PartNumber],[PoolNumber])
GO


USE [FPCAPPS]
GO
CREATE NONCLUSTERED INDEX [ix_CrossPart_IsActive]
ON [BM].[CrossPartInventory] ([IsActive])
INCLUDE ([CrossPartId])
GO
