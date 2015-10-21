CREATE PROCEDURE [dbo].[rest_holiday_years_list]
	@employee_sid varchar(46)=null,
	@top_rows int = null,
	@year int = null
AS
begin
set nocount on;
if @top_rows is null
begin
set @top_rows = 10000
end

select top (@top_rows) [year], sum(duration) as days_count
from
(
	select rh.[year], rh.duration from rest_holidays rh
	where rh.enabled=1 and
	(@employee_sid is null or @employee_sid = '' or (@employee_sid is not null and @employee_sid!= '' and rh.employee_sid=@employee_sid))
	and (@year is null or @year <=0 or (@year is not null and @year > 0 and rh.year = @year))
	union  all
	select year(getdate()) as [year], 0 as duration
	union  all
	select year(DATEADD(year, 1, getdate())) as [year], 0 as duration) as t
	where t.[year] > 2015 and (@year is null or @year <=0 or (@year is not null and @year > 0 and t.year = @year))
	group by [year]
	order by [year]
end
