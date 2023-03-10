USE [master]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER procedure [dbo].[generate_codes]
as begin
	
	declare @charset nvarchar(25)
	declare @codeCount INT
	set @charset = 'ACDEFGHKLMNPRTXYZ234579'
	set @codeCount = 0
	CREATE TABLE #codes (code nvarchar(8))

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
		Exec dbo.check_code @randomCode, @valid output 
		
		
		if @valid = 1
			INSERT INTO #codes (code) VALUES (@randomCode)
			set @codeCount = (SELECT COUNT(code) from #codes)
	end 
	select * from #codes
	END;
	GO
CREATE OR ALTER procedure [dbo].[check_code]
	@Code nvarchar(8),
	@IsValid int out as begin
	declare @isUnique INT
		set @isUnique = (select COUNT(code) from #codes where code = @Code)
		if LEN(@Code) = 8 AND @isUnique = 0
		set @IsValid = 1
		else set @IsValid = 0
		return @IsValid

END;