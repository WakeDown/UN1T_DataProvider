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
PRINT N'Операция рефакторинга Rename с помощью ключа 12d8e0db-fc0a-49a8-a3ce-fb31bef47b4a пропущена, элемент [dbo].[QuestionStates].[Id] (SqlSimpleColumn) не будет переименован в id';


GO
PRINT N'Операция рефакторинга Rename с помощью ключа f8815890-cea6-4312-89e9-de907c39b15a пропущена, элемент [dbo].[QuestionStateHistory].[Id] (SqlSimpleColumn) не будет переименован в id';


GO
PRINT N'Выполняется изменение [dbo].[Questions]...';


GO
ALTER TABLE [dbo].[Questions]
    ADD [id_que_state] INT NULL;


GO
PRINT N'Выполняется создание [dbo].[QuestionStateHistory]...';


GO
CREATE TABLE [dbo].[QuestionStateHistory] (
    [id]           INT            IDENTITY (1, 1) NOT NULL,
    [id_question]  INT            NOT NULL,
    [id_que_state] INT            NOT NULL,
    [dattim1]      DATETIME       NOT NULL,
    [creator_sid]  VARCHAR (46)   NOT NULL,
    [descr]        NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[QuestionStates]...';


GO
CREATE TABLE [dbo].[QuestionStates] (
    [id]        INT           NOT NULL,
    [name]      NVARCHAR (50) NOT NULL,
    [sys_name]  NVARCHAR (50) NULL,
    [order_num] INT           NOT NULL,
    [enabled]   BIT           NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[QuestionStateHistory]...';


GO
ALTER TABLE [dbo].[QuestionStateHistory]
    ADD DEFAULT getdate() FOR [dattim1];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[QuestionStates]...';


GO
ALTER TABLE [dbo].[QuestionStates]
    ADD DEFAULT 500 FOR [order_num];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[QuestionStates]...';


GO
ALTER TABLE [dbo].[QuestionStates]
    ADD DEFAULT 1 FOR [enabled];


GO
PRINT N'Выполняется изменение [dbo].[questions_view]...';


GO
ALTER VIEW [dbo].[questions_view]
	AS SELECT id, manager_sid, date_limit, descr , id_que_state, (select name from QuestionStates qs where qs.id=q.id_que_state) as que_state
	FROM Questions q 
	where enabled = 1
GO
PRINT N'Выполняется изменение [dbo].[save_question]...';


GO
ALTER PROCEDURE [dbo].[save_question]
    @id int = null, 
	@manager_sid varchar(46), @date_limit datetime, @descr nvarchar(max)=null,
	@creator_sid varchar(46)=null,
	@id_que_state int = null
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
						  creator_sid,
						id_que_state

                        )
                VALUES  ( @manager_sid ,
                          @date_limit ,
                          @descr,
						   @creator_sid,
						   @id_que_state
                        )

						SELECT @id=@@IDENTITY
            END
	 
		SELECT @id AS id
    END
GO
PRINT N'Выполняется изменение [dbo].[get_question]...';


GO
ALTER PROCEDURE [dbo].[get_question] @id INT = NULL
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  id, manager_sid, date_limit, descr , id_que_state, que_state
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
PRINT N'Выполняется изменение [dbo].[save_question_position]...';


GO
ALTER PROCEDURE [dbo].[save_question_position]
    @id int = null, 
	@id_question int,
	@user_sid varchar(46), 
	@descr nvarchar(max),
	@creator_sid varchar(46)=null
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
PRINT N'Выполняется создание [dbo].[get_question_state]...';


GO
CREATE PROCEDURE [dbo].[get_question_state]
	@sys_name nvarchar(50)
AS
begin
set nocount on;
	select top 1 id, name from QuestionStates where enabled=1 and lower(sys_name)=lower(@sys_name)
end
GO
PRINT N'Выполняется создание [dbo].[save_question_state]...';


GO
CREATE PROCEDURE [dbo].[save_question_state]
    @id_question INT ,
    @id_que_state INT ,
    @creator_sid VARCHAR(46) ,
    @descr NVARCHAR(MAX) = NULL
AS
    BEGIN 
        SET NOCOUNT ON;
        BEGIN TRY
            BEGIN TRANSACTION t1
            INSERT  INTO QuestionStateHistory
                    ( id_question ,
                      id_que_state ,
                      creator_sid ,
                      descr
                    )
            VALUES  ( @id_question ,
                      @id_que_state ,
                      @creator_sid ,
                      @descr
                    )

            UPDATE  Questions
            SET     id_que_state = @id_que_state
            WHERE   id = @id_question
            COMMIT TRANSACTION t1
        END TRY

        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION t1
            DECLARE @error_text NVARCHAR(MAX)
            SELECT  @error_text = ERROR_MESSAGE()
                    + ' Изменения не были сохранены!'

            RAISERROR (
								@error_text
								,16
								,1
								)
        END CATCH
	
    END
GO
PRINT N'Выполняется обновление [dbo].[close_question]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[close_question]';


GO
-- Выполняется этап рефакторинга для обновления развернутых журналов транзакций на целевом сервере
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '12d8e0db-fc0a-49a8-a3ce-fb31bef47b4a')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('12d8e0db-fc0a-49a8-a3ce-fb31bef47b4a')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'f8815890-cea6-4312-89e9-de907c39b15a')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('f8815890-cea6-4312-89e9-de907c39b15a')

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
