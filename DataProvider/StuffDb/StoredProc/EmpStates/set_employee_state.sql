CREATE PROCEDURE [dbo].[set_employee_state]
	@id_employee int,
	@id_emp_state int
AS
begin
set nocount on;
update employees
set id_emp_state= @id_emp_state
where id = @id_employee

end
