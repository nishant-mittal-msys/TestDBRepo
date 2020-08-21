USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal	
-- Create date: 12/16/19
-- Description:	Delete Cross Part Inventory
-- =============================================
CREATE OR ALTER PROCEDURE [BM].[Inventory_DeleteCrossPartsInventory] (@DeleteCrossPartsInventoryIdUDT AS BM.[CrossPartsInventoryIdDeleteUDT] READONLY)
AS
BEGIN
	DELETE
	FROM BM.CrossPartInventory
	WHERE CrossPartInventoryId IN (
			SELECT CrossPartInventoryId
			FROM @DeleteCrossPartsInventoryIdUDT
			)
END
