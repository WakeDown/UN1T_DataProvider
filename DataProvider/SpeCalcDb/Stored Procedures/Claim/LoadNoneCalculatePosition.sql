
create procedure LoadNoneCalculatePosition
(
	@id int
)
as
select * from ClaimPosition where Deleted = 0 and IdClaim = @id and (PositionState = 1 or PositionState = 3)
