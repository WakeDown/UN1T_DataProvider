CREATE PROCEDURE [dbo].[get_vendor]
	@id int = null
AS
	begin set nocount on;
	select id, name, descr, creator_sid from vendors
	where enabled=1 and (@id is null or @id <= 0 or (@id is not null and @id > 0 and id=@id))

	end
