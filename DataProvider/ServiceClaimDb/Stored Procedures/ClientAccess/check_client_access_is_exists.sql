CREATE PROCEDURE [dbo].[check_client_access_is_exists]
	@id_client_etalon int
AS
	begin set nocount on;

	if exists(select 1 from client_access where enabled=1 and id_client_etalon=@id_client_etalon)
	begin

	select 1 as result
	end
	else
	begin
	select 0 as result
	end
	end
