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
PRINT N'Выполняется изменение [dbo].[get_department]...';


GO
ALTER PROCEDURE [dbo].[get_department] @id INT = NULL
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  id, name, id_parent, id_chief
        FROM    departments d
        WHERE   d.ENABLED = 1
                AND ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND d.id = @id
                         )
                    )
    END
GO
PRINT N'Выполняется изменение [dbo].[save_department]...';


GO
ALTER PROCEDURE [dbo].[save_department]
    @id INT = NULL ,
    @name NVARCHAR(150) ,
    @id_parent INT = NULL ,
    @id_chief INT = NULL
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
            END
	 

    END
GO
PRINT N'Обновление завершено.';


GO
