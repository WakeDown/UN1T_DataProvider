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
Тип столбца display_name в таблице [dbo].[employees] на данный момент -  NVARCHAR (150) NOT NULL, но будет изменен на  NVARCHAR (100) NOT NULL. Данные могут быть утеряны.
*/

IF EXISTS (select top 1 1 from [dbo].[employees])
    RAISERROR (N'Обнаружены строки. Обновление схемы завершено из-за возможной потери данных.', 16, 127) WITH NOWAIT

GO
PRINT N'Выполняется изменение [dbo].[employees]...';


GO
ALTER TABLE [dbo].[employees] ALTER COLUMN [display_name] NVARCHAR (100) NOT NULL;


GO
PRINT N'Выполняется создание [dbo].[get_employee]...';


GO
CREATE PROCEDURE [dbo].[get_employee]
	 @id INT = NULL
AS
	BEGIN
    SET NOCOUNT ON;
	SELECT  
	 id
      ,ad_sid
      ,id_manager
      ,surname
      ,name
      ,patronymic
      ,full_name
      ,display_name
      ,id_position
      ,id_organization
      ,email
      ,work_num
      ,mobil_num
      ,id_emp_state
      ,id_department
      ,id_city
      ,date_came

        FROM    employees e
        WHERE   e.enabled = 1
                AND ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND e.id = @id
                         )
                    )
	end
GO
PRINT N'Выполняется создание [dbo].[save_eployee]...';


GO
CREATE PROCEDURE [dbo].[save_eployee]
    @id INT = NULL ,
    @ad_sid VARCHAR(36) ,
    @id_manager INT ,
    @surname NVARCHAR(50) ,
    @name NVARCHAR(50) ,
    @patronymic NVARCHAR(50) ,
    @full_name NVARCHAR(150) ,
    @display_name NVARCHAR(100) ,
    @id_position INT ,
    @id_organization INT ,
    @email NVARCHAR(150) ,
    @work_num NVARCHAR(50) ,
    @mobil_num NVARCHAR(50) ,
    @id_emp_state INT ,
    @id_department INT ,
    @id_city INT ,
    @date_came DATE
AS
    BEGIN
        SET NOCOUNT ON;
        IF @id IS NOT NULL
            AND @id > 0
            AND EXISTS ( SELECT 1
                         FROM   employees
                         WHERE  id = @id )
            BEGIN
                UPDATE  employees
                SET     ad_sid = @ad_sid ,
                        id_manager = @id_manager ,
                        surname = @surname ,
                        NAME = @name ,
                        patronymic = @patronymic ,
                        full_name = @full_name ,
                        display_name = @display_name ,
                        id_position = @id_position ,
                        id_organization = @id_organization ,
                        email = @email ,
                        work_num = @work_num ,
                        mobil_num = @mobil_num ,
                        id_emp_state = @id_emp_state ,
                        id_department = @id_department ,
                        id_city = @id_city ,
                        date_came = @date_came
                WHERE   id = @id
            END
        ELSE
            BEGIN
                INSERT  INTO employees
                        ( ad_sid ,
                          id_manager ,
                          surname ,
                          name ,
                          patronymic ,
                          full_name ,
                          display_name ,
                          id_position ,
                          id_organization ,
                          email ,
                          work_num ,
                          mobil_num ,
                          id_emp_state ,
                          id_department ,
                          id_city ,
                          date_came 
                        )
                VALUES  ( @ad_sid ,
                          @id_manager ,
                          @surname ,
                          @name ,
                          @patronymic ,
                          @full_name ,
                          @display_name ,
                          @id_position ,
                          @id_organization ,
                          @email ,
                          @work_num ,
                          @mobil_num ,
                          @id_emp_state ,
                          @id_department ,
                          @id_city ,
                          @date_came  
                        )

                SELECT  @id = @@IDENTITY
            END
	 
        RETURN @id
    END
GO
PRINT N'Обновление завершено.';


GO
