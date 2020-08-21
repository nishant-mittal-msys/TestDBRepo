USE [FPCAPPS]
GO

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal	
-- Create date: 02/26/2020
-- Description:	Save vendor grade in bulk
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[VendorGrade_BulkSaveVendorGrade] (
	@VendorGradeUDT AS BM.[VendorGradeUDT] READONLY
	,@UserId NVARCHAR(100) = NULL
	)
AS
BEGIN
	-- Truncate the table before bulk upload
	TRUNCATE TABLE BM.VendorGrade

	-- Bulk insert Vendor Grade
	INSERT INTO BM.VendorGrade (
		Category
		,VendorName
		,VendorNumber
		,ColorCode
		,Color
		,DEFINITION
		,LastModifiedBy
		,LastModifiedOn
		)
	SELECT vgUDT.Category
		,vgUDT.VendorName
		,vgUDT.VendorNumber
		,vgUDT.ColorCode
		,vgUDT.Color
		,vgUDT.DEFINITION
		,@UserId
		,GETDATE()
	FROM @VendorGradeUDT vgUDT

	UPDATE BM.VendorGrade
	SET Color = CASE 
			WHEN ColorCode = 'R'
				THEN 'Red'
			WHEN ColorCode = 'G'
				THEN 'Green'
			WHEN ColorCode = 'Y'
				THEN 'Yellow'
			WHEN ColorCode = 'O'
				THEN 'Orange'
			WHEN ColorCode = 'K'
				THEN 'Khaki'
			WHEN ColorCode = 'B'
				THEN 'Blue'
			WHEN ColorCode = 'P'
				THEN 'Purple'
			END
		,DEFINITION = CASE 
			WHEN ColorCode = 'R'
				THEN 'Do not use'
			WHEN ColorCode = 'G'
				THEN 'Approved'
			WHEN ColorCode = 'Y'
				THEN 'To be reviewed by CM'
			WHEN ColorCode = 'O'
				THEN 'Do not use'
			WHEN ColorCode = 'K'
				THEN 'To be reviewed by CM'
			WHEN ColorCode = 'B'
				THEN 'Preferred'
			WHEN ColorCode = 'P'
				THEN 'To be reviewed by CM'
			END
END
