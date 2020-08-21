USE [FPCAPPS]
GO

ALTER TABLE BM.CrossPartLineReview
ADD 
	LastUpdatedBy varchar(100) Null,
	LastUpdatedOn datetime null,

AlreadyStockingLocation int null ,
Estimated3MonthUsageWithoutSalesPack int null,
Estimated3MonthUsageWithSalesPack int null,
AlreadyStockingLocations int null,
NewPartNumber varchar(100) NUll,
NewPool int NUll,
L12Revenue decimal(38, 5) NULL,
RevisedPool int NULL,
RevisedPartNumber varchar(100) NULL