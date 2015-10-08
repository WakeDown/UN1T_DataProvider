CREATE PROCEDURE [dbo].[rest_holiday_list]
	@employee_sid varchar(46) = null,
	@year int
AS
	begin
	set nocount on;
	select rh.id, rh.start_date, rh.end_date, rh.duration, case when can_edit=1 and confirmed=0 then 1 else 0 end as can_edit,
	case when confirmed=1 then 1 else 0 end as confirmed, employee_sid, e.display_name as employee_name, rh.year
	from rest_holidays rh
	inner join employees e on rh.employee_sid = e.ad_sid
	where rh.enabled=1
	and (@employee_sid is null or @employee_sid = '' or (@employee_sid is not null and @employee_sid != '' and rh.employee_sid=@employee_sid))
	and (@year is null or @year <=0 or (@year is not null and @year > 0 and year=@year))
	order by employee_sid, year, start_date
	end
