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
	@id_engeneer int = null,
	@id_work_type int = null,
	@specialist_sid varchar(46)=null,
	@client_sd_num nvarchar(50)=null,
	@cur_engeneer_sid varchar(46) = null,
	@cur_admin_sid varchar(46) = null,
	@cur_tech_sid varchar(46) = null,
	@cur_manager_sid varchar(46) = null,
	@serial_num nvarchar(150) = null,
	@cur_service_issue_id int = null,
	@id_service_came int = null

	--,	@id_claim_state int= null -- статус меняем отдельной процедурой
	as begin
	set nocount on;

	if (@id is not null and @id > 0 and exists(select 1 from claims where id=@id))
	begin
	--if @id_engeneer is null or @id_engeneer = 0 begin
	--select @id_admin = isnull(@id_admin,(select id_admin from claims where id=@id))
	--if @id_engeneer is null or @id_engeneer = 0 begin
	--	select @id_engeneer = isnull(@id_engeneer,(select id_engeneer from claims where id=@id))
	--	end
		if @id_work_type is null or @id_work_type = 0 begin
		select @id_work_type = id_work_type from claims where id=@id
		end

		select @specialist_sid = isnull(@specialist_sid,(select specialist_sid from claims where id=@id))

		select @cur_engeneer_sid = isnull(@cur_engeneer_sid,(select cur_engeneer_sid from claims where id=@id))
		select @cur_admin_sid = isnull(@cur_admin_sid,(select cur_admin_sid from claims where id=@id))
		select @cur_tech_sid = isnull(@cur_tech_sid,(select cur_tech_sid from claims where id=@id))
		select @cur_manager_sid = isnull(@cur_manager_sid,(select cur_manager_sid from claims where id=@id))
		select @cur_service_issue_id = isnull(@cur_service_issue_id,(select cur_service_issue_id from claims where id=@id))
		

		update claims
		set 
		--creator_sid=@creator_sid,
		--id_admin=@id_admin, id_engeneer=@id_engeneer, 
		id_work_type=@id_work_type, specialist_sid=@specialist_sid,
		cur_engeneer_sid = @cur_engeneer_sid, cur_admin_sid=@cur_admin_sid, cur_tech_sid=@cur_tech_sid, cur_manager_sid=@cur_manager_sid, cur_service_issue_id = @cur_service_issue_id
		--id_contractor = @id_contractor,id_contract=@id_contract,id_device=@id_device, contractor_name=@contractor_name, contract_number=@contract_number, device_name=@device_name, id_claim_state=@id_claim_state
		where id=@id
	end
	else if (@sid is not null and @sid <> '' and exists(select 1 from claims where sid=@sid))
	begin
	--select @id_admin = isnull(@id_admin,(select id_admin from claims where sid=@sid))
	--	select @id_engeneer = isnull(@id_engeneer,(select id_engeneer from claims where sid=@sid))
		if @id_work_type is null or @id_work_type = 0 begin
		select @id_work_type = id_work_type from claims where sid=@sid
		end

		select @specialist_sid = isnull(@specialist_sid,(select specialist_sid from claims where sid=@sid))

		select @cur_engeneer_sid = isnull(@cur_engeneer_sid,(select cur_engeneer_sid from claims where sid=@sid))
		select @cur_admin_sid = isnull(@cur_admin_sid,(select cur_admin_sid from claims where sid=@sid))
		select @cur_tech_sid = isnull(@cur_tech_sid,(select cur_tech_sid from claims where sid=@sid))
		select @cur_manager_sid = isnull(@cur_manager_sid,(select cur_manager_sid from claims where sid=@sid))
		select @cur_service_issue_id = isnull(@cur_service_issue_id,(select cur_service_issue_id from claims where sid=@sid))

		update claims
		set 
		--creator_sid=@creator_sid,
		--id_admin=@id_admin, id_engeneer=@id_engeneer, 
		id_work_type=@id_work_type, specialist_sid=@specialist_sid,
		cur_engeneer_sid = @cur_engeneer_sid, cur_admin_sid=@cur_admin_sid, cur_tech_sid=@cur_tech_sid, cur_manager_sid=@cur_manager_sid, cur_service_issue_id = @cur_service_issue_id
		--id_contractor = @id_contractor,id_contract=@id_contract,id_device=@id_device, contractor_name=@contractor_name, contract_number=@contract_number, device_name=@device_name, id_claim_state=@id_claim_state
		where sid=@sid
	end
	else
	begin
	insert into claims(id_contractor, id_contract, id_device, contractor_name, contract_number, device_name, creator_sid, 
	id_admin, id_engeneer, id_claim_state, id_work_type, date_state_change, client_sd_num, cur_engeneer_sid, cur_admin_sid, cur_tech_sid, cur_manager_sid, serial_num, id_service_came)
	values(@id_contractor, @id_contract, @id_device, @contractor_name, @contract_number, @device_name, @creator_sid, 
	@id_admin, @id_engeneer, 0, 0, getdate(), @client_sd_num, @cur_engeneer_sid, @cur_admin_sid, @cur_tech_sid, @cur_manager_sid, @serial_num, @id_service_came)
		set @id = @@IDENTITY
	end
	select @id as id
	end