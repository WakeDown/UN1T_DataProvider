CREATE PROCEDURE [dbo].[save_service_sheet]
	@id int = null,
	@id_claim int,
	@id_service_issue int,
	@process_enabled bit = null,
	@device_enabled bit = null,
	@zip_claim bit = null,
	@zip_claim_number nvarchar(50) = null,
	@creator_sid varchar(46),
	@counter_mono bigint = null,
	@counter_color bigint = null,
	@counter_total bigint = null,
	@no_counter bit = null,
	@descr nvarchar(MAX) = null,
	@counter_unavailable bit = null,
	@counter_descr nvarchar(MAX) = null,
	@engeneer_sid varchar(46) = null,
	@admin_sid varchar(46) = null,
	@time_on_work_minutes int = null,
	@id_work_type int

	as begin set nocount on;

	if exists(select 1 from service_sheet where id=@id)
	begin
		--update service_sheet
		--set 
		--where id=@id
		select null
	end
	else begin
		insert into service_sheet (process_enabled, device_enabled, zip_claim, zip_claim_number, creator_sid, counter_mono, 
		counter_color, counter_total, no_counter,descr, counter_unavailable, counter_descr, engeneer_sid, admin_sid, id_service_issue, id_claim, time_on_work_minutes, id_work_type)
		values(@process_enabled, @device_enabled, @zip_claim, @zip_claim_number, @creator_sid, @counter_mono, 
		@counter_color, @counter_total, @no_counter, @descr, @counter_unavailable, @counter_descr, @engeneer_sid, @admin_sid, @id_service_issue,@id_claim, @time_on_work_minutes, @id_work_type)
		set @id = @@IDENTITY
	end

	select @id as id

	end