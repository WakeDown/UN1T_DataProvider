CREATE PROCEDURE [dbo].[get_email]
	@full_name nvarchar(150)
	as begin set nocount on;
	select email from employees_view e where e.full_name = @full_name

	end;