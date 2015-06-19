CREATE PROCEDURE [dbo].[get_organization]
	@id int =null
AS
begin
SET NOCOUNT ON;
	select id, name,
	(
	select count(1) from employees e INNER JOIN employee_states es ON e.id_emp_state = es.id where e.enabled=1 and es.sys_name IN ( 'STUFF', 'DECREE' ) and e.id_organization=o.id
	) as emp_count
	from organizations o
	where o.enabled=1
	AND ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND o.id = @id
                         )
                    )
					order by name
end
