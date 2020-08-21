USE [FPCAPPS]
GO

/****** Object:  UserDefinedFunction [sicf].[udf_RemoveSpecialCharacters]    Script Date: 8/13/2019 2:33:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE
	OR

ALTER FUNCTION BM.GetInventoryActionType (@BidId INT)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @BidStatus VARCHAR(100)

	SELECT @BidStatus = BidStatus
	FROM BM.BID
	WHERE BIDID = @BidId

	DECLARE @ActionType VARCHAR(100)

	IF @BidStatus = 'InventoryUpdate'
		SET @ActionType = 'Inventory Update'
	ELSE IF @BidStatus IN (
			'LineReview_CM'
			,'LineReview_Dir'
			,'LineReview_VP'
			)
		SET @ActionType = 'Inventory Pullback Update'
	ELSE IF @BidStatus IN (
			'InventoryReUpdate'
			,'DataTeam'
			,'DemandTeam'
			)
		SET @ActionType = 'Inventory Re-Update'

	RETURN @ActionType
END
