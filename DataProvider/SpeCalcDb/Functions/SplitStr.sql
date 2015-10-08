create function [dbo].[SplitStr]
(
    @value varchar(max),
    @delimiter nvarchar(10)
)
returns @SplittedValues table
(
    value nvarchar(max)
)
as
begin
    declare @SplitLength int
    
    while len(@value) > 0
    begin 
        select @SplitLength = (case charindex(@delimiter,@value) when 0 then
            len(@value) else charindex(@delimiter,@value) -1 end)
 
        insert into @SplittedValues
        select cast(substring(@value,1,@SplitLength) as nvarchar(max))
    
        select @value = (case (len(@value) - @SplitLength) when 0 then  ''
            else right(@value, len(@value) - @SplitLength - 1) end)
    end 
return  
end
