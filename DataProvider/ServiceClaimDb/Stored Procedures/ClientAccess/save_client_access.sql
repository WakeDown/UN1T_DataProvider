CREATE PROCEDURE [dbo].[save_client_access]
@id int = null,
	@id_client_etalon int = null,
	@login nvarchar(50),
	--пароль приходит зашифрованый
	@password nvarchar(500),
	@creator_sid varchar(46),
	@ad_sid varchar(46) = null,
	@name nvarchar(500)=null,
	@full_name nvarchar(500)=null,
	@zip_access bit,
	@counter_access bit
AS
	begin
	set nocount on;
	
	if not exists(select 1 from client_access where id=@id)
	begin
	insert into client_access (id_client_etalon, login, password, creator_sid, ad_sid,zip_access,counter_access, name, full_name)
	values (@id_client_etalon, @login, @password, @creator_sid, @ad_sid, @zip_access, @counter_access, @name, @full_name)
	set @id = @@IDENTITY
	end
	else
	begin
		update client_access
		set zip_access=@zip_access, counter_access=@counter_access
		where id=@id
	end
	select @id as id
	end
