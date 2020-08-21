USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [BM].[ErrorLogging](
	[ErrorLoggingId] bigint IDENTITY(1,1) NOT NULL,
	[ErrorDateTime] nvarchar(100) NULL,
	[ErrorMessage] nvarchar(2000) NULL,
	[ErrorStackTrace] nvarchar(max) NULL,
	[DeployedEnvironment] nvarchar(10) NULL,
	[UserId] nvarchar(100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


