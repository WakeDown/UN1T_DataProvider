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
:setvar DefaultDataPath "E:\mssql\"
:setvar DefaultLogPath "E:\mssql\"

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
Столбец currency_str таблицы [dbo].[catalog_products] необходимо изменить с NULL на NOT NULL. Если таблица содержит данные, скрипт ALTER может оказаться неработоспособным. Чтобы избежать возникновения этой проблемы, необходимо добавить значения этого столбца во все строки, пометить его как допускающий значения NULL или разрешить формирование интеллектуальных умолчаний в параметрах развертывания.

Тип столбца sid в таблице [dbo].[catalog_products] на данный момент -  UNIQUEIDENTIFIER NOT NULL, но будет изменен на  BIGINT IDENTITY (1, 1) NOT NULL. Отсутствует неявное или явное преобразование.

Тип столбца sid_cat в таблице [dbo].[catalog_products] на данный момент -  VARCHAR (46) NOT NULL, но будет изменен на  BIGINT NOT NULL. Данные могут быть утеряны.

Столбец vendor таблицы [dbo].[catalog_products] необходимо изменить с NULL на NOT NULL. Если таблица содержит данные, скрипт ALTER может оказаться неработоспособным. Чтобы избежать возникновения этой проблемы, необходимо добавить значения этого столбца во все строки, пометить его как допускающий значения NULL или разрешить формирование интеллектуальных умолчаний в параметрах развертывания.
*/

IF EXISTS (select top 1 1 from [dbo].[catalog_products])
    RAISERROR (N'Обнаружены строки. Обновление схемы завершено из-за возможной потери данных.', 16, 127) WITH NOWAIT

GO
PRINT N'Выполняется удаление ограничение без названия для [dbo].[catalog_categories]...';


GO
ALTER TABLE [dbo].[catalog_categories] DROP CONSTRAINT [DF__catalog_c__id_pa__38996AB5];


GO
PRINT N'Выполняется удаление ограничение без названия для [dbo].[catalog_categories]...';


GO
ALTER TABLE [dbo].[catalog_categories] DROP CONSTRAINT [DF__catalog_c__datti__398D8EEE];


GO
PRINT N'Выполняется удаление ограничение без названия для [dbo].[catalog_categories]...';


GO
ALTER TABLE [dbo].[catalog_categories] DROP CONSTRAINT [DF__catalog_c__enabl__3A81B327];


GO
PRINT N'Выполняется удаление ограничение без названия для [dbo].[catalog_categories]...';


GO
ALTER TABLE [dbo].[catalog_categories] DROP CONSTRAINT [DF__catalog_cat__sid__45F365D3];


GO
PRINT N'Выполняется удаление ограничение без названия для [dbo].[catalog_products]...';


GO
ALTER TABLE [dbo].[catalog_products] DROP CONSTRAINT [DF__catalog_p__price__49C3F6B7];


GO
PRINT N'Выполняется удаление ограничение без названия для [dbo].[catalog_products]...';


GO
ALTER TABLE [dbo].[catalog_products] DROP CONSTRAINT [DF__catalog_p__id_cu__4AB81AF0];


GO
PRINT N'Выполняется удаление ограничение без названия для [dbo].[catalog_products]...';


GO
ALTER TABLE [dbo].[catalog_products] DROP CONSTRAINT [DF__catalog_p__datti__4BAC3F29];


GO
PRINT N'Выполняется удаление ограничение без названия для [dbo].[catalog_products]...';


GO
ALTER TABLE [dbo].[catalog_products] DROP CONSTRAINT [DF__catalog_p__enabl__4CA06362];


GO
PRINT N'Выполняется удаление ограничение без названия для [dbo].[catalog_products]...';


GO
ALTER TABLE [dbo].[catalog_products] DROP CONSTRAINT [DF__catalog_p__part___4D94879B];


GO
PRINT N'Выполняется удаление ограничение без названия для [dbo].[catalog_products]...';


GO
ALTER TABLE [dbo].[catalog_products] DROP CONSTRAINT [DF__catalog_pro__sid__4E88ABD4];


GO
PRINT N'Выполняется удаление [sqlUnit_prog]...';


GO
DROP USER [sqlUnit_prog];


GO
PRINT N'Выполняется создание [sqlUnit_prog]...';


GO
CREATE USER [sqlUnit_prog] FOR LOGIN [sqlUnit_prog];


GO
REVOKE CONNECT TO [sqlUnit_prog];


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
    [sid_cat]      BIGINT          NOT NULL,
    [vendor]       NVARCHAR (500)  NOT NULL,
    [currency_str] NVARCHAR (20)   NOT NULL,
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
PRINT N'Выполняется изменение [dbo].[save_catalog_category]...';


GO
ALTER PROCEDURE [dbo].[save_catalog_category]
@sid bigint = null,
	@id nvarchar(50),
	@id_parent nvarchar(50) = '',
	@name nvarchar(500),
	@id_provider int
AS
BEGIN 
SET NOCOUNT ON;
IF not EXISTS(SELECT 1 FROM catalog_categories c where c.enabled=1 and c.id=@id and c.id_provider=@id_provider)
begin
	insert into catalog_categories (id_provider, id, id_parent, name)
	values (@id_provider, @id, @id_parent, @name)
	set  @sid = @@IDENTITY
end

select @sid as sid
end
GO
PRINT N'Выполняется изменение [dbo].[save_catalog_product]...';


GO
ALTER PROCEDURE [dbo].[save_catalog_product]
@sid bigint = null,
	@id nvarchar(50),
	@sid_cat bigint,
	@name nvarchar(MAX),
	@price decimal(10, 2),
	@id_currency int,
	@part_number nvarchar(50),
	@vendor nvarchar(500) = null,
	@currency_str nvarchar(20) = null
AS
BEGIN 
SET NOCOUNT ON;
IF not EXISTS(SELECT 1 FROM catalog_products p where p.enabled=1 and p.id=@id and p.sid_cat=@sid_cat)
begin
	insert into catalog_products (sid_cat,name, price, id_currency, part_number, id, vendor, currency_str)
	values (@sid_cat, @name, @price, @id_currency, @part_number, @id, @vendor, @currency_str)
	set  @sid = @@IDENTITY
end
else
begin
	if not exists(SELECT 1 FROM catalog_products p where p.enabled=1 and p.id=@id and p.sid_cat=@sid_cat and p.price=@price and p.id_currency = @id_currency)
	begin
		update catalog_products
		set price=@price, id_currency = @id_currency, part_number=@part_number, currency_str=@currency_str
		where enabled=1 and id=@id and sid_cat=@sid_cat
		select @sid = sid from catalog_products where enabled=1 and id=@id and sid_cat=@sid_cat
	end
end

select @sid as sid
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
