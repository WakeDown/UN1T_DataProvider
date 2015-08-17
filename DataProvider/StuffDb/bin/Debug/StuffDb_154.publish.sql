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
    ADD [full_name_dat] NVARCHAR (150) NULL,
        [full_name_vin] NVARCHAR (150) NULL;


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
PRINT N'Выполняется изменение [dbo].[get_employee]...';


GO
ALTER PROCEDURE [dbo].[get_employee]
    @id INT = NULL ,
    @get_photo BIT = 0 ,
	@ad_sid VARCHAR(46) = NULL
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  e.id ,
                ad_sid ,
                id_manager ,
                surname ,
                e.name ,
                patronymic ,
                e.full_name ,
                display_name ,
                id_position ,
                id_organization ,
                e.email ,
                work_num ,
                mobil_num ,
                id_emp_state ,
                id_department ,
                id_city ,
                date_came ,
                birth_date ,
                ( SELECT    e2.display_name
                  FROM      employees e2
                  WHERE     e2.id = e.id_manager
                ) AS manager,
                ( SELECT    e2.email
                  FROM      employees e2
                  WHERE     e2.id = e.id_manager
                ) AS manager_email ,
                es.name AS emp_state ,
				es.sys_name as emp_state_sys_name,
                p.name AS position ,
                o.name AS organization ,
                c.name AS city ,
                d.name AS department ,
				case when male=1 then 1 else 0 end as male,
				id_position_org,
				p_org.name as position_org,
				CASE WHEN e.has_ad_account = 1 THEN 1 ELSE 0 END AS has_ad_account,
				ad_login,
				e.dattim1 as date_create
				,
				CASE WHEN @get_photo = 1
                     THEN ( SELECT TOP 1
                                    picture
                            FROM    photos ph
                            WHERE   ph.enabled = 1
                                    AND ph.id_employee = e.id
                          )
                     ELSE NULL
                END AS photo,
				full_name_dat,
				full_name_vin
				--,
				--CASE WHEN @id_department IS NOT NULL THEN 
				--CASE WHEN EXISTS(SELECT 1 FROM departments dd WHERE dd.id=@id_department AND dd.id_chief=e.id) THEN 0 ELSE 1 end
				--ELSE NULL END AS is_chief
        FROM    employees e
		INNER JOIN employee_states es ON e.id_emp_state = es.id
                INNER JOIN positions p ON e.id_position = p.id
				INNER JOIN positions p_org ON e.id_position_org = p_org.id
                INNER JOIN organizations o ON e.id_organization = o.id
                INNER JOIN cities c ON e.id_city = c.id
                INNER JOIN departments d ON e.id_department = d.id
        WHERE ((@id is null or @id <= 0) or (@id is not null and @id > 0 and e.id = @id))
		and ((@ad_sid is null or @ad_sid = '') or (@ad_sid is not null and @ad_sid != '' and e.ad_sid = @ad_sid))
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
	@creator_sid varchar(46)=null,
	@date_fired date = null,
	@full_name_dat nvarchar(150) = null,
	@full_name_vin nvarchar(150) = null
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
						has_ad_account = @has_ad_account,
						full_name_dat = @full_name_dat,
						full_name_vin = @full_name_vin
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
						  creator_sid,
						  full_name_dat,
						  full_name_vin
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
						  @creator_sid,
						  @full_name_dat,
						  @full_name_vin
                        )

                SELECT  @id = @@IDENTITY
            END
	 
        SELECT @id AS id
    END
GO
PRINT N'Выполняется обновление [dbo].[close_employee]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[close_employee]';


GO
PRINT N'Выполняется обновление [dbo].[get_other_employee_list]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_other_employee_list]';


GO
PRINT N'Выполняется обновление [dbo].[set_employee_date_fired]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[set_employee_date_fired]';


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
