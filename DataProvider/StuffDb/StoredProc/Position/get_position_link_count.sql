CREATE Procedure [dbo].[get_position_link_count]
(
	@id int
)
AS
BEGIN
	select count(1) from employees_view e INNER JOIN employee_states es ON e.id_emp_state = es.id where e.id_position=@id
END
