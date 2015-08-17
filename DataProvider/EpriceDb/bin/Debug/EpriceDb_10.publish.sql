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
PRINT N'Операция рефакторинга Rename с помощью ключа 06dc8b37-d21b-4408-9ae6-693e59877209, f73ff595-5ba3-4529-bd8e-46f0a845d8e9 пропущена, элемент [dbo].[catalog_products].[id_position] (SqlSimpleColumn) не будет переименован в id';


GO
PRINT N'Выполняется изменение [dbo].[catalog_categories]...';


GO
ALTER TABLE [dbo].[catalog_categories]
    ADD [sid] UNIQUEIDENTIFIER DEFAULT newid() NOT NULL;


GO
PRINT N'Выполняется создание [dbo].[catalog_products]...';


GO
CREATE TABLE [dbo].[catalog_products] (
    [name]        NVARCHAR (1500) NOT NULL,
    [price]       DECIMAL (10, 2) NOT NULL,
    [id_currency] INT             NOT NULL,
    [dattim1]     DATETIME        NOT NULL,
    [enabled]     BIT             NOT NULL,
    [id_category] NVARCHAR (50)   NOT NULL,
    [id_provider] INT             NOT NULL,
    [part_number] NVARCHAR (50)   NOT NULL,
    [id]          NVARCHAR (50)   NOT NULL
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
PRINT N'Выполняется создание [dbo].[save_catalog_product]...';


GO
CREATE PROCEDURE [dbo].[save_catalog_product]
	@id nvarchar(50),
	@id_category nvarchar(50),
	@name nvarchar(500),
	@id_provider int,
	@price decimal(10, 2),
	@id_currency int,
	@part_number nvarchar(50),
	@id_position nvarchar(50)
AS
BEGIN 
SET NOCOUNT ON;

IF not EXISTS(SELECT 1 FROM catalog_products p where p.enabled=1 and p.id=@id and p.id_provider=@id_provider)
begin
	insert into catalog_products (id_provider, id_category,  name, price, id_currency, part_number, id)
	values (@id_provider, @id_category, @name, @price, @id_currency, @part_number, @id)
end
else
begin
	if not exists(SELECT 1 FROM catalog_products p where p.enabled=1 and p.id=@id_position and p.id_provider=@id_provider and p.price=@price and p.id_currency = @id_currency)
	begin
		update catalog_products
		set price=@price, id_currency = @id_currency, part_number=@part_number
		where enabled=1 and id=@id and id_provider=@id_provider
	end
end
end
GO
PRINT N'Выполняется обновление [dbo].[save_catalog_category]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[save_catalog_category]';


GO
-- Выполняется этап рефакторинга для обновления развернутых журналов транзакций на целевом сервере
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '06dc8b37-d21b-4408-9ae6-693e59877209')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('06dc8b37-d21b-4408-9ae6-693e59877209')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'f73ff595-5ba3-4529-bd8e-46f0a845d8e9')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('f73ff595-5ba3-4529-bd8e-46f0a845d8e9')

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
