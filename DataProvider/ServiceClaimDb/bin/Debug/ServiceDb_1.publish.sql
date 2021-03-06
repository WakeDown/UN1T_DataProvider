﻿/*
Deployment script for Service

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "Service"
:setvar DefaultFilePrefix "Service"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
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
PRINT N'Creating $(DatabaseName)...'
GO
CREATE DATABASE [$(DatabaseName)]
    ON 
    PRIMARY(NAME = [$(DatabaseName)], FILENAME = N'$(DefaultDataPath)$(DefaultFilePrefix)_Primary.mdf')
    LOG ON (NAME = [$(DatabaseName)_log], FILENAME = N'$(DefaultLogPath)$(DefaultFilePrefix)_Primary.ldf') COLLATE Cyrillic_General_CI_AS
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
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
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
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
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
PRINT N'Creating [dbo].[claim_states]...';


GO
CREATE TABLE [dbo].[claim_states] (
    [id]               INT           IDENTITY (1, 1) NOT NULL,
    [name]             NVARCHAR (50) NOT NULL,
    [sys_name]         NVARCHAR (20) NOT NULL,
    [order_num]        INT           NOT NULL,
    [enabled]          BIT           NOT NULL,
    [dattim1]          DATETIME      NOT NULL,
    [background_color] NVARCHAR (50) NULL,
    [foreground_color] NVARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Creating [dbo].[claim2claim_states]...';


GO
CREATE TABLE [dbo].[claim2claim_states] (
    [id]             BIGINT         IDENTITY (1, 1) NOT NULL,
    [id_claim]       INT            NOT NULL,
    [id_claim_state] INT            NOT NULL,
    [dattim1]        DATETIME       NOT NULL,
    [enabled]        BIT            NOT NULL,
    [creator_sid]    VARCHAR (46)   NOT NULL,
    [descr]          NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Creating [dbo].[claims]...';


GO
CREATE TABLE [dbo].[claims] (
    [id]              INT            IDENTITY (1, 1) NOT NULL,
    [sid]             VARCHAR (46)   NOT NULL,
    [id_contractor]   INT            NULL,
    [id_contract]     INT            NULL,
    [id_device]       INT            NULL,
    [contractor_name] NVARCHAR (500) NULL,
    [contract_number] NVARCHAR (150) NULL,
    [device_name]     NVARCHAR (500) NULL,
    [creator_sid]     VARCHAR (46)   NOT NULL,
    [id_admin]        INT            NULL,
    [id_engeneer]     INT            NULL,
    [dattim1]         DATETIME       NOT NULL,
    [dattim2]         DATETIME       NOT NULL,
    [enabled]         BIT            NOT NULL,
    [id_claim_state]  INT            NOT NULL,
    [deleter_sid]     VARCHAR (46)   NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Creating [dbo].[claims].[IX_service_claims_enabled]...';


GO
CREATE NONCLUSTERED INDEX [IX_service_claims_enabled]
    ON [dbo].[claims]([enabled] DESC);


GO
PRINT N'Creating [dbo].[claims].[IX_service_claims_id_admin]...';


GO
CREATE NONCLUSTERED INDEX [IX_service_claims_id_admin]
    ON [dbo].[claims]([id_admin] ASC);


GO
PRINT N'Creating [dbo].[claims].[IX_service_claims_id_engeneer]...';


GO
CREATE NONCLUSTERED INDEX [IX_service_claims_id_engeneer]
    ON [dbo].[claims]([id_engeneer] ASC);


GO
PRINT N'Creating unnamed constraint on [dbo].[claim_states]...';


GO
ALTER TABLE [dbo].[claim_states]
    ADD DEFAULT 500 FOR [order_num];


GO
PRINT N'Creating unnamed constraint on [dbo].[claim_states]...';


GO
ALTER TABLE [dbo].[claim_states]
    ADD DEFAULT 1 FOR [enabled];


GO
PRINT N'Creating unnamed constraint on [dbo].[claim_states]...';


GO
ALTER TABLE [dbo].[claim_states]
    ADD DEFAULT getdate() FOR [dattim1];


GO
PRINT N'Creating unnamed constraint on [dbo].[claim2claim_states]...';


GO
ALTER TABLE [dbo].[claim2claim_states]
    ADD DEFAULT getdate() FOR [dattim1];


GO
PRINT N'Creating unnamed constraint on [dbo].[claim2claim_states]...';


GO
ALTER TABLE [dbo].[claim2claim_states]
    ADD DEFAULT 1 FOR [enabled];


GO
PRINT N'Creating unnamed constraint on [dbo].[claims]...';


GO
ALTER TABLE [dbo].[claims]
    ADD DEFAULT newid() FOR [sid];


GO
PRINT N'Creating unnamed constraint on [dbo].[claims]...';


GO
ALTER TABLE [dbo].[claims]
    ADD DEFAULT getdate() FOR [dattim1];


GO
PRINT N'Creating unnamed constraint on [dbo].[claims]...';


GO
ALTER TABLE [dbo].[claims]
    ADD DEFAULT '3.3.3333' FOR [dattim2];


GO
PRINT N'Creating unnamed constraint on [dbo].[claims]...';


GO
ALTER TABLE [dbo].[claims]
    ADD DEFAULT 1 FOR [enabled];


GO
PRINT N'Creating [dbo].[claims_view]...';


GO
CREATE VIEW [dbo].[claims_view]
	AS SELECT  c.id, c.sid, c.id_contractor, c.id_contract, c.id_device, c.contractor_name, c.contract_number, c.device_name, c.id_admin, c.id_engeneer, c.id_claim_state
	FROM claims c where c.enabled = 1
GO
PRINT N'Creating [dbo].[close_claim]...';


GO
CREATE PROCEDURE [dbo].[close_claim]@sid varchar(46), @deleter_sid varchar(46)
AS
    BEGIN
        SET NOCOUNT ON;
        UPDATE  claims
        SET     enabled = 0, dattim2 = getdate(), deleter_sid=@deleter_sid
        WHERE   sid = @sid
    END
GO
PRINT N'Creating [dbo].[get_claim]...';


GO
CREATE PROCEDURE [dbo].[get_claim]
	@id int = null,
	@sid varchar(46) = null
	as begin
	set nocount on;
	select c.id, c.sid, c.id_contractor, c.id_contract, c.id_device, c.contractor_name, c.contract_number, c.device_name, c.id_admin, c.id_engeneer, c.id_claim_state
	from claims c
	where (@id is null or @id<= 0 or (@id is not null and @id> 0 and c.id=@id)) and
	(@sid is null or @sid= '' or (@id is not null and @sid!= '' and c.sid=@sid))
	end
GO
PRINT N'Creating [dbo].[get_claim_list]...';


GO
CREATE PROCEDURE [dbo].[get_claim_list]
	@id int = null
	as begin
	set nocount on;

	select c.id, c.sid, c.id_contractor, c.id_contract, c.id_device, c.contractor_name, c.contract_number, c.device_name, c.id_admin, c.id_engeneer, c.id_claim_state
	from claim_view c

	end
GO
PRINT N'Creating [dbo].[get_claim_state]...';


GO
CREATE PROCEDURE [dbo].[get_claim_state]
	@sys_name nvarchar(20) = null
	as begin set nocount on;

	end
GO
PRINT N'Creating [dbo].[save_claim]...';


GO
CREATE PROCEDURE [dbo].[save_claim]
	@id int = null,
	@sid varchar(46) = null,
	@id_contractor int = null,
	@id_contract int = null,
	@id_device int = null, 
	@contractor_name nvarchar(500) = null,
	@contract_number nvarchar(150) = null,
	@device_name nvarchar(500) = null,
	@creator_sid varchar(46),
	@id_admin int = null,
	@id_engeneer int = null
	--,	@id_claim_state int= null -- статус меняем отдельной процедурой
	as begin
	set nocount on;
	if (@id is not null and @id > 0 and exists(select 1 from claims where id=@id))
	begin
		update claims
		set creator_sid=@creator_sid,id_admin=@id_admin, id_engeneer=@id_engeneer
		--id_contractor = @id_contractor,id_contract=@id_contract,id_device=@id_device, contractor_name=@contractor_name, contract_number=@contract_number, device_name=@device_name, id_claim_state=@id_claim_state
		where id=@id
	end
	else if (@sid is not null and @sid <> '' and exists(select 1 from claims where sid=@sid))
	begin
		update claims
		set creator_sid=@creator_sid,id_admin=@id_admin, id_engeneer=@id_engeneer
		--id_contractor = @id_contractor,id_contract=@id_contract,id_device=@id_device, contractor_name=@contractor_name, contract_number=@contract_number, device_name=@device_name, id_claim_state=@id_claim_state
		where sid=@sid
	end
	else
	begin
	insert into claims(id_contractor, id_contract, id_device, contractor_name, contract_number, device_name, creator_sid, id_admin, id_engeneer, id_claim_state)
	values(@id_contractor, @id_contract, @id_device, @contractor_name, @contract_number, @device_name, @creator_sid, @id_admin, @id_engeneer, 0)

	end

	end
GO
PRINT N'Creating [dbo].[save_claim2claim_state]...';


GO
CREATE PROCEDURE [dbo].[save_claim2claim_state]
	@id_claim int,
	@id_claim_state int,
	@creator_sid varchar(46),
	@descr nvarchar(max)
	as begin set nocount on;
	
	insert into claim2claim_states(id_claim, id_claim_state, creator_sid, descr)
	values (@id_claim, @id_claim_state, @creator_sid, @descr)	

	end
GO
PRINT N'Creating [dbo].[set_claim_claim_state]...';


GO
CREATE PROCEDURE [dbo].[set_claim_claim_state]
	@id int = null,
	@sid varchar(46) = null,
	@id_claim_state int
AS
begin
set nocount on;
if @id is not null and @id > 0
begin
update claims
set id_claim_state=@id_claim_state
where id=@id end 
else if @sid is not null and @sid <> ''
begin
	update claims
set id_claim_state=@id_claim_state
where sid=@sid 
end
end
GO
-- Refactoring step to update target server with deployed transaction logs

IF OBJECT_ID(N'dbo.__RefactorLog') IS NULL
BEGIN
    CREATE TABLE [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
    EXEC sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
END
GO
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'b83b2a2d-c137-4b7b-804a-033fe63ffad0')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('b83b2a2d-c137-4b7b-804a-033fe63ffad0')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'aaf171b6-a888-4e7e-aeff-a29c64e3fc42')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('aaf171b6-a888-4e7e-aeff-a29c64e3fc42')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '11e3d99e-0851-4213-938e-9f8bae7069a6')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('11e3d99e-0851-4213-938e-9f8bae7069a6')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '4f09af0f-807e-4953-bb87-a92f404ec92f')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('4f09af0f-807e-4953-bb87-a92f404ec92f')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '7f0686f2-d840-4408-a982-1085900f2aff')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('7f0686f2-d840-4408-a982-1085900f2aff')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'd7b74989-299a-41a6-b637-c7d70c819e14')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('d7b74989-299a-41a6-b637-c7d70c819e14')

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
PRINT N'Update complete.';


GO
