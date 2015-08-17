CREATE PROCEDURE LoadProviderCategories
(
	@provider int
)
AS 
SELECT * FROM ProviderCategory WHERE Provider = @provider;
