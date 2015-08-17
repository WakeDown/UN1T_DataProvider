CREATE PROCEDURE [dbo].[get_claim_state]
	@sys_name nvarchar(20) = null,
	@id int = null
	as begin set nocount on;
	select id, name ,sys_name,order_num,background_color,foreground_color
	from claim_states where enabled=1 and (@sys_name is null or @sys_name = '' or (@sys_name is not null and @sys_name != '' and sys_name= @sys_name))
	and (@id is null or @id <=0 or (@id is not null and @id >0 and id= @id))

	end
