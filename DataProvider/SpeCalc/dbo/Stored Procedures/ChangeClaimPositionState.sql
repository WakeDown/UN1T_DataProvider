
create procedure ChangeClaimPositionState
(
	@id int,
	@positionState int
)
as
update ClaimPosition set PositionState = @positionState where Deleted = 0 and Id = @id
