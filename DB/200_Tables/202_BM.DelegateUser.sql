USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [BM].[DelegateUser] (
	 [DelegateUserId] [varchar](100) NOT NULL
	,[PrincipalUserId] [varchar](100) NOT NULL
	,[UserRole] [varchar](100) NOT NULL
	,[EmailAddress] [varchar](500) NULL
	) ON [PRIMARY]
GO

use [FPCAPPS]
ALTER TABLE [FPCAPPS].[BM].[DelegateUser] ADD CONSTRAINT PK_DelegateUser_DelegateUserId PRIMARY KEY CLUSTERED (DelegateUserId);

