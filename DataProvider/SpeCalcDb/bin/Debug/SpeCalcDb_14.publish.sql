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
PRINT N'Выполняется изменение [dbo].[get_que_pos_answer]...';


GO
ALTER PROCEDURE [dbo].[get_que_pos_answer] @id INT = NULL, @id_que_position int
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  id, id_que_position, answerer_sid, descr 
        FROM    QuePosAnswer t
        WHERE  t.enabled = 1 AND   ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND t.id = @id
                         )
                    )
					and
					t.id_que_position=@id_que_position
					order by id desc
    END
GO
PRINT N'Выполняется изменение [dbo].[get_question]...';


GO
ALTER PROCEDURE [dbo].[get_question] @id INT = NULL
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  id, manager_sid, date_limit, descr 
        FROM    questions_view q
        WHERE  t.enabled = 1 AND   ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND q.id = @id
                         )
                    )
					order by id desc
    END
GO
PRINT N'Выполняется изменение [dbo].[get_question_position]...';


GO
ALTER PROCEDURE [dbo].[get_question_position] @id INT = NULL, @id_question int
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  id, id_question, user_sid, descr
        FROM    QuestionPositions t
        WHERE t.enabled = 1 AND ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND t.id = @id
                         )
                    )
					and t.id_question = @id_question
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
GO

GO
PRINT N'Обновление завершено.';


GO
