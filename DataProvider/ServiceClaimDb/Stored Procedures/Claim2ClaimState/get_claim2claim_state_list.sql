CREATE PROCEDURE [dbo].[get_claim2claim_state_list]
	@id_claim int
	as begin set nocount on;
	select c2cs.id, c2cs.id_claim, c2cs.id_claim_state, c2cs.dattim1, c2cs.creator_sid, c2cs.descr, cs.background_color, cs.foreground_color, cs.sys_name, cs.name
	from claim2claim_states c2cs
	inner join claim_states cs on c2cs.id_claim_state=cs.id
	where c2cs.enabled=1 and cs.enabled=1 and c2cs.id_claim=@id_claim
	end
