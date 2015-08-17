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
ALTER TABLE [dbo].[organizations] ALTER COLUMN [name] NVARCHAR (150) NOT NULL;


GO
ALTER TABLE [dbo].[organizations]
    ADD [sys_name] NVARCHAR (50) NULL;


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
ALTER PROCEDURE [dbo].[get_organization] @id INT = NULL, @sys_name nvarchar(50) = null
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
					AND ( @sys_name IS NULL or @sys_name = ''
                      OR ( @sys_name IS NOT NULL
                           AND @sys_name != ''
                           AND o.sys_name = @sys_name
                         )
                    )
        ORDER BY name
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
PRINT N'Выполняется обновление [dbo].[save_organization]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[save_organization]';


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
