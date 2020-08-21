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
CREATE OR ALTER PROCEDURE [BM].[Bid_Submit] (
	@BidId int,
	@NewStatus varchar(50),
	@PhaseDueDate datetime,
	@CalculatedDueDate datetime,
	@Comments nvarchar(max)
	)
AS
BEGIN
	UPDATE BM.Bid
	SET BidStatus = @NewStatus,
	CurrentPhaseDueDate = @PhaseDueDate,
	CalculatedDueDate = @CalculatedDueDate,
	Comments = Comments + char(10) + @Comments
	WHERE BidId = @BidId;
END
