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
PRINT N'Выполняется изменение [dbo].[positions]...';


GO
ALTER TABLE [dbo].[positions]
    ADD [name_dat] NVARCHAR (500) NULL,
        [name_vin] NVARCHAR (500) NULL;


GO
PRINT N'Выполняется обновление [dbo].[employees_report]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[employees_report]';


GO
PRINT N'Выполняется обновление [dbo].[employees_view]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[employees_view]';


GO
PRINT N'Выполняется изменение [dbo].[get_position]...';


GO
ALTER PROCEDURE [dbo].[get_position]
	@id int = null
AS
begin
SET NOCOUNT ON;
	select id, name,
	name_rod,
	(
	select count(1) from employees_view e  where e.id_position=p.id
	) as emp_count
	,name_dat,name_vin
	 from positions p
	where p.enabled=1
	AND ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND p.id = @id
                         )
                    )
					order by name
end
GO
PRINT N'Выполняется изменение [dbo].[save_position]...';


GO
ALTER PROCEDURE [dbo].[save_position]
	@id INT = NULL ,
    @name NVARCHAR(500),
	@creator_sid varchar(46)=NULL,
	@name_rod NVARCHAR(500),
	@name_dat nvarchar(500),
	@name_vin nvarchar(500)
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
                SET     name = @name , name_rod=@name_rod, name_dat=@name_dat, name_vin=@name_vin
                WHERE   id = @id
            END
        ELSE
            BEGIN
                INSERT  INTO positions
                        ( name  ,creator_sid, name_rod,name_dat,name_vin
                        )
                VALUES  ( @name  ,@creator_sid, @name_rod,@name_dat,@name_vin
                        )

						SELECT @id=@@IDENTITY
            END
	 
		SELECT @id AS id
    END
GO
PRINT N'Выполняется обновление [dbo].[close_position]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[close_position]';


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
PRINT N'Выполняется обновление [dbo].[get_organization]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_organization]';


GO
PRINT N'Выполняется обновление [dbo].[get_organization_link_count]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_organization_link_count]';


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
