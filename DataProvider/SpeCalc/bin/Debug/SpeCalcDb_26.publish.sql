﻿/*
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
PRINT N'Выполняется изменение [dbo].[get_question_position]...';


GO
ALTER PROCEDURE [dbo].[get_question_position] @id INT = NULL, @id_question INT=null
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  id, id_question, user_sid, descr
        FROM    QuestionPositions t
        WHERE t.enabled = 1 AND ( @id IS NULL OR @id<=0
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND t.id = @id
                         )
                    )
					and (@id_question IS NULL OR @id_question <=0 OR (@id_question IS NOT NULL AND @id_question>0 and t.id_question = @id_question))
					order by id desc
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
