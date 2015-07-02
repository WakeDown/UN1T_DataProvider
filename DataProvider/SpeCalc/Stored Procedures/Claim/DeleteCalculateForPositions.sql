
create procedure DeleteCalculateForPositions
(
    @idClaim int,
	@ids nvarchar(max)
)
as
delete from CalculateClaimPosition where IdClaim = @idClaim and IdPosition in(select * from dbo.Split(@ids,','));
