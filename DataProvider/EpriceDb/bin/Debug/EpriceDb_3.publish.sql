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
PRINT N'Операция рефакторинга Rename с помощью ключа 707e136b-4801-4ed5-b7eb-a23528dd6449 пропущена, элемент [dbo].[product_providers].[Id] (SqlSimpleColumn) не будет переименован в id';


GO
PRINT N'Выполняется создание [dbo].[product_providers]...';


GO
CREATE TABLE [dbo].[product_providers] (
    [id]       INT           NOT NULL,
    [name]     NVARCHAR (50) NOT NULL,
    [sys_name] NVARCHAR (20) NOT NULL,
    [enabled]  BIT           NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[product_providers]...';


GO
ALTER TABLE [dbo].[product_providers]
    ADD DEFAULT 1 FOR [enabled];


GO
PRINT N'Выполняется создание [dbo].[get_prod_provider]...';


GO
CREATE PROCEDURE [dbo].[get_prod_provider]
    @id INT = NULL ,
    @sys_name NVARCHAR(20) = NULL
AS
    BEGIN
        SET nocount ON;
        SELECT  id ,
                name ,
                sys_name
        FROM    product_providers p
        WHERE   enabled = 1
                AND ( ( @id IS NOT NULL
                        AND @id > 0
                        AND p.id = @id
                      )
                      OR @id IS NULL
                      OR @id <= 0
                    )
                AND ( ( @sys_name IS NOT NULL
                        AND @sys_name <> ''
                        AND p.sys_name = @sys_name
                      )
                      OR @sys_name IS NULL
                      OR @sys_name = ''
                    )

    END
GO
-- Выполняется этап рефакторинга для обновления развернутых журналов транзакций на целевом сервере
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '707e136b-4801-4ed5-b7eb-a23528dd6449')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('707e136b-4801-4ed5-b7eb-a23528dd6449')

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
