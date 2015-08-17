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
	SELECT  @sid = @@IDENTITY
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
