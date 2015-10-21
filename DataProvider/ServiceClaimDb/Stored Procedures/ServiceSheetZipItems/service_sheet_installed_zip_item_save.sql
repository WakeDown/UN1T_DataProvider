CREATE PROCEDURE [dbo].[service_sheet_installed_zip_item_save]
	@id_ordered_zip_item int,
	@creator_sid varchar(46),
	@id_service_sheet int,
	@installed bit = 1
as begin
	set nocount on;
	declare @part_num nvarchar(50), @name nvarchar(500), @count int, @id_zip_claim_unit int
	
	if @installed = 1
	begin


	insert into service_sheet_installed_zip_items (id_ordered_zip_item, id_service_sheet, creator_sid)
	values (@id_ordered_zip_item, @id_service_sheet,@creator_sid)

	--update service_sheet_zip_items
	--set installed = 1, installed_sid = @creator_sid, installed_id_service_sheet = @id_service_sheet
	--where id=@id
	end
	if @installed = 0
	begin

	update service_sheet_installed_zip_items
	set enabled=0, dattim2=getdate(),deleter_sid=@creator_sid
	where id_service_sheet=@id_service_sheet and id_ordered_zip_item=@id_ordered_zip_item

	--update service_sheet_zip_items
	--set installed = 0, installed_cancel_sid = @creator_sid, installed_id_service_sheet = null
	--where id=@id
	end
	end
