USE FPCAPPS
GO

ALTER TABLE BM.VendorGrade
   ADD VendorGradeId INT IDENTITY
       CONSTRAINT PK_VendorGrade PRIMARY KEY CLUSTERED

ALTER TABLE BM.VendorGrade
ADD 
LastModifiedBy NVARCHAR(50) NULL

ALTER TABLE BM.VendorGrade
ADD 
LastModifiedOn DATETIME NULL

UPDATE BM.VendorGrade SET LastModifiedBy = 'pure-nmittal'

UPDATE BM.VendorGrade SET LastModifiedOn = '2020-02-25 00:00:00.000'