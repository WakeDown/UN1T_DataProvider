
create procedure LoadCalculateClaimPositionForClaim
(
	@id int
)
as
select [Id]         ,
    [IdPosition]    ,
    [IdClaim]     ,
    [CatalogNumber] ,
    [Name]         ,
    [ReplaceValue]  ,
    [PriceCurrency]  ,
    [SumCurrency]   ,
    [PriceRub]     ,
    [SumRub]      ,
    [Provider]    ,
    [ProtectFact] ,
    [ProtectCondition] ,
    [Comment]  ,
    [Author]  ,
    [Deleted]  ,
    [DeletedUser] ,
    [DeleteDate]  ,
    [Currency]   ,
    [PriceUsd]  ,
    [PriceEur]  ,
    [PriceEurRicoh]  ,
    [PriceRubl]   ,
    [DeliveryTime]  
from CalculateClaimPosition where Deleted = 0 and IdClaim = @id
