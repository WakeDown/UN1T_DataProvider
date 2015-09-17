CREATE PROCEDURE [dbo].[get_client_access]
	@id int = null
AS
	begin
	set nocount on;

	select id, login,ad_sid,id_client_etalon, name, full_name, password, case when zip_access=1 then 1 else 0 end as zip_access, case when counter_access=1 then 1 else 0 end as counter_access, ad_sid, name
	from client_access
	where enabled=1 and (@id is null or @id <= 0 or (@id is not null and @id > 0 and id=@id))
	end
