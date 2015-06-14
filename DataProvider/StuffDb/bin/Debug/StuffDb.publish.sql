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
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET PAGE_VERIFY NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Операция рефакторинга Rename с помощью ключа 7925ff97-a267-45fb-a848-6fa5f2fe5653 пропущена, элемент [dbo].[employee].[Id] (SqlSimpleColumn) не будет переименован в id';


GO
PRINT N'Операция рефакторинга Rename с помощью ключа a3723de1-4beb-4652-a154-46de2422ba12 пропущена, элемент [dbo].[employee].[tel_num] (SqlSimpleColumn) не будет переименован в work_num';


GO
PRINT N'Операция рефакторинга Rename с помощью ключа d7ee292b-9850-440d-9616-d8a8f37c8ae0 пропущена, элемент [dbo].[organizations].[Id] (SqlSimpleColumn) не будет переименован в id';


GO
PRINT N'Операция рефакторинга Rename с помощью ключа eb2ab5df-e261-4998-a95f-ae5bfb59155b пропущена, элемент [dbo].[positions].[Id] (SqlSimpleColumn) не будет переименован в id';


GO
PRINT N'Операция рефакторинга Rename с помощью ключа e7f65736-d392-41b7-8ebb-9f4ba1dee9dd пропущена, элемент [dbo].[employee_states].[Id] (SqlSimpleColumn) не будет переименован в id';


GO
PRINT N'Операция рефакторинга Rename с помощью ключа d2eaf850-694c-4a9e-859c-9510f62c3a6d пропущена, элемент [dbo].[departments].[Id] (SqlSimpleColumn) не будет переименован в id';


GO
PRINT N'Операция рефакторинга Rename с помощью ключа 10667296-64fc-4f83-8fef-3cf8692fb187 пропущена, элемент [dbo].[departments].[id_] (SqlSimpleColumn) не будет переименован в id_chief';


GO
PRINT N'Операция рефакторинга Rename с помощью ключа cd1f7aba-4005-420b-b279-54526660c2c6 пропущена, элемент [dbo].[photos].[Id] (SqlSimpleColumn) не будет переименован в id';


GO
PRINT N'Операция рефакторинга Rename с помощью ключа e85b3eb9-eb91-41bc-8f17-3350b8f8734a пропущена, элемент [dbo].[cities].[Id] (SqlSimpleColumn) не будет переименован в id';


GO
PRINT N'Выполняется создание [dbo].[cities]...';


GO
CREATE TABLE [dbo].[cities] (
    [id]      INT           IDENTITY (1, 1) NOT NULL,
    [name]    NVARCHAR (50) NOT NULL,
    [enabled] BIT           NOT NULL,
    [dattim1] DATETIME      NOT NULL,
    [dattim2] DATETIME      NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[departments]...';


GO
CREATE TABLE [dbo].[departments] (
    [id]        INT           IDENTITY (1, 1) NOT NULL,
    [name]      NVARCHAR (50) NOT NULL,
    [id_parent] INT           NOT NULL,
    [enabled]   BIT           NOT NULL,
    [dattim1]   DATETIME      NOT NULL,
    [dattim2]   DATETIME      NOT NULL,
    [id_chief]  INT           NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[employee]...';


GO
CREATE TABLE [dbo].[employee] (
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
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[employee].[IX_employee_id_department]...';


GO
CREATE NONCLUSTERED INDEX [IX_employee_id_department]
    ON [dbo].[employee]([id_department] ASC);


GO
PRINT N'Выполняется создание [dbo].[employee].[IX_employee_id_manager]...';


GO
CREATE NONCLUSTERED INDEX [IX_employee_id_manager]
    ON [dbo].[employee]([id_manager] ASC);


GO
PRINT N'Выполняется создание [dbo].[employee].[IX_employee_ad_sid]...';


GO
CREATE NONCLUSTERED INDEX [IX_employee_ad_sid]
    ON [dbo].[employee]([ad_sid] ASC);


GO
PRINT N'Выполняется создание [dbo].[employee].[IX_employee_id_emp_state]...';


GO
CREATE NONCLUSTERED INDEX [IX_employee_id_emp_state]
    ON [dbo].[employee]([id_emp_state] ASC);


GO
PRINT N'Выполняется создание [dbo].[employee].[IX_employee_enabled]...';


GO
CREATE NONCLUSTERED INDEX [IX_employee_enabled]
    ON [dbo].[employee]([enabled] DESC);


GO
PRINT N'Выполняется создание [dbo].[employee_states]...';


GO
CREATE TABLE [dbo].[employee_states] (
    [id]       INT           IDENTITY (1, 1) NOT NULL,
    [name]     NVARCHAR (50) NOT NULL,
    [sys_name] NVARCHAR (50) NOT NULL,
    [enabled]  BIT           NOT NULL,
    [dattim1]  DATETIME      NOT NULL,
    [dattim2]  DATETIME      NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[organizations]...';


GO
CREATE TABLE [dbo].[organizations] (
    [id]       INT           IDENTITY (1, 1) NOT NULL,
    [name]     NVARCHAR (50) NOT NULL,
    [sys_name] NVARCHAR (50) NOT NULL,
    [enaled]   BIT           NOT NULL,
    [dattim1]  DATETIME      NOT NULL,
    [dattim2]  DATETIME      NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[photos]...';


GO
CREATE TABLE [dbo].[photos] (
    [id]          INT             IDENTITY (1, 1) NOT NULL,
    [id_employee] INT             NOT NULL,
    [enabled]     BIT             NOT NULL,
    [dattim1]     DATETIME        NOT NULL,
    [dattim2]     DATETIME        NOT NULL,
    [path]        NVARCHAR (4000) NULL,
    [picture]     VARBINARY (MAX) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[photos].[IX_photos_id_employee]...';


GO
CREATE NONCLUSTERED INDEX [IX_photos_id_employee]
    ON [dbo].[photos]([id_employee] ASC);


GO
PRINT N'Выполняется создание [dbo].[positions]...';


GO
CREATE TABLE [dbo].[positions] (
    [id]       INT           IDENTITY (1, 1) NOT NULL,
    [name]     NVARCHAR (50) NOT NULL,
    [sys_name] NVARCHAR (50) NOT NULL,
    [enabled]  BIT           NOT NULL,
    [dattim1]  DATETIME      NOT NULL,
    [dattim2]  DATETIME      NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[cities]...';


GO
ALTER TABLE [dbo].[cities]
    ADD DEFAULT 1 FOR [enabled];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[cities]...';


GO
ALTER TABLE [dbo].[cities]
    ADD DEFAULT getdate() FOR [dattim1];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[cities]...';


GO
ALTER TABLE [dbo].[cities]
    ADD DEFAULT '3.3.3333' FOR [dattim2];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[departments]...';


GO
ALTER TABLE [dbo].[departments]
    ADD DEFAULT 1 FOR [enabled];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[departments]...';


GO
ALTER TABLE [dbo].[departments]
    ADD DEFAULT getdate() FOR [dattim1];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[departments]...';


GO
ALTER TABLE [dbo].[departments]
    ADD DEFAULT '3.3.3333' FOR [dattim2];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[employee]...';


GO
ALTER TABLE [dbo].[employee]
    ADD DEFAULT '' FOR [ad_sid];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[employee]...';


GO
ALTER TABLE [dbo].[employee]
    ADD DEFAULT 1 FOR [enabled];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[employee]...';


GO
ALTER TABLE [dbo].[employee]
    ADD DEFAULT getdate() FOR [dattim1];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[employee]...';


GO
ALTER TABLE [dbo].[employee]
    ADD DEFAULT '3.3.3333' FOR [dattim2];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[employee_states]...';


GO
ALTER TABLE [dbo].[employee_states]
    ADD DEFAULT 1 FOR [enabled];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[employee_states]...';


GO
ALTER TABLE [dbo].[employee_states]
    ADD DEFAULT getdate() FOR [dattim1];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[employee_states]...';


GO
ALTER TABLE [dbo].[employee_states]
    ADD DEFAULT '3.3.3333' FOR [dattim2];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[organizations]...';


GO
ALTER TABLE [dbo].[organizations]
    ADD DEFAULT 1 FOR [enaled];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[organizations]...';


GO
ALTER TABLE [dbo].[organizations]
    ADD DEFAULT getdate() FOR [dattim1];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[organizations]...';


GO
ALTER TABLE [dbo].[organizations]
    ADD DEFAULT '3.3.3333' FOR [dattim2];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[photos]...';


GO
ALTER TABLE [dbo].[photos]
    ADD DEFAULT 1 FOR [enabled];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[photos]...';


GO
ALTER TABLE [dbo].[photos]
    ADD DEFAULT getdate() FOR [dattim1];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[photos]...';


GO
ALTER TABLE [dbo].[photos]
    ADD DEFAULT '3.3.3333' FOR [dattim2];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[positions]...';


GO
ALTER TABLE [dbo].[positions]
    ADD DEFAULT 1 FOR [enabled];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[positions]...';


GO
ALTER TABLE [dbo].[positions]
    ADD DEFAULT getdate() FOR [dattim1];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[positions]...';


GO
ALTER TABLE [dbo].[positions]
    ADD DEFAULT '3.3.3333' FOR [dattim2];


GO
-- Выполняется этап рефакторинга для обновления развернутых журналов транзакций на целевом сервере

IF OBJECT_ID(N'dbo.__RefactorLog') IS NULL
BEGIN
    CREATE TABLE [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
    EXEC sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
END
GO
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '7925ff97-a267-45fb-a848-6fa5f2fe5653')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('7925ff97-a267-45fb-a848-6fa5f2fe5653')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'bab710db-a69c-4cfd-81f9-4b289c99f088')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('bab710db-a69c-4cfd-81f9-4b289c99f088')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '823082de-8dc5-4c99-a8dd-ef76401ff9e8')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('823082de-8dc5-4c99-a8dd-ef76401ff9e8')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'a3723de1-4beb-4652-a154-46de2422ba12')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('a3723de1-4beb-4652-a154-46de2422ba12')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'd7ee292b-9850-440d-9616-d8a8f37c8ae0')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('d7ee292b-9850-440d-9616-d8a8f37c8ae0')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'eb2ab5df-e261-4998-a95f-ae5bfb59155b')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('eb2ab5df-e261-4998-a95f-ae5bfb59155b')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'e7f65736-d392-41b7-8ebb-9f4ba1dee9dd')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('e7f65736-d392-41b7-8ebb-9f4ba1dee9dd')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'd2eaf850-694c-4a9e-859c-9510f62c3a6d')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('d2eaf850-694c-4a9e-859c-9510f62c3a6d')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '10667296-64fc-4f83-8fef-3cf8692fb187')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('10667296-64fc-4f83-8fef-3cf8692fb187')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'cd1f7aba-4005-420b-b279-54526660c2c6')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('cd1f7aba-4005-420b-b279-54526660c2c6')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'e85b3eb9-eb91-41bc-8f17-3350b8f8734a')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('e85b3eb9-eb91-41bc-8f17-3350b8f8734a')

GO

GO
PRINT N'Обновление завершено.';


GO
