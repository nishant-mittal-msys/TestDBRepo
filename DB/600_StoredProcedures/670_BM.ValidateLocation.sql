USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal	
-- Create date: 12/16/19
-- Description:	Validate the location
-- =============================================
CREATE
	OR

ALTER PROCEDURE BM.ValidateLocation (
	@Location VARCHAR(100)
	,@BidId INT
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT TOP 1 Location
	FROM [FPBIDW].[EDW].[DimLocation] (nolock) 
	WHERE Company = (
			SELECT Company
			FROM BM.Bid
			WHERE BidId = @BidId
			)
		AND [Location] = @Location
END
GO


