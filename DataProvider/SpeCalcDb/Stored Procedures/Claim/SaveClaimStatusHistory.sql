
create procedure SaveClaimStatusHistory
(
	@idClaim int,
	@idStatus int,
	@comment nvarchar(MAX) = '',
	@idUser nvarchar(500),
	@recordDate datetime
)
as
insert into ClaimStatusHistory values(@recordDate, @idClaim, @idStatus, @comment, @idUser)
