
create procedure LoadClaimPositionForTenderClaimForProduct
(
	@id int,
	@product nvarchar(500),
	@calcVersion int=1
)
as
select * from ClaimPosition where Deleted = 0 and IdClaim = @id and ProductManager = @product and Version=@calcVersion
