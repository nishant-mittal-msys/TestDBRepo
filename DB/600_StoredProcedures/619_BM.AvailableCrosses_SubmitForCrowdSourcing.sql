USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Vaqqas
-- Create date: 7/12/2019
-- Description:	Submit the bid for crowd sourcing
-- =============================================
CREATE OR ALTER PROCEDURE [BM].[AvailableCrosses_SubmitForCrowdSourcing] (
	@BidPartIds BM.IDs readonly
	)
AS
BEGIN
	UPDATE BM.BidPart
	SET IsCrowdSourcingEligible = 1
	WHERE BidPartId in (SELECT ID from @BidPartIds)

END
