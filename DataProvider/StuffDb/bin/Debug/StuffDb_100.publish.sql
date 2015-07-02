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
/*
Тип столбца creator_sid в таблице [dbo].[positions] на данный момент -  VARCHAR (100) NULL, но будет изменен на  VARCHAR (46) NULL. Данные могут быть утеряны.
*/

IF EXISTS (select top 1 1 from [dbo].[positions])
    RAISERROR (N'Обнаружены строки. Обновление схемы завершено из-за возможной потери данных.', 16, 127) WITH NOWAIT

GO
PRINT N'Выполняется удаление [dbo].[employees].[IX_employee_ad_sid]...';


GO
DROP INDEX [IX_employee_ad_sid]
    ON [dbo].[employees];


GO
PRINT N'Выполняется удаление ограничение без названия для [dbo].[employees]...';


GO
ALTER TABLE [dbo].[employees] DROP CONSTRAINT [DF__tmp_ms_xx__ad_si__7B5B524B];


GO
PRINT N'Выполняется изменение [dbo].[departments]...';


GO
ALTER TABLE [dbo].[departments] ALTER COLUMN [creator_sid] VARCHAR (46) NULL;


GO
PRINT N'Выполняется изменение [dbo].[employees]...';


GO
ALTER TABLE [dbo].[employees] ALTER COLUMN [ad_sid] VARCHAR (46) NOT NULL;

ALTER TABLE [dbo].[employees] ALTER COLUMN [creator_sid] VARCHAR (46) NULL;


GO
PRINT N'Выполняется создание [dbo].[employees].[IX_employee_ad_sid]...';


GO
CREATE NONCLUSTERED INDEX [IX_employee_ad_sid]
    ON [dbo].[employees]([ad_sid] ASC);


GO
PRINT N'Выполняется изменение [dbo].[organizations]...';


GO
ALTER TABLE [dbo].[organizations] ALTER COLUMN [creator_sid] VARCHAR (46) NULL;


GO
PRINT N'Выполняется изменение [dbo].[photos]...';


GO
ALTER TABLE [dbo].[photos] ALTER COLUMN [creator_sid] VARCHAR (46) NULL;


GO
PRINT N'Выполняется изменение [dbo].[positions]...';


GO
ALTER TABLE [dbo].[positions] ALTER COLUMN [creator_sid] VARCHAR (46) NULL;


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[employees]...';


GO
ALTER TABLE [dbo].[employees]
    ADD DEFAULT '' FOR [ad_sid];


GO
PRINT N'Выполняется обновление [dbo].[departments_view]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[departments_view]';


GO
PRINT N'Выполняется обновление [dbo].[employees_view]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[employees_view]';


GO
PRINT N'Выполняется изменение [dbo].[save_department]...';


GO
ALTER PROCEDURE [dbo].[save_department]
    @id INT = NULL ,
    @name NVARCHAR(150) ,
    @id_parent INT ,
    @id_chief INT,
	@creator_sid varchar(46)=null
AS
    BEGIN
	SET NOCOUNT ON;
        IF @id IS NOT NULL
            AND @id > 0
            AND EXISTS ( SELECT 1
                         FROM   departments d
                         WHERE  id = @id )
            BEGIN
                UPDATE  departments
                SET     name = @name ,
                        id_parent = @id_parent ,
                        id_chief = @id_chief
                WHERE   id = @id
            END
        ELSE
            BEGIN
                INSERT  INTO departments
                        ( name ,
                          id_parent ,
                          id_chief  ,creator_sid
                        )
                VALUES  ( @name ,
                          @id_parent ,
                          @id_chief  ,@creator_sid
                        )

						SELECT @id=@@IDENTITY
            END
	 
		SELECT @id AS id
    END
GO
PRINT N'Выполняется изменение [dbo].[save_employee]...';


GO
ALTER PROCEDURE [dbo].[save_employee]
    @id INT = NULL ,
    @ad_sid VARCHAR(46) ,
    @id_manager INT ,
    @surname NVARCHAR(50) ,
    @name NVARCHAR(50) ,
    @patronymic NVARCHAR(50)=null ,
    @full_name NVARCHAR(150) ,
    @display_name NVARCHAR(100) ,
    @id_position INT ,
    @id_organization INT ,
    @email NVARCHAR(150) = null,
    @work_num NVARCHAR(50)  = null,
    @mobil_num NVARCHAR(50)  = null,
    @id_emp_state INT ,
    @id_department INT ,
    @id_city INT ,
    @date_came DATE =null ,
	@birth_date date= null,
	@male bit,
	@id_position_org int,
	@has_ad_account bit,
	@creator_sid varchar(46)=null
AS
    BEGIN
        SET NOCOUNT ON;
        IF @id IS NOT NULL
            AND @id > 0
            AND EXISTS ( SELECT 1
                         FROM   employees
                         WHERE  id = @id )
            BEGIN
                UPDATE  employees
                SET     ad_sid = @ad_sid ,
                        id_manager = @id_manager ,
                        surname = @surname ,
                        NAME = @name ,
                        patronymic = @patronymic ,
                        full_name = @full_name ,
                        display_name = @display_name ,
                        id_position = @id_position ,
                        id_organization = @id_organization ,
                        email = @email ,
                        work_num = @work_num ,
                        mobil_num = @mobil_num ,
                        id_emp_state = @id_emp_state ,
                        id_department = @id_department ,
                        id_city = @id_city ,
                        date_came = @date_came,
						birth_date=@birth_date,
						male=@male,
						id_position_org=@id_position_org,
						has_ad_account = @has_ad_account
                WHERE   id = @id
            END
        ELSE
            BEGIN
                INSERT  INTO employees
                        ( ad_sid ,
                          id_manager ,
                          surname ,
                          name ,
                          patronymic ,
                          full_name ,
                          display_name ,
                          id_position ,
                          id_organization ,
                          email ,
                          work_num ,
                          mobil_num ,
                          id_emp_state ,
                          id_department ,
                          id_city ,
                          date_came ,
						  birth_date,
						  male,
						  id_position_org,
						  has_ad_account,
						  creator_sid
                        )
                VALUES  ( @ad_sid ,
                          @id_manager ,
                          @surname ,
                          @name ,
                          @patronymic ,
                          @full_name ,
                          @display_name ,
                          @id_position ,
                          @id_organization ,
                          @email ,
                          @work_num ,
                          @mobil_num ,
                          @id_emp_state ,
                          @id_department ,
                          @id_city ,
                          @date_came  ,
						  @birth_date,
						  @male,
						  @id_position_org,
						  @has_ad_account,
						  @creator_sid
                        )

                SELECT  @id = @@IDENTITY
            END
	 
        SELECT @id AS id
    END
GO
PRINT N'Выполняется изменение [dbo].[save_organization]...';


GO
ALTER PROCEDURE [dbo].[save_organization]
    @id INT = NULL ,
    @name NVARCHAR(150),
	@creator_sid varchar(46)=null
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
                SET     name = @name 
                WHERE   id = @id
            END
        ELSE
            BEGIN
                INSERT  INTO organizations
                        ( name ,creator_sid
                        )
                VALUES  ( @name ,@creator_sid
                        )

						SELECT @id=@@IDENTITY
            END
	 
		SELECT @id AS id
    END
GO
PRINT N'Выполняется изменение [dbo].[save_photo]...';


GO
ALTER PROCEDURE [dbo].[save_photo]
    @id_employee INT ,
    @picture IMAGE,
	@creator_sid varchar(46) = null
AS
    BEGIN
        SET nocount ON;
        IF EXISTS ( SELECT  1
                    FROM    photos p
                    WHERE   p.id_employee = @id_employee )
            BEGIN
                UPDATE  photos
                SET     picture = @picture
				where id_employee = @id_employee
            END
        ELSE
            BEGIN
                INSERT  INTO photos
                        ( id_employee ,picture, creator_sid )
                VALUES  ( @id_employee, @picture, @creator_sid )
            END
    END
GO
PRINT N'Выполняется изменение [dbo].[save_position]...';


GO
ALTER PROCEDURE [dbo].[save_position]
	@id INT = NULL ,
    @name NVARCHAR(500),
	@creator_sid varchar(46)=null
AS
    BEGIN
	SET NOCOUNT ON;
        IF @id IS NOT NULL
            AND @id > 0
            AND EXISTS ( SELECT 1
                         FROM   positions
                         WHERE  id = @id )
            BEGIN
                UPDATE  positions
                SET     name = @name 
                WHERE   id = @id
            END
        ELSE
            BEGIN
                INSERT  INTO positions
                        ( name  ,creator_sid
                        )
                VALUES  ( @name  ,@creator_sid
                        )

						SELECT @id=@@IDENTITY
            END
	 
		SELECT @id AS id
    END
GO
PRINT N'Выполняется создание [dbo].[check_employee_is_chief]...';


GO
CREATE PROCEDURE [dbo].[check_employee_is_chief]
	@id_employee int,
	@id_department int
AS
begin
set nocount on;
	select case when exists(select 1 from departments d where d.id = @id_department and d.id_chief = @id_employee) then 1 else 0 end as result
end
GO
PRINT N'Выполняется обновление [dbo].[close_department]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[close_department]';


GO
PRINT N'Выполняется обновление [dbo].[get_employee]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_employee]';


GO
PRINT N'Выполняется обновление [dbo].[get_department]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_department]';


GO
PRINT N'Выполняется обновление [dbo].[get_employees_birthday]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_employees_birthday]';


GO
PRINT N'Выполняется обновление [dbo].[get_organization_link_count]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_organization_link_count]';


GO
PRINT N'Выполняется обновление [dbo].[get_position_link_count]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_position_link_count]';


GO
PRINT N'Выполняется обновление [dbo].[close_employee]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[close_employee]';


GO
PRINT N'Выполняется обновление [dbo].[get_organization]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_organization]';


GO
PRINT N'Выполняется обновление [dbo].[get_position]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_position]';


GO
PRINT N'Выполняется обновление [dbo].[close_organization]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[close_organization]';


GO
PRINT N'Выполняется обновление [dbo].[close_position]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[close_position]';


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
delete employee_states where id between 1 and 4
GO

insert into employee_states (id, name, sys_name, display_in_list, enabled)
values(1, N'Кандидат', N'CANDIDATE', 1, 0)
insert into employee_states (id, name, sys_name, display_in_list)
values(2, N'Сотрудник', N'STUFF', 1)
insert into employee_states (id, name, sys_name, display_in_list)
values(3, N'Декрет', N'DECREE', 0)
insert into employee_states (id, name, sys_name, display_in_list)
values(4, N'Уволен', N'FIRED', 0)

--:r .\ins_orgs.sql
--:r .\ins_cities.sql
--:r .\ins_positions.sql
GO

GO
PRINT N'Обновление завершено.';


GO
