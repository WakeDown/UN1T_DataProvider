CREATE PROCEDURE [dbo].[get_claim_current_state]
	@id_claim int
	as begin
	set nocount on;
	select top 1 c2cd.id_claim, c2cd.id_claim_state, c2cd.descr, c2cd.creator_sid from claim2claim_states c2cd where c2cd.enabled=1 and c2cd.id_claim=@id_claim
	order by id desc
	end
