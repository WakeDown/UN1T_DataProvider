CREATE PROCEDURE [dbo].[get_claim]
	@id int = null,
	@sid varchar(46) = null
	as begin
	set nocount on;
	select c.id, c.sid, c.id_contractor, c.id_contract, c.id_device, c.contractor_name, c.contract_number, c.device_name, c.id_admin, c.id_engeneer, c.id_claim_state
	from claims c
	where (@id is null or @id<= 0 or (@id is not null and @id> 0 and c.id=@id)) and
	(@sid is null or @sid= '' or (@id is not null and @sid!= '' and c.sid=@sid))
	end
