USE [FPCAPPS]
GO

/****** Object:  UserDefinedFunction [sicf].[udf_RemoveSpecialCharacters]    Script Date: 8/13/2019 2:33:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER FUNCTION BM.SmartMatch(@val1 varchar(100), @val2 varchar(100))
RETURNS bit
AS
BEGIN
	set @val1 = rtrim(ltrim(@val1))
	set @val2 = rtrim(ltrim(@val2))

	if isnull(@val1, '') = '' OR isnull(@val2, '') = '' OR rtrim(substring(@val1, 1, 5)) = ''
		return 0

	if charindex(rtrim(substring(@val1, 1, 5)), @val2) > 0 --OR charindex(rtrim(substring(@val2, 1, 5)), @val1) > 0
		return 1
	
		return 0
END
