CREATE PROCEDURE LoadStocksForProducts
(
	@categoryId int
)
AS
SELECT * FROM Stock WHERE IdProduct IN (SELECT Id FROM Product WHERE IdCategory = @categoryId)
