
create procedure DeleteTenderClaims
(
	@id int,
	@deletedUser nvarchar(150),
	@date datetime
)
as
update TenderClaim set Deleted = 1, DeletedUser = @deletedUser, DeleteDate = @date where Id = @id
