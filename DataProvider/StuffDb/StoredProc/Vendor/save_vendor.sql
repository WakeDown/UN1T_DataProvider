CREATE PROCEDURE [dbo].[save_vendor]
	@id int = null,
	@name nvarchar(150) = null,
	@descr nvarchar(max) = null,
	@creator_sid varchar(46)= null
	as begin
	set nocount on;
	if @id is not null and @id > 0 and exists(select 1 from vendors where id=@id)
	begin
		set @name = isnull(@name, (select name from vendors where id=@id))
		set @descr = isnull(@descr, (select descr from vendors where id=@id))

		update vendors
		set name=@name, descr=@descr
		where id=@id

	end
	else
	begin
		insert into vendors (name, descr, creator_sid)
		values(@name, @descr, @creator_sid)
		set @id=@@IDENTITY
	end
	select @id as id
	end
