CREATE PROCEDURE [dbo].[rest_holiday_check_period_cross]
	@employee_sid varchar(46),
	@start_date date,
	@end_date date
	as begin
	set nocount on;
	
	if exists(select 1 from rest_holidays rh where rh.enabled=1 and rh.employee_sid=@employee_sid and (@start_date between convert(date,rh.start_date) and convert(date, rh.end_date) 
	or @end_date between convert(date,rh.start_date) and convert(date,rh.end_date)))
	begin
		--Попадает в другой период
		select 1 as result
	end
	else
	begin
	--НЕ попадает в другой период
		select 0 as result
	end
	end
