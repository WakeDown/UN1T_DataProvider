
create procedure HasClaimTranmissedPosition
(
	@id int,
	@version int
)
as
select count(*) from ClaimPosition where Deleted = 0 and IdClaim = @id and Version=@version and PositionState = 2 --and PositionState > 1 and PositionState != 6
