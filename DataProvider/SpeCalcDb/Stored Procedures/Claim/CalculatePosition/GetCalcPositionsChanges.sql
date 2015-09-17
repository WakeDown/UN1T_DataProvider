CREATE PROCEDURE [dbo].[GetCalcPositionsChanges]
	@idCalcPosition int
	as begin
	set nocount on;

 

if exists(select 1 from dbo.CalculateClaimPosition cp where cp.Id = @idCalcPosition and IdCalcPosParent is not null)
begin
SELECT 0 as IsNewCalcPosition
, CASE WHEN cp.CatalogNumber != parent.CatalogNumber THEN 1 ELSE 0 END AS CatalogNumberChange
, CASE WHEN cp.Name != parent.Name THEN 1 ELSE 0 END AS NameChange
, CASE WHEN cp.Provider != parent.Provider THEN 1 ELSE 0 END AS ProviderChange
, CASE WHEN cp.ProtectFact != parent.ProtectFact THEN 1 ELSE 0 END AS ProtectFactChange
, CASE WHEN cp.ProtectCondition != parent.ProtectCondition THEN 1 ELSE 0 END AS ProtectConditionChange
, CASE WHEN cp.Comment != parent.Comment THEN 1 ELSE 0 END AS CommentChange
, CASE WHEN cp.PriceUsd != parent.PriceUsd THEN 1 ELSE 0 END AS PriceUsdChange
, CASE WHEN cp.PriceEur != parent.PriceEur THEN 1 ELSE 0 END AS PriceEurChange
, CASE WHEN cp.PriceEurRicoh != parent.PriceEurRicoh THEN 1 ELSE 0 END AS PriceEurRicohChange
, CASE WHEN cp.PriceRubl != parent.PriceRubl THEN 1 ELSE 0 END AS PriceRublChange
, CASE WHEN cp.DeliveryTime != parent.DeliveryTime THEN 1 ELSE 0 END AS DeliveryTimeChange
FROM dbo.CalculateClaimPosition cp INNER JOIN dbo.CalculateClaimPosition parent ON cp.IdCalcPosParent=parent.id
WHERE 
cp.Id = @idCalcPosition
end
else
begin
	select 1 as IsNewCalcPosition
end
	end