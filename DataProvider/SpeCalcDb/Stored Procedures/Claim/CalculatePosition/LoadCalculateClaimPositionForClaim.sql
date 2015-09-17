
create procedure LoadCalculateClaimPositionForClaim
(
	@id int
	,@version int
)
as
select cp.[Id]         ,
    [IdPosition]    ,
    cp.[IdClaim]     ,
    cp.[CatalogNumber] ,
    cp.[Name]         ,
    cp.[ReplaceValue]  ,
    [PriceCurrency]  ,
    [SumCurrency]   ,
    [PriceRub]     ,
    [SumRub]      ,
    [Provider]    ,
    [ProtectFact] ,
    [ProtectCondition] ,
    cp.[Comment]  ,
    cp.[Author]  ,
    cp.[Deleted]  ,
    cp.[DeletedUser] ,
    cp.[DeleteDate]  ,
    cp.[Currency]   ,
    [PriceUsd]  ,
    [PriceEur]  ,
    [PriceEurRicoh]  ,
    [PriceRubl]   ,
    [DeliveryTime] ,
	cp.Version
from CalculateClaimPosition cp
inner join ClaimPosition p on cp.IdPosition=p.Id
where cp.Deleted = 0 and cp.IdClaim = @id 
and p.Version=@version
--and Version=@calcVersion
