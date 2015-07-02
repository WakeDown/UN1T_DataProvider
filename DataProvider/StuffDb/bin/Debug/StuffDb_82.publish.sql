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
PRINT N'Выполняется удаление [dbo].[DF__employees__has_a__6EF57B66]...';


GO
ALTER TABLE [dbo].[employees] DROP CONSTRAINT [DF__employees__has_a__6EF57B66];


GO
PRINT N'Выполняется удаление [dbo].[DF__tmp_ms_xx___male__6754599E]...';


GO
ALTER TABLE [dbo].[employees] DROP CONSTRAINT [DF__tmp_ms_xx___male__6754599E];


GO
PRINT N'Выполняется удаление [dbo].[DF__tmp_ms_xx__ad_si__6383C8BA]...';


GO
ALTER TABLE [dbo].[employees] DROP CONSTRAINT [DF__tmp_ms_xx__ad_si__6383C8BA];


GO
PRINT N'Выполняется удаление [dbo].[DF__tmp_ms_xx__datti__656C112C]...';


GO
ALTER TABLE [dbo].[employees] DROP CONSTRAINT [DF__tmp_ms_xx__datti__656C112C];


GO
PRINT N'Выполняется удаление [dbo].[DF__tmp_ms_xx__datti__66603565]...';


GO
ALTER TABLE [dbo].[employees] DROP CONSTRAINT [DF__tmp_ms_xx__datti__66603565];


GO
PRINT N'Выполняется удаление [dbo].[DF__tmp_ms_xx__enabl__6477ECF3]...';


GO
ALTER TABLE [dbo].[employees] DROP CONSTRAINT [DF__tmp_ms_xx__enabl__6477ECF3];


GO
PRINT N'Выполняется запуск перестройки таблицы [dbo].[employees]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_employees] (
    [id]              INT            IDENTITY (1, 1) NOT NULL,
    [ad_sid]          VARCHAR (36)   DEFAULT '' NOT NULL,
    [id_manager]      INT            NOT NULL,
    [surname]         NVARCHAR (50)  NOT NULL,
    [name]            NVARCHAR (50)  NOT NULL,
    [patronymic]      NVARCHAR (50)  NULL,
    [full_name]       NVARCHAR (150) NOT NULL,
    [display_name]    NVARCHAR (100) NOT NULL,
    [id_position]     INT            NOT NULL,
    [id_organization] INT            NOT NULL,
    [email]           NVARCHAR (150) NULL,
    [work_num]        NVARCHAR (50)  NULL,
    [mobil_num]       NVARCHAR (50)  NULL,
    [id_emp_state]    SMALLINT       NOT NULL,
    [id_department]   INT            NOT NULL,
    [id_city]         INT            NOT NULL,
    [enabled]         BIT            DEFAULT 1 NOT NULL,
    [dattim1]         DATETIME       DEFAULT getdate() NOT NULL,
    [dattim2]         DATETIME       DEFAULT '3.3.3333' NOT NULL,
    [date_came]       DATE           NULL,
    [birth_date]      DATE           NULL,
    [male]            BIT            DEFAULT 1 NOT NULL,
    [id_position_org] INT            NOT NULL,
    [has_ad_account]  BIT            DEFAULT 0 NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[employees])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_employees] ON;
        INSERT INTO [dbo].[tmp_ms_xx_employees] ([id], [ad_sid], [id_manager], [surname], [name], [patronymic], [full_name], [display_name], [id_position], [id_organization], [email], [work_num], [mobil_num], [id_emp_state], [id_department], [id_city], [enabled], [dattim1], [dattim2], [date_came], [birth_date], [male], [id_position_org], [has_ad_account])
        SELECT   [id],
                 [ad_sid],
                 [id_manager],
                 [surname],
                 [name],
                 [patronymic],
                 [full_name],
                 [display_name],
                 [id_position],
                 [id_organization],
                 [email],
                 [work_num],
                 [mobil_num],
                 [id_emp_state],
                 [id_department],
                 [id_city],
                 [enabled],
                 [dattim1],
                 [dattim2],
                 [date_came],
                 [birth_date],
                 [male],
                 [id_position_org],
                 [has_ad_account]
        FROM     [dbo].[employees]
        ORDER BY [id] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_employees] OFF;
    END

DROP TABLE [dbo].[employees];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_employees]', N'employees';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Выполняется создание [dbo].[employees].[IX_employee_id_department]...';


GO
CREATE NONCLUSTERED INDEX [IX_employee_id_department]
    ON [dbo].[employees]([id_department] ASC);


GO
PRINT N'Выполняется создание [dbo].[employees].[IX_employee_id_manager]...';


GO
CREATE NONCLUSTERED INDEX [IX_employee_id_manager]
    ON [dbo].[employees]([id_manager] ASC);


GO
PRINT N'Выполняется создание [dbo].[employees].[IX_employee_ad_sid]...';


GO
CREATE NONCLUSTERED INDEX [IX_employee_ad_sid]
    ON [dbo].[employees]([ad_sid] ASC);


GO
PRINT N'Выполняется создание [dbo].[employees].[IX_employee_id_emp_state]...';


GO
CREATE NONCLUSTERED INDEX [IX_employee_id_emp_state]
    ON [dbo].[employees]([id_emp_state] ASC);


GO
PRINT N'Выполняется создание [dbo].[employees].[IX_employee_enabled]...';


GO
CREATE NONCLUSTERED INDEX [IX_employee_enabled]
    ON [dbo].[employees]([enabled] DESC);


GO
PRINT N'Выполняется обновление [dbo].[employees_view]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[employees_view]';


GO
PRINT N'Выполняется обновление [dbo].[close_employee]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[close_employee]';


GO
PRINT N'Выполняется обновление [dbo].[get_department]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_department]';


GO
PRINT N'Выполняется обновление [dbo].[get_employee]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_employee]';


GO
PRINT N'Выполняется обновление [dbo].[get_organization]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_organization]';


GO
PRINT N'Выполняется обновление [dbo].[get_position]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_position]';


GO
PRINT N'Выполняется обновление [dbo].[save_employee]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[save_employee]';


GO
PRINT N'Выполняется обновление [dbo].[get_organization_link_count]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_organization_link_count]';


GO
PRINT N'Выполняется обновление [dbo].[get_position_link_count]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_position_link_count]';


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
delete employee_states where id between 1 and 4
GO

insert into employee_states (id, name, sys_name, display_in_list, enabled)
values(1, N'Кандидат', N'CANDIDATE', 1, 0)
insert into employee_states (id, name, sys_name, display_in_list)
values(2, N'Сотрудник', N'STUFF', 1)
insert into employee_states (id, name, sys_name, display_in_list)
values(3, N'Декрет', N'DECREE', 0)
insert into employee_states (id, name, sys_name, display_in_list)
values(4, N'Уволен', N'FIRED', 0)

--:r .\ins_orgs.sql
--:r .\ins_cities.sql
--:r .\ins_positions.sql
GO

GO
PRINT N'Обновление завершено.';


GO
