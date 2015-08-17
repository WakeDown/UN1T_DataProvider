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
PRINT N'Операция рефакторинга Rename с помощью ключа 3bc451b4-edbc-49c1-bad2-c1efe09933c3 пропущена, элемент [dbo].[Questions].[Id] (SqlSimpleColumn) не будет переименован в id';


GO
PRINT N'Операция рефакторинга Rename с помощью ключа e8cf4a7b-1ff8-4461-b2d2-3de3803654d6 пропущена, элемент [dbo].[Questions].[date_answer] (SqlSimpleColumn) не будет переименован в date_limit';


GO
PRINT N'Операция рефакторинга Rename с помощью ключа dbb3f0ce-7a63-4961-99d6-9b1c18a61db6 пропущена, элемент [dbo].[QuestionAnswers].[Id] (SqlSimpleColumn) не будет переименован в id';


GO
PRINT N'Операция рефакторинга Rename с помощью ключа 04cc6560-2014-4b77-9f66-1c1ae74cf1f6 пропущена, элемент [dbo].[QuestionPositions].[Id] (SqlSimpleColumn) не будет переименован в id';


GO
PRINT N'Операция рефакторинга Rename с помощью ключа 47918f83-3ea6-4079-a7b2-5c5004d9fcc2, a0ec8b06-aec2-4b08-9e95-d10834fe1083 пропущена, элемент [dbo].[QuestionPositions].[answerer_sid] (SqlSimpleColumn) не будет переименован в user_sid';


GO
PRINT N'Операция рефакторинга Rename с помощью ключа 8dc7f2b7-c5be-41e6-80f0-01526ffe5bfb пропущена, элемент [dbo].[QuePosAnswer].[Id] (SqlSimpleColumn) не будет переименован в id';


GO
PRINT N'Выполняется создание [dbo].[QuePosAnswer]...';


GO
CREATE TABLE [dbo].[QuePosAnswer] (
    [id]              INT            IDENTITY (1, 1) NOT NULL,
    [id_que_position] INT            NOT NULL,
    [answerer_sid]    VARCHAR (36)   NOT NULL,
    [descr]           NVARCHAR (MAX) NOT NULL,
    [dattim1]         DATETIME       NOT NULL,
    [dattim2]         DATETIME       NOT NULL,
    [enabled]         BIT            NOT NULL,
    [creator_sid]     VARCHAR (36)   NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[QuestionPositions]...';


GO
CREATE TABLE [dbo].[QuestionPositions] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [id_question] INT            NOT NULL,
    [user_sid]    VARCHAR (36)   NOT NULL,
    [descr]       NVARCHAR (MAX) NOT NULL,
    [dattim1]     DATETIME       NOT NULL,
    [dattim2]     DATETIME       NOT NULL,
    [enabled]     BIT            NOT NULL,
    [creator_sid] VARCHAR (36)   NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[Questions]...';


GO
CREATE TABLE [dbo].[Questions] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [manager_sid] VARCHAR (36)   NOT NULL,
    [date_limit]  DATETIME       NOT NULL,
    [dattim1]     DATETIME       NOT NULL,
    [dattim2]     DATETIME       NOT NULL,
    [enabled]     BIT            NOT NULL,
    [creator_sid] VARCHAR (36)   NOT NULL,
    [descr]       NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[QuePosAnswer]...';


GO
ALTER TABLE [dbo].[QuePosAnswer]
    ADD DEFAULT getdate() FOR [dattim1];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[QuePosAnswer]...';


GO
ALTER TABLE [dbo].[QuePosAnswer]
    ADD DEFAULT 1 FOR [enabled];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[QuestionPositions]...';


GO
ALTER TABLE [dbo].[QuestionPositions]
    ADD DEFAULT getdate() FOR [dattim1];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[QuestionPositions]...';


GO
ALTER TABLE [dbo].[QuestionPositions]
    ADD DEFAULT 1 FOR [enabled];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[Questions]...';


GO
ALTER TABLE [dbo].[Questions]
    ADD DEFAULT getdate() FOR [dattim1];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[Questions]...';


GO
ALTER TABLE [dbo].[Questions]
    ADD DEFAULT 1 FOR [enabled];


GO
PRINT N'Выполняется создание [dbo].[questions_view]...';


GO
CREATE VIEW [dbo].[questions_view]
	AS SELECT id, manager_sid, date_limit, descr 
	FROM Questions q 
	where enabled = 1
GO
PRINT N'Выполняется создание [dbo].[close_question]...';


GO
CREATE PROCEDURE [dbo].[close_question] @id INT
AS
    BEGIN
        SET NOCOUNT ON;
        UPDATE  Questions
        SET     enabled = 0, dattim2=getdate()
        WHERE   id = @id
    END
GO
PRINT N'Выполняется создание [dbo].[close_question_position]...';


GO
CREATE PROCEDURE [dbo].[close_question_position] @id INT
AS
    BEGIN
        SET NOCOUNT ON;
        UPDATE  QuestionPositions
        SET     enabled = 0, dattim2=getdate()
        WHERE   id = @id
    END
GO
PRINT N'Выполняется создание [dbo].[get_question]...';


GO
CREATE PROCEDURE [dbo].[get_question] @id INT = NULL, @get_emp_count BIT = 0
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  id, manager_sid, date_limit, descr 
        FROM    questions_view q
        WHERE   ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND q.id = @id
                         )
                    )
					order by id desc
    END
GO
PRINT N'Выполняется создание [dbo].[get_question_position]...';


GO
CREATE PROCEDURE [dbo].[get_question_position] @id INT = NULL, @get_emp_count BIT = 0
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  *
        FROM    QuestionPositions t
        WHERE   ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND t.id = @id
                         )
                    )
					order by id desc
    END
GO
PRINT N'Выполняется создание [dbo].[save_question]...';


GO
CREATE PROCEDURE [dbo].[save_question]
    @id int = null, 
	@manager_sid varchar(36), @date_limit datetime, @descr nvarchar(max),
	@creator_sid varchar(36)
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
PRINT N'Выполняется создание [dbo].[save_question_position]...';


GO
CREATE PROCEDURE [dbo].[save_question_position]
    @id int = null, 
	@id_question int,
	@user_sid varchar(36), 
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
-- Выполняется этап рефакторинга для обновления развернутых журналов транзакций на целевом сервере

IF OBJECT_ID(N'dbo.__RefactorLog') IS NULL
BEGIN
    CREATE TABLE [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
    EXEC sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
END
GO
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '3bc451b4-edbc-49c1-bad2-c1efe09933c3')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('3bc451b4-edbc-49c1-bad2-c1efe09933c3')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'e8cf4a7b-1ff8-4461-b2d2-3de3803654d6')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('e8cf4a7b-1ff8-4461-b2d2-3de3803654d6')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'dbb3f0ce-7a63-4961-99d6-9b1c18a61db6')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('dbb3f0ce-7a63-4961-99d6-9b1c18a61db6')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '04cc6560-2014-4b77-9f66-1c1ae74cf1f6')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('04cc6560-2014-4b77-9f66-1c1ae74cf1f6')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '47918f83-3ea6-4079-a7b2-5c5004d9fcc2')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('47918f83-3ea6-4079-a7b2-5c5004d9fcc2')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'a0ec8b06-aec2-4b08-9e95-d10834fe1083')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('a0ec8b06-aec2-4b08-9e95-d10834fe1083')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '8dc7f2b7-c5be-41e6-80f0-01526ffe5bfb')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('8dc7f2b7-c5be-41e6-80f0-01526ffe5bfb')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'b3719683-a2e4-4de3-bb4a-81e0c912b0b5')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('b3719683-a2e4-4de3-bb4a-81e0c912b0b5')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'cb9a6d53-1ee6-4f49-ae33-5b80d898c4ad')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('cb9a6d53-1ee6-4f49-ae33-5b80d898c4ad')

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
GO

GO
PRINT N'Обновление завершено.';


GO
