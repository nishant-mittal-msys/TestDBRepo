USE [FPCAPPS]
GO

--drop table  BM.InvestmentThresholds

CREATE TABLE BM.InvestmentThresholds (
	Minimum decimal NOT NULL
	,Maximum decimal NOT NULL
	,Role varchar(100) NOT NULL
	)

	truncate table BM.InvestmentThresholds
	insert into BM.InvestmentThresholds values (0.0, 5000.0, 'CategoryManager')
	insert into BM.InvestmentThresholds values (5001.0, 2147483647.0, 'CategoryVP')