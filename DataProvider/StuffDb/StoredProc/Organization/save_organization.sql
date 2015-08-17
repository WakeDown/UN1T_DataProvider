CREATE PROCEDURE [dbo].[save_organization]
    @id INT = NULL ,
    @name NVARCHAR(150) ,
    @creator_sid VARCHAR(46) = NULL ,
    @address_ur NVARCHAR(500) = NULL ,
    @address_fact NVARCHAR(500) = NULL ,
    @phone NVARCHAR(50) = NULL ,
    @email NVARCHAR(50) = NULL ,
    @inn NVARCHAR(12) = NULL ,
    @kpp NVARCHAR(20) = NULL ,
    @ogrn NVARCHAR(20) = NULL ,
    @rs NVARCHAR(50) = NULL ,
    @bank NVARCHAR(500) = NULL ,
    @ks NVARCHAR(50) = NULL ,
    @bik NVARCHAR(50) = NULL ,
    @okpo NVARCHAR(50) = NULL ,
    @okved NVARCHAR(50) = NULL ,
    @manager_name NVARCHAR(150) = NULL ,
    @manager_name_dat NVARCHAR(150) = NULL ,
    @manager_position NVARCHAR(250) = NULL ,
    @manager_position_dat NVARCHAR(250) = NULL,
	@site NVARCHAR(50) = NULL,
	@director_sid varchar(46)=null,
	@id_director int
AS
    BEGIN
        SET NOCOUNT ON;
        IF @id IS NOT NULL
            AND @id > 0
            AND EXISTS ( SELECT 1
                         FROM   organizations
                         WHERE  id = @id )
            BEGIN
                UPDATE  organizations
                SET     name = @name,
				address_ur =@address_ur,
                          address_fact = @address_fact,
                          phone = @phone,
                          email = @email,
                          inn = @inn,
                          kpp = @kpp,
                          ogrn = @ogrn,
                          rs = @rs,
                          bank = @bank,
                          ks = @ks,
                          bik = @bik,
                          okpo = @okpo,
                          okved = @okved,
                          manager_name = @manager_name,
                          manager_name_dat = @manager_name_dat,
                          manager_position = @manager_position,
                          manager_position_dat =@manager_position_dat,
						  SITE = @site,
						  director_sid = @director_sid,
						  id_director = @id_director
                WHERE   id = @id
            END
        ELSE
            BEGIN
                INSERT  INTO organizations
                        ( name ,
                          creator_sid ,
                          address_ur ,
                          address_fact ,
                          phone ,
                          email ,
                          inn ,
                          kpp ,
                          ogrn ,
                          rs ,
                          bank ,
                          ks ,
                          bik ,
                          okpo ,
                          okved ,
                          manager_name ,
                          manager_name_dat ,
                          manager_position ,
                          manager_position_dat ,
						  site,
						  director_sid,
						  id_director
                        )
                VALUES  ( @name ,
                          @creator_sid ,
                          @address_ur ,
                          @address_fact ,
                          @phone ,
                          @email ,
                          @inn ,
                          @kpp ,
                          @ogrn ,
                          @rs ,
                          @bank ,
                          @ks ,
                          @bik ,
                          @okpo ,
                          @okved ,
                          @manager_name ,
                          @manager_name_dat ,
                          @manager_position ,
                          @manager_position_dat ,
						  @site,
						  @director_sid,
						  @id_director
                        )

                SELECT  @id = @@IDENTITY
            END
	 
        SELECT  @id AS id
    END
