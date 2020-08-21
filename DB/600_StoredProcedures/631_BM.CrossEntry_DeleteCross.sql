USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal
-- Create date: 07/08/19
-- Description:	to delete a cross from crowd sourced part
-- =============================================
CREATE
	OR

ALTER PROC [BM].[CrossEntry_DeleteCross] (@CrossPartId INT)
AS
BEGIN
	DELETE
	FROM BM.CrossPart
	WHERE CrossPartId = @CrossPartId
END
