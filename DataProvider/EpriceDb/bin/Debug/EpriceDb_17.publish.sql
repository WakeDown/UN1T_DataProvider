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
PRINT N'Операция рефакторинга Rename с помощью ключа 06dc8b37-d21b-4408-9ae6-693e59877209, f73ff595-5ba3-4529-bd8e-46f0a845d8e9 пропущена, элемент [dbo].[catalog_products].[id_position] (SqlSimpleColumn) не будет переименован в id';


GO
PRINT N'Операция рефакторинга Rename с помощью ключа 35bc6fa0-c303-4a8a-99d6-e1fe416bd464 пропущена, элемент [dbo].[catalog_products].[cat_sid] (SqlSimpleColumn) не будет переименован в sid_cat';


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
PRINT N'Выполняется изменение [dbo].[catalog_categories]...';


GO
ALTER TABLE [dbo].[catalog_categories]
    ADD [sid] UNIQUEIDENTIFIER DEFAULT newid() NOT NULL;


GO
PRINT N'Выполняется создание [dbo].[PK_catalog_categories]...';


GO
ALTER TABLE [dbo].[catalog_categories]
    ADD CONSTRAINT [PK_catalog_categories] PRIMARY KEY CLUSTERED ([sid] ASC);


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
PRINT N'Выполняется создание [dbo].[catalog_products]...';


GO
CREATE TABLE [dbo].[catalog_products] (
    [name]         NVARCHAR (MAX)   NOT NULL,
    [price]        DECIMAL (10, 2)  NOT NULL,
    [id_currency]  INT              NOT NULL,
    [dattim1]      DATETIME         NOT NULL,
    [enabled]      BIT              NOT NULL,
    [part_number]  NVARCHAR (50)    NOT NULL,
    [id]           NVARCHAR (50)    NOT NULL,
    [sid]          UNIQUEIDENTIFIER NOT NULL,
    [sid_cat]      VARCHAR (46)     NOT NULL,
    [vendor]       NVARCHAR (500)   NULL,
    [currency_str] NVARCHAR (20)    NULL,
    CONSTRAINT [PK_catalog_products] PRIMARY KEY CLUSTERED ([sid] ASC)
);


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[catalog_products]...';


GO
ALTER TABLE [dbo].[catalog_products]
    ADD DEFAULT 0 FOR [price];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[catalog_products]...';


GO
ALTER TABLE [dbo].[catalog_products]
    ADD DEFAULT 1 FOR [id_currency];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[catalog_products]...';


GO
ALTER TABLE [dbo].[catalog_products]
    ADD DEFAULT getdate() FOR [dattim1];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[catalog_products]...';


GO
ALTER TABLE [dbo].[catalog_products]
    ADD DEFAULT 1 FOR [enabled];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[catalog_products]...';


GO
ALTER TABLE [dbo].[catalog_products]
    ADD DEFAULT '' FOR [part_number];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[catalog_products]...';


GO
ALTER TABLE [dbo].[catalog_products]
    ADD DEFAULT newid() FOR [sid];


GO
PRINT N'Выполняется изменение [dbo].[save_catalog_category]...';


GO
ALTER PROCEDURE [dbo].[save_catalog_category]
	@id nvarchar(50),
	@id_parent nvarchar(50) = '',
	@name nvarchar(500),
	@id_provider int
AS
BEGIN 
SET NOCOUNT ON;
declare @sid varchar(46)
IF not EXISTS(SELECT 1 FROM catalog_categories c where c.enabled=1 and c.id=@id and c.id_provider=@id_provider)
begin
	insert into catalog_categories (id_provider, id, id_parent, name)
	values (@id_provider, @id, @id_parent, @name)
	SELECT  @sid = @@IDENTITY
end

select @sid as sid
end
GO
PRINT N'Выполняется создание [dbo].[save_catalog_product]...';


GO
CREATE PROCEDURE [dbo].[save_catalog_product]
@sid varchar(46) = null,
	@id nvarchar(50),
	@sid_cat varchar(46),
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
	SELECT  @sid = @@IDENTITY
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
-- Выполняется этап рефакторинга для обновления развернутых журналов транзакций на целевом сервере
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '06dc8b37-d21b-4408-9ae6-693e59877209')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('06dc8b37-d21b-4408-9ae6-693e59877209')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'f73ff595-5ba3-4529-bd8e-46f0a845d8e9')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('f73ff595-5ba3-4529-bd8e-46f0a845d8e9')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '35bc6fa0-c303-4a8a-99d6-e1fe416bd464')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('35bc6fa0-c303-4a8a-99d6-e1fe416bd464')

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
