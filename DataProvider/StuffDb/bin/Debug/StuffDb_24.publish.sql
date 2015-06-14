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
PRINT N'Выполняется удаление ограничение без названия для [dbo].[employee_states]...';


GO
ALTER TABLE [dbo].[employee_states] DROP CONSTRAINT [DF__employee___enabl__21B6055D];


GO
PRINT N'Выполняется удаление ограничение без названия для [dbo].[employee_states]...';


GO
ALTER TABLE [dbo].[employee_states] DROP CONSTRAINT [DF__employee___datti__22AA2996];


GO
PRINT N'Выполняется удаление ограничение без названия для [dbo].[employee_states]...';


GO
ALTER TABLE [dbo].[employee_states] DROP CONSTRAINT [DF__employee___datti__239E4DCF];


GO
PRINT N'Выполняется удаление ограничение без названия для [dbo].[employee_states]...';


GO
ALTER TABLE [dbo].[employee_states] DROP CONSTRAINT [DF__employee___displ__4222D4EF];


GO
PRINT N'Выполняется удаление ограничение без названия для [dbo].[employee_states]...';


GO
ALTER TABLE [dbo].[employee_states] DROP CONSTRAINT [DF__employee___order__4316F928];


GO
PRINT N'Выполняется запуск перестройки таблицы [dbo].[employee_states]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_employee_states] (
    [id]              INT           NOT NULL,
    [name]            NVARCHAR (50) NOT NULL,
    [sys_name]        NVARCHAR (50) NOT NULL,
    [enabled]         BIT           DEFAULT 1 NOT NULL,
    [dattim1]         DATETIME      DEFAULT getdate() NOT NULL,
    [dattim2]         DATETIME      DEFAULT '3.3.3333' NOT NULL,
    [display_in_list] BIT           DEFAULT 1 NOT NULL,
    [order_num]       INT           DEFAULT 500 NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[employee_states])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_employee_states] ([id], [name], [sys_name], [enabled], [dattim1], [dattim2], [display_in_list], [order_num])
        SELECT   [id],
                 [name],
                 [sys_name],
                 [enabled],
                 [dattim1],
                 [dattim2],
                 [display_in_list],
                 [order_num]
        FROM     [dbo].[employee_states]
        ORDER BY [id] ASC;
    END

DROP TABLE [dbo].[employee_states];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_employee_states]', N'employee_states';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Выполняется обновление [dbo].[get_emp_state]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_emp_state]';


GO
PRINT N'Выполняется обновление [dbo].[get_employee]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_employee]';


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

delete organizations --where id between 1 and 4
GO
insert into organizations (name, display_in_list, full_name)
values ( 'Копир', 1, 'ООО "Юнит-Копир"')
insert into organizations (id, name, display_in_list, full_name)
values ( 'УК', 1, 'ООО "Управляющая компания ЮНИТ"')
insert into organizations (id, name, display_in_list, full_name)
values ('Коммуникации', 1, 'ООО "Юнит-Коммуникации"')
insert into organizations (id, name, display_in_list, full_name)
values ('Компьютер', 1, 'ООО "Юнит-Компьютер"')
delete cities --where id between 1 and 5
GO
insert into cities (id, name)
values('Екатеринбург')
insert into cities (id, name)
values('Москва')
insert into cities (id, name)
values('Челябинск')
insert into cities (id, name)
values('Пермь')
insert into cities (id, name)
values('Нягань')
delete positions --where id between 1 and 5
GO
insert into positions (name)
values ('Директор')
insert into positions (id, name)
values ('Руководитель')
insert into positions (id, name)
values ('Менеджер')
insert into positions (id, name)
values ('Оператор')
insert into positions (id, name)
values ('Инженер')
GO

GO
PRINT N'Обновление завершено.';


GO
