CREATE PROCEDURE [dbo].[check_employee_is_chief]
	@id_employee int,
	@id_department int
AS
begin
set nocount on;
	select (case when exists(select 1 from departments d where d.id = @id_department and d.id_chief = @id_employee) then 1 else 0 end) as result
end
