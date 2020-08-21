USE FPCAPPS
GO

--DROP SCRIPTS
--DROP PROCEDURE BM.CompletedBids_UploadPartMarkWon
--DROP type BM.PartsMarkWonUDT

-- Create the data type
CREATE TYPE BM.PartsMarkWonUDT AS TABLE (
	IsPartWon BIT NULL
	,BidPartId INT NOT NULL
	,CrossPartId INT NOT NULL
	)
GO


