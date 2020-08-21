USE FPCAPPS
GO

--DROP SCRIPTS
--DROP PROCEDURE BM.Inventory_DownloadLocationInventory
--Drop type BM.LocationsUDT

CREATE TYPE BM.LocationsUDT AS TABLE(
	[Location] VARCHAR(20) NOT NULL
)
GO
