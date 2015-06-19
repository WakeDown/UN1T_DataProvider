
CREATE procedure ExistsClaimPosition
(
	@idClaim int,
	@rowNumber int = -1,
	@catalogNumber nvarchar(500) = '',
	@name nvarchar(1000),
	@replaceValue nvarchar(1000) = '',
	@unit nvarchar(10),
	@value int,
	@productManager nvarchar(500),
	@comment nvarchar(1500),
	@price decimal(18,2) = -1,
	@sumMax decimal(18,2) = -1,
	@positionState int,
  @currency int,
	@priceTzr decimal(18,2) = -1,
	@sumTzr decimal(18,2) = -1,
	@priceNds decimal(18,2) = -1,
	@sumNds decimal(18,2) = -1
)
as
declare @result int;
declare @count int;
set @result = 0;
set @count = (select count(*) from ClaimPosition where Deleted = 0 and IdClaim = @idClaim and RowNumber = @rowNumber and CatalogNumber = @catalogNumber
	and Name = @name and ReplaceValue = @replaceValue and Unit = @unit and Value = @value and ProductManager = @productManager and
	Comment = @comment and Price = @price and SumMax = @sumMax and PositionState = @positionState and Currency = @currency
  and PriceTzr = @priceTzr and SumTzr = @sumTzr and PriceNds = @priceNds and SumNds = @sumNds);
if @count > 0
begin
	set @result = 1;
end
select @result;
