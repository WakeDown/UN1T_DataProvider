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
Удаляется столбец [dbo].[organizations].[sys_name], возможна потеря данных.
*/

IF EXISTS (select top 1 1 from [dbo].[organizations])
    RAISERROR (N'Обнаружены строки. Обновление схемы завершено из-за возможной потери данных.', 16, 127) WITH NOWAIT

GO
/*
Удаляется столбец [dbo].[positions].[sys_name], возможна потеря данных.
*/

IF EXISTS (select top 1 1 from [dbo].[positions])
    RAISERROR (N'Обнаружены строки. Обновление схемы завершено из-за возможной потери данных.', 16, 127) WITH NOWAIT

GO
PRINT N'Указанная ниже операция создана из файла журнала рефакторинга 5296580b-af79-40ef-8058-a120eee6eb0e';

PRINT N'Переименование [dbo].[organizations].[enaled] в enabled';


GO
EXECUTE sp_rename @objname = N'[dbo].[organizations].[enaled]', @newname = N'enabled', @objtype = N'COLUMN';


GO
PRINT N'Операция рефакторинга Rename с помощью ключа a5e503e6-194d-4807-bdf8-ea81dfd26fdb пропущена, элемент [dbo].[organizations].[display] (SqlSimpleColumn) не будет переименован в display_in_list';


GO
PRINT N'Операция рефакторинга Rename с помощью ключа 5db26c6e-1291-40f2-b192-769be44d3ae7 пропущена, элемент [dbo].[employee_states].[list_display] (SqlSimpleColumn) не будет переименован в display_in_list';


GO
PRINT N'Операция рефакторинга Rename с помощью ключа dd3b36f5-0a82-4dad-8ed1-083e4fdc1852 пропущена, элемент [dbo].[employee_states].[order] (SqlSimpleColumn) не будет переименован в order_num';


GO
PRINT N'Выполняется изменение [dbo].[cities]...';


GO
ALTER TABLE [dbo].[cities]
    ADD [order_num] INT DEFAULT 500 NOT NULL;


GO
PRINT N'Выполняется изменение [dbo].[employee_states]...';


GO
ALTER TABLE [dbo].[employee_states]
    ADD [display_in_list] BIT DEFAULT 1 NOT NULL,
        [order_num]       INT DEFAULT 500 NOT NULL;


GO
PRINT N'Выполняется изменение [dbo].[organizations]...';


GO
ALTER TABLE [dbo].[organizations] DROP COLUMN [sys_name];


GO
ALTER TABLE [dbo].[organizations]
    ADD [display_in_list] BIT            DEFAULT 1 NOT NULL,
        [full_name]       NVARCHAR (500) NULL,
        [order_num]       INT            DEFAULT 500 NOT NULL;


GO
PRINT N'Выполняется изменение [dbo].[positions]...';


GO
ALTER TABLE [dbo].[positions] DROP COLUMN [sys_name];


GO
ALTER TABLE [dbo].[positions]
    ADD [order_num] INT DEFAULT 500 NOT NULL;


GO
PRINT N'Выполняется изменение [dbo].[get_employee]...';


GO
ALTER PROCEDURE [dbo].[get_employee]
    @id INT = NULL ,
    @in_stuff BIT = 1 ,
    @id_emp_state INT = NULL ,
    @get_photo BIT = 0
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
                email ,
                work_num ,
                mobil_num ,
                id_emp_state ,
                id_department ,
                id_city ,
                date_came ,
                birth_date ,
                es.name AS emp_state ,
                p.name AS position ,
                o.name AS organization ,
                c.name AS city ,
                d.name AS department ,
                CASE WHEN @get_photo = 1 THEN 
				(select top 1 picture from photos ph where ph.enabled=1 and ph.id_employee=e.id)
                     ELSE null
                END AS photo
        FROM    employees e
                INNER JOIN employee_states es ON e.id_emp_state = es.id
                INNER JOIN positions p ON e.id_position = p.id
                INNER JOIN organizations o ON e.id_organization = o.id
                INNER JOIN cities c ON e.id_city = c.id
                INNER JOIN departments d ON e.id_department = d.id
        WHERE   e.enabled = 1
                AND ( @in_stuff = 0
                      OR ( @in_stuff = 1
                           AND es.sys_name IN ( 'STUFF', 'DECREE' )
                         )
                    )
                AND ( ( @id_emp_state IS NULL )
                      OR ( @id_emp_state IS NOT NULL
                           AND e.id_emp_state = @id_emp_state
                         )
                    )
                AND ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND e.id = @id
                         )
                    )
    END
GO
PRINT N'Выполняется создание [dbo].[get_city]...';


GO
CREATE PROCEDURE [dbo].[get_city]
	@id int = null
	
AS
begin
SET NOCOUNT ON;
	select id, name from cities c
	where c.enabled=1
	AND ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND c.id = @id
                         )
                    )
end
GO
PRINT N'Выполняется создание [dbo].[get_emp_state]...';


GO
CREATE PROCEDURE [dbo].[get_emp_state]
	@id int = null,
	@get_all bit = 0,
	@sys_name nvarchar(20) = null
AS
begin
SET NOCOUNT ON;
	select id, name from employee_states es
	where es.enabled=1
	and (@get_all=0 or (@get_all=1 and es.display_in_list = 1))
	and ((@sys_name is null and ltrim(rtrim(@sys_name)) = '') or (@sys_name is not null and rtrim(ltrim(@sys_name))<>'' and sys_name=@sys_name))
	AND ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND es.id = @id
                         )
                    )
end
GO
PRINT N'Выполняется создание [dbo].[get_organization]...';


GO
CREATE PROCEDURE [dbo].[get_organization]
	@id int =null
AS
begin
SET NOCOUNT ON;
	select id, name from organizations o
	where o.enabled=1
	AND ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND o.id = @id
                         )
                    )
end
GO
PRINT N'Выполняется создание [dbo].[get_position]...';


GO
CREATE PROCEDURE [dbo].[get_position]
	@id int = null
AS
begin
SET NOCOUNT ON;
	select id, name from positions p
	where p.enabled=1
	AND ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND p.id = @id
                         )
                    )
end
GO
PRINT N'Выполняется создание [dbo].[save_photo]...';


GO
CREATE PROCEDURE [dbo].[save_photo]
    @id_employee INT ,
    @picture IMAGE
AS
    BEGIN
        SET nocount ON;
        IF EXISTS ( SELECT  1
                    FROM    photos p
                    WHERE   p.id_employee = @id_employee )
            BEGIN
                UPDATE  photos
                SET     picture = @picture
            END
        ELSE
            BEGIN
                INSERT  INTO photos
                        ( picture )
                VALUES  ( @picture )
            END
    END
GO
-- Выполняется этап рефакторинга для обновления развернутых журналов транзакций на целевом сервере
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '5296580b-af79-40ef-8058-a120eee6eb0e')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('5296580b-af79-40ef-8058-a120eee6eb0e')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'a5e503e6-194d-4807-bdf8-ea81dfd26fdb')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('a5e503e6-194d-4807-bdf8-ea81dfd26fdb')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '5db26c6e-1291-40f2-b192-769be44d3ae7')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('5db26c6e-1291-40f2-b192-769be44d3ae7')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'dd3b36f5-0a82-4dad-8ed1-083e4fdc1852')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('dd3b36f5-0a82-4dad-8ed1-083e4fdc1852')

GO

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

insert into employee_states (id, name, sys_name, display_in_list)
values(1, 'Кандидат', 'CANDIDATE', 1)
insert into employee_states (id, name, sys_name, display_in_list)
values(2, 'Сотрудник', 'STUFF', 1)
insert into employee_states (id, name, sys_name, display_in_list)
values(3, 'Декрет', 'DECREE', 0)
insert into employee_states (id, name, sys_name, display_in_list)
values(4, 'Уволен', 'FIRED', 0)

delete organizations where id between 1 and 4
GO
insert into organizations (id, name, display_in_list, full_name)
values (1, 'Копир', 1, 'ООО "Юнит-Копир"')
insert into organizations (id, name, display_in_list, full_name)
values (2, 'УК', 1, 'ООО "Управляющая компания ЮНИТ"')
insert into organizations (id, name, display_in_list, full_name)
values (3, 'Коммуникации', 1, 'ООО "Юнит-Коммуникации"')
insert into organizations (id, name, display_in_list, full_name)
values (4, 'Компьютер', 1, 'ООО "Юнит-Компьютер"')
delete cities where id between 1 and 5
GO
insert into cities (id, name)
values(1, 'Екатеринбург')
insert into cities (id, name)
values(2, 'Москва')
insert into cities (id, name)
values(3, 'Челябинск')
insert into cities (id, name)
values(4, 'Пермь')
insert into cities (id, name)
values(5, 'Нягань')
delete positions where id between 1 and 5
GO
insert into positions (id, name)
values (1, 'Директор')
insert into positions (id, name)
values (2, 'Руководитель')
insert into positions (id, name)
values (3, 'Менеджер')
insert into positions (id, name)
values (4, 'Оператор')
insert into positions (id, name)
values (5, 'Инженер')
GO

GO
PRINT N'Обновление завершено.';


GO
