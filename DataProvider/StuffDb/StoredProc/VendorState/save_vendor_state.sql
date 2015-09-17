CREATE PROCEDURE [dbo].[save_vendor_state]
	@id int = null,
	@id_vendor int = null,
	@descr nvarchar(max) = null,
	@date_end datetime = null,
	@id_organization int = null,
	@id_language int = null,
	@creator_sid varchar(46),
	@pic_data varbinary(max) = null
AS begin
set nocount on;
	if @id is not null and @id > 0 and exists(select 1 from vendor_states where id=@id)
	begin
	declare @pic_guid uniqueidentifier
	set @pic_guid = newid()

		insert into vendor_states (id_vendor, descr, date_end, id_organization, id_language, creator_sid, pic_data, pic_guid, old_id, dattim1, dattim2, enabled, deleter_sid)
		select id_vendor, descr, date_end, id_organization, id_language, creator_sid, pic_data, @pic_guid, id, dattim1, getdate(), 0, @creator_sid from vendor_states where id=@id

		--declare @pic_guid uniqueidentifier

		set @id_vendor = isnull(@id_vendor, (select id_vendor from vendor_states where id=@id))
		set @descr = isnull(@descr, (select descr from vendor_states where id=@id))
		set @date_end = isnull(@date_end, (select date_end from vendor_states where id=@id))
		set @id_organization = isnull(@id_organization, (select id_organization from vendor_states where id=@id))
		set @id_language = isnull(@id_language, (select id_language from vendor_states where id=@id))

		--if @pic_data != null --обновляет guid картинки если загружаем заново
		--begin
			--set @pic_guid = newid()
		--end

		set @pic_data = isnull(@pic_data, (select pic_data from vendor_states where id=@id))

		update vendor_states
		set id_vendor=@id_vendor, descr=@descr, date_end=@date_end, id_organization=@id_organization, id_language=@id_language, creator_sid=@creator_sid, pic_data=@pic_data, dattim1 = getdate()
		where id=@id
	end
	else
	begin
		insert into vendor_states (id_vendor, descr, date_end, id_organization, id_language, creator_sid, pic_data)
		values(@id_vendor,@descr, @date_end, @id_organization, @id_language, @creator_sid, @pic_data)
		set @id=@@IDENTITY
	end
	select @id as id
end
