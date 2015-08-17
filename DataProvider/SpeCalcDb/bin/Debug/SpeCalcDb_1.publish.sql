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
PRINT N'Выполняется создание [dbo].[ClaimCertFiles]...';


GO
CREATE TABLE [dbo].[ClaimCertFiles] (
    [Id]       INT                        IDENTITY (1, 1) NOT NULL,
    [IdClaim]  INT                        NOT NULL,
    [fileDATA] VARBINARY (MAX) FILESTREAM NOT NULL,
    [enabled]  BIT                        NOT NULL,
    [fileGUID] UNIQUEIDENTIFIER           ROWGUIDCOL NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([fileGUID] ASC)
);


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[ClaimCertFiles]...';


GO
ALTER TABLE [dbo].[ClaimCertFiles]
    ADD DEFAULT 1 FOR [enabled];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[ClaimCertFiles]...';


GO
ALTER TABLE [dbo].[ClaimCertFiles]
    ADD DEFAULT newid() FOR [fileGUID];


GO
PRINT N'Выполняется создание [dbo].[DeleteClaimCertFile]...';


GO
CREATE PROCEDURE [dbo].[DeleteClaimCertFile]
	@Id INT,
	@file VARBINARY(MAX) 
AS
BEGIN
set NOCOUNT ON;
update ClaimCertFiles 
set fileDATA = @file
where Id=@Id

END
GO
PRINT N'Выполняется создание [dbo].[SaveClaimCertFile]...';


GO
CREATE PROCEDURE [dbo].[SaveClaimCertFile]
	@IdClaim INT,
	@file VARBINARY(MAX) 
AS
BEGIN
set NOCOUNT ON;
INSERT INTO ClaimCertFiles (IdClaim, fileDATA)
values(@IdClaim, @file)

END
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
