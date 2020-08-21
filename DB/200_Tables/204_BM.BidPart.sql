USE [FPCAPPS]
GO


CREATE TABLE BM.BidPart (
	BidPartId INT PRIMARY KEY IDENTITY
	,BidId INT NOT NULL
	,CustomerPartNumber NVARCHAR(50) NULL
	,PartDescription NVARCHAR(300) NULL
	,Manufacturer NVARCHAR(50) NULL
	,ManufacturerPartNumber NVARCHAR(50) NULL
	,Note NVARCHAR(300) NULL
	,EstimatedAnnualUsage INT NULL
	,IsCrowdSourcingEligible BIT NULL
	,CreatedBy NVARCHAR(100) NOT NULL
	,CreatedOn DATETIME NOT NULL
	,IsSubmitted BIT NULL
	,IsValidated BIT NULL
	,SubmittedBy NVARCHAR(100) NULL
	,SubmittedOn DATETIME NULL
	,ValidatedBy NVARCHAR(100) NULL
	,ValidatedOn DATETIME NULL
	,Comments NVARCHAR(max) NULL
	,IsFinalized BIT NULL
	,FinalizedBy NVARCHAR(100) NULL
	,FinalizedOn DateTime NULL
	,IsVerified BIT NULL
	,VerifiedBy NVARCHAR(100) NULL
	,VerifiedOn DateTime NULL
	,CleanCustomerPartNumber NVARCHAR(50) NULL
	,CleanManufacturerPartNumber NVARCHAR(50) NULL
	)

ALTER TABLE [BM].[BidPart] ADD  CONSTRAINT [DF_BidPart_IsSubmitted]  DEFAULT ((0)) FOR [IsSubmitted]
GO

ALTER TABLE [BM].[BidPart] ADD  CONSTRAINT [DF_BidPart_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO


use [FPCAPPS]
CREATE NONCLUSTERED INDEX IX_BidPart_IsCrowdSourcingEligible ON [FPCAPPS].[BM].[BidPart] (BidId, IsCrowdSourcingEligible, IsSubmitted);  
