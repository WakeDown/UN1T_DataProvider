
create procedure HasClaimPosition
(
	@id int
)
as
select count(*) from ClaimPosition where Deleted = 0 and IdClaim = @id
