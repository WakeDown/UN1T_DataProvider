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
PRINT N'Выполняется изменение [dbo].[employees]...';


GO
ALTER TABLE [dbo].[employees]
    ADD [date_fired] DATE NULL;


GO
PRINT N'Выполняется обновление [dbo].[departments_view]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[departments_view]';


GO
PRINT N'Выполняется обновление [dbo].[employees_report]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[employees_report]';


GO
PRINT N'Выполняется обновление [dbo].[employees_view]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[employees_view]';


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
	@creator_sid varchar(46)=null,
	@date_fired date = null
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
                        --id_emp_state = @id_emp_state ,
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
PRINT N'Выполняется создание [dbo].[set_employee_date_fired]...';


GO
CREATE PROCEDURE [dbo].[set_employee_date_fired]
	@id_employee int,
	@date_fired date
	as begin set nocount on;
	update employees
	set date_fired=@date_fired
	where id=@id_employee
	end
GO
PRINT N'Выполняется обновление [dbo].[close_employee]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[close_employee]';


GO
PRINT N'Выполняется обновление [dbo].[get_employee]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_employee]';


GO
PRINT N'Выполняется обновление [dbo].[get_other_employee_list]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_other_employee_list]';


GO
PRINT N'Выполняется обновление [dbo].[set_employee_state]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[set_employee_state]';


GO
PRINT N'Выполняется обновление [dbo].[get_department]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_department]';


GO
PRINT N'Выполняется обновление [dbo].[get_city]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_city]';


GO
PRINT N'Выполняется обновление [dbo].[get_city_link_count]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_city_link_count]';


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
PRINT N'Выполняется обновление [dbo].[get_organization]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_organization]';


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
