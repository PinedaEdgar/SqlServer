CREATE FUNCTION dbo.[RmvNonNumeric]
(@inputData varchar(500)) 
returns varchar(500)
AS

	begin

	  declare @returnData varchar(500)
	  declare @i int
	  declare @len int
	  declare @letter_val int
	  declare @letter char(1)

	  -- Initialize variables
	  set @inputData = rtrim(ltrim(@inputData))
	  set @len = len(rtrim(ltrim(@inputData)))
	  set @returnData = ''
	  
	  -- Strip numeric characters
	  if @len <> 0
	  begin
		set @i = 1
	  
		while @i <= @len 
		begin
		  set @letter_val = ascii(substring(@inputData,@i,1))
	   --   if (@letter_val >= 43) and (@letter_val <= 57)  -- I need the following ( [0-9], ".", "+" )
		  if (@letter_val >= 48) and (@letter_val <= 57)  -- I need the following ( [0-9] )
			 set @returnData = rtrim(@returnData) + substring(@inputData,@i,1)
		  set @i = @i + 1
		end
	  end

set @returnData = REPLACE( REPLACE(@returnData,'/', ''), '%', '')
return @returnData
end
GO