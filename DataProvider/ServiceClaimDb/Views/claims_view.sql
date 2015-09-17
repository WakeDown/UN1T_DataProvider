CREATE VIEW [dbo].[claims_view]
	AS SELECT  c.id, c.sid, c.id_contractor, c.id_contract, c.id_device, c.contractor_name, 
	c.contract_number, c.device_name, c.id_admin, c.id_engeneer, c.id_claim_state, c.id_work_type,
	c.dattim1 as date_create, date_state_change, client_sd_num, changer_sid, cur_engeneer_sid, cur_admin_sid, cur_tech_sid, cur_manager_sid
	FROM claims c where c.enabled = 1
