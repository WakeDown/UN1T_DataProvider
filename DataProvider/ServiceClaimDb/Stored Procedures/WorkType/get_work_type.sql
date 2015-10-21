CREATE PROCEDURE [dbo].[get_work_type]
	@id int = null,
	@sys_name nvarchar(20) = null
AS
	begin set nocount on;

	select id, id_parent, name, sys_name, zip_install, zip_order
	from work_types
	where (@id is null or @id <= 0 or (@id is not null and @id > 0 and id=@id)) and (@sys_name is null or @sys_name = '' or (@sys_name is not null and @sys_name != '' and enabled=1 and sys_name=@sys_name)) 

	end
