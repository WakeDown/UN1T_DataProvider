CREATE PROCEDURE [dbo].[save_service_issue]
	@id int= null,
	@id_claim int = null,
	@date_plan datetime = null,
	@specialist_sid varchar(46) = null,
	@creator_sid varchar(46) = null,
	@descr nvarchar(max) = null
	as begin
	set nocount on

	if exists(select 1 from service_issue where id=@id)
	begin
	update service_issue
	set id_claim=@id_claim, date_plan=@date_plan, specialist_sid=@specialist_sid, creator_sid=@creator_sid, descr=@descr
	where id=@id
	end
	else
	begin
	insert into service_issue (id_claim, date_plan, specialist_sid, creator_sid, descr)
	values (@id_claim, @date_plan, @specialist_sid, @creator_sid, @descr)
	set @id = @@IDENTITY
	end
	select @id as id
	end
