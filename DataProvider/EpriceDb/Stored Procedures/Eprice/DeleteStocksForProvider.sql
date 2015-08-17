CREATE PROCEDURE DeleteStocksForProvider
(
	@provider int
)
AS
DELETE FROM Stock WHERE Provider = @provider
