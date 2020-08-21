USE FPCAPPS
GO

--DROP SCRIPTS
--DROP PROCEDURE BM.PriceValidation_UploadCrossPrice
--Drop type BM.CrossPartsPriceUDT

-- Create the data type
CREATE TYPE BM.CrossPartsPriceUDT AS TABLE (
	BidPartId INT NOT NULL
	,CrossPartId INT NOT NULL	
	,PriceToQuote NUMERIC(9,2) NULL
	,SuggestedPrice NUMERIC(9,2) NULL
	,ICOST NUMERIC(9,2) NULL
	,Margin NUMERIC(9,2) NULL
	,AdjustedICOST NUMERIC(9,2) NULL
	,AdjustedMargin NUMERIC(9,2) NULL
	)
GO


