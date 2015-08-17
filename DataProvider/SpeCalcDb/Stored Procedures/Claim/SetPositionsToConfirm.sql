
create procedure SetPositionsToConfirm
(
	@ids nvarchar(max)
)
as
update ClaimPosition set PositionState = 2 where Deleted = 0 and Id in(select * from dbo.Split(@ids,','));
