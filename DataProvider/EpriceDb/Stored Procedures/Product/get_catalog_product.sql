CREATE PROCEDURE [dbo].[get_catalog_product]
	@part_num NVARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

   SELECT TOP 1 p.price, p.id_currency,p.currency_str, pr.name FROM dbo.catalog_products p
   INNER JOIN dbo.catalog_categories c ON p.sid_cat=c.sid
   INNER JOIN dbo.product_providers pr ON c.id_provider=pr.id
   
   WHERE p.enabled=1 and p.price > 0 AND LOWER(RTRIM(LTRIM(p.part_number))) = LOWER(RTRIM(LTRIM(@part_num)))
   ORDER BY price
END

