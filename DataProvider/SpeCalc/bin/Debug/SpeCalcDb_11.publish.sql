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
PRINT N'Выполняется изменение [dbo].[QuePosAnswer]...';


GO
ALTER TABLE [dbo].[QuePosAnswer] ALTER COLUMN [answerer_sid] VARCHAR (46) NOT NULL;

ALTER TABLE [dbo].[QuePosAnswer] ALTER COLUMN [creator_sid] VARCHAR (46) NOT NULL;


GO
PRINT N'Выполняется изменение [dbo].[QuestionPositions]...';


GO
ALTER TABLE [dbo].[QuestionPositions] ALTER COLUMN [creator_sid] VARCHAR (46) NOT NULL;

ALTER TABLE [dbo].[QuestionPositions] ALTER COLUMN [user_sid] VARCHAR (46) NOT NULL;


GO
PRINT N'Выполняется изменение [dbo].[Questions]...';


GO
ALTER TABLE [dbo].[Questions] ALTER COLUMN [creator_sid] VARCHAR (46) NOT NULL;

ALTER TABLE [dbo].[Questions] ALTER COLUMN [manager_sid] VARCHAR (46) NOT NULL;


GO
PRINT N'Выполняется обновление [dbo].[questions_view]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[questions_view]';


GO
PRINT N'Выполняется изменение [dbo].[save_que_pos_answer]...';


GO
ALTER PROCEDURE [dbo].[save_que_pos_answer]
    @id int = null, 
	@answerer_sid varchar(46), 
	@id_que_position int, 
	@descr nvarchar(max),
	@creator_sid varchar(46)=null
AS
    BEGIN
	SET NOCOUNT ON;
        IF @id IS NOT NULL
            AND @id > 0
            AND EXISTS ( SELECT 1
                         FROM   QuePosAnswer
                         WHERE  id = @id )
            BEGIN
                UPDATE  QuePosAnswer
                SET     answerer_sid = @answerer_sid ,
                        descr = @descr
                WHERE   id = @id
            END
        ELSE
            BEGIN
                INSERT  INTO QuePosAnswer
                        ( answerer_sid ,
                          id_que_position ,
                          descr ,
						  creator_sid
                        )
                VALUES  ( @answerer_sid ,
                          @id_que_position ,
                          @descr,
						   @creator_sid
                        )

						SELECT @id=@@IDENTITY
            END
	 
		SELECT @id AS id
    END
GO
PRINT N'Выполняется изменение [dbo].[save_question_position]...';


GO
ALTER PROCEDURE [dbo].[save_question_position]
    @id int = null, 
	@id_question int,
	@user_sid varchar(46), 
	@descr nvarchar(max),
	@creator_sid varchar(36)=null
AS
    BEGIN
	SET NOCOUNT ON;
        IF @id IS NOT NULL
            AND @id > 0
            AND EXISTS ( SELECT 1
                         FROM   QuestionPositions
                         WHERE  id = @id )
            BEGIN
                UPDATE  QuestionPositions
                SET     
				user_sid = @user_sid ,
                        descr = @descr
                WHERE   id = @id
            END
        ELSE
            BEGIN
                INSERT  INTO QuestionPositions
                        ( id_question,
						user_sid ,
                          descr ,
						  creator_sid
                        )
                VALUES  ( @id_question, @user_sid ,
                          @descr,
						   @creator_sid
                        )

						SELECT @id=@@IDENTITY
            END
	 
		SELECT @id AS id
    END
GO
PRINT N'Выполняется изменение [dbo].[save_question]...';


GO
ALTER PROCEDURE [dbo].[save_question]
    @id int = null, 
	@manager_sid varchar(46), @date_limit datetime, @descr nvarchar(max),
	@creator_sid varchar(46)=null
AS
    BEGIN
	SET NOCOUNT ON;
        IF @id IS NOT NULL
            AND @id > 0
            AND EXISTS ( SELECT 1
                         FROM   questions
                         WHERE  id = @id )
            BEGIN
                UPDATE  questions
                SET     manager_sid = @manager_sid ,
                        date_limit = @date_limit ,
                        descr = @descr
                WHERE   id = @id
            END
        ELSE
            BEGIN
                INSERT  INTO questions
                        ( manager_sid ,
                          date_limit ,
                          descr ,
						  creator_sid
                        )
                VALUES  ( @manager_sid ,
                          @date_limit ,
                          @descr,
						   @creator_sid
                        )

						SELECT @id=@@IDENTITY
            END
	 
		SELECT @id AS id
    END
GO
PRINT N'Выполняется обновление [dbo].[close_que_pos_answer]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[close_que_pos_answer]';


GO
PRINT N'Выполняется обновление [dbo].[get_que_pos_answer]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_que_pos_answer]';


GO
PRINT N'Выполняется обновление [dbo].[close_question_position]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[close_question_position]';


GO
PRINT N'Выполняется обновление [dbo].[get_question_position]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_question_position]';


GO
PRINT N'Выполняется обновление [dbo].[close_question]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[close_question]';


GO
PRINT N'Выполняется обновление [dbo].[get_question]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_question]';


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
