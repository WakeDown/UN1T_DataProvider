CREATE PROCEDURE [dbo].[get_budget_list]
AS
begin
set nocount on;
	select b.id, b.name, b.descr, b.creator_sid, (select count (1) from employees_view e where e.id_budget=b.id) as emp_count, b.id_parent
	from budget b
	where b.enabled=1
	order by b.name
end