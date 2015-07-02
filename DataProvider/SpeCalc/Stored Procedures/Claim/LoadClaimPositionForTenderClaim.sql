
create procedure LoadClaimPositionForTenderClaim
(
	@id int
)
as
select * from ClaimPosition where Deleted = 0 and IdClaim = @id
