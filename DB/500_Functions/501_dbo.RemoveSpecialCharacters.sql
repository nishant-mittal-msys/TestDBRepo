USE [FPCAPPS]
GO
/****** Object:  UserDefinedFunction [sicf].[udf_RemoveSpecialCharacters]    Script Date: 8/13/2019 2:33:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER Function dbo.[RemoveSpecialCharacters](@PartNo VarChar(100))
Returns VarChar(100)
AS
Begin

    Declare @CleanPartNumber as varchar(100)
    Set @CleanPartNumber = '%[^a-z0-9]%'
    While PatIndex(@CleanPartNumber, @PartNo) > 0
        Set @PartNo = Stuff(@PartNo, PatIndex(@CleanPartNumber, @Partno), 1, '')

    Return @PartNo
End
