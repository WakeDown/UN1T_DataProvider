
create procedure LoadTenderClaimById
(
	@id int
)
as
select * from TenderClaim where Deleted = 0 and Id = @id
