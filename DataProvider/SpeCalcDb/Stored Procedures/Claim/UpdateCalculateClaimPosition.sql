
CREATE procedure [dbo].[UpdateCalculateClaimPosition]
(
	@id int,
	@catalogNumber nvarchar(500)='',
	@name nvarchar(1000)='',
	@replaceValue nvarchar(1000) = '',
	@priceCurrency decimal(18,2) = -1,
	@sumCurrency decimal(18,2) = -1,
	@priceRub decimal(18,2) = -1,
	@sumRub decimal(18,2)=-1,
	@provider nvarchar(150) = '',
	@protectFact INT=NULL,
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
Update CalculateClaimPosition set CatalogNumber = @catalogNumber, Name = @name, ReplaceValue = @replaceValue, 
	PriceCurrency = @priceCurrency, SumCurrency = @sumCurrency, PriceRub = @priceRub, SumRub = @sumRub, Provider = @provider, 
	ProtectFact = @protectFact, ProtectCondition = @protectCondition, Comment = @comment, 
	--Author = @author, 
	Currency = @currency,
	PriceUsd = @priceUsd, PriceEur=@priceEur, PriceEurRicoh=@priceEurRicoh, PriceRubl=@priceRubl,DeliveryTime=@deliveryTime,
	LastModifer = @author
	where Id = @id
