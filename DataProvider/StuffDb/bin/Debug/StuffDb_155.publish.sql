/*
Скрипт развертывания для Stuff

Этот код был создан программным средством.
Изменения, внесенные в этот файл, могут привести к неверному выполнению кода и будут потеряны
в случае его повторного формирования.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "Stuff"
:setvar DefaultFilePrefix "Stuff"
:setvar DefaultDataPath "S:\SQL-DB\MSSQL10_50.MSSQLSERVER\MSSQL\Data\"
:setvar DefaultLogPath "T:\SQL-TL\MSSQL10_50.MSSQLSERVER\MSSQL\Data\"

GO
:on error exit
GO
/*
Проверьте режим SQLCMD и отключите выполнение скрипта, если режим SQLCMD не поддерживается.
Чтобы повторно включить скрипт после включения режима SQLCMD выполните следующую инструкцию:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'Для успешного выполнения этого скрипта должен быть включен режим SQLCMD.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Выполняется изменение [dbo].[organizations]...';


GO
ALTER TABLE [dbo].[organizations]
    ADD [director_sid] VARCHAR (46) NULL;


GO
PRINT N'Выполняется обновление [dbo].[employees_report]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[employees_report]';


GO
PRINT N'Выполняется обновление [dbo].[employees_view]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[employees_view]';


GO
PRINT N'Выполняется изменение [dbo].[get_organization]...';


GO
ALTER PROCEDURE [dbo].[get_organization] @id INT = NULL
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  id ,
                name ,
                ( SELECT    COUNT(1)
                  FROM      employees_view e
                  WHERE     e.id_organization = o.id
                ) AS emp_count ,
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
                manager_position_dat,
				site,
				director_sid
        FROM    organizations o
        WHERE   o.enabled = 1
                AND ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND o.id = @id
                         )
                    )
        ORDER BY name
    END
GO
PRINT N'Выполняется изменение [dbo].[save_organization]...';


GO
ALTER PROCEDURE [dbo].[save_organization]
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
	@director_sid varchar(46)
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
						  director_sid = @director_sid
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
						  director_sid
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
						  @director_sid
                        )

                SELECT  @id = @@IDENTITY
            END
	 
        SELECT  @id AS id
    END
GO
PRINT N'Выполняется обновление [dbo].[close_organization]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[close_organization]';


GO
PRINT N'Выполняется обновление [dbo].[get_employee]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_employee]';


GO
PRINT N'Выполняется обновление [dbo].[get_other_employee_list]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_other_employee_list]';


GO
PRINT N'Выполняется обновление [dbo].[get_city]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_city]';


GO
PRINT N'Выполняется обновление [dbo].[get_city_link_count]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_city_link_count]';


GO
PRINT N'Выполняется обновление [dbo].[get_department]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_department]';


GO
PRINT N'Выполняется обновление [dbo].[get_employee_list]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_employee_list]';


GO
PRINT N'Выполняется обновление [dbo].[get_employees_birthday]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_employees_birthday]';


GO
PRINT N'Выполняется обновление [dbo].[get_employees_newbie]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_employees_newbie]';


GO
PRINT N'Выполняется обновление [dbo].[get_organization_link_count]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_organization_link_count]';


GO
PRINT N'Выполняется обновление [dbo].[get_position]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_position]';


GO
PRINT N'Выполняется обновление [dbo].[get_position_link_count]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_position_link_count]';


GO
/*
Шаблон скрипта после развертывания							
--------------------------------------------------------------------------------------
 В данном файле содержатся инструкции SQL, которые будут добавлены в скрипт построения.		
 Используйте синтаксис SQLCMD для включения файла в скрипт после развертывания.			
 Пример:      :r .\myfile.sql								
 Используйте синтаксис SQLCMD для создания ссылки на переменную в скрипте после развертывания.		
 Пример:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

GRANT EXECUTE ON SCHEMA ::dbo TO sqlUnit_prog
--:r .\ins_emp_states.sql
--:r .\ins_orgs.sql
--:r .\ins_cities.sql
--:r .\ins_positions.sql
GO

GO
PRINT N'Обновление завершено.';


GO
