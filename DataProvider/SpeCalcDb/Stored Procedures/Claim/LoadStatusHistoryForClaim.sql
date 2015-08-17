
CREATE procedure [dbo].[LoadStatusHistoryForClaim]
(
	@idClaim int
)
as
select [ClaimStatusHistory].*, Value from ClaimStatusHistory, ClaimStatus where IdClaim = @idClaim and IdStatus = [ClaimStatus].Id order by RecordDate
