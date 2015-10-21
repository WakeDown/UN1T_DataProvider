CREATE PROCEDURE [dbo].[get_work_type_list]
	
AS
	begin
	set nocount on;
	select id, id_parent, name, sys_name, zip_install, zip_order
	from work_types
	where enabled=1
	order by order_num

	end
