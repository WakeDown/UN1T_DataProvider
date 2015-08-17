CREATE PROCEDURE [dbo].[check_is_work_day]
	@date date
AS
begin set nocount on;
	if exists(select 1 from work_days wd where wd.date=@date)
	begin select 1 as result end
	else begin
	select 0 as result
	end
end
