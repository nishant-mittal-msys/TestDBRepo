USE [FPCAPPS]
GO
/****** Object:  UserDefinedFunction [sicf].[udf_RemoveSpecialCharacters]    Script Date: 8/13/2019 2:33:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER Function dbo.IsNullOrZero(@val1 NUMERIC(20,2) null, @val2 NUMERIC(20,2) null)
Returns NUMERIC(20,2)
AS
Begin
    return case when isnull(@val1, 0) <> 0 then @val1 else isnull(@val2, 0) end;
End
