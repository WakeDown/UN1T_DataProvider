
create procedure IsPositionsReadyToConfirm
(
	@ids nvarchar(max)
)
as
select IdPosition, count(*) from CalculateClaimPosition where Deleted = 0 and IdPosition in(select * from dbo.Split(@ids,',')) group by IdPosition;
