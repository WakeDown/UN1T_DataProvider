CREATE PROCEDURE [dbo].[get_position]
	@id int = null
AS
begin
SET NOCOUNT ON;
	select id, name,
	name_rod,
	(
	select count(1) from employees_view e  where e.id_position=p.id
	) as emp_count
	,name_dat
	 from positions p
	where p.enabled=1
	AND ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND p.id = @id
                         )
                    )
					order by name
end