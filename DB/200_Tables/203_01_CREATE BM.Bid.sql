USE [FPCAPPS]
GO

/****** Object:  Table [BM].[Bid]    Script Date: 6/24/2019 10:29:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE TABLE BM.BID (
	BidId INT PRIMARY KEY IDENTITY
	,IsProspect BIT NOT NULL
	,BidStatus VARCHAR(255) NOT NULL
	,BidType VARCHAR(10) NOT NULL
	,BidName VARCHAR(255) NOT NULL
	,BidDescription VARCHAR(max) NOT NULL
	,DueDate DATETIME NOT NULL
	,CalculatedDueDate DATETIME NULL
	,CurrentPhaseDueDate DATETIME NULL
	,[Rank] INT NOT NULL
	,Company TINYINT NULL
	,CustNumber INT NULL
	,CustBranch INT NULL
	,CustName NVARCHAR(255) NULL
	,CustCorpId INT NULL
	,CustCorpAccName NVARCHAR(255) NULL
	,GroupId INT NULL
	,GroupDesc NVARCHAR(255) NULL
	,RequestType NVARCHAR(255) NULL
	,SubmittedDate DATETIME NULL
	,FPFacingLocations SMALLINT NULL
	,TotalValueOfBid NUMERIC(19, 2) NULL
	,ProjectedGPDollar NUMERIC(19, 2) NULL
	,ProjectedGPPerc NUMERIC(19, 2) NULL
	,IsFPPriceHold BIT NULL
	,HoldDate DATETIME NULL
	,IsCustomerAllowSubstitutions BIT NULL
	,BrandPreference VARCHAR(255) NULL
	,IsCustomerInventoryPurchaseGuarantee BIT NULL
	,LevelOfInvetoryDetailCustomerCanProvide NVARCHAR(255) NULL
	,SourceExcelFileName NVARCHAR(255) NULL
	,CreatedByRole NVARCHAR(100) NULL
	,NAMUserID NVARCHAR(100) NULL
	,CreatedBy NVARCHAR(100) NOT NULL
	,CreatedOn DATETIME NOT NULL
	,Comments NVARCHAR(max) NULL
	)


