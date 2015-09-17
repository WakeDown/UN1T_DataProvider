CREATE PROCEDURE [dbo].[get_claim_list]
	@id_admin int = null,
	@id_engeneer int = null,
	@date_start date = null,
	@date_end date = null,
	@top_rows int
	as begin
	set nocount on;
	--/////////
	-- Поправил запрос - ПОПРАВЬ ДАПРОС КОЛИЧЕСТВА get_claim_list_count
	--/////////
	select top (@top_rows) c.id, c.sid, c.id_contractor, c.id_contract, c.id_device, c.contractor_name, 
	c.contract_number, c.device_name, c.id_admin, c.id_engeneer, c.id_claim_state, c.id_work_type,
	c.date_create, date_state_change, client_sd_num, changer_sid, cur_engeneer_sid, cur_admin_sid, cur_tech_sid, cur_manager_sid
	from claims_view c
	order by c.id desc
	end