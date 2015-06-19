
create procedure LoadClaimPositionForTenderClaimForProduct
(
	@id int,
	@product nvarchar(500)
)
as
select * from ClaimPosition where Deleted = 0 and IdClaim = @id and ProductManager = @product
