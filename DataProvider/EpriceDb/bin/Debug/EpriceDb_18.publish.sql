/*
Скрипт развертывания для e_price

Этот код был создан программным средством.
Изменения, внесенные в этот файл, могут привести к неверному выполнению кода и будут потеряны
в случае его повторного формирования.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "e_price"
:setvar DefaultFilePrefix "e_price"
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
Тип столбца sid в таблице [dbo].[catalog_categories] на данный момент -  UNIQUEIDENTIFIER NOT NULL, но будет изменен на  BIGINT IDENTITY (1, 1) NOT NULL. Отсутствует неявное или явное преобразование.
*/

IF EXISTS (select top 1 1 from [dbo].[catalog_categories])
    RAISERROR (N'Обнаружены строки. Обновление схемы завершено из-за возможной потери данных.', 16, 127) WITH NOWAIT

GO
/*
Тип столбца sid в таблице [dbo].[catalog_products] на данный момент -  UNIQUEIDENTIFIER NOT NULL, но будет изменен на  BIGINT IDENTITY (1, 1) NOT NULL. Отсутствует неявное или явное преобразование.
*/

IF EXISTS (select top 1 1 from [dbo].[catalog_products])
    RAISERROR (N'Обнаружены строки. Обновление схемы завершено из-за возможной потери данных.', 16, 127) WITH NOWAIT

GO
PRINT N'Выполняется удаление ограничение без названия для [dbo].[catalog_categories]...';


GO
ALTER TABLE [dbo].[catalog_categories] DROP CONSTRAINT [DF__catalog_c__id_pa__2F10007B];


GO
PRINT N'Выполняется удаление ограничение без названия для [dbo].[catalog_categories]...';


GO
ALTER TABLE [dbo].[catalog_categories] DROP CONSTRAINT [DF__catalog_c__datti__300424B4];


GO
PRINT N'Выполняется удаление ограничение без названия для [dbo].[catalog_categories]...';


GO
ALTER TABLE [dbo].[catalog_categories] DROP CONSTRAINT [DF__catalog_c__enabl__30F848ED];


GO
PRINT N'Выполняется удаление ограничение без названия для [dbo].[catalog_categories]...';


GO
ALTER TABLE [dbo].[catalog_categories] DROP CONSTRAINT [DF__catalog_cat__sid__31EC6D26];


GO
PRINT N'Выполняется удаление ограничение без названия для [dbo].[catalog_products]...';


GO
ALTER TABLE [dbo].[catalog_products] DROP CONSTRAINT [DF__catalog_p__price__33D4B598];


GO
PRINT N'Выполняется удаление ограничение без названия для [dbo].[catalog_products]...';


GO
ALTER TABLE [dbo].[catalog_products] DROP CONSTRAINT [DF__catalog_p__id_cu__34C8D9D1];


GO
PRINT N'Выполняется удаление ограничение без названия для [dbo].[catalog_products]...';


GO
ALTER TABLE [dbo].[catalog_products] DROP CONSTRAINT [DF__catalog_p__datti__35BCFE0A];


GO
PRINT N'Выполняется удаление ограничение без названия для [dbo].[catalog_products]...';


GO
ALTER TABLE [dbo].[catalog_products] DROP CONSTRAINT [DF__catalog_p__enabl__36B12243];


GO
PRINT N'Выполняется удаление ограничение без названия для [dbo].[catalog_products]...';


GO
ALTER TABLE [dbo].[catalog_products] DROP CONSTRAINT [DF__catalog_p__part___37A5467C];


GO
PRINT N'Выполняется удаление ограничение без названия для [dbo].[catalog_products]...';


GO
ALTER TABLE [dbo].[catalog_products] DROP CONSTRAINT [DF__catalog_pro__sid__398D8EEE];


GO
PRINT N'Выполняется запуск перестройки таблицы [dbo].[catalog_categories]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_catalog_categories] (
    [id_provider] INT            NOT NULL,
    [name]        NVARCHAR (500) NOT NULL,
    [id]          NVARCHAR (50)  NOT NULL,
    [id_parent]   NVARCHAR (50)  DEFAULT '' NOT NULL,
    [dattim1]     DATETIME       DEFAULT getdate() NOT NULL,
    [enabled]     BIT            DEFAULT 1 NOT NULL,
    [sid]         BIGINT         IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_catalog_categories] PRIMARY KEY CLUSTERED ([sid] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[catalog_categories])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_catalog_categories] ON;
        INSERT INTO [dbo].[tmp_ms_xx_catalog_categories] ([sid], [id_provider], [name], [id], [id_parent], [dattim1], [enabled])
        SELECT   [sid],
                 [id_provider],
                 [name],
                 [id],
                 [id_parent],
                 [dattim1],
                 [enabled]
        FROM     [dbo].[catalog_categories]
        ORDER BY [sid] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_catalog_categories] OFF;
    END

DROP TABLE [dbo].[catalog_categories];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_catalog_categories]', N'catalog_categories';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_catalog_categories]', N'PK_catalog_categories', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Выполняется создание [dbo].[catalog_categories].[IX_catalog_categories_enabled]...';


GO
CREATE NONCLUSTERED INDEX [IX_catalog_categories_enabled]
    ON [dbo].[catalog_categories]([enabled] DESC);


GO
PRINT N'Выполняется создание [dbo].[catalog_categories].[IX_catalog_categories_id_provider]...';


GO
CREATE NONCLUSTERED INDEX [IX_catalog_categories_id_provider]
    ON [dbo].[catalog_categories]([id_provider] ASC);


GO
PRINT N'Выполняется запуск перестройки таблицы [dbo].[catalog_products]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_catalog_products] (
    [name]         NVARCHAR (MAX)  NOT NULL,
    [price]        DECIMAL (10, 2) DEFAULT 0 NOT NULL,
    [id_currency]  INT             DEFAULT 1 NOT NULL,
    [dattim1]      DATETIME        DEFAULT getdate() NOT NULL,
    [enabled]      BIT             DEFAULT 1 NOT NULL,
    [part_number]  NVARCHAR (50)   DEFAULT '' NOT NULL,
    [id]           NVARCHAR (50)   NOT NULL,
    [sid]          BIGINT          IDENTITY (1, 1) NOT NULL,
    [sid_cat]      VARCHAR (46)    NOT NULL,
    [vendor]       NVARCHAR (500)  NULL,
    [currency_str] NVARCHAR (20)   NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_catalog_products] PRIMARY KEY CLUSTERED ([sid] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[catalog_products])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_catalog_products] ON;
        INSERT INTO [dbo].[tmp_ms_xx_catalog_products] ([sid], [name], [price], [id_currency], [dattim1], [enabled], [part_number], [id], [sid_cat], [vendor], [currency_str])
        SELECT   [sid],
                 [name],
                 [price],
                 [id_currency],
                 [dattim1],
                 [enabled],
                 [part_number],
                 [id],
                 [sid_cat],
                 [vendor],
                 [currency_str]
        FROM     [dbo].[catalog_products]
        ORDER BY [sid] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_catalog_products] OFF;
    END

DROP TABLE [dbo].[catalog_products];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_catalog_products]', N'catalog_products';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_catalog_products]', N'PK_catalog_products', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Выполняется обновление [dbo].[save_catalog_category]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[save_catalog_category]';


GO
PRINT N'Выполняется обновление [dbo].[save_catalog_product]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[save_catalog_product]';


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
DELETE product_providers

insert into product_providers (id, name, sys_name)
values (1, N'Treolan', N'TREOLAN')

insert into product_providers (id, name, sys_name)
values (2, N'Merlion', N'MERLION')

insert into product_providers (id, name, sys_name)
values (3, N'OCS', N'OCS')

insert into product_providers (id, name, sys_name)
values (4, N'Oldi', N'OLDI')
GO

GO
PRINT N'Обновление завершено.';


GO
