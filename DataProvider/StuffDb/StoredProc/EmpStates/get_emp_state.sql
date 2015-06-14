CREATE PROCEDURE [dbo].[get_emp_state]
	@id int = null,
	--@get_all bit = 0,
	@sys_name nvarchar(20) = null
AS
begin
SET NOCOUNT ON;
	select id, name from employee_states es
	where es.enabled=1
	--and (@get_all=1 or (@get_all=0 and es.display_in_list = 1))
	and ((@sys_name is null or ltrim(rtrim(@sys_name)) = '') or (@sys_name is not null and rtrim(ltrim(@sys_name))<>'' and sys_name=@sys_name))
	AND ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND es.id = @id
                         )
                    )
end
