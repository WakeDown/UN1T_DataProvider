﻿CREATE PROCEDURE [dbo].[rest_holiday_list]
	@employee_sid varchar(46) = null,
	@year int
AS
	begin
	set nocount on;

	select rh.id, rh.start_date, rh.end_date, rh.duration, case when can_edit=1 then 1 else 0 end as can_edit,case when confirmed=1 then 1 else 0 end as confirmed, employee_sid, e.display_name as employee_name
	from rest_holidays rh
	inner join employees e on rh.employee_sid = e.ad_sid
	where rh.enabled=1
	order by employee_sid, start_date
	

	end
