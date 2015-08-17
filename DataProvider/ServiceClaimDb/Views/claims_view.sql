CREATE VIEW [dbo].[claims_view]
	AS SELECT  c.id, c.sid, c.id_contractor, c.id_contract, c.id_device, c.contractor_name, c.contract_number, c.device_name, c.id_admin, c.id_engeneer, c.id_claim_state
	FROM claims c where c.enabled = 1
