CREATE PROCEDURE [dbo].[get_city]
	@id int = null,
	@sys_name nvarchar(50) = null	
AS
begin
SET NOCOUNT ON;
	select id, name,
	(
	select count(1) from employees_view e  where e.id_city=c.id
	) as emp_count
	 from cities c
	where c.enabled=1
	AND ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND c.id = @id
                         )
                    )
AND ( @sys_name IS NULL or @sys_name = ''
                      OR ( @sys_name IS NOT NULL
                           AND @sys_name != ''
                           AND c.sys_name = @sys_name
                         )
                    )
					order by name
end
