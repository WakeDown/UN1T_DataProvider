CREATE PROCEDURE [dbo].[get_claim_list]
	@admin_sid varchar(46) = null,
	@engeneer_sid varchar(46) = null,
	@date_start date = null,
	@date_end date = null,
	@top_rows int = null,
	@manager_sid varchar(46) = null,
	@tech_sid varchar(46) = null,
	@serial_num nvarchar(150) = null,
	@id_device int = null,
	@active_claims_only bit = null,
	@id_claim_state int = null,
	@id_client int = null,
	@client_sd_num nvarchar(20) = null
	as begin
	set nocount on;
	--/////////
	-- Поправил запрос - ПОПРАВЬ ЗАПРОС КОЛИЧЕСТВА get_claim_list_count
	--/////////

	if @top_rows is null or @top_rows = 0
	begin
	set @top_rows = 100000000
	end

	select top (@top_rows) c.id, c.sid, c.id_contractor, c.id_contract, c.id_device, c.contractor_name, 
	c.contract_number, c.device_name, c.id_admin, c.id_engeneer, c.id_claim_state, c.id_work_type,
	c.date_create, date_state_change, client_sd_num, changer_sid, cur_engeneer_sid, cur_admin_sid, cur_tech_sid, cur_manager_sid, cur_service_issue_id
	from claims_view c
	where (@admin_sid is null or @admin_sid = '' or (@admin_sid is not null and @admin_sid <> '' and (cur_admin_sid = @admin_sid or specialist_sid=@admin_sid)))
	and (@engeneer_sid is null or @engeneer_sid = '' or (@engeneer_sid is not null and @engeneer_sid <> '' and (cur_engeneer_sid = @engeneer_sid or specialist_sid=@engeneer_sid)))
	and (@manager_sid is null or @manager_sid = '' or (@manager_sid is not null and @manager_sid <> '' and (cur_manager_sid = @manager_sid or specialist_sid=@manager_sid)))
	and (@tech_sid is null or @tech_sid = '' or (@tech_sid is not null and @tech_sid <> '' and (cur_tech_sid = @tech_sid or specialist_sid=@tech_sid)))
	and (@serial_num is null or @serial_num = '' or (@serial_num is not null and @serial_num <> '' and c.serial_num = @serial_num))
	and (@id_device is null or @id_device <= 0 or (@id_device is not null and @id_device > 0 and c.id_device = @id_device))
	and (@active_claims_only is null or @active_claims_only = 0 or (@active_claims_only is not null and @active_claims_only = 1 and c.id_end_state = 0))
	and (@id_claim_state is null or @id_claim_state <= 0 or (@id_claim_state is not null and @id_claim_state > 0 and c.id_claim_state = @id_claim_state))
	and (@id_client is null or @id_client <= 0 or (@id_client is not null and @id_client > 0 and c.id_contractor = @id_client))
	and (@client_sd_num is null or @client_sd_num = '' or (@client_sd_num is not null and @client_sd_num <> '' and c.client_sd_num = @client_sd_num))
	order by c.id desc
	end