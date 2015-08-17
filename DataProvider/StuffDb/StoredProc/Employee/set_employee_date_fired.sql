CREATE PROCEDURE [dbo].[set_employee_date_fired]
	@id_employee int,
	@date_fired date
	as begin set nocount on;
	update employees
	set date_fired=@date_fired
	where id=@id_employee
	end
