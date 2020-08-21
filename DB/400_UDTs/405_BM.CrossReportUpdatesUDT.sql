USE FPCAPPS
GO

--DROP SCRIPTS
--DROP PROCEDURE BM.[CrossReport_SaveAll]
--Drop type BM.CrossReportUpdatesUDT

-- Create the data type
CREATE TYPE BM.CrossReportUpdatesUDT AS TABLE (
	BidPartId INT NOT NULL
	,CrossPartId INT NULL	
	,FinalPreference varchar(20) NULL
	,IsVerified  bit NULL
	)
GO


