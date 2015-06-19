
create procedure ChangeTenderClaimTenderStatus
(
	@id int,
	@status int
)
as
update TenderClaim set TenderStatus = @status where Id = @id
