
create procedure LoadProductManagersForClaim
(
	@idClaim int,
	@version int = 1,
	@selIds nvarchar(max) = null,
	@getActualize bit = null
)
as

if (@selIds is not null and len(@selIds) > 0)
begin
select distinct ProductManager from ClaimPosition where Deleted = 0 and IdClaim = @idClaim and Version=@version and Id in (select value from Split(@selIds, ',')) 
and (@getActualize is null or @getActualize =0 or (@getActualize is not null and @getActualize = 1 and PositionState = 6))
end
else
begin
select distinct ProductManager from ClaimPosition where Deleted = 0 and IdClaim = @idClaim and Version=@version
and (@getActualize is null or @getActualize =0 or (@getActualize is not null and @getActualize = 1 and PositionState = 6))
end