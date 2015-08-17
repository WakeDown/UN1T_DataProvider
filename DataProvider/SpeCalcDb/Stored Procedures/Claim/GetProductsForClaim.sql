
create procedure GetProductsForClaim
(
	@id int
)
as
select ProductManager from ClaimPosition where Deleted = 0 and IdClaim = @id and (PositionState = 1 or PositionState = 3)
