
create procedure LoadClaimPositionForTenderClaim
(
	@id int,
	@calcVersion int=1
)
as

select * 
from ClaimPosition where Deleted = 0 and IdClaim = @id and Version=@calcVersion
