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
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL11.TEST\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL11.TEST\MSSQL\DATA\"

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
USE [master];


GO

IF (DB_ID(N'$(DatabaseName)') IS NOT NULL) 
BEGIN
    ALTER DATABASE [$(DatabaseName)]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [$(DatabaseName)];
END

GO
PRINT N'Выполняется создание $(DatabaseName)...'
GO
CREATE DATABASE [$(DatabaseName)]
    ON 
    PRIMARY(NAME = [$(DatabaseName)], FILENAME = N'$(DefaultDataPath)$(DefaultFilePrefix)_Primary.mdf')
    LOG ON (NAME = [$(DatabaseName)_log], FILENAME = N'$(DefaultLogPath)$(DefaultFilePrefix)_Primary.ldf') COLLATE SQL_Latin1_General_CP1_CI_AS
GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL,
                RECOVERY FULL,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CLOSE OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET READ_COMMITTED_SNAPSHOT OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_UPDATE_STATISTICS_ASYNC OFF,
                PAGE_VERIFY NONE,
                DATE_CORRELATION_OPTIMIZATION OFF,
                DISABLE_BROKER,
                PARAMETERIZATION SIMPLE,
                SUPPLEMENTAL_LOGGING OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET TRUSTWORTHY OFF,
        DB_CHAINING OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'Параметры базы данных изменить нельзя. Применить эти параметры может только пользователь SysAdmin.';
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET HONOR_BROKER_PRIORITY OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'Параметры базы данных изменить нельзя. Применить эти параметры может только пользователь SysAdmin.';
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET TARGET_RECOVERY_TIME = 0 SECONDS 
    WITH ROLLBACK IMMEDIATE;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET FILESTREAM(NON_TRANSACTED_ACCESS = OFF),
                CONTAINMENT = NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
USE [$(DatabaseName)];


GO
IF fulltextserviceproperty(N'IsFulltextInstalled') = 1
    EXECUTE sp_fulltext_database 'enable';


GO
PRINT N'Выполняется создание [sqlUnit_prog]...';


GO
CREATE LOGIN [sqlUnit_prog]
    WITH PASSWORD = N'Id;1rzj7j7htgs6qu|znejeamsFT7_&#$!~<ei6j1litcjys', SID = 0xDF6BB6678BAA4044A9A299D90E9F906E, DEFAULT_LANGUAGE = [русский], CHECK_POLICY = OFF;


GO
PRINT N'Выполняется создание [sqlUnit_prog]...';


GO
CREATE USER [sqlUnit_prog] FOR LOGIN [sqlUnit_prog];


GO
REVOKE CONNECT TO [sqlUnit_prog];


GO
PRINT N'Выполняется создание [dbo].[cities]...';


GO
CREATE TABLE [dbo].[cities] (
    [id]          INT           IDENTITY (1, 1) NOT NULL,
    [name]        NVARCHAR (50) NOT NULL,
    [enabled]     BIT           NOT NULL,
    [dattim1]     DATETIME      NOT NULL,
    [dattim2]     DATETIME      NOT NULL,
    [order_num]   INT           NOT NULL,
    [creator_sid] VARCHAR (46)  NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[departments]...';


GO
CREATE TABLE [dbo].[departments] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [name]        NVARCHAR (150) NOT NULL,
    [id_parent]   INT            NOT NULL,
    [enabled]     BIT            NOT NULL,
    [dattim1]     DATETIME       NOT NULL,
    [dattim2]     DATETIME       NOT NULL,
    [id_chief]    INT            NOT NULL,
    [creator_sid] VARCHAR (46)   NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[departments].[IX_departments_id_parent]...';


GO
CREATE NONCLUSTERED INDEX [IX_departments_id_parent]
    ON [dbo].[departments]([id_parent] ASC);


GO
PRINT N'Выполняется создание [dbo].[employee_states]...';


GO
CREATE TABLE [dbo].[employee_states] (
    [id]              INT           NOT NULL,
    [name]            NVARCHAR (50) NOT NULL,
    [sys_name]        NVARCHAR (50) NOT NULL,
    [enabled]         BIT           NOT NULL,
    [dattim1]         DATETIME      NOT NULL,
    [dattim2]         DATETIME      NOT NULL,
    [display_in_list] BIT           NOT NULL,
    [order_num]       INT           NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[employees]...';


GO
CREATE TABLE [dbo].[employees] (
    [id]              INT            IDENTITY (1, 1) NOT NULL,
    [ad_sid]          VARCHAR (46)   NOT NULL,
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
    [enabled]         BIT            NOT NULL,
    [dattim1]         DATETIME       NOT NULL,
    [dattim2]         DATETIME       NOT NULL,
    [date_came]       DATE           NULL,
    [birth_date]      DATE           NULL,
    [male]            BIT            NOT NULL,
    [id_position_org] INT            NOT NULL,
    [has_ad_account]  BIT            NOT NULL,
    [creator_sid]     VARCHAR (46)   NULL,
    [ad_login]        NVARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


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
PRINT N'Выполняется создание [dbo].[organizations]...';


GO
CREATE TABLE [dbo].[organizations] (
    [id]                   INT            IDENTITY (1, 1) NOT NULL,
    [name]                 NVARCHAR (50)  NOT NULL,
    [enabled]              BIT            NOT NULL,
    [dattim1]              DATETIME       NOT NULL,
    [dattim2]              DATETIME       NOT NULL,
    [display_in_list]      BIT            NOT NULL,
    [full_name]            NVARCHAR (500) NULL,
    [order_num]            INT            NOT NULL,
    [creator_sid]          VARCHAR (46)   NULL,
    [address_ur]           NVARCHAR (500) NULL,
    [address_fact]         NVARCHAR (500) NULL,
    [phone]                NVARCHAR (50)  NULL,
    [email]                NVARCHAR (50)  NULL,
    [inn]                  NVARCHAR (12)  NULL,
    [kpp]                  NVARCHAR (20)  NULL,
    [ogrn]                 NVARCHAR (20)  NULL,
    [rs]                   NVARCHAR (50)  NULL,
    [bank]                 NVARCHAR (500) NULL,
    [ks]                   NVARCHAR (50)  NULL,
    [bik]                  NVARCHAR (50)  NULL,
    [okpo]                 NVARCHAR (50)  NULL,
    [okved]                NVARCHAR (50)  NULL,
    [manager_name]         NVARCHAR (150) NULL,
    [manager_name_dat]     NVARCHAR (150) NULL,
    [manager_position]     NVARCHAR (250) NULL,
    [manager_position_dat] NVARCHAR (250) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[photos]...';


GO
CREATE TABLE [dbo].[photos] (
    [id]           INT             IDENTITY (1, 1) NOT NULL,
    [id_employee]  INT             NOT NULL,
    [enabled]      BIT             NOT NULL,
    [dattim1]      DATETIME        NOT NULL,
    [dattim2]      DATETIME        NOT NULL,
    [path]         NVARCHAR (4000) NULL,
    [picture]      IMAGE           NULL,
    [picture_name] NVARCHAR (100)  NULL,
    [creator_sid]  VARCHAR (46)    NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[photos].[IX_photos_id_employee]...';


GO
CREATE NONCLUSTERED INDEX [IX_photos_id_employee]
    ON [dbo].[photos]([id_employee] ASC);


GO
PRINT N'Выполняется создание [dbo].[positions]...';


GO
CREATE TABLE [dbo].[positions] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [name]        NVARCHAR (500) NOT NULL,
    [enabled]     BIT            NOT NULL,
    [dattim1]     DATETIME       NOT NULL,
    [dattim2]     DATETIME       NOT NULL,
    [order_num]   INT            NOT NULL,
    [creator_sid] VARCHAR (46)   NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[cities]...';


GO
ALTER TABLE [dbo].[cities]
    ADD DEFAULT 1 FOR [enabled];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[cities]...';


GO
ALTER TABLE [dbo].[cities]
    ADD DEFAULT getdate() FOR [dattim1];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[cities]...';


GO
ALTER TABLE [dbo].[cities]
    ADD DEFAULT '3.3.3333' FOR [dattim2];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[cities]...';


GO
ALTER TABLE [dbo].[cities]
    ADD DEFAULT 500 FOR [order_num];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[departments]...';


GO
ALTER TABLE [dbo].[departments]
    ADD DEFAULT 0 FOR [id_parent];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[departments]...';


GO
ALTER TABLE [dbo].[departments]
    ADD DEFAULT 1 FOR [enabled];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[departments]...';


GO
ALTER TABLE [dbo].[departments]
    ADD DEFAULT getdate() FOR [dattim1];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[departments]...';


GO
ALTER TABLE [dbo].[departments]
    ADD DEFAULT '3.3.3333' FOR [dattim2];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[departments]...';


GO
ALTER TABLE [dbo].[departments]
    ADD DEFAULT 0 FOR [id_chief];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[employee_states]...';


GO
ALTER TABLE [dbo].[employee_states]
    ADD DEFAULT 1 FOR [enabled];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[employee_states]...';


GO
ALTER TABLE [dbo].[employee_states]
    ADD DEFAULT getdate() FOR [dattim1];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[employee_states]...';


GO
ALTER TABLE [dbo].[employee_states]
    ADD DEFAULT '3.3.3333' FOR [dattim2];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[employee_states]...';


GO
ALTER TABLE [dbo].[employee_states]
    ADD DEFAULT 1 FOR [display_in_list];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[employee_states]...';


GO
ALTER TABLE [dbo].[employee_states]
    ADD DEFAULT 500 FOR [order_num];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[employees]...';


GO
ALTER TABLE [dbo].[employees]
    ADD DEFAULT '' FOR [ad_sid];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[employees]...';


GO
ALTER TABLE [dbo].[employees]
    ADD DEFAULT 1 FOR [enabled];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[employees]...';


GO
ALTER TABLE [dbo].[employees]
    ADD DEFAULT getdate() FOR [dattim1];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[employees]...';


GO
ALTER TABLE [dbo].[employees]
    ADD DEFAULT '3.3.3333' FOR [dattim2];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[employees]...';


GO
ALTER TABLE [dbo].[employees]
    ADD DEFAULT 1 FOR [male];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[employees]...';


GO
ALTER TABLE [dbo].[employees]
    ADD DEFAULT 0 FOR [has_ad_account];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[organizations]...';


GO
ALTER TABLE [dbo].[organizations]
    ADD DEFAULT 1 FOR [enabled];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[organizations]...';


GO
ALTER TABLE [dbo].[organizations]
    ADD DEFAULT getdate() FOR [dattim1];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[organizations]...';


GO
ALTER TABLE [dbo].[organizations]
    ADD DEFAULT '3.3.3333' FOR [dattim2];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[organizations]...';


GO
ALTER TABLE [dbo].[organizations]
    ADD DEFAULT 1 FOR [display_in_list];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[organizations]...';


GO
ALTER TABLE [dbo].[organizations]
    ADD DEFAULT 500 FOR [order_num];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[photos]...';


GO
ALTER TABLE [dbo].[photos]
    ADD DEFAULT 1 FOR [enabled];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[photos]...';


GO
ALTER TABLE [dbo].[photos]
    ADD DEFAULT getdate() FOR [dattim1];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[photos]...';


GO
ALTER TABLE [dbo].[photos]
    ADD DEFAULT '3.3.3333' FOR [dattim2];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[positions]...';


GO
ALTER TABLE [dbo].[positions]
    ADD DEFAULT 1 FOR [enabled];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[positions]...';


GO
ALTER TABLE [dbo].[positions]
    ADD DEFAULT getdate() FOR [dattim1];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[positions]...';


GO
ALTER TABLE [dbo].[positions]
    ADD DEFAULT '3.3.3333' FOR [dattim2];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[positions]...';


GO
ALTER TABLE [dbo].[positions]
    ADD DEFAULT 500 FOR [order_num];


GO
PRINT N'Выполняется создание [dbo].[departments_view]...';


GO
CREATE VIEW [dbo].[departments_view]
	AS SELECT  id ,
                name ,
                id_parent ,
                ( SELECT    name
                  FROM      departments d2
                  WHERE     d2.id = d.id_parent
                ) AS parent ,
                id_chief ,
                ( SELECT    display_name
                  FROM      employees e
                  WHERE     e.id = d.id_chief
                ) AS chief
        FROM    departments d
        WHERE   d.enabled = 1
GO
PRINT N'Выполняется создание [dbo].[employees_report]...';


GO
CREATE VIEW [dbo].[employees_report]
	AS SELECT  e.id ,
                ad_sid ,
                id_manager ,
                surname ,
                e.name ,
                patronymic ,
                e.full_name ,
                display_name ,
                id_position ,
                id_organization ,
                e.email ,
                work_num ,
                mobil_num ,
                id_emp_state ,
                id_department ,
                id_city ,
                date_came ,
                birth_date ,
                ( SELECT    e2.display_name
                  FROM      employees e2
                  WHERE     e2.id = e.id_manager
                ) AS manager,
                ( SELECT    e2.email
                  FROM      employees e2
                  WHERE     e2.id = e.id_manager
                ) AS manager_email ,
                es.name AS emp_state ,
				es.sys_name as emp_state_sys_name,
                p.name AS position ,
                o.name AS organization ,
                c.name AS city ,
                d.name AS department ,
				case when male=1 then 1 else 0 end as male,
				id_position_org,
				p_org.name as position_org,
				CASE WHEN e.has_ad_account = 1 THEN 1 ELSE 0 END AS has_ad_account,
				ad_login,
				e.dattim1 as date_create
        FROM    employees e
                INNER JOIN employee_states es ON e.id_emp_state = es.id
                INNER JOIN positions p ON e.id_position = p.id
				INNER JOIN positions p_org ON e.id_position_org = p_org.id
                INNER JOIN organizations o ON e.id_organization = o.id
                INNER JOIN cities c ON e.id_city = c.id
                INNER JOIN departments d ON e.id_department = d.id
        WHERE   e.enabled = 1
GO
PRINT N'Выполняется создание [dbo].[employees_view]...';


GO
CREATE VIEW [dbo].[employees_view]
	AS SELECT  e.id ,
                ad_sid ,
                id_manager ,
                surname ,
                e.name ,
                patronymic ,
                e.full_name ,
                display_name ,
                id_position ,
                id_organization ,
                e.email ,
                work_num ,
                mobil_num ,
                id_emp_state ,
                id_department ,
                id_city ,
                date_came ,
                birth_date ,
                ( SELECT    e2.display_name
                  FROM      employees e2
                  WHERE     e2.id = e.id_manager
                ) AS manager,
                ( SELECT    e2.email
                  FROM      employees e2
                  WHERE     e2.id = e.id_manager
                ) AS manager_email ,
                es.name AS emp_state ,
				es.sys_name as emp_state_sys_name,
                p.name AS position ,
                o.name AS organization ,
                c.name AS city ,
                d.name AS department ,
				case when male=1 then 1 else 0 end as male,
				id_position_org,
				p_org.name as position_org,
				CASE WHEN e.has_ad_account = 1 THEN 1 ELSE 0 END AS has_ad_account,
				ad_login,
				e.dattim1 as date_create
        FROM    employees e
                INNER JOIN employee_states es ON e.id_emp_state = es.id
                INNER JOIN positions p ON e.id_position = p.id
				INNER JOIN positions p_org ON e.id_position_org = p_org.id
                INNER JOIN organizations o ON e.id_organization = o.id
                INNER JOIN cities c ON e.id_city = c.id
                INNER JOIN departments d ON e.id_department = d.id
        WHERE   e.enabled = 1 and es.sys_name IN ( 'STUFF' )
GO
PRINT N'Выполняется создание [dbo].[check_employee_is_chief]...';


GO
CREATE PROCEDURE [dbo].[check_employee_is_chief]
	@id_employee int,
	@id_department int
AS
begin
set nocount on;
	select (case when exists(select 1 from departments d where d.id = @id_department and d.id_chief = @id_employee) then 1 else 0 end) as result
end
GO
PRINT N'Выполняется создание [dbo].[close_city]...';


GO
CREATE PROCEDURE [dbo].[close_city]@id INT
AS
    BEGIN
        SET NOCOUNT ON;
        UPDATE  cities
        SET     enabled = 0, dattim2 = getdate()
        WHERE   id = @id
    END
GO
PRINT N'Выполняется создание [dbo].[close_department]...';


GO
CREATE PROCEDURE [dbo].[close_department] @id INT
AS
    BEGIN
        SET NOCOUNT ON;
        UPDATE  departments
        SET     enabled = 0, dattim2 = getdate()
        WHERE   id = @id
    END
GO
PRINT N'Выполняется создание [dbo].[close_employee]...';


GO
CREATE PROCEDURE [dbo].[close_employee] @id INT
AS
    BEGIN
        SET NOCOUNT ON;
        UPDATE  employees
        SET     enabled = 0, dattim2 = getdate()
        WHERE   id = @id
    END
GO
PRINT N'Выполняется создание [dbo].[close_organization]...';


GO
CREATE PROCEDURE [dbo].[close_organization] @id INT
AS
    BEGIN
        SET NOCOUNT ON;
        UPDATE  organizations
        SET     enabled = 0, dattim2 = getdate()
        WHERE   id = @id
    END
GO
PRINT N'Выполняется создание [dbo].[close_position]...';


GO
CREATE PROCEDURE [dbo].[close_position] @id INT
AS
    BEGIN
        SET NOCOUNT ON;
        UPDATE  positions
        SET     enabled = 0, dattim2 = getdate()
        WHERE   id = @id
    END
GO
PRINT N'Выполняется создание [dbo].[get_city]...';


GO
CREATE PROCEDURE [dbo].[get_city]
	@id int = null
	
AS
begin
SET NOCOUNT ON;
	select id, name,
	(
	select count(1) from employees_view e  where e.id_city=c.id
	) as emp_count
	 from cities c
	where c.enabled=1
	AND ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND c.id = @id
                         )
                    )
					order by name
end
GO
PRINT N'Выполняется создание [dbo].[get_city_link_count]...';


GO
CREATE PROCEDURE [dbo].[get_city_link_count]
(
	@id int
)
AS
BEGIN
	select count(1) from employees_view e where e.id_city=@id
END
GO
PRINT N'Выполняется создание [dbo].[get_department]...';


GO
CREATE PROCEDURE [dbo].[get_department] @id INT = NULL, @get_emp_count BIT = 0
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  id ,
                name ,
                id_parent ,
                parent ,
                id_chief ,
                chief,
				CASE WHEN @get_emp_count = 1 THEN 
				(SELECT COUNT(1) FROM employees_view e WHERE e.id_department = d.id)
				 ELSE NULL END AS emp_count
        FROM    departments_view d
        WHERE   ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND d.id = @id
                         )
                    )
					order by d.name
    END
GO
PRINT N'Выполняется создание [dbo].[get_emp_state]...';


GO
CREATE PROCEDURE [dbo].[get_emp_state]
	@id int = null,
	--@get_all bit = 0,
	@sys_name nvarchar(20) = null
AS
begin
SET NOCOUNT ON;
	select id, name from employee_states es
	where es.enabled=1
	--and (@get_all=1 or (@get_all=0 and es.display_in_list = 1))
	and ((@sys_name is null or ltrim(rtrim(@sys_name)) = '') or (@sys_name is not null and rtrim(ltrim(@sys_name))<>'' and sys_name=@sys_name))
	AND ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND es.id = @id
                         )
                    )
end
GO
PRINT N'Выполняется создание [dbo].[get_employee]...';


GO
CREATE PROCEDURE [dbo].[get_employee]
    @id INT = NULL ,
    @get_photo BIT = 0 ,
	@ad_sid VARCHAR(46) = NULL
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  e.id ,
                ad_sid ,
                id_manager ,
                surname ,
                e.name ,
                patronymic ,
                e.full_name ,
                display_name ,
                id_position ,
                id_organization ,
                e.email ,
                work_num ,
                mobil_num ,
                id_emp_state ,
                id_department ,
                id_city ,
                date_came ,
                birth_date ,
                ( SELECT    e2.display_name
                  FROM      employees e2
                  WHERE     e2.id = e.id_manager
                ) AS manager,
                ( SELECT    e2.email
                  FROM      employees e2
                  WHERE     e2.id = e.id_manager
                ) AS manager_email ,
                es.name AS emp_state ,
				es.sys_name as emp_state_sys_name,
                p.name AS position ,
                o.name AS organization ,
                c.name AS city ,
                d.name AS department ,
				case when male=1 then 1 else 0 end as male,
				id_position_org,
				p_org.name as position_org,
				CASE WHEN e.has_ad_account = 1 THEN 1 ELSE 0 END AS has_ad_account,
				ad_login,
				e.dattim1 as date_create
				,
				CASE WHEN @get_photo = 1
                     THEN ( SELECT TOP 1
                                    picture
                            FROM    photos ph
                            WHERE   ph.enabled = 1
                                    AND ph.id_employee = e.id
                          )
                     ELSE NULL
                END AS photo
				--,
				--CASE WHEN @id_department IS NOT NULL THEN 
				--CASE WHEN EXISTS(SELECT 1 FROM departments dd WHERE dd.id=@id_department AND dd.id_chief=e.id) THEN 0 ELSE 1 end
				--ELSE NULL END AS is_chief
        FROM    employees e
		INNER JOIN employee_states es ON e.id_emp_state = es.id
                INNER JOIN positions p ON e.id_position = p.id
				INNER JOIN positions p_org ON e.id_position_org = p_org.id
                INNER JOIN organizations o ON e.id_organization = o.id
                INNER JOIN cities c ON e.id_city = c.id
                INNER JOIN departments d ON e.id_department = d.id
        WHERE  e.id = @id
    END
GO
PRINT N'Выполняется создание [dbo].[get_employee_list]...';


GO
CREATE PROCEDURE [dbo].[get_employee_list]
	@id INT = NULL ,
    @id_emp_state INT = NULL ,
    @get_photo BIT = 0 ,
    @id_department INT = NULL,
	@ad_sid VARCHAR(46) = NULL
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  e.id ,
                ad_sid ,
                id_manager ,
                surname ,
                e.name ,
                patronymic ,
                e.full_name ,
                display_name ,
                id_position ,
                id_organization ,
                email ,
                work_num ,
                mobil_num ,
                id_emp_state ,
                id_department ,
                id_city ,
                date_came ,
                birth_date ,
                manager,
                manager_email ,
                emp_state ,
                position ,
                organization ,
                city ,
                department ,
                CASE WHEN @get_photo = 1
                     THEN ( SELECT TOP 1
                                    picture
                            FROM    photos ph
                            WHERE   ph.enabled = 1
                                    AND ph.id_employee = e.id
                          )
                     ELSE NULL
                END AS photo,
				CASE WHEN @id_department IS NOT NULL THEN 
				CASE WHEN EXISTS(SELECT 1 FROM departments dd WHERE dd.id=@id_department AND dd.id_chief=e.id) THEN 0 ELSE 1 end
				ELSE NULL END AS is_chief,
				 male,
				id_position_org,
				position_org,
				has_ad_account,
				ad_login
        FROM    employees_view e
        WHERE  
		( @id IS NULL 
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND e.id = @id
                         )
                    )
				AND ( @ad_sid IS NULL OR @ad_sid = ''
                      OR ( @ad_sid IS NOT NULL
                           AND @ad_sid != ''
                           AND e.ad_sid = @ad_sid
                         )
                    )	
                AND ( ( @id_department IS NULL
                        OR @id_department <= 0
                      )
                      OR ( @id_department IS NOT NULL
                           AND @id_department > 0
                           AND id_department = @id_department
                         )
                    )
					ORDER BY is_chief, e.full_name
    END
GO
PRINT N'Выполняется создание [dbo].[get_employees_birthday]...';


GO
CREATE PROCEDURE [dbo].[get_employees_birthday]
    @day DATE = NULL ,
    @month INT = NULL
AS
    BEGIN
        SELECT  *
        FROM    employees_view e
        WHERE   ( @day IS NULL
                  OR ( @day IS NOT NULL
                       AND month(e.birth_date) = month(@day) and day(e.birth_date) = day(@day)
                     )
                )
                AND ( @month IS NULL
                      OR ( @month IS NOT NULL
                           AND MONTH(e.birth_date) = @month
                         )
                    )
					order by month(birth_date), day(birth_date)
    END
GO
PRINT N'Выполняется создание [dbo].[get_employees_newbie]...';


GO
CREATE PROCEDURE [dbo].[get_employees_newbie]
	@date_came date
AS
    BEGIN
        SET NOCOUNT ON;
		SELECT id, full_name, position,city,department, date_create 
		FROM employees_view where convert(date,date_create) = @date_came
    END
GO
PRINT N'Выполняется создание [dbo].[get_organization]...';


GO
CREATE PROCEDURE [dbo].[get_organization] @id INT = NULL
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  id ,
                name ,
                ( SELECT    COUNT(1)
                  FROM      employees_view e
                  WHERE     e.id_organization = o.id
                ) AS emp_count ,
                address_ur ,
                address_fact ,
                phone ,
                email ,
                inn ,
                kpp ,
                ogrn ,
                rs ,
                bank ,
                ks ,
                bik ,
                okpo ,
                okved ,
                manager_name ,
                manager_name_dat ,
                manager_position ,
                manager_position_dat
        FROM    organizations o
        WHERE   o.enabled = 1
                AND ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND o.id = @id
                         )
                    )
        ORDER BY name
    END
GO
PRINT N'Выполняется создание [dbo].[get_organization_link_count]...';


GO
CREATE PROCEDURE [dbo].[get_organization_link_count]
(
	@id int
)
AS
BEGIN
	select count(1) from employees_view e where e.id_organization=@id
END
GO
PRINT N'Выполняется создание [dbo].[get_other_employee_list]...';


GO
CREATE PROCEDURE [dbo].[get_other_employee_list]
@id_emp_state int,
@id_department int = null
	AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  e.id ,
                e.full_name ,
                p.name AS position ,
                o.name AS organization ,
                c.name AS city ,
                d.name AS department ,
                CASE WHEN male = 1 THEN 1
                     ELSE 0
                END AS male ,
                id_position_org ,
                p_org.name AS position_org
        FROM    employees e
                INNER JOIN employee_states st ON e.id_emp_state = st.id
                INNER JOIN positions p ON e.id_position = p.id
                INNER JOIN positions p_org ON e.id_position_org = p_org.id
                INNER JOIN organizations o ON e.id_organization = o.id
                INNER JOIN cities c ON e.id_city = c.id
                INNER JOIN departments d ON e.id_department = d.id
        WHERE   e.enabled = 1 and e.id_emp_state = @id_emp_state
		 AND ( ( @id_department IS NULL
                        OR @id_department <= 0
                      )
                      OR ( @id_department IS NOT NULL
                           AND @id_department > 0
                           AND id_department = @id_department
                         )
                    )
					ORDER BY e.full_name
                         
    END
GO
PRINT N'Выполняется создание [dbo].[get_position]...';


GO
CREATE PROCEDURE [dbo].[get_position]
	@id int = null
AS
begin
SET NOCOUNT ON;
	select id, name,
	
	(
	select count(1) from employees_view e  where e.id_position=p.id
	) as emp_count from positions p
	where p.enabled=1
	AND ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND p.id = @id
                         )
                    )
					order by name
end
GO
PRINT N'Выполняется создание [dbo].[get_position_link_count]...';


GO
CREATE Procedure [dbo].[get_position_link_count]
(
	@id int
)
AS
BEGIN
	select count(1) from employees_view e where e.id_position=@id
END
GO
PRINT N'Выполняется создание [dbo].[save_city]...';


GO
CREATE PROCEDURE [dbo].[save_city]
	@id INT = NULL ,
    @name NVARCHAR(150) ,
	@creator_sid varchar(46)=null
AS
    BEGIN
	SET NOCOUNT ON;
        IF @id IS NOT NULL
            AND @id > 0
            AND EXISTS ( SELECT 1
                         FROM   cities
                         WHERE  id = @id )
            BEGIN
                UPDATE  cities
                SET     name = @name 
                WHERE   id = @id
            END
        ELSE
            BEGIN
                INSERT  INTO cities
                        ( name ,creator_sid
                        )
                VALUES  ( @name ,@creator_sid
                        )

						SELECT @id=@@IDENTITY
            END
	 
		SELECT @id AS id
    END
GO
PRINT N'Выполняется создание [dbo].[save_department]...';


GO
CREATE PROCEDURE [dbo].[save_department]
    @id INT = NULL ,
    @name NVARCHAR(150) ,
    @id_parent INT ,
    @id_chief INT,
	@creator_sid varchar(46)=null
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
                          id_chief  ,creator_sid
                        )
                VALUES  ( @name ,
                          @id_parent ,
                          @id_chief  ,@creator_sid
                        )

						SELECT @id=@@IDENTITY
            END
	 
		SELECT @id AS id
    END
GO
PRINT N'Выполняется создание [dbo].[save_employee]...';


GO
CREATE PROCEDURE [dbo].[save_employee]
    @id INT = NULL ,
    @ad_sid VARCHAR(46) ,
    @id_manager INT ,
    @surname NVARCHAR(50) ,
    @name NVARCHAR(50) ,
    @patronymic NVARCHAR(50)=null ,
    @full_name NVARCHAR(150) ,
    @display_name NVARCHAR(100) ,
    @id_position INT ,
    @id_organization INT ,
    @email NVARCHAR(150) = null,
    @work_num NVARCHAR(50)  = null,
    @mobil_num NVARCHAR(50)  = null,
    @id_emp_state INT ,
    @id_department INT ,
    @id_city INT ,
    @date_came DATE =null ,
	@birth_date date= null,
	@male bit,
	@id_position_org int,
	@has_ad_account bit,
	@creator_sid varchar(46)=null
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
                        --id_emp_state = @id_emp_state ,
                        id_department = @id_department ,
                        id_city = @id_city ,
                        date_came = @date_came,
						birth_date=@birth_date,
						male=@male,
						id_position_org=@id_position_org,
						has_ad_account = @has_ad_account
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
                          date_came ,
						  birth_date,
						  male,
						  id_position_org,
						  has_ad_account,
						  creator_sid
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
                          @date_came  ,
						  @birth_date,
						  @male,
						  @id_position_org,
						  @has_ad_account,
						  @creator_sid
                        )

                SELECT  @id = @@IDENTITY
            END
	 
        SELECT @id AS id
    END
GO
PRINT N'Выполняется создание [dbo].[save_organization]...';


GO
CREATE PROCEDURE [dbo].[save_organization]
    @id INT = NULL ,
    @name NVARCHAR(150) ,
    @creator_sid VARCHAR(46) = NULL ,
    @address_ur NVARCHAR(500) = NULL ,
    @address_fact NVARCHAR(500) = NULL ,
    @phone NVARCHAR(50) = NULL ,
    @email NVARCHAR(50) = NULL ,
    @inn NVARCHAR(12) = NULL ,
    @kpp NVARCHAR(20) = NULL ,
    @ogrn NVARCHAR(20) = NULL ,
    @rs NVARCHAR(50) = NULL ,
    @bank NVARCHAR(500) = NULL ,
    @ks NVARCHAR(50) = NULL ,
    @bik NVARCHAR(50) = NULL ,
    @okpo NVARCHAR(50) = NULL ,
    @okved NVARCHAR(50) = NULL ,
    @manager_name NVARCHAR(150) = NULL ,
    @manager_name_dat NVARCHAR(150) = NULL ,
    @manager_position NVARCHAR(250) = NULL ,
    @manager_position_dat NVARCHAR(250) = NULL
AS
    BEGIN
        SET NOCOUNT ON;
        IF @id IS NOT NULL
            AND @id > 0
            AND EXISTS ( SELECT 1
                         FROM   organizations
                         WHERE  id = @id )
            BEGIN
                UPDATE  organizations
                SET     name = @name,
				@address_ur =@address_ur,
                          @address_fact = @address_fact,
                          @phone = @phone,
                          @email = @email,
                          @inn = @inn,
                          @kpp = @kpp,
                          @ogrn = @ogrn,
                          @rs = @rs,
                          @bank = @bank,
                          @ks = @ks,
                          @bik = @bik,
                          @okpo = @okpo,
                          @okved = @okved,
                          @manager_name = @manager_name,
                          @manager_name_dat = @manager_name_dat,
                          @manager_position = @manager_position,
                          @manager_position_dat =@manager_position_dat
                WHERE   id = @id
            END
        ELSE
            BEGIN
                INSERT  INTO organizations
                        ( name ,
                          creator_sid ,
                          address_ur ,
                          address_fact ,
                          phone ,
                          email ,
                          inn ,
                          kpp ,
                          ogrn ,
                          rs ,
                          bank ,
                          ks ,
                          bik ,
                          okpo ,
                          okved ,
                          manager_name ,
                          manager_name_dat ,
                          manager_position ,
                          manager_position_dat 
                        )
                VALUES  ( @name ,
                          @creator_sid ,
                          @address_ur ,
                          @address_fact ,
                          @phone ,
                          @email ,
                          @inn ,
                          @kpp ,
                          @ogrn ,
                          @rs ,
                          @bank ,
                          @ks ,
                          @bik ,
                          @okpo ,
                          @okved ,
                          @manager_name ,
                          @manager_name_dat ,
                          @manager_position ,
                          @manager_position_dat 
                        )

                SELECT  @id = @@IDENTITY
            END
	 
        SELECT  @id AS id
    END
GO
PRINT N'Выполняется создание [dbo].[save_photo]...';


GO
CREATE PROCEDURE [dbo].[save_photo]
    @id_employee INT ,
    @picture IMAGE,
	@creator_sid varchar(46) = null
AS
    BEGIN
        SET nocount ON;
        IF EXISTS ( SELECT  1
                    FROM    photos p
                    WHERE   p.id_employee = @id_employee )
            BEGIN
                UPDATE  photos
                SET     picture = @picture
				where id_employee = @id_employee
            END
        ELSE
            BEGIN
                INSERT  INTO photos
                        ( id_employee ,picture, creator_sid )
                VALUES  ( @id_employee, @picture, @creator_sid )
            END
    END
GO
PRINT N'Выполняется создание [dbo].[save_position]...';


GO
CREATE PROCEDURE [dbo].[save_position]
	@id INT = NULL ,
    @name NVARCHAR(500),
	@creator_sid varchar(46)=null
AS
    BEGIN
	SET NOCOUNT ON;
        IF @id IS NOT NULL
            AND @id > 0
            AND EXISTS ( SELECT 1
                         FROM   positions
                         WHERE  id = @id )
            BEGIN
                UPDATE  positions
                SET     name = @name 
                WHERE   id = @id
            END
        ELSE
            BEGIN
                INSERT  INTO positions
                        ( name  ,creator_sid
                        )
                VALUES  ( @name  ,@creator_sid
                        )

						SELECT @id=@@IDENTITY
            END
	 
		SELECT @id AS id
    END
GO
PRINT N'Выполняется создание [dbo].[set_employee_state]...';


GO
CREATE PROCEDURE [dbo].[set_employee_state]
	@id_employee int,
	@id_emp_state int
AS
begin
set nocount on;
update employees
set id_emp_state= @id_emp_state
where id = @id_employee

end
GO
-- Выполняется этап рефакторинга для обновления развернутых журналов транзакций на целевом сервере

IF OBJECT_ID(N'dbo.__RefactorLog') IS NULL
BEGIN
    CREATE TABLE [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
    EXEC sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
END
GO
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '7925ff97-a267-45fb-a848-6fa5f2fe5653')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('7925ff97-a267-45fb-a848-6fa5f2fe5653')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'bab710db-a69c-4cfd-81f9-4b289c99f088')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('bab710db-a69c-4cfd-81f9-4b289c99f088')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '823082de-8dc5-4c99-a8dd-ef76401ff9e8')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('823082de-8dc5-4c99-a8dd-ef76401ff9e8')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'a3723de1-4beb-4652-a154-46de2422ba12')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('a3723de1-4beb-4652-a154-46de2422ba12')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'd7ee292b-9850-440d-9616-d8a8f37c8ae0')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('d7ee292b-9850-440d-9616-d8a8f37c8ae0')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'eb2ab5df-e261-4998-a95f-ae5bfb59155b')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('eb2ab5df-e261-4998-a95f-ae5bfb59155b')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'e7f65736-d392-41b7-8ebb-9f4ba1dee9dd')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('e7f65736-d392-41b7-8ebb-9f4ba1dee9dd')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'd2eaf850-694c-4a9e-859c-9510f62c3a6d')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('d2eaf850-694c-4a9e-859c-9510f62c3a6d')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '10667296-64fc-4f83-8fef-3cf8692fb187')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('10667296-64fc-4f83-8fef-3cf8692fb187')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'cd1f7aba-4005-420b-b279-54526660c2c6')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('cd1f7aba-4005-420b-b279-54526660c2c6')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'e85b3eb9-eb91-41bc-8f17-3350b8f8734a')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('e85b3eb9-eb91-41bc-8f17-3350b8f8734a')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '5bd78363-5a25-4e53-be0f-4eb3397cbfc9')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('5bd78363-5a25-4e53-be0f-4eb3397cbfc9')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'd73f5243-d98b-4e73-bdf7-05207782c7d2')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('d73f5243-d98b-4e73-bdf7-05207782c7d2')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '5296580b-af79-40ef-8058-a120eee6eb0e')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('5296580b-af79-40ef-8058-a120eee6eb0e')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'a5e503e6-194d-4807-bdf8-ea81dfd26fdb')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('a5e503e6-194d-4807-bdf8-ea81dfd26fdb')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '5db26c6e-1291-40f2-b192-769be44d3ae7')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('5db26c6e-1291-40f2-b192-769be44d3ae7')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'dd3b36f5-0a82-4dad-8ed1-083e4fdc1852')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('dd3b36f5-0a82-4dad-8ed1-083e4fdc1852')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '72634209-685d-44e2-ba29-32e812a00340')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('72634209-685d-44e2-ba29-32e812a00340')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'aebbc97b-5295-4b14-b189-6514b3640211')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('aebbc97b-5295-4b14-b189-6514b3640211')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'e068b3a1-f7e7-4bc6-a2ea-1699f48e65eb')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('e068b3a1-f7e7-4bc6-a2ea-1699f48e65eb')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'ea52b8de-f887-4231-b2cb-8cd2ac2de5ea')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('ea52b8de-f887-4231-b2cb-8cd2ac2de5ea')

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
--:r .\ins_emp_states.sql
--:r .\ins_orgs.sql
--:r .\ins_cities.sql
--:r .\ins_positions.sql
GO

GO
DECLARE @VarDecimalSupported AS BIT;

SELECT @VarDecimalSupported = 0;

IF ((ServerProperty(N'EngineEdition') = 3)
    AND (((@@microsoftversion / power(2, 24) = 9)
          AND (@@microsoftversion & 0xffff >= 3024))
         OR ((@@microsoftversion / power(2, 24) = 10)
             AND (@@microsoftversion & 0xffff >= 1600))))
    SELECT @VarDecimalSupported = 1;

IF (@VarDecimalSupported > 0)
    BEGIN
        EXECUTE sp_db_vardecimal_storage_format N'$(DatabaseName)', 'ON';
    END


GO
PRINT N'Обновление завершено.';


GO
