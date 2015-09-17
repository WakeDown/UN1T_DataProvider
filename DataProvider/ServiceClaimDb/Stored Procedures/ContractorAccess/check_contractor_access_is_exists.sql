CREATE PROCEDURE [dbo].[check_contractor_access_is_exists]
	@login nvarchar(50)
AS
	begin set nocount on;

	if exists(select 1 from contractor_access where enabled=1 and login=@login)
	begin

	select 1 as result
	end
	else
	begin
	select 0 as result
	end
	end
