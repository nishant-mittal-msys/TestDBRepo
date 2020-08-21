USE [FPCAPPS]
GO

--drop table [FPCAPPS].[BM].CrossPartLineReview

CREATE TABLE [BM].CrossPartLineReview(
	ID INT IDENTITY(1,1) NOT NULL,
	BidID INT NOT NULL,
	BidPartID int not NULL,
	[CrossPartId] [int] NOT NULL,
	[ExistingStockingLocations] [int] NULL,
	[DCStockCount] [int] NULL,
	[L12Units] decimal(38,2) NULL,
	[NewStockingLocations] [int] NULL,
	[ProjectedL12Units] [int] NULL,
	[ProjectedL12GP] decimal (18,2) NULL,
	[ProjectedInvestment] decimal (18,2) NULL,
	[ProjectedL12Revenue] decimal (18,2) NULL,
	[ICost] decimal (18,2) NULL,
	[MedianCost] decimal (18,2) NULL,
	[SalesPack] int null,
	[StockingType] varchar(10) NULL,
	[EstimatedMonthlyUsage] int null,
	[Price] decimal(18,2) null,
	[CategoryManagerID] VARCHAR(100) NULL,
	[CategoryDirectorID] VARCHAR(100) NULL,
	[CategoryCMOID] VARCHAR(100) NULL,
	IsApproved bit not null,
	CreatedOn Datetime not null,
	Comments VARCHAR(2000) NULL,
 CONSTRAINT [PK_CrossPartLineReview_ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO