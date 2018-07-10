if exists (select * from dbo.sysobjects where id = object_id(N'[SRTINVALF]') and xtype in (N'FN', N'IF', N'TF'))
drop function [SRTINVALF]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE FUNCTION SRTINVALF
(@inputData varchar(8000)) 
returns varchar(8000)
AS

begin

  declare @returnData varchar(8000)
  declare @i int
  declare @len int
  declare @letter_val int
  declare @letter char(1)

  -- Initialize variables
  set @inputData = rtrim(ltrim(@inputData))
  set @len = len(rtrim(ltrim(@inputData)))
  set @returnData = ''
  
  -- Strip non-numeric characters
  if @len <> 0
  begin
    set @i = 1
  
    while @i <= @len 
    begin
      set @letter_val = ascii(substring(@inputData,@i,1))
      if (@letter_val >= 60) and (@letter_val <= 95) 
         set @returnData = rtrim(@returnData) + substring(@inputData,@i,1)
      set @i = @i + 1
    end
  end

  -- Remove leading zeros  
  set @returnData = replace(ltrim(replace(@returnData,'0',' ')),' ','0')
  
  return @returnData

end



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

