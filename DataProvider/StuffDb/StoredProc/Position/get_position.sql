CREATE PROCEDURE [dbo].[get_position]
	@id int = null
AS
begin
SET NOCOUNT ON;
	select id, name,
	
	(
	select count(1) from employees e INNER JOIN employee_states es ON e.id_emp_state = es.id where e.enabled=1 and es.sys_name IN ( 'STUFF', 'DECREE' ) and e.id_position=p.id
	) as emp_count from positions p
	where p.enabled=1
	AND ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND p.id = @id
                         )
                    )
					order by name
end