USE [FPCAPPS]
GO

/****** Object:  Table [BM].[BidStatusReport]    Script Date: 1/15/2020 12:44:19 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [BM].[BidStatusReport](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BidId] [int] NULL,
	[IsProspect] [bit] NULL,
	[BidStatus] [varchar](255) NULL,
	[BidType] [varchar](10) NULL,
	[BidName] [varchar](255) NULL,
	[BidDescription] [varchar](max) NULL,
	[LaunchDate] [datetime] NULL,
	[Company] [tinyint] NULL,
	[CustNumber] [int] NULL,
	[CustBranch] [int] NULL,
	[CustName] [nvarchar](255) NULL,
	[CustCorpId] [int] NULL,
	[CustCorpAccName] [nvarchar](255) NULL,
	[GroupId] [int] NULL,
	[GroupDesc] [nvarchar](255) NULL,
	[BidPartId] [int] NULL,
	[CustomerPartNumber] [nvarchar](50) NULL,
	[PartDescription] [nvarchar](300) NULL,
	[Manufacturer] [nvarchar](50) NULL,
	[ManufacturerPartNumber] [nvarchar](50) NULL,
	[CrossPartId] [int] NULL,
	[CrossPartNumber] [nvarchar](50) NULL,
	[CrossPoolNumber] [int] NULL,
	[CrossPartDescription] [nvarchar](100) NULL,
	[PriceToQuote] [numeric](9, 2) NULL,
	[CrossPartInventoryId] [int] NULL,
	[Location] [nvarchar](50) NULL,
	[CustPartUOM] [nvarchar](50) NULL,
	[EstimatedAnnualUsage] [int] NULL,
	[NewPool] [int] NULL,
	[NewPartNo] [nvarchar](50) NULL,
	[NewPrice] [numeric](9, 2) NULL,
	[IsActive] [nvarchar](10) NULL,
	[IType] [varchar](3) NULL,
	[NewIType] [varchar](3) NULL,
	[UpdatedBy] [varchar](100) NULL,
	[UpdatedOn] [datetime] NULL,
	[CrossPartLineReviewId] [int] NULL,
	[DCSafetyStock] [int] NULL,
	[NPPartType] [varchar](10) NULL,
	[NewNPPartType] [varchar](3) NULL,
	[CategoryManagerID] [varchar](100) NULL,
	[CategoryManagerName] [varchar](100) NULL,
	[IsApproved] [bit] NULL,
	[CrossSupersedeNote] [varchar](100) NULL,
	[NewSupersedeNote] [varchar](100) NULL,
 CONSTRAINT [PK_BidStatusReport] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

