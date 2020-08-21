USE FPCAPPS
GO

--DROP SCRIPTS
--DROP PROCEDURE BM.VendorGrade_BulkSaveVendorGrade
--Drop type BM.VendorGradeUDT
-- Create the data type
CREATE TYPE BM.VendorGradeUDT AS TABLE (
	Category NVARCHAR(255) NULL
	,VendorName NVARCHAR(255) NULL
	,VendorNumber INT NULL
	,ColorCode NVARCHAR(255) NULL
	,Color NVARCHAR(255) NULL
	,Definition NVARCHAR(255) NULL
	)
GO


