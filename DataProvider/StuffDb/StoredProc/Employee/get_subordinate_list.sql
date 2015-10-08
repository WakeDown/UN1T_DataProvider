CREATE PROCEDURE [dbo].[get_subordinate_list]
	@sid varchar(46)
AS
	begin

	set nocount on;
	declare @id_department int
	select @id_department = id_department from employees_view e where e.ad_sid = @sid and e.is_chief = 1

	if @id_department is not null and @id_department > 0
	begin
with deps as (
   select id, id_parent
   from dbo.departments
   where id = @id_department
   union all
   select c.id, c.id_parent
   from departments c
     join deps p on p.id = c.id_parent 
)

SELECT * FROM dbo.employees_view e
WHERE e.ad_sid <> @sid and e.id_department IN (SELECT id FROM deps)
end

	end
