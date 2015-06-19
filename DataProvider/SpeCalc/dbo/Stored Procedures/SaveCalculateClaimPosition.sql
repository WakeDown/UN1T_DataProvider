
CREATE procedure [dbo].[SaveCalculateClaimPosition]
(
	@idPosition int,
	@idClaim int,
	@catalogNumber nvarchar(500) = '',
	@name nvarchar(1000) = '',
	@replaceValue nvarchar(1000) = '',
	@priceCurrency decimal(18,2) = -1,
	@sumCurrency decimal(18,2) = -1,
	@priceRub decimal(18,2) = -1,
	@sumRub decimal(18,2) = -1,
	@provider nvarchar(150) = '',
	@protectFact int = null,
	@protectCondition nvarchar(500) = '',
	@comment nvarchar(1500) = '',
	@author nvarchar(150),
  @currency int = NULL,
  @priceUsd decimal(18,2) = NULL,
  @priceEur decimal(18,2) = NULL,
  @priceEurRicoh decimal(18,2) = NULL,
  @priceRubl decimal(18,2) = NULL,
  @deliveryTime int = null
)
as
declare @id int;
insert into CalculateClaimPosition values(@idPosition, @idClaim, @catalogNumber, @name, @replaceValue, @priceCurrency, @sumCurrency,
		@priceRub, @sumRub, @provider, @protectFact, @protectCondition, @comment, @author, 0, null, null, NULL, @priceUsd, @priceEur, @priceEurRicoh, @priceRubl, @deliveryTime)
set @id = @@IDENTITY;
select @id;
