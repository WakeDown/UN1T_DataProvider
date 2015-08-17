CREATE PROCEDURE LoadProductsForCategory
(
	@idCategory int
)
AS
SELECT * FROM Product WHERE IdCategory = @idCategory
