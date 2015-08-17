CREATE PROCEDURE [dbo].[get_next_work_day]
	@date date
AS
begin
set nocount on;
	select top 1 [date] from work_days wd
	where wd.date > @date

end
