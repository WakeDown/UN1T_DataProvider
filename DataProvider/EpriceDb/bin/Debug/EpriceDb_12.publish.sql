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
Необходимо добавить столбец [dbo].[catalog_products].[cat_sid] таблицы [dbo].[catalog_products], но он не содержит значения по умолчанию и не допускает значения NULL. Если таблица содержит данные, скрипт ALTER окажется неработоспособным. Чтобы избежать возникновения этой проблемы, необходимо выполнить одно из следующих действий: добавить в столбец значение по умолчанию, пометить его как допускающий значения NULL или разрешить формирование интеллектуальных умолчаний в параметрах развертывания.
*/

IF EXISTS (select top 1 1 from [dbo].[catalog_products])
    RAISERROR (N'Обнаружены строки. Обновление схемы завершено из-за возможной потери данных.', 16, 127) WITH NOWAIT

GO
PRINT N'Выполняется изменение [dbo].[catalog_products]...';


GO
ALTER TABLE [dbo].[catalog_products]
    ADD [cat_sid] UNIQUEIDENTIFIER NOT NULL;


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
