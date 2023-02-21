
USE [master]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER procedure [dbo].[check_code]
@Code nvarchar(8),
@Codes nvarchar(max),
@IsValid int out as begin
declare @found INT

set @found = (SELECT count(value) FROM string_split(@Codes, ',') where RTRIM(value) <> '' AND value = @Code)
if LEN(@Code) = 8 AND @found = 0
set @IsValid = 1
else set @IsValid = 0
return @IsValid
END
GO
CREATE OR ALTER procedure [dbo].[generate_codes]
as begin

declare @charset nvarchar(25)
declare @codeCount INT
set @charset = 'ACDEFGHKLMNPRTXYZ234579'
set @codeCount = 0
DECLARE @codes NVARCHAR(MAX)
set @codes = ''
while (@codeCount < 1000)
begin
declare @randomCode nvarchar(8)
declare @i int
set @i = 0
set @randomCode = ''
while (@i < 8)
begin
declare @randIndex int
set @randIndex = CAST(RAND() * (LEN(@charset) - 1) AS INT)
set @randomCode = @randomCode + SUBSTRING(@charset, @randIndex, 1)
set @i = @i + 1
end
declare @valid INT
Exec dbo.check_code @randomCode, @codes, @valid output


if @valid = 1
set @codes += @randomCode + ','
set @codeCount = (SELECT count(value) FROM string_split(@codes, ',') WHERE RTRIM(value) <> '')
print @codes

end
select value as code FROM string_split(TRIM(@codes), ',') WHERE RTRIM(value) <> ''
END;
