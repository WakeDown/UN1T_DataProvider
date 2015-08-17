CREATE PROCEDURE [dbo].[save_catalog_category]
@sid bigint = null,
	@id nvarchar(50),
	@id_parent nvarchar(50) = '',
	@name nvarchar(500),
	@id_provider int
AS
BEGIN 
SET NOCOUNT ON;
IF not EXISTS(SELECT 1 FROM catalog_categories c where c.enabled=1 and c.id=@id and c.id_provider=@id_provider)
begin
	insert into catalog_categories (id_provider, id, id_parent, name)
	values (@id_provider, @id, @id_parent, @name)
	set  @sid = @@IDENTITY
end
else
begin
	SELECT @sid = c.sid FROM catalog_categories c where c.enabled=1 and c.id=@id and c.id_provider=@id_provider
end

select @sid as sid
end
