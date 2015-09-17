CREATE PROCEDURE [dbo].[save_contractor_access]
	@id int = null,
	@login nvarchar(50),
	--пароль приходит зашифрованый
	@password nvarchar(500),
	@creator_sid varchar(46),
	@ad_sid varchar(46) = null,
	@name nvarchar(500)=null,
	@org_name nvarchar(500)=null,
	@city nvarchar(500)=null,
	@org_sid varchar(46) = null, 
	@email varchar(50) = null
AS
	begin
	set nocount on;
	
	if not exists(select 1 from contractor_access where id=@id)
	begin
	insert into contractor_access (login, password, creator_sid, ad_sid, name, org_name, city, org_sid, email)
	values (@login, @password, @creator_sid, @ad_sid, @name, @org_name, @city, @org_sid, @email)
	set @id = @@IDENTITY
	end
	
	select @id as id
	end

