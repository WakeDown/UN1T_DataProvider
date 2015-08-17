CREATE PROCEDURE [dbo].[get_holiday_work_delivery_recipient_list]
AS
	begin

	set nocount on;
		select email from employees_view e where dep_sys_name = 'PERSDEP' and pos_sys_name in ('PERSDIRECTOR', 'PERSMGR')
	end


