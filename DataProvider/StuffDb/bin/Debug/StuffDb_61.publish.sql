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
PRINT N'Выполняется изменение [dbo].[get_department]...';


GO
ALTER PROCEDURE [dbo].[get_department] @id INT = NULL
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  id ,
                name ,
                id_parent ,
                ( SELECT    name
                  FROM      departments d2
                  WHERE     d2.id = d.id_parent
                ) AS parent ,
                id_chief ,
                ( SELECT    display_name
                  FROM      employees e
                  WHERE     e.id = d.id_chief
                ) AS chief
        FROM    departments d
        WHERE   d.enabled = 1
                AND ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND d.id = @id
                         )
                    )
					order by d.name
    END
GO
PRINT N'Выполняется изменение [dbo].[get_organization]...';


GO
ALTER PROCEDURE [dbo].[get_organization]
	@id int =null
AS
begin
SET NOCOUNT ON;
	select id, name,
	(
	select count(1) from employees e INNER JOIN employee_states es ON e.id_emp_state = es.id where e.enabled=1 and es.sys_name IN ( 'STUFF', 'DECREE' ) and e.id_organization=o.id
	) as emp_count
	from organizations o
	where o.enabled=1
	AND ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND o.id = @id
                         )
                    )
					order by name
end
GO
PRINT N'Выполняется изменение [dbo].[get_position]...';


GO
ALTER PROCEDURE [dbo].[get_position]
	@id int = null
AS
begin
SET NOCOUNT ON;
	select id, name,
	
	(
	select count(1) from employees e INNER JOIN employee_states es ON e.id_emp_state = es.id where e.enabled=1 and es.sys_name IN ( 'STUFF', 'DECREE' ) and e.id_position=p.id
	) as emp_count from positions p
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
