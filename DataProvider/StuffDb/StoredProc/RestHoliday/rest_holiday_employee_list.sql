CREATE PROCEDURE [dbo].[rest_holiday_employee_list]
	@year int
AS
	begin
	set nocount on;
	select duration, t.employee_sid, e.display_name as emlpoyee_name, period_count, 
	(case when exists(select 1 from rest_holidays rh2	
	where rh2.enabled=1 and rh2.year=@year and rh2.employee_sid=t.employee_sid and rh2.confirmed = 0 and rh2.can_edit= 0) then 1 else 0 end) as has_blocked_periods
	from (
	select sum(rh.duration) as duration, employee_sid, count(1) as period_count
	from rest_holidays rh	
	where rh.enabled=1
	and year=@year and (can_edit = 0 and confirmed = 0)
	group by employee_sid
	) as t
	inner join employees e on t.employee_sid = e.ad_sid	
	order by employee_sid
	end
