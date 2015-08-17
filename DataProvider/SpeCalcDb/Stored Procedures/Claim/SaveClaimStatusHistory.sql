
create procedure SaveClaimStatusHistory
(
	@idClaim int,
	@idStatus int,
	@comment nvarchar(1000) = '',
	@idUser nvarchar(500),
	@recordDate datetime
)
as
insert into ClaimStatusHistory values(@recordDate, @idClaim, @idStatus, @comment, @idUser)
