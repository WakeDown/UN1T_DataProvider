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
PRINT N'Выполняется изменение [dbo].[photos]...';


GO
ALTER TABLE [dbo].[photos]
    ADD [picture_name] NVARCHAR (100) NULL;


GO
PRINT N'Выполняется создание [dbo].[employees]...';


GO
CREATE TABLE [dbo].[employees] (
    [id]              INT            IDENTITY (1, 1) NOT NULL,
    [ad_sid]          VARCHAR (36)   NOT NULL,
    [id_manager]      INT            NOT NULL,
    [surname]         NVARCHAR (50)  NOT NULL,
    [name]            NVARCHAR (50)  NOT NULL,
    [patronymic]      NVARCHAR (50)  NULL,
    [full_name]       NVARCHAR (150) NOT NULL,
    [display_name]    NVARCHAR (150) NOT NULL,
    [id_position]     INT            NOT NULL,
    [id_organization] INT            NOT NULL,
    [email]           NVARCHAR (150) NOT NULL,
    [work_num]        NVARCHAR (50)  NOT NULL,
    [mobil_num]       NVARCHAR (50)  NOT NULL,
    [id_emp_state]    SMALLINT       NOT NULL,
    [id_department]   INT            NOT NULL,
    [id_city]         INT            NOT NULL,
    [enabled]         BIT            NOT NULL,
    [dattim1]         DATETIME       NOT NULL,
    [dattim2]         DATETIME       NOT NULL,
    [date_came]       DATE           NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[employees].[IX_employee_id_department]...';


GO
CREATE NONCLUSTERED INDEX [IX_employee_id_department]
    ON [dbo].[employees]([id_department] ASC);


GO
PRINT N'Выполняется создание [dbo].[employees].[IX_employee_id_manager]...';


GO
CREATE NONCLUSTERED INDEX [IX_employee_id_manager]
    ON [dbo].[employees]([id_manager] ASC);


GO
PRINT N'Выполняется создание [dbo].[employees].[IX_employee_ad_sid]...';


GO
CREATE NONCLUSTERED INDEX [IX_employee_ad_sid]
    ON [dbo].[employees]([ad_sid] ASC);


GO
PRINT N'Выполняется создание [dbo].[employees].[IX_employee_id_emp_state]...';


GO
CREATE NONCLUSTERED INDEX [IX_employee_id_emp_state]
    ON [dbo].[employees]([id_emp_state] ASC);


GO
PRINT N'Выполняется создание [dbo].[employees].[IX_employee_enabled]...';


GO
CREATE NONCLUSTERED INDEX [IX_employee_enabled]
    ON [dbo].[employees]([enabled] DESC);


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[employees]...';


GO
ALTER TABLE [dbo].[employees]
    ADD DEFAULT '' FOR [ad_sid];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[employees]...';


GO
ALTER TABLE [dbo].[employees]
    ADD DEFAULT 1 FOR [enabled];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[employees]...';


GO
ALTER TABLE [dbo].[employees]
    ADD DEFAULT getdate() FOR [dattim1];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[employees]...';


GO
ALTER TABLE [dbo].[employees]
    ADD DEFAULT '3.3.3333' FOR [dattim2];


GO
PRINT N'Обновление завершено.';


GO
