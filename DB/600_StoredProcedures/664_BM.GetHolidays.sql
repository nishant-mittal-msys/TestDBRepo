USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ====================================================
-- Author:		Vaqqas
-- Create date: 8/26/2019
-- Description:	Get all the holidays from internal table FPBIDW.edw.DimDate
-- ===================================================
CREATE OR ALTER PROC [BM].[GetHolidays] 
AS
BEGIN
	SELECT CalendarDate AS HolidayDate, 'Holiday' AS HolidayName FROM FPBIDW.edw.DimDate WHERE HolidayIndicator = 'holiday' 
	AND CalendarDate > (GETDATE() - 1)
END
GO