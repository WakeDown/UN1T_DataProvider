
CREATE procedure [dbo].[UpdateClaimPosition]
(
	@id int,
	@rowNumber int = -1,
	@catalogNumber nvarchar(500) = '',
	@name nvarchar(max),
	@replaceValue nvarchar(1000) = '',
	@unit nvarchar(10),
	@value int,
	@productManager nvarchar(500),
	@comment nvarchar(1500) = '',
	@price decimal(18,2) = -1,
	@sumMax decimal(18,2) = -1,
	@positionState int,
	@author nvarchar(150),
  @currency int,
	@priceTzr decimal(18,2) = -1,
	@sumTzr decimal(18,2) = -1,
	@priceNds decimal(18,2) = -1,
	@sumNds decimal(18,2) = -1
)
as
update ClaimPosition set RowNumber = @rowNumber, CatalogNumber = @catalogNumber, Name = @name, 
	ReplaceValue = @replaceValue, Unit = @unit, Value = @value, ProductManager = @productManager, 
	Comment = @comment, Price = @price, SumMax = @sumMax, PositionState = @positionState, Author = @author,
	--Currency = @currency,
	 PriceTzr = @priceTzr, SumTzr = @sumTzr, PriceNds = @priceNds, SumNds = @sumNds where Id = @id
