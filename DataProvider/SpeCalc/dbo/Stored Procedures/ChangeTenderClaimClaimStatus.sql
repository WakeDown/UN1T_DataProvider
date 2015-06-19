
create procedure ChangeTenderClaimClaimStatus
(
	@id int,
	@claimStatus int
)
as
update TenderClaim set ClaimStatus = @claimStatus where Id = @id
