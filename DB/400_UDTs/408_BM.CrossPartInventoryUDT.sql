USE FPCAPPS
GO

--DROP SCRIPTS
--DROP PROCEDURE BM.Inventory_BulkSaveCrossPartsInventory
--Drop type BM.CrossPartInventoryUDT
-- Create the data type
CREATE TYPE BM.CrossPartInventoryUDT AS TABLE (
	BidId int null,
	BidPartId int null,
	CrossPartId int null,
	CustomerPartNumber NVARCHAR(100) NULL
	,ManufacturerPartNumber NVARCHAR(100) NULL
	,CrossPoolNumber INT NULL
	,CrossPartNumber NVARCHAR(100) NULL
	,CrossPrice NUMERIC(9, 2) NULL
	,Location NVARCHAR(10) NULL
	,CustPartUOM NVARCHAR(50) NULL
	,EstimatedAnnualUsage INT NULL
	,NewPool INT NULL
	,NewPartNo NVARCHAR(100) NULL
	,NewPrice NUMERIC(9, 2) NULL
	,IsActive NVARCHAR(10) NULL
	)
GO


