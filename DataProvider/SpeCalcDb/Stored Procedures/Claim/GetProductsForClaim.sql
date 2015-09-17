
create procedure GetProductsForClaim
(
	@id int
)
as
select distinct ProductManager from ClaimPosition where Deleted = 0 and IdClaim = @id and (PositionState = 1 or PositionState = 3)
