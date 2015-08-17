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
PRINT N'Выполняется изменение [dbo].[FilterTenderClaims]...';


GO

ALTER PROCEDURE FilterTenderClaims
    (
      @rowCount INT ,
      @idClaim INT = NULL ,
      @tenderNumber NVARCHAR(150) = NULL ,
      @claimStatusIds NVARCHAR(MAX) = NULL ,
      @manager NVARCHAR(500) = NULL ,
      @managerSubDivision NVARCHAR(500) = NULL ,
      @tenderStartFrom DATETIME = NULL ,
      @tenderStartTo DATETIME = NULL ,
      @overdie BIT = NULL ,
      @idProductManager NVARCHAR(500) = NULL ,
      @author NVARCHAR(150) = NULL
    )
AS
    SELECT TOP ( @rowCount )
            *
    FROM    TenderClaim
    WHERE   Deleted = 0
            AND ( ( @idClaim IS NULL )
                  OR ( @idClaim IS NOT NULL
                       AND Id = @idClaim
                     )
                )
            AND ( ( @tenderNumber IS NULL )
                  OR ( @tenderNumber IS NOT NULL
                       AND TenderNumber = @tenderNumber
                     )
                )
            AND ( ( @claimStatusIds IS NULL )
                  OR ( @claimStatusIds IS NOT NULL
                       AND ClaimStatus IN (
                       SELECT   *
                       FROM     dbo.Split(@claimStatusIds, ',') )
                     )
                )
            AND ( ( @manager IS NULL )
                  OR ( @manager IS NOT NULL
                       AND (Manager = @manager OR Author=@manager)

                     )
                )
            AND ( ( @managerSubDivision IS NULL )
                  OR ( @managerSubDivision IS NOT NULL
                       AND ManagerSubDivision = @managerSubDivision
                     )
                )
            AND ( ( @author IS NULL )
                  OR ( @author IS NOT NULL
                       AND Author = @author
                     )
                )
            AND ( ( @idProductManager IS NULL )
                  OR ( @idProductManager IS NOT NULL
                       AND @idProductManager IN (
                       SELECT   ProductManager
                       FROM     ClaimPosition
                       WHERE    IdClaim = [TenderClaim].Id )
                     )
                )
            AND ( ( @overdie IS NULL )
                  OR ( @overdie IS NOT NULL
                       AND ( ( @overdie = 1
                               AND GETDATE() > ClaimDeadline
                               AND ClaimStatus NOT IN ( 1, 8 )
                             )
                             OR ( @overdie = 0
                                  AND GETDATE() < ClaimDeadline
                                  AND ClaimStatus NOT IN ( 1, 8 )
                                )
                           )
                     )
                )
            AND ( ( @tenderStartFrom IS NULL
                    AND @tenderStartTo IS NULL
                  )
                  OR ( @tenderStartFrom IS NOT NULL
                       AND @tenderStartTo IS NOT NULL
                       AND ClaimDeadline BETWEEN @tenderStartFrom
                                         AND     @tenderStartTo
                     )
                  OR ( @tenderStartFrom IS NULL
                       AND @tenderStartTo IS NOT NULL
                       AND ClaimDeadline <= @tenderStartTo
                     )
                  OR ( @tenderStartFrom IS NOT NULL
                       AND @tenderStartTo IS NULL
                       AND ClaimDeadline >= @tenderStartFrom
                     )
                )
    ORDER BY Id DESC
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
DELETE QuestionStates

INSERT INTO QuestionStates (id, name, sys_name, order_num)
Values (1, N'Создан', N'NEW', 1)

INSERT INTO QuestionStates (id, name, sys_name, order_num)
Values (2, N'Передан', N'SENT', 2)

INSERT INTO QuestionStates (id, name, sys_name, order_num)
Values (3, N'В работе', N'PROCESS', 3)

INSERT INTO QuestionStates (id, name, sys_name, order_num)
Values (4, N'Получен ответ', N'GETANSWER', 4)

INSERT INTO QuestionStates (id, name, sys_name, order_num)
Values (5, N'Подтвержден', N'APROVE', 5)
GO

GO
PRINT N'Обновление завершено.';


GO
