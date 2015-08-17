CREATE PROCEDURE [dbo].[save_catalog_product]
@sid bigint = null,
	@id nvarchar(50),
	@sid_cat bigint,
	@name nvarchar(MAX),
	@price decimal(10, 2),
	@id_currency int,
	@part_number nvarchar(50),
	@vendor nvarchar(500) = null,
	@currency_str nvarchar(20) = null
AS
BEGIN 
SET NOCOUNT ON;
IF not EXISTS(SELECT 1 FROM catalog_products p where p.enabled=1 and p.id=@id and p.sid_cat=@sid_cat)
begin
	insert into catalog_products (sid_cat,name, price, id_currency, part_number, id, vendor, currency_str)
	values (@sid_cat, @name, @price, @id_currency, @part_number, @id, @vendor, @currency_str)
	set  @sid = @@IDENTITY
end
else
begin
	if not exists(SELECT 1 FROM catalog_products p where p.enabled=1 and p.id=@id and p.sid_cat=@sid_cat and p.price=@price and p.id_currency = @id_currency)
	begin
		update catalog_products
		set price=@price, id_currency = @id_currency, part_number=@part_number, currency_str=@currency_str
		where enabled=1 and id=@id and sid_cat=@sid_cat
		select @sid = sid from catalog_products where enabled=1 and id=@id and sid_cat=@sid_cat
	end
end

select @sid as sid
end
