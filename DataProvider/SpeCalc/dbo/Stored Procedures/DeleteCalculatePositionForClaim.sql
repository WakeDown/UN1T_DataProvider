
create procedure DeleteCalculatePositionForClaim
(
	@id int
)
as
delete from CalculateClaimPosition where IdClaim = @id
