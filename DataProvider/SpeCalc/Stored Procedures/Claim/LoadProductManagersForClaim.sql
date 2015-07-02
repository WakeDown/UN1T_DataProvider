
create procedure LoadProductManagersForClaim
(
	@idClaim int
)
as
select distinct ProductManager from ClaimPosition where Deleted = 0 and IdClaim = @idClaim
