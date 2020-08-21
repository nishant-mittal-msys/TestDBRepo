USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gurpreet Singh	
-- Create date: 08/08/19
-- Description:	Download crosses in excel on price validation page
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[PriceValidation_DownloadCrosses] (@BidId INT)
AS
BEGIN
	SELECT CP.BidPartId [Bid Part Id]
		,CP.CrossPartId [Cross Part Id]
		,(
			CASE 
				WHEN BP.ManufacturerPartNumber IS NULL
					OR BP.ManufacturerPartNumber = ''
					THEN BP.CustomerPartNumber
				ELSE BP.ManufacturerPartNumber
				END
			) AS [Part Number]
		, BP.EstimatedAnnualUsage AS [Estimated Annual Usage]
		,CP.FinalPreference AS [Cross Preference]
		,CP.ReferenceTableName AS [Reference Table]
		,CP.PartNumber AS [Cross Part]
		,cast(CP.PoolNumber AS VARCHAR) AS [Cross Pool]
		,( cast(CP.PoolNumber AS VARCHAR) + '-' + CP.PartNumber ) As [CrossPool-CrossPart]
		,CP.PartDescription AS [Cross Description]
		,CP.PartCategory AS [Cross Category]
		,CP.VendorName AS [Vendor Name]
		,CP.VendorColorDefinition AS [Vendor Status]
		,PriceToQuote AS [Price To Quote] 
		,SuggestedPrice As [Suggested Price]
		,[ICOST]
		,[Margin]
		,[AdjustedICOST] As [Adjusted ICost]
		,[AdjustedMargin] As [Adjusted Margin]
	FROM FPCAPPS.BM.BidPart BP (nolock)
	INNER JOIN FPCAPPS.BM.CrossPart CP  (nolock) ON CP.BidPartId = BP.BidPartId
	WHERE BP.BidId = @BidId
		AND CP.FinalPreference in ('Primary','Alternate1', 'Alternate2')
		AND(  (UPPER(ltrim(rtrim(CP.VendorColorDefinition))) = 'DO NOT USE'AND BP.IsVerified = 1) 
		     OR (UPPER(ltrim(rtrim(CP.VendorColorDefinition))) != 'DO NOT USE')
			  --To handle few cases where VendorColorDefinition in null
			 OR (CP.VendorColorDefinition IS NULL)
		   )
	ORDER BY BP.BidPartId
END
