
create procedure HasClaimTranmissedPosition
(
	@id int
)
as
select count(*) from ClaimPosition where Deleted = 0 and IdClaim = @id and PositionState > 1 
