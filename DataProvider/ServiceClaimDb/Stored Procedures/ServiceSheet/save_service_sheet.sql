CREATE PROCEDURE [dbo].[save_service_sheet]
	@id int = null,
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
	@counter_descr nvarchar(MAX) = null

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
		counter_color, counter_total, no_counter,descr, counter_unavailable, counter_descr)
		values(@process_enabled, @device_enabled, @zip_claim, @zip_claim_number, @creator_sid, @counter_mono, 
		@counter_color, @counter_total, @no_counter, @descr, @counter_unavailable, @counter_descr)
		set @id = @@IDENTITY
	end

	select @id as id

	end