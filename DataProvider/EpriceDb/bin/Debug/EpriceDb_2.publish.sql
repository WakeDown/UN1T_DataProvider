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
Необходимо добавить столбец [dbo].[catalog_positions].[id_position] таблицы [dbo].[catalog_positions], но он не содержит значения по умолчанию и не допускает значения NULL. Если таблица содержит данные, скрипт ALTER окажется неработоспособным. Чтобы избежать возникновения этой проблемы, необходимо выполнить одно из следующих действий: добавить в столбец значение по умолчанию, пометить его как допускающий значения NULL или разрешить формирование интеллектуальных умолчаний в параметрах развертывания.
*/

IF EXISTS (select top 1 1 from [dbo].[catalog_positions])
    RAISERROR (N'Обнаружены строки. Обновление схемы завершено из-за возможной потери данных.', 16, 127) WITH NOWAIT

GO
PRINT N'Выполняется изменение [dbo].[catalog_positions]...';


GO
ALTER TABLE [dbo].[catalog_positions]
    ADD [part_number] NVARCHAR (50) DEFAULT '' NOT NULL,
        [id_position] NVARCHAR (50) NOT NULL;


GO
PRINT N'Выполняется изменение [dbo].[save_catalog_position]...';


GO
ALTER PROCEDURE [dbo].[save_catalog_position]
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

IF not EXISTS(SELECT 1 FROM catalog_positions p where p.enabled=1 and p.id_position=@id_position and p.id_provider=@id_provider)
begin
	insert into catalog_positions (id_provider, id_category,  name, price, id_currency, part_number, id_position)
	values (@id_provider, @id_category, @name, @price, @id_currency, @part_number, @id_position)
end
else
begin
	if not exists(SELECT 1 FROM catalog_positions p where p.enabled=1 and p.id_position=@id_position and p.id_provider=@id_provider and p.price=@price and p.id_currency = @id_currency)
	begin
		update catalog_positions
		set price=@price, id_currency = @id_currency, part_number=@part_number
		where enabled=1 and id_position=@id_position and id_provider=@id_provider
	end
end
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
GO

GO
PRINT N'Обновление завершено.';


GO
