USE FPCAPPS
GO

--DROP SCRIPTS
--DROP PROCEDURE BM.Inventory_DeleteCrossPartsInventory
--Drop type BM.CrossPartsInventoryIdDeleteUDT

CREATE TYPE BM.CrossPartsInventoryIdDeleteUDT AS TABLE(
	[CrossPartInventoryId] [int] NOT NULL
)
GO
