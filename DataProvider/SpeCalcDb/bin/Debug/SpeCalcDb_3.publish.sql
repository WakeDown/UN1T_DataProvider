/*
Скрипт развертывания для tenderProcessing

Этот код был создан программным средством.
Изменения, внесенные в этот файл, могут привести к неверному выполнению кода и будут потеряны
в случае его повторного формирования.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "tenderProcessing"
:setvar DefaultFilePrefix "tenderProcessing"
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
IF (SELECT is_default
    FROM   [$(DatabaseName)].[sys].[filegroups]
    WHERE  [name] = N'ContentDBFSGroup') = 0
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            MODIFY FILEGROUP [ContentDBFSGroup] DEFAULT;
    END


GO
USE [$(DatabaseName)];


GO
/*
Необходимо добавить столбец [dbo].[ClaimCertFiles].[fileName] таблицы [dbo].[ClaimCertFiles], но он не содержит значения по умолчанию и не допускает значения NULL. Если таблица содержит данные, скрипт ALTER окажется неработоспособным. Чтобы избежать возникновения этой проблемы, необходимо выполнить одно из следующих действий: добавить в столбец значение по умолчанию, пометить его как допускающий значения NULL или разрешить формирование интеллектуальных умолчаний в параметрах развертывания.
*/

IF EXISTS (select top 1 1 from [dbo].[ClaimCertFiles])
    RAISERROR (N'Обнаружены строки. Обновление схемы завершено из-за возможной потери данных.', 16, 127) WITH NOWAIT

GO
PRINT N'Выполняется изменение [dbo].[ClaimCertFiles]...';


GO
ALTER TABLE [dbo].[ClaimCertFiles]
    ADD [fileName] NVARCHAR (500) NOT NULL;


GO
PRINT N'Выполняется изменение [dbo].[SaveClaimCertFile]...';


GO
ALTER PROCEDURE [dbo].[SaveClaimCertFile]
	@IdClaim INT,
	@file VARBINARY(MAX),
	@fileName NVARCHAR(500)
AS
BEGIN
set NOCOUNT ON;
declare @id int
INSERT INTO ClaimCertFiles (IdClaim, fileDATA, fileName)
values(@IdClaim, @file, @fileName)
select @id=@@IDENTITY
select @id as id
END
GO
PRINT N'Выполняется обновление [dbo].[DeleteClaimCertFile]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[DeleteClaimCertFile]';


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
