USE [FPCAPPS]
GO


CREATE TABLE [BM].[CrossPartInventory](
	[CrossPartInventoryId] [int] IDENTITY(1,1) NOT NULL,
	[BidId] [int] NULL,
	[CrossPartId] [int] NULL,
	[Location] [nvarchar](50) NULL,
	[StockingType] varchar(3) NULL,
	[CustPartUOM] [nvarchar](50) NULL,
	[EstimatedAnnualUsage] [int] NULL,
	[NewPool] [int] NULL,
	[NewPartNo] [nvarchar](50) NULL,
	[NewStockingType] varchar(3) NULL,
	[NewPrice] [numeric](9, 2) NULL,
	[IsActive] [nvarchar](10) NULL,
	[LastUpdatedBy] [nvarchar](100) NULL,
	[LastUpdatedOn] [datetime] NULL,
	
 CONSTRAINT [PK_CrossPartInventory] PRIMARY KEY CLUSTERED 
(
	[CrossPartInventoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

--alter table [BM].[CrossPartInventory] add StockingType varchar(3) null
--alter table [BM].[CrossPartInventory] add NewStockingType varchar(3) null
--alter table [BM].[CrossPartInventory] add BidId INT null