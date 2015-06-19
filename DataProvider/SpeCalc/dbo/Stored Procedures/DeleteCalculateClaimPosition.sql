
create procedure DeleteCalculateClaimPosition
(
	@id int,
	@deletedUser nvarchar(150),
	@date datetime
)
as
update CalculateClaimPosition set Deleted = 1, DeletedUser = @deletedUser, DeleteDate = @date where Id = @id
