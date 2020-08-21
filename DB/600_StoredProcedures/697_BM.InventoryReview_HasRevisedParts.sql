USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Vaqqas
-- Create date: 12/27/19
-- Description:	Save the approval of the parts
-- =============================================
CREATE OR ALTER PROCEDURE [BM].[InventoryReview_HasRevisedParts] (
	@BidId int
	)
AS
BEGIN
	IF EXISTS( SELECT TOP 1 CPLR.ID as ID
	FROM FPCAPPS.BM.CrossPartLineReview CPLR  (nolock) 
	WHERE cplr.BidId = @BidId AND cplr.IsApproved = 0 )
		SELECT 1 
	ELSE
		SELECT 0 
END

