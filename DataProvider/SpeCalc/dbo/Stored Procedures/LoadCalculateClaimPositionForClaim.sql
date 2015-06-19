
create procedure LoadCalculateClaimPositionForClaim
(
	@id int
)
as
select * from CalculateClaimPosition where Deleted = 0 and IdClaim = @id
