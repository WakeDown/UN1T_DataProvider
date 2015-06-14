/*
Скрипт развертывания для Stuff

Этот код был создан программным средством.
Изменения, внесенные в этот файл, могут привести к неверному выполнению кода и будут потеряны
в случае его повторного формирования.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "Stuff"
:setvar DefaultFilePrefix "Stuff"
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
Столбец id_chief таблицы [dbo].[departments] необходимо изменить с NULL на NOT NULL. Если таблица содержит данные, скрипт ALTER может оказаться неработоспособным. Чтобы избежать возникновения этой проблемы, необходимо добавить значения этого столбца во все строки, пометить его как допускающий значения NULL или разрешить формирование интеллектуальных умолчаний в параметрах развертывания.

Столбец id_parent таблицы [dbo].[departments] необходимо изменить с NULL на NOT NULL. Если таблица содержит данные, скрипт ALTER может оказаться неработоспособным. Чтобы избежать возникновения этой проблемы, необходимо добавить значения этого столбца во все строки, пометить его как допускающий значения NULL или разрешить формирование интеллектуальных умолчаний в параметрах развертывания.
*/

IF EXISTS (select top 1 1 from [dbo].[departments])
    RAISERROR (N'Обнаружены строки. Обновление схемы завершено из-за возможной потери данных.', 16, 127) WITH NOWAIT

GO
PRINT N'Выполняется удаление [dbo].[departments].[IX_departments_id_parent]...';


GO
DROP INDEX [IX_departments_id_parent]
    ON [dbo].[departments];


GO
PRINT N'Выполняется изменение [dbo].[departments]...';


GO
ALTER TABLE [dbo].[departments] ALTER COLUMN [id_chief] INT NOT NULL;

ALTER TABLE [dbo].[departments] ALTER COLUMN [id_parent] INT NOT NULL;


GO
PRINT N'Выполняется создание [dbo].[departments].[IX_departments_id_parent]...';


GO
CREATE NONCLUSTERED INDEX [IX_departments_id_parent]
    ON [dbo].[departments]([id_parent] ASC);


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[departments]...';


GO
ALTER TABLE [dbo].[departments]
    ADD DEFAULT 0 FOR [id_parent];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[departments]...';


GO
ALTER TABLE [dbo].[departments]
    ADD DEFAULT 0 FOR [id_chief];


GO
PRINT N'Выполняется изменение [dbo].[save_department]...';


GO
ALTER PROCEDURE [dbo].[save_department]
    @id INT = NULL ,
    @name NVARCHAR(150) ,
    @id_parent INT ,
    @id_chief INT
AS
    BEGIN
	SET NOCOUNT ON;
        IF @id IS NOT NULL
            AND @id > 0
            AND EXISTS ( SELECT 1
                         FROM   departments d
                         WHERE  id = @id )
            BEGIN
                UPDATE  departments
                SET     name = @name ,
                        id_parent = @id_parent ,
                        id_chief = @id_chief
                WHERE   id = @id
            END
        ELSE
            BEGIN
                INSERT  INTO departments
                        ( name ,
                          id_parent ,
                          id_chief 
                        )
                VALUES  ( @name ,
                          @id_parent ,
                          @id_chief 
                        )

						SELECT @id=@@IDENTITY
            END
	 
		RETURN @id
    END
GO
PRINT N'Выполняется обновление [dbo].[get_department]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_department]';


GO
PRINT N'Обновление завершено.';


GO
