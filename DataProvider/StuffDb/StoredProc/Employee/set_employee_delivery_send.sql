CREATE PROCEDURE [dbo].[set_employee_delivery_send]
	@id int
	as begin set nocount on;
	update employees
	set newvbie_delivery=1
	where id=@id
	end
