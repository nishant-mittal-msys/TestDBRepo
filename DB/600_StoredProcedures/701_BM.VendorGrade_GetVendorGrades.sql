USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal
-- Create date: 02/25/2020
-- Description:	Get all vendor grades
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[VendorGrade_GetVendorGrades]
AS
BEGIN
	SELECT  [VendorGradeId]
		,[Category]
		,[VendorName]
		,[VendorNumber]
		,[ColorCode]
		,[Color]
		,[Definition]
		,[LastModifiedBy]
		,[LastModifiedOn]
	FROM BM.VendorGrade (nolock) 
END
