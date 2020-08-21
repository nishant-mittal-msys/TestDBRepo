USE [FPCAPPS]
GO

--drop table [BM].[CrossPartInventoryHistory]
CREATE TABLE [BM].[CrossPartInventoryHistory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
    [CrossPartInventoryId] [int],
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
	[EventType] varchar(20) NULL,
	[ActionType] varchar(30) NULL,
	[ColumnsUpdated] varchar(max) NULL,
	
 CONSTRAINT [PK_CrossPartInventoryHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

--select * from fpcapps.bm.[CrossPartInventoryHistory]

