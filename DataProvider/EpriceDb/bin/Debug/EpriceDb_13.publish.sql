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
Удаляется столбец [dbo].[catalog_products].[id_category], возможна потеря данных.

Удаляется столбец [dbo].[catalog_products].[id_provider], возможна потеря данных.
*/

IF EXISTS (select top 1 1 from [dbo].[catalog_products])
    RAISERROR (N'Обнаружены строки. Обновление схемы завершено из-за возможной потери данных.', 16, 127) WITH NOWAIT

GO
PRINT N'Указанная ниже операция создана из файла журнала рефакторинга 35bc6fa0-c303-4a8a-99d6-e1fe416bd464';

PRINT N'Переименование [dbo].[catalog_products].[cat_sid] в sid_cat';


GO
EXECUTE sp_rename @objname = N'[dbo].[catalog_products].[cat_sid]', @newname = N'sid_cat', @objtype = N'COLUMN';


GO
PRINT N'Выполняется изменение [dbo].[catalog_products]...';


GO
ALTER TABLE [dbo].[catalog_products] DROP COLUMN [id_category], COLUMN [id_provider];


GO
ALTER TABLE [dbo].[catalog_products] ALTER COLUMN [sid_cat] NVARCHAR (50) NOT NULL;


GO
PRINT N'Выполняется изменение [dbo].[save_catalog_product]...';


GO
ALTER PROCEDURE [dbo].[save_catalog_product]
	@id nvarchar(50),
	@sid_cat nvarchar(50),
	@name nvarchar(500),
	@id_provider int,
	@price decimal(10, 2),
	@id_currency int,
	@part_number nvarchar(50),
	@id_position nvarchar(50)
AS
BEGIN 
SET NOCOUNT ON;

IF not EXISTS(SELECT 1 FROM catalog_products p where p.enabled=1 and p.id=@id and p.sid_cat=@sid_cat)
begin
	insert into catalog_products (sid_cat,name, price, id_currency, part_number, id)
	values (@sid_cat, @name, @price, @id_currency, @part_number, @id)
end
else
begin
	if not exists(SELECT 1 FROM catalog_products p where p.enabled=1 and p.id=@id and p.sid_cat=@sid_cat and p.price=@price and p.id_currency = @id_currency)
	begin
		update catalog_products
		set price=@price, id_currency = @id_currency, part_number=@part_number
		where enabled=1 and id=@id and sid_cat=@sid_cat
	end
end
end
GO
-- Выполняется этап рефакторинга для обновления развернутых журналов транзакций на целевом сервере
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
