
create procedure ChangePositionsState
(
	@ids nvarchar(max),
	@state int
)
as
update ClaimPosition set PositionState = @state where Deleted = 0 and Id in (select * from dbo.Split(@ids,','));
