CREATE PROCEDURE [dbo].[save_classifier_attributes]
	@wage decimal(10,2),
	@overhead decimal(10,2)
AS
begin
set nocount on;

declare @wage_str nvarchar(50), @overhead_str nvarchar(50)

set @wage_str = convert(nvarchar(50), @wage)
set @overhead_str = convert(nvarchar(50), @overhead)

update attributes
set value = @wage_str
where sys_name = 'CLSFRWAGE'

update attributes
set value = @overhead_str
where sys_name = 'CLSFROVERHEAD'

update c
set c.cost_people = c.price + @wage, c.cost_company=c.price+@overhead
from classifier c	

end
