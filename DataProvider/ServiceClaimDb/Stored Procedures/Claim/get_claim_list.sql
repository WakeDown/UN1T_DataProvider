CREATE PROCEDURE [dbo].[get_claim_list]
	@id_admin int = null,
	@id_engeneer int = null,
	@date_start date = null,
	@date_end date = null,
	@top_rows int = null
	as begin
	set nocount on;

	select c.id, c.sid, c.id_contractor, c.id_contract, c.id_device, c.contractor_name, c.contract_number, c.device_name, c.id_admin, c.id_engeneer, c.id_claim_state
	from claims_view c
	order by c.id desc
	end