
create procedure LoadLastStatusHistoryForClaim
(
	@idClaim int
)
as
select top(1) [ClaimStatusHistory].*, Value from ClaimStatusHistory, ClaimStatus where IdClaim = @idClaim and IdStatus = [ClaimStatus].Id order by RecordDate desc
