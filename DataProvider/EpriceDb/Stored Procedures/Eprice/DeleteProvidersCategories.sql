CREATE PROCEDURE DeleteProvidersCategories
(
	@provider int
)
AS 
DELETE FROM ProviderCategory WHERE Provider = @provider
