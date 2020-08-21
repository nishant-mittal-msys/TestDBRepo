USE FPCAPPS
GO

--DROP SCRIPTS
--DROP PROCEDURE BM.UploadBidPart_BulkInsertBidParts
--Drop type BM.BidPartsUDT
-- Create the data type
CREATE TYPE BM.BidPartsUDT AS TABLE (
	BidId INT NOT NULL
	,CustomerPartNumber NVARCHAR(50) NOT NULL
	,PartDescription NVARCHAR(300) NULL
	,Manufacturer NVARCHAR(50) NULL
	,ManufacturerPartNumber NVARCHAR(50) NULL
	,EstimatedAnnualUsage INT NULL
	,Note NVARCHAR(300) NULL
	,UserId NVARCHAR(100) NOT NULL
	)
GO


