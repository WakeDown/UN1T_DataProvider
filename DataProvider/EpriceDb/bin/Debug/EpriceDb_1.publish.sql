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
PRINT N'Операция рефакторинга Rename с помощью ключа f9c2a76e-9d03-43af-9ba4-971ec36a4920 пропущена, элемент [dbo].[catalog_pivot].[Id] (SqlSimpleColumn) не будет переименован в id';


GO
PRINT N'Операция рефакторинга Rename с помощью ключа fa1fa576-5f45-415c-8c87-a72a0982f816 пропущена, элемент [dbo].[catalog_positions].[Id] (SqlSimpleColumn) не будет переименован в id';


GO
PRINT N'Операция рефакторинга Rename с помощью ключа ccb7d34a-49d1-4a8c-a19d-8fffc4dfd12c пропущена, элемент [dbo].[catalog_positions].[provider_category_id] (SqlSimpleColumn) не будет переименован в provider_id_category';


GO
PRINT N'Операция рефакторинга Rename с помощью ключа 1474fd18-4788-404f-b402-896405f0a5c3, bb963e50-7bd0-4667-8643-521bb7b7d4ae пропущена, элемент [dbo].[catalog_pivot].[provider_id] (SqlSimpleColumn) не будет переименован в id_category';


GO
PRINT N'Операция рефакторинга Rename с помощью ключа 36866aff-012a-4e5b-974d-fa0c8f137267, 4ae02fb4-4068-45a5-852d-4113190de9ea, 951d23d1-bd4c-42df-824f-22b774c6c44f пропущена, элемент [dbo].[catalog_pivot].[provider_parent_id] (SqlSimpleColumn) не будет переименован в id_parent_category';


GO
PRINT N'Операция рефакторинга Rename с помощью ключа 87681331-683a-4cf7-8024-fff398a6b2fe пропущена, элемент [dbo].[catalog_positions].[currency] (SqlSimpleColumn) не будет переименован в id_currency';


GO
PRINT N'Выполняется создание [dbo].[catalog_pivot]...';


GO
CREATE TABLE [dbo].[catalog_pivot] (
    [id_provider]        INT            NOT NULL,
    [name]               NVARCHAR (500) NOT NULL,
    [id_category]        NVARCHAR (50)  NOT NULL,
    [id_parent_category] NVARCHAR (50)  NOT NULL,
    [dattim1]            DATETIME       NOT NULL,
    [enabled]            BIT            NOT NULL
);


GO
PRINT N'Выполняется создание [dbo].[catalog_positions]...';


GO
CREATE TABLE [dbo].[catalog_positions] (
    [name]        NVARCHAR (1500) NOT NULL,
    [price]       DECIMAL (10, 2) NOT NULL,
    [id_currency] INT             NOT NULL,
    [dattim1]     DATETIME        NOT NULL,
    [enabled]     BIT             NOT NULL,
    [id_category] NVARCHAR (50)   NOT NULL,
    [id_provider] INT             NOT NULL
);


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[catalog_pivot]...';


GO
ALTER TABLE [dbo].[catalog_pivot]
    ADD DEFAULT '' FOR [id_parent_category];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[catalog_pivot]...';


GO
ALTER TABLE [dbo].[catalog_pivot]
    ADD DEFAULT getdate() FOR [dattim1];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[catalog_pivot]...';


GO
ALTER TABLE [dbo].[catalog_pivot]
    ADD DEFAULT 1 FOR [enabled];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[catalog_positions]...';


GO
ALTER TABLE [dbo].[catalog_positions]
    ADD DEFAULT 0 FOR [price];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[catalog_positions]...';


GO
ALTER TABLE [dbo].[catalog_positions]
    ADD DEFAULT 1 FOR [id_currency];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[catalog_positions]...';


GO
ALTER TABLE [dbo].[catalog_positions]
    ADD DEFAULT getdate() FOR [dattim1];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[catalog_positions]...';


GO
ALTER TABLE [dbo].[catalog_positions]
    ADD DEFAULT 1 FOR [enabled];


GO
PRINT N'Выполняется создание [dbo].[save_catalog_category]...';


GO
CREATE PROCEDURE [dbo].[save_catalog_category]
	@id_category nvarchar(50),
	@id_parent_category nvarchar(50) = '',
	@name nvarchar(500),
	@id_provider int
AS
BEGIN 
SET NOCOUNT ON;

IF not EXISTS(SELECT 1 FROM catalog_pivot c where c.enabled=1 and c.id_category=@id_category and c.id_provider=@id_provider)
begin
	insert into catalog_pivot (id_provider, id_category, id_parent_category, name)
	values (@id_provider, @id_category, @id_parent_category, @name)
end
end
GO
PRINT N'Выполняется создание [dbo].[save_catalog_position]...';


GO
CREATE PROCEDURE [dbo].[save_catalog_position]
	@id_category nvarchar(50),
	@name nvarchar(500),
	@id_provider int,
	@price decimal(10, 2),
	@id_currency int
AS
BEGIN 
SET NOCOUNT ON;

IF not EXISTS(SELECT 1 FROM catalog_positions p where p.enabled=1 and p.id_category=@id_category and p.id_provider=@id_provider)
begin
	insert into catalog_positions (id_provider, id_category,  name, price, id_currency)
	values (@id_provider, @id_category, @name, @price, @id_currency)
end
else
begin
	if not exists(SELECT 1 FROM catalog_positions p where p.enabled=1 and p.id_category=@id_category and p.id_provider=@id_provider and p.price=@price and p.id_currency = @id_currency)
	begin
		update catalog_positions
		set price=@price, id_currency = @id_currency
		where enabled=1 and id_category=@id_category and id_provider=@id_provider
	end
end
end
GO
-- Выполняется этап рефакторинга для обновления развернутых журналов транзакций на целевом сервере

IF OBJECT_ID(N'dbo.__RefactorLog') IS NULL
BEGIN
    CREATE TABLE [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
    EXEC sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
END
GO
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'f9c2a76e-9d03-43af-9ba4-971ec36a4920')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('f9c2a76e-9d03-43af-9ba4-971ec36a4920')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'fa1fa576-5f45-415c-8c87-a72a0982f816')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('fa1fa576-5f45-415c-8c87-a72a0982f816')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'ccb7d34a-49d1-4a8c-a19d-8fffc4dfd12c')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('ccb7d34a-49d1-4a8c-a19d-8fffc4dfd12c')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '1474fd18-4788-404f-b402-896405f0a5c3')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('1474fd18-4788-404f-b402-896405f0a5c3')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '36866aff-012a-4e5b-974d-fa0c8f137267')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('36866aff-012a-4e5b-974d-fa0c8f137267')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'bb963e50-7bd0-4667-8643-521bb7b7d4ae')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('bb963e50-7bd0-4667-8643-521bb7b7d4ae')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '4ae02fb4-4068-45a5-852d-4113190de9ea')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('4ae02fb4-4068-45a5-852d-4113190de9ea')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '951d23d1-bd4c-42df-824f-22b774c6c44f')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('951d23d1-bd4c-42df-824f-22b774c6c44f')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '87681331-683a-4cf7-8024-fff398a6b2fe')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('87681331-683a-4cf7-8024-fff398a6b2fe')

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
GO

GO
PRINT N'Обновление завершено.';


GO
