
create procedure DeleteClaimPosition
(
	@id int,
	@deletedUser nvarchar(150),
	@date datetime
)
as
update ClaimPosition set Deleted = 1, DeletedUser = @deletedUser, DeleteDate = @date where Id = @id
