USE FPCAPPS
GO

CREATE TABLE BM.CrossPart (
	CrossPartId INT PRIMARY KEY IDENTITY
	,BidPartId INT NOT NULL 
	,CrossRank INT NOT NULL
	,ReferenceTableName NVARCHAR(100) NULL
	,Source NVARCHAR(20) NOT NULL
	,Company INT NOT NULL
	,PartNumber NVARCHAR(50) NOT NULL
	,PoolNumber INT NULL
	,PartDescription NVARCHAR(100) NULL
	,PartCategory NVARCHAR(20) NULL
	,VendorNumber INT NULL
	,VendorName VARCHAR(500) NULL
	,VendorColor NVARCHAR(255) NULL
	,VendorColorDefinition NVARCHAR(255) NULL
	,Manufacturer NVARCHAR(50) NULL
	,IsFlip BIT NULL
	,IsNonFP BIT NULL
	,ValidationStatus NCHAR(1) NULL
	,ValidatedBy NVARCHAR(100) NULL
	,ValidatedOn DATETIME NULL
	,CreatedBy NVARCHAR(100) NOT NULL
	,CreatedOn DATETIME NOT NULL
	,FinalPreference NVARCHAR(50) NULL
	,Comments NVARCHAR(max) NULL
	,PriceToQuote NUMERIC(9,2) NULL
	,SuggestedPrice NUMERIC(9,2) NULL
	,ICOST NUMERIC(9,2) NULL
	,Margin NUMERIC(9,2) NULL
	,AdjustedICost NUMERIC(9,2) NULL
	,AdjustedMargin NUMERIC(9,2) NULL
	,IsWon BIT NULL
)

use [FPCAPPS]
CREATE NONCLUSTERED INDEX IX_CrossPart_SourceCreatedByCreatedOn ON [FPCAPPS].[BM].CrossPart (Source,CreatedBy,CreatedOn)
CREATE NONCLUSTERED INDEX IX_CrossPart_VStatusVByVOn ON [FPCAPPS].[BM].CrossPart (ValidationStatus,ValidatedBy,ValidatedOn)
CREATE NONCLUSTERED INDEX IX_CrossPart_CreatedByOn ON [FPCAPPS].[BM].CrossPart (CreatedBy,CreatedOn)


