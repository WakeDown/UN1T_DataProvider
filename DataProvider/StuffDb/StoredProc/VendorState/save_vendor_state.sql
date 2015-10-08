CREATE PROCEDURE [dbo].[save_vendor_state]
	@id int = null,
	@id_vendor int = null,
	@descr nvarchar(max) = null,
	@date_end datetime = null,
	@id_organization int = null,
	@id_language int = null,
	@creator_sid varchar(46),
	@pic_data varbinary(max) = null,
	@name nvarchar(150) = null
AS begin
set nocount on;
	if @id is not null and @id > 0 and exists(select 1 from vendor_states where id=@id)
	begin
	declare @pic_guid uniqueidentifier
	set @pic_guid = newid()

		insert into vendor_states (id_vendor, descr, date_end, id_organization, id_language, creator_sid, pic_data, pic_guid, old_id, dattim1, dattim2, enabled, deleter_sid, name, new_delivery_sent, expired_delivery_sent, update_delivery_sent)
		select id_vendor, descr, date_end, id_organization, id_language, creator_sid, pic_data, @pic_guid, id, dattim1, getdate(), 0, @creator_sid, name, new_delivery_sent, expired_delivery_sent, update_delivery_sent from vendor_states where id=@id

		--declare @pic_guid uniqueidentifier

		set @id_vendor = isnull(@id_vendor, (select id_vendor from vendor_states where id=@id))
		set @descr = isnull(@descr, (select descr from vendor_states where id=@id))
		set @date_end = isnull(@date_end, (select date_end from vendor_states where id=@id))
		set @id_organization = isnull(@id_organization, (select id_organization from vendor_states where id=@id))
		set @id_language = isnull(@id_language, (select id_language from vendor_states where id=@id))
		set @name = isnull(@name, (select name from vendor_states where id=@id))

		--if @pic_data != null --обновляет guid картинки если загружаем заново
		--begin
			--set @pic_guid = newid()
		--end

		set @pic_data = isnull(@pic_data, (select pic_data from vendor_states where id=@id))

		update vendor_states
		set id_vendor=@id_vendor, descr=@descr, date_end=@date_end, id_organization=@id_organization, id_language=@id_language, 
		creator_sid=@creator_sid, pic_data=@pic_data, dattim1 = getdate(), name = @name, expired_delivery_sent = 0
		where id=@id

		--если были изменения и это недавно созданный уведомление не отправлено
		if exists(select 1 
from vendor_states vs inner join vendor_states vs_old on vs.id=vs_old.old_id AND vs_old.id = (SELECT MAX(id) FROM vendor_states old WHERE old.old_id=@id)
where vs.id=@id AND vs.new_delivery_sent = 1 and (vs.id_vendor != vs_old.id_vendor or LTRIM(RTRIM(vs.descr))!=RTRIM(LTRIM(vs_old.descr)) 
or vs.date_end!=vs_old.date_end or vs.id_organization != vs_old.id_organization or vs.id_language!=vs_old.id_language or vs.pic_data!=vs_old.pic_data))
begin
update vendor_states
set update_delivery_sent=0
where id=@id
end

	end
	else
	begin
		insert into vendor_states (id_vendor, descr, date_end, id_organization, id_language, creator_sid, pic_data, name, new_delivery_sent, expired_delivery_sent, update_delivery_sent)
		values(@id_vendor,@descr, @date_end, @id_organization, @id_language, @creator_sid, @pic_data, @name, 0, 0, 1)
		set @id=@@IDENTITY
	end
	select @id as id
end
