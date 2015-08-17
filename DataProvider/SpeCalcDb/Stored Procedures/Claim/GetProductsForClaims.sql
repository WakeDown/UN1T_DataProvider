
create procedure GetProductsForClaims
(
	@ids nvarchar(max)
)
as
select distinct IdClaim, ProductManager from ClaimPosition where Deleted = 0 and IdClaim in (select * from dbo.Split(@ids,','));
