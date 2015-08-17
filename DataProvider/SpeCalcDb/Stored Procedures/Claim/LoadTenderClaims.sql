
create procedure LoadTenderClaims
(
	@pageSize int
)
as
select top (@pageSize) * from TenderClaim where Deleted = 0 order by Id desc
