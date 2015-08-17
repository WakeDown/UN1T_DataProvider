
create procedure GetClaimsPositionsStatistics
(
	@ids nvarchar(max)
)
as
select IdClaim, ProductManager, Count(*) from ClaimPosition where Deleted = 0 and IdClaim in(select * from dbo.Split(@ids,',')) group by IdClaim, ProductManager;
