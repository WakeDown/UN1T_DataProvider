
CREATE procedure [dbo].[SaveClaimPosition]
(
	@idClaim int,
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
declare @id int;
insert into ClaimPosition values(@idClaim, @rowNumber, @catalogNumber, @name, @replaceValue, @unit,
	@value, @productManager, @comment, @price, @sumMax, @positionState, @author, 0, null, null, @currency,
	@priceTzr, @sumTzr, @priceNds, @sumNds)
set @id = @@IDENTITY;
select @id;
