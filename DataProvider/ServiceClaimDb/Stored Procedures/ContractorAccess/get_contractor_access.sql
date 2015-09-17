CREATE PROCEDURE [dbo].[get_contractor_access]
	@id int = null
AS
	begin
	set nocount on;

	select id, login,ad_sid, name, password, name, org_name ,city, org_sid, email
	from contractor_access
	where enabled=1 and (@id is null or @id <= 0 or (@id is not null and @id > 0 and id=@id))
	end
