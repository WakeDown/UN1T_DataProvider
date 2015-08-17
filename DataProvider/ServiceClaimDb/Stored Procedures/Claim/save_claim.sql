CREATE PROCEDURE [dbo].[save_claim]
	@id int = null,
	@sid varchar(46) = null,
	@id_contractor int = null,
	@id_contract int = null,
	@id_device int = null, 
	@contractor_name nvarchar(500) = null,
	@contract_number nvarchar(150) = null,
	@device_name nvarchar(500) = null,
	@creator_sid varchar(46),
	@id_admin int = null,
	@id_engeneer int = null
	--,	@id_claim_state int= null -- статус меняем отдельной процедурой
	as begin
	set nocount on;
	if (@id is not null and @id > 0 and exists(select 1 from claims where id=@id))
	begin
		update claims
		set creator_sid=@creator_sid,id_admin=@id_admin, id_engeneer=@id_engeneer
		--id_contractor = @id_contractor,id_contract=@id_contract,id_device=@id_device, contractor_name=@contractor_name, contract_number=@contract_number, device_name=@device_name, id_claim_state=@id_claim_state
		where id=@id
	end
	else if (@sid is not null and @sid <> '' and exists(select 1 from claims where sid=@sid))
	begin
		update claims
		set creator_sid=@creator_sid,id_admin=@id_admin, id_engeneer=@id_engeneer
		--id_contractor = @id_contractor,id_contract=@id_contract,id_device=@id_device, contractor_name=@contractor_name, contract_number=@contract_number, device_name=@device_name, id_claim_state=@id_claim_state
		where sid=@sid
	end
	else
	begin
	insert into claims(id_contractor, id_contract, id_device, contractor_name, contract_number, device_name, creator_sid, id_admin, id_engeneer, id_claim_state)
	values(@id_contractor, @id_contract, @id_device, @contractor_name, @contract_number, @device_name, @creator_sid, @id_admin, @id_engeneer, 0)
		set @id = @@IDENTITY
	end
	select @id as id
	end