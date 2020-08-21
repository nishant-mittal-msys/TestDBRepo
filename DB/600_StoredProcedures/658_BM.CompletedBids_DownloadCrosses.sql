USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nishant Mittal	
-- Create date: 08/08/19
-- Description:	Download crosses in excel on Completed Bids page
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[CompletedBids_DownloadCrosses] (@BidId INT)
AS
BEGIN
	SELECT (
			CASE 
				WHEN CP.IsWon = 1 
					THEN 'Yes'
				ELSE ''
				END
			) AS [Is Part Won (Yes/No)]
		,CP.BidPartId [Bid Part Id]
		,CP.CrossPartId [Cross Part Id]
		,(
			CASE 
				WHEN BP.ManufacturerPartNumber IS NULL
					OR BP.ManufacturerPartNumber = ''
					THEN BP.CustomerPartNumber
				ELSE BP.ManufacturerPartNumber
				END
			) AS [Part Number]
		,CP.FinalPreference AS [Cross Preference]
		,CP.ReferenceTableName AS [Reference Table]
		,CP.PartNumber AS [Cross Part]
		,cast(CP.PoolNumber AS VARCHAR) AS [Cross Pool]
		,CP.PartDescription AS [Cross Description]
		,CP.PartCategory AS [Cross Category]
		,CP.VendorName AS [Vendor Name]
		,CP.VendorColorDefinition AS [Vendor Status]
		,PriceToQuote AS [Price To Quote]
		,SuggestedPrice AS [Suggested Price]
		,[ICOST]
		,[Margin]
		,[AdjustedICOST] AS [Adjusted ICost]
		,[AdjustedMargin] AS [Adjusted Margin]
	FROM FPCAPPS.BM.BidPart BP (nolock)
	INNER JOIN FPCAPPS.BM.CrossPart CP (nolock) ON CP.BidPartId = BP.BidPartId
	WHERE BP.BidId = @BidId
		AND CP.FinalPreference in ('Primary', 'Alternate1', 'Alternate2')
		--added below condition to show 'Do Not Use' parts only when CM verified
		AND(  (UPPER(ltrim(rtrim(CP.VendorColorDefinition))) = 'DO NOT USE'AND BP.IsVerified = 1) 
		     OR (UPPER(ltrim(rtrim(CP.VendorColorDefinition))) != 'DO NOT USE')
			  --To handle few cases where VendorColorDefinition in null
			 OR (CP.VendorColorDefinition IS NULL)
		   )
	ORDER BY BP.BidPartId
END
