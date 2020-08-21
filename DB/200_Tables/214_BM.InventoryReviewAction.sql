USE [FPCAPPS]
GO

--drop table fpcapps.BM.InventoryReviewAction

CREATE TABLE BM.InventoryReviewAction (
	Id INT PRIMARY KEY IDENTITY
	,BidId INT NOT NULL
	,UserId NVARCHAR(100) NULL
	,UserRole NVARCHAR(100) NULL
	,ActionStatus BIT NULL
	,ActionTakenOn DATETIME NULL
	)
