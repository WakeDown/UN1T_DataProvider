/*
Скрипт развертывания для SpeCalc

Этот код был создан программным средством.
Изменения, внесенные в этот файл, могут привести к неверному выполнению кода и будут потеряны
в случае его повторного формирования.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "SpeCalc"
:setvar DefaultFilePrefix "SpeCalc"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\"

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
PRINT N'Выполняется создание [ContentDBFSGroup]...';


GO
ALTER DATABASE [$(DatabaseName)]
    ADD FILEGROUP [ContentDBFSGroup] CONTAINS FILESTREAM;


GO
ALTER DATABASE [$(DatabaseName)]
    ADD FILE (NAME = [ContentDBFSGroup_6F773D2D], FILENAME = N'$(DefaultDataPath)$(DefaultFilePrefix)_ContentDBFSGroup_6F773D2D.mdf') TO FILEGROUP [ContentDBFSGroup];


GO
IF (SELECT is_default
    FROM   [$(DatabaseName)].[sys].[filegroups]
    WHERE  [name] = N'ContentDBFSGroup') = 0
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            MODIFY FILEGROUP [ContentDBFSGroup] DEFAULT;
    END


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
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET PAGE_VERIFY NONE,
                DISABLE_BROKER 
            WITH ROLLBACK IMMEDIATE;
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
PRINT N'Операция рефакторинга Rename с помощью ключа 12d8e0db-fc0a-49a8-a3ce-fb31bef47b4a пропущена, элемент [dbo].[QuestionStates].[Id] (SqlSimpleColumn) не будет переименован в id';


GO
PRINT N'Операция рефакторинга Rename с помощью ключа f8815890-cea6-4312-89e9-de907c39b15a пропущена, элемент [dbo].[QuestionStateHistory].[Id] (SqlSimpleColumn) не будет переименован в id';


GO
PRINT N'Выполняется создание [dbo].[CalculateClaimPosition]...';


GO
CREATE TABLE [dbo].[CalculateClaimPosition] (
    [Id]               INT             IDENTITY (1, 1) NOT NULL,
    [IdPosition]       INT             NOT NULL,
    [IdClaim]          INT             NOT NULL,
    [CatalogNumber]    NVARCHAR (500)  NOT NULL,
    [Name]             NVARCHAR (1000) NOT NULL,
    [ReplaceValue]     NVARCHAR (1000) NULL,
    [PriceCurrency]    DECIMAL (18, 2) NULL,
    [SumCurrency]      DECIMAL (18, 2) NULL,
    [PriceRub]         DECIMAL (18, 2) NULL,
    [SumRub]           DECIMAL (18, 2) NOT NULL,
    [Provider]         NVARCHAR (150)  NULL,
    [ProtectFact]      INT             NULL,
    [ProtectCondition] NVARCHAR (500)  NULL,
    [Comment]          NVARCHAR (1000) NULL,
    [Author]           NVARCHAR (150)  NULL,
    [Deleted]          BIT             NOT NULL,
    [DeletedUser]      NVARCHAR (150)  NULL,
    [DeleteDate]       DATETIME        NULL,
    [Currency]         INT             NULL,
    [PriceUsd]         DECIMAL (18, 2) NULL,
    [PriceEur]         DECIMAL (18, 2) NULL,
    [PriceEurRicoh]    DECIMAL (18, 2) NULL,
    [PriceRubl]        DECIMAL (18, 2) NULL,
    [DeliveryTime]     INT             NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[CalculateClaimPosition].[i_idClaim_calculateClaimPosition]...';


GO
CREATE NONCLUSTERED INDEX [i_idClaim_calculateClaimPosition]
    ON [dbo].[CalculateClaimPosition]([IdClaim] ASC);


GO
PRINT N'Выполняется создание [dbo].[CalculateClaimPosition].[i_idPosition_calculateClaimPosition]...';


GO
CREATE NONCLUSTERED INDEX [i_idPosition_calculateClaimPosition]
    ON [dbo].[CalculateClaimPosition]([IdPosition] ASC);


GO
PRINT N'Выполняется создание [dbo].[ClaimCertFiles]...';


GO
CREATE TABLE [dbo].[ClaimCertFiles] (
    [Id]       INT                        IDENTITY (1, 1) NOT NULL,
    [IdClaim]  INT                        NOT NULL,
    [fileDATA] VARBINARY (MAX) FILESTREAM NOT NULL,
    [enabled]  BIT                        NOT NULL,
    [fileGUID] UNIQUEIDENTIFIER           ROWGUIDCOL NOT NULL,
    [fileName] NVARCHAR (500)             NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([fileGUID] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[ClaimPosition]...';


GO
CREATE TABLE [dbo].[ClaimPosition] (
    [Id]             INT             IDENTITY (1, 1) NOT NULL,
    [IdClaim]        INT             NOT NULL,
    [RowNumber]      INT             NULL,
    [CatalogNumber]  NVARCHAR (500)  NULL,
    [Name]           NVARCHAR (MAX)  NULL,
    [ReplaceValue]   NVARCHAR (1000) NULL,
    [Unit]           NVARCHAR (10)   NOT NULL,
    [Value]          INT             NOT NULL,
    [ProductManager] NVARCHAR (500)  NOT NULL,
    [Comment]        NVARCHAR (1500) NOT NULL,
    [Price]          DECIMAL (18, 2) NULL,
    [SumMax]         DECIMAL (18, 2) NULL,
    [PositionState]  INT             NOT NULL,
    [Author]         NVARCHAR (150)  NULL,
    [Deleted]        BIT             NOT NULL,
    [DeletedUser]    NVARCHAR (150)  NULL,
    [DeleteDate]     DATETIME        NULL,
    [Currency]       INT             NULL,
    [PriceTzr]       DECIMAL (18, 2) NOT NULL,
    [SumTzr]         DECIMAL (18, 2) NOT NULL,
    [PriceNds]       DECIMAL (18, 2) NOT NULL,
    [SumNds]         DECIMAL (18, 2) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[ClaimPosition].[i_idClaim_claimPosition]...';


GO
CREATE NONCLUSTERED INDEX [i_idClaim_claimPosition]
    ON [dbo].[ClaimPosition]([IdClaim] ASC);


GO
PRINT N'Выполняется создание [dbo].[ClaimStatus]...';


GO
CREATE TABLE [dbo].[ClaimStatus] (
    [Id]    INT            NOT NULL,
    [Value] NVARCHAR (100) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[ClaimStatusHistory]...';


GO
CREATE TABLE [dbo].[ClaimStatusHistory] (
    [Id]         INT             IDENTITY (1, 1) NOT NULL,
    [RecordDate] DATETIME        NOT NULL,
    [IdClaim]    INT             NOT NULL,
    [IdStatus]   INT             NOT NULL,
    [Comment]    NVARCHAR (1000) NULL,
    [IdUser]     NVARCHAR (500)  NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[Currency]...';


GO
CREATE TABLE [dbo].[Currency] (
    [Id]    INT            NOT NULL,
    [Value] NVARCHAR (100) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[DealType]...';


GO
CREATE TABLE [dbo].[DealType] (
    [Id]    INT            NOT NULL,
    [Value] NVARCHAR (100) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[DeliveryTime]...';


GO
CREATE TABLE [dbo].[DeliveryTime] (
    [Id]    INT            NOT NULL,
    [Value] NVARCHAR (100) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[PositionState]...';


GO
CREATE TABLE [dbo].[PositionState] (
    [Id]    INT            NOT NULL,
    [Value] NVARCHAR (100) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[ProtectFact]...';


GO
CREATE TABLE [dbo].[ProtectFact] (
    [Id]    INT            NOT NULL,
    [Value] NVARCHAR (100) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[QuePosAnswer]...';


GO
CREATE TABLE [dbo].[QuePosAnswer] (
    [id]              INT            IDENTITY (1, 1) NOT NULL,
    [id_que_position] INT            NOT NULL,
    [answerer_sid]    VARCHAR (46)   NOT NULL,
    [descr]           NVARCHAR (MAX) NOT NULL,
    [dattim1]         DATETIME       NOT NULL,
    [dattim2]         DATETIME       NOT NULL,
    [enabled]         BIT            NOT NULL,
    [creator_sid]     VARCHAR (46)   NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[QuestionPositions]...';


GO
CREATE TABLE [dbo].[QuestionPositions] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [id_question] INT            NOT NULL,
    [user_sid]    VARCHAR (46)   NOT NULL,
    [descr]       NVARCHAR (MAX) NOT NULL,
    [dattim1]     DATETIME       NOT NULL,
    [dattim2]     DATETIME       NOT NULL,
    [enabled]     BIT            NOT NULL,
    [creator_sid] VARCHAR (46)   NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[Questions]...';


GO
CREATE TABLE [dbo].[Questions] (
    [id]           INT            IDENTITY (1, 1) NOT NULL,
    [manager_sid]  VARCHAR (46)   NOT NULL,
    [date_limit]   DATETIME       NOT NULL,
    [dattim1]      DATETIME       NOT NULL,
    [dattim2]      DATETIME       NOT NULL,
    [enabled]      BIT            NOT NULL,
    [creator_sid]  VARCHAR (46)   NOT NULL,
    [descr]        NVARCHAR (MAX) NULL,
    [id_que_state] INT            NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


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
    [enabled]      BIT            NULL,
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
PRINT N'Выполняется создание [dbo].[Roles]...';


GO
CREATE TABLE [dbo].[Roles] (
    [Id]        INT            NOT NULL,
    [GroupId]   NVARCHAR (500) NOT NULL,
    [GroupName] NVARCHAR (500) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[TenderClaim]...';


GO
CREATE TABLE [dbo].[TenderClaim] (
    [Id]                 INT             IDENTITY (1, 1) NOT NULL,
    [TenderNumber]       NVARCHAR (150)  NULL,
    [TenderStart]        DATETIME        NOT NULL,
    [ClaimDeadline]      DATETIME        NOT NULL,
    [KPDeadline]         DATETIME        NOT NULL,
    [Comment]            NVARCHAR (1000) NULL,
    [Customer]           NVARCHAR (150)  NOT NULL,
    [CustomerInn]        NVARCHAR (150)  NULL,
    [TotalSum]           DECIMAL (18, 2) NULL,
    [DealType]           INT             NOT NULL,
    [TenderUrl]          NVARCHAR (1500) NULL,
    [TenderStatus]       INT             NOT NULL,
    [Manager]            NVARCHAR (500)  NOT NULL,
    [ManagerSubDivision] NVARCHAR (500)  NOT NULL,
    [ClaimStatus]        INT             NOT NULL,
    [RecordDate]         DATETIME        NOT NULL,
    [Deleted]            BIT             NOT NULL,
    [Author]             NVARCHAR (150)  NULL,
    [DeletedUser]        NVARCHAR (150)  NULL,
    [DeleteDate]         DATETIME        NULL,
    [CurrencyUsd]        DECIMAL (18, 2) NOT NULL,
    [CurrencyEur]        DECIMAL (18, 2) NOT NULL,
    [DeliveryDate]       DATETIME        NULL,
    [DeliveryPlace]      NVARCHAR (1000) NOT NULL,
    [AuctionDate]        DATETIME        NULL,
    [IdSumCurrency]      INT             NULL,
    [DeliveryDateEnd]    DATETIME        NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[TenderStatus]...';


GO
CREATE TABLE [dbo].[TenderStatus] (
    [Id]    INT            NOT NULL,
    [Value] NVARCHAR (100) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[ClaimCertFiles]...';


GO
ALTER TABLE [dbo].[ClaimCertFiles]
    ADD DEFAULT 1 FOR [enabled];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[ClaimCertFiles]...';


GO
ALTER TABLE [dbo].[ClaimCertFiles]
    ADD DEFAULT newid() FOR [fileGUID];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[ClaimPosition]...';


GO
ALTER TABLE [dbo].[ClaimPosition]
    ADD DEFAULT ((-1)) FOR [PriceTzr];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[ClaimPosition]...';


GO
ALTER TABLE [dbo].[ClaimPosition]
    ADD DEFAULT ((-1)) FOR [SumTzr];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[ClaimPosition]...';


GO
ALTER TABLE [dbo].[ClaimPosition]
    ADD DEFAULT ((-1)) FOR [PriceNds];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[ClaimPosition]...';


GO
ALTER TABLE [dbo].[ClaimPosition]
    ADD DEFAULT ((-1)) FOR [SumNds];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[QuePosAnswer]...';


GO
ALTER TABLE [dbo].[QuePosAnswer]
    ADD DEFAULT getdate() FOR [dattim1];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[QuePosAnswer]...';


GO
ALTER TABLE [dbo].[QuePosAnswer]
    ADD DEFAULT '3.3.3333' FOR [dattim2];


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
    ADD DEFAULT '3.3.3333' FOR [dattim2];


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
    ADD DEFAULT '3.3.3333' FOR [dattim2];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[Questions]...';


GO
ALTER TABLE [dbo].[Questions]
    ADD DEFAULT 1 FOR [enabled];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[QuestionStateHistory]...';


GO
ALTER TABLE [dbo].[QuestionStateHistory]
    ADD DEFAULT getdate() FOR [dattim1];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[QuestionStateHistory]...';


GO
ALTER TABLE [dbo].[QuestionStateHistory]
    ADD DEFAULT 1 FOR [enabled];


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
PRINT N'Выполняется создание ограничение без названия для [dbo].[TenderClaim]...';


GO
ALTER TABLE [dbo].[TenderClaim]
    ADD DEFAULT ((-1)) FOR [CurrencyUsd];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[TenderClaim]...';


GO
ALTER TABLE [dbo].[TenderClaim]
    ADD DEFAULT ((-1)) FOR [CurrencyEur];


GO
PRINT N'Выполняется создание ограничение без названия для [dbo].[TenderClaim]...';


GO
ALTER TABLE [dbo].[TenderClaim]
    ADD DEFAULT ('') FOR [DeliveryPlace];


GO
PRINT N'Выполняется создание [dbo].[FK_CalculateClaimPosition_ClaimPosition]...';


GO
ALTER TABLE [dbo].[CalculateClaimPosition] WITH NOCHECK
    ADD CONSTRAINT [FK_CalculateClaimPosition_ClaimPosition] FOREIGN KEY ([IdPosition]) REFERENCES [dbo].[ClaimPosition] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE;


GO
PRINT N'Выполняется создание [dbo].[FK_CalculateClaimPosition_Currency]...';


GO
ALTER TABLE [dbo].[CalculateClaimPosition] WITH NOCHECK
    ADD CONSTRAINT [FK_CalculateClaimPosition_Currency] FOREIGN KEY ([Currency]) REFERENCES [dbo].[Currency] ([Id]);


GO
PRINT N'Выполняется создание [dbo].[FK_CalculateClaimPosition_ProtectFact]...';


GO
ALTER TABLE [dbo].[CalculateClaimPosition] WITH NOCHECK
    ADD CONSTRAINT [FK_CalculateClaimPosition_ProtectFact] FOREIGN KEY ([ProtectFact]) REFERENCES [dbo].[ProtectFact] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE;


GO
PRINT N'Выполняется создание [dbo].[FK_CalculateClaimPosition_TenderClaim]...';


GO
ALTER TABLE [dbo].[CalculateClaimPosition] WITH NOCHECK
    ADD CONSTRAINT [FK_CalculateClaimPosition_TenderClaim] FOREIGN KEY ([IdClaim]) REFERENCES [dbo].[TenderClaim] ([Id]);


GO
PRINT N'Выполняется создание [dbo].[FK_ClaimPosition_Currency]...';


GO
ALTER TABLE [dbo].[ClaimPosition] WITH NOCHECK
    ADD CONSTRAINT [FK_ClaimPosition_Currency] FOREIGN KEY ([Currency]) REFERENCES [dbo].[Currency] ([Id]);


GO
PRINT N'Выполняется создание [dbo].[FK_ClaimPosition_PositionState]...';


GO
ALTER TABLE [dbo].[ClaimPosition] WITH NOCHECK
    ADD CONSTRAINT [FK_ClaimPosition_PositionState] FOREIGN KEY ([PositionState]) REFERENCES [dbo].[PositionState] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE;


GO
PRINT N'Выполняется создание [dbo].[FK_ClaimPosition_TenderClaim]...';


GO
ALTER TABLE [dbo].[ClaimPosition] WITH NOCHECK
    ADD CONSTRAINT [FK_ClaimPosition_TenderClaim] FOREIGN KEY ([IdClaim]) REFERENCES [dbo].[TenderClaim] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE;


GO
PRINT N'Выполняется создание [dbo].[FK_ClaimStatusHistory_ClaimStatus]...';


GO
ALTER TABLE [dbo].[ClaimStatusHistory] WITH NOCHECK
    ADD CONSTRAINT [FK_ClaimStatusHistory_ClaimStatus] FOREIGN KEY ([IdStatus]) REFERENCES [dbo].[ClaimStatus] ([Id]);


GO
PRINT N'Выполняется создание [dbo].[FK_ClaimStatusHistory_TenderClaim]...';


GO
ALTER TABLE [dbo].[ClaimStatusHistory] WITH NOCHECK
    ADD CONSTRAINT [FK_ClaimStatusHistory_TenderClaim] FOREIGN KEY ([IdClaim]) REFERENCES [dbo].[TenderClaim] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE;


GO
PRINT N'Выполняется создание [dbo].[FK_TenderClaim_ClaimStatus]...';


GO
ALTER TABLE [dbo].[TenderClaim] WITH NOCHECK
    ADD CONSTRAINT [FK_TenderClaim_ClaimStatus] FOREIGN KEY ([ClaimStatus]) REFERENCES [dbo].[ClaimStatus] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE;


GO
PRINT N'Выполняется создание [dbo].[FK_TenderClaim_DealType]...';


GO
ALTER TABLE [dbo].[TenderClaim] WITH NOCHECK
    ADD CONSTRAINT [FK_TenderClaim_DealType] FOREIGN KEY ([DealType]) REFERENCES [dbo].[DealType] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE;


GO
PRINT N'Выполняется создание [dbo].[FK_TenderClaim_TenderStatus]...';


GO
ALTER TABLE [dbo].[TenderClaim] WITH NOCHECK
    ADD CONSTRAINT [FK_TenderClaim_TenderStatus] FOREIGN KEY ([TenderStatus]) REFERENCES [dbo].[TenderStatus] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE;


GO
PRINT N'Выполняется создание [dbo].[Split]...';


GO
create function [dbo].[Split]
(
    @value varchar(max),
    @delimiter nvarchar(10)
)
returns @SplittedValues table
(
    value int
)
as
begin
    declare @SplitLength int
    
    while len(@value) > 0
    begin 
        select @SplitLength = (case charindex(@delimiter,@value) when 0 then
            len(@value) else charindex(@delimiter,@value) -1 end)
 
        insert into @SplittedValues
        select cast(substring(@value,1,@SplitLength) as int)
    
        select @value = (case (len(@value) - @SplitLength) when 0 then  ''
            else right(@value, len(@value) - @SplitLength - 1) end)
    end 
return  
end
GO
PRINT N'Выполняется создание [dbo].[questions_view]...';


GO
CREATE VIEW [dbo].[questions_view]
	AS SELECT id, manager_sid, date_limit, dattim1, descr , id_que_state, (select name from QuestionStates qs where qs.id=q.id_que_state) as que_state
	FROM Questions q 
	where enabled = 1
GO
PRINT N'Выполняется создание [dbo].[ChangeClaimPositionState]...';


GO

create procedure ChangeClaimPositionState
(
	@id int,
	@positionState int
)
as
update ClaimPosition set PositionState = @positionState where Deleted = 0 and Id = @id
GO
PRINT N'Выполняется создание [dbo].[ChangePositionsProduct]...';


GO

create procedure ChangePositionsProduct
(
	@ids nvarchar(max),
	@product nvarchar(500)
)
as
update ClaimPosition set ProductManager = @product where Deleted = 0 and Id in (select * from dbo.Split(@ids,','));
GO
PRINT N'Выполняется создание [dbo].[ChangePositionsState]...';


GO

create procedure ChangePositionsState
(
	@ids nvarchar(max),
	@state int
)
as
update ClaimPosition set PositionState = @state where Deleted = 0 and Id in (select * from dbo.Split(@ids,','));
GO
PRINT N'Выполняется создание [dbo].[ChangeTenderClaimClaimStatus]...';


GO

create procedure ChangeTenderClaimClaimStatus
(
	@id int,
	@claimStatus int
)
as
update TenderClaim set ClaimStatus = @claimStatus where Id = @id
GO
PRINT N'Выполняется создание [dbo].[ChangeTenderClaimTenderStatus]...';


GO

create procedure ChangeTenderClaimTenderStatus
(
	@id int,
	@status int
)
as
update TenderClaim set TenderStatus = @status where Id = @id
GO
PRINT N'Выполняется создание [dbo].[check_question_can_be_answered]...';


GO
CREATE PROCEDURE [dbo].[check_question_can_be_answered] @id_question INT
AS
    BEGIN
        SET NOCOUNT ON;

        IF EXISTS ( SELECT  1
                    FROM    QuestionPositions p
                    WHERE   enabled = 1
                            AND id_question = @id_question
                            AND NOT EXISTS ( SELECT 1
                                             FROM   QuePosAnswer a
                                             WHERE  a.enabled = 1
                                                    AND a.id_que_position = p.id ) )
            BEGIN
                SELECT  0 as result
            END
        ELSE
            BEGIN
                SELECT  1 as result
            END
    END
GO
PRINT N'Выполняется создание [dbo].[check_question_can_be_sent]...';


GO
CREATE PROCEDURE [dbo].[check_question_can_be_sent] @id_question INT
AS
    BEGIN
        SET NOCOUNT ON;

        IF EXISTS ( SELECT  1
                    FROM    QuestionPositions p
                    WHERE   enabled = 1
                            AND id_question = @id_question)
            BEGIN
                SELECT  1 as result
            END
        ELSE
            BEGIN
                SELECT  0 as result
            END
    END
GO
PRINT N'Выполняется создание [dbo].[close_que_pos_answer]...';


GO
CREATE PROCEDURE [dbo].[close_que_pos_answer] @id INT
AS
    BEGIN
        SET NOCOUNT ON;
        UPDATE  QuePosAnswer
        SET     enabled = 0, dattim2=getdate()
        WHERE   id = @id
    END
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
PRINT N'Выполняется создание [dbo].[DeleteCalculateClaimPosition]...';


GO

create procedure DeleteCalculateClaimPosition
(
	@id int,
	@deletedUser nvarchar(150),
	@date datetime
)
as
update CalculateClaimPosition set Deleted = 1, DeletedUser = @deletedUser, DeleteDate = @date where Id = @id
GO
PRINT N'Выполняется создание [dbo].[DeleteCalculateForPositions]...';


GO

create procedure DeleteCalculateForPositions
(
    @idClaim int,
	@ids nvarchar(max)
)
as
delete from CalculateClaimPosition where IdClaim = @idClaim and IdPosition in(select * from dbo.Split(@ids,','));
GO
PRINT N'Выполняется создание [dbo].[DeleteCalculatePositionForClaim]...';


GO

create procedure DeleteCalculatePositionForClaim
(
	@id int
)
as
delete from CalculateClaimPosition where IdClaim = @id
GO
PRINT N'Выполняется создание [dbo].[DeleteClaimCertFile]...';


GO
CREATE PROCEDURE [dbo].[DeleteClaimCertFile]
	@Id INT,
	@file VARBINARY(MAX) 
AS
BEGIN
set NOCOUNT ON;
update ClaimCertFiles 
set fileDATA = @file
where Id=@Id

END
GO
PRINT N'Выполняется создание [dbo].[DeleteClaimPosition]...';


GO

create procedure DeleteClaimPosition
(
	@id int,
	@deletedUser nvarchar(150),
	@date datetime
)
as
update ClaimPosition set Deleted = 1, DeletedUser = @deletedUser, DeleteDate = @date where Id = @id
GO
PRINT N'Выполняется создание [dbo].[DeleteTenderClaims]...';


GO

create procedure DeleteTenderClaims
(
	@id int,
	@deletedUser nvarchar(150),
	@date datetime
)
as
update TenderClaim set Deleted = 1, DeletedUser = @deletedUser, DeleteDate = @date where Id = @id
GO
PRINT N'Выполняется создание [dbo].[ExistsClaimPosition]...';


GO

CREATE procedure ExistsClaimPosition
(
	@idClaim int,
	@rowNumber int = -1,
	@catalogNumber nvarchar(500) = '',
	@name nvarchar(1000),
	@replaceValue nvarchar(1000) = '',
	@unit nvarchar(10),
	@value int,
	@productManager nvarchar(500),
	@comment nvarchar(1500),
	@price decimal(18,2) = -1,
	@sumMax decimal(18,2) = -1,
	@positionState int,
  @currency int,
	@priceTzr decimal(18,2) = -1,
	@sumTzr decimal(18,2) = -1,
	@priceNds decimal(18,2) = -1,
	@sumNds decimal(18,2) = -1
)
as
declare @result int;
declare @count int;
set @result = 0;
set @count = (select count(*) from ClaimPosition where Deleted = 0 and IdClaim = @idClaim and RowNumber = @rowNumber and CatalogNumber = @catalogNumber
	and Name = @name and ReplaceValue = @replaceValue and Unit = @unit and Value = @value and ProductManager = @productManager and
	Comment = @comment and Price = @price and SumMax = @sumMax and PositionState = @positionState and Currency = @currency
  and PriceTzr = @priceTzr and SumTzr = @sumTzr and PriceNds = @priceNds and SumNds = @sumNds);
if @count > 0
begin
	set @result = 1;
end
select @result;
GO
PRINT N'Выполняется создание [dbo].[FilterTenderClaims]...';


GO

CREATE procedure FilterTenderClaims
(
  @rowCount int,
 @idClaim int = null,
 @tenderNumber nvarchar(150) = null,
 @claimStatusIds nvarchar(max) = null,
 @manager nvarchar(500) = null,
 @managerSubDivision nvarchar(500) = null,
 @tenderStartFrom datetime = null,
 @tenderStartTo datetime = null,
 @overdie bit = null,
 @idProductManager nvarchar(500) = null,
 @author nvarchar(150) = null
)
as
select top(@rowCount) * from TenderClaim where Deleted = 0 and ((@idClaim is null) or (@idClaim is not null and Id = @idClaim)) 
and ((@tenderNumber is null) or (@tenderNumber is not null and TenderNumber = @tenderNumber))
and ((@claimStatusIds is null) or (@claimStatusIds is not null and ClaimStatus in (select * from dbo.Split(@claimStatusIds,','))))
and ((@manager is null) or (@manager is not null and Manager = @manager))
and ((@managerSubDivision is null) or (@managerSubDivision is not null and ManagerSubDivision = @managerSubDivision))
and ((@author is null) or (@author is not null and Author = @author))
and ((@idProductManager is null) or (@idProductManager is not null and @idProductManager in (select ProductManager from ClaimPosition where IdClaim = [TenderClaim].Id)))
and ((@overdie is null) or (@overdie is not null and 
((@overdie = 1 and GETDATE() > ClaimDeadline and ClaimStatus not in(1,8)) or (@overdie = 0 and GETDATE() < ClaimDeadline  and ClaimStatus not in(1,8)))))
and ((@tenderStartFrom is null and @tenderStartTo is null) or (@tenderStartFrom is not null and @tenderStartTo is not null
and ClaimDeadline BETWEEN @tenderStartFrom AND @tenderStartTo) or (@tenderStartFrom is null and @tenderStartTo is not null
and ClaimDeadline <= @tenderStartTo) or (@tenderStartFrom is not null and @tenderStartTo is null
and ClaimDeadline >= @tenderStartFrom)) order by Id desc
GO
PRINT N'Выполняется создание [dbo].[FilterTenderClaimsCount]...';


GO

CREATE procedure FilterTenderClaimsCount
(
 @idClaim int = null,
 @tenderNumber nvarchar(150) = null,
 @claimStatusIds nvarchar(max) = null,
 @manager nvarchar(500) = null,
 @managerSubDivision nvarchar(500) = null,
 @tenderStartFrom datetime = null,
 @tenderStartTo datetime = null,
 @overdie bit = null,
 @idProductManager nvarchar(500) = null,
 @author nvarchar(150) = null
)
as
select count(*) from TenderClaim where Deleted = 0 and ((@idClaim is null) or (@idClaim is not null and Id = @idClaim)) 
and ((@tenderNumber is null) or (@tenderNumber is not null and TenderNumber = @tenderNumber))
and ((@claimStatusIds is null) or (@claimStatusIds is not null and ClaimStatus in (select * from dbo.Split(@claimStatusIds,','))))
and ((@manager is null) or (@manager is not null and Manager = @manager))
and ((@managerSubDivision is null) or (@managerSubDivision is not null and ManagerSubDivision = @managerSubDivision))
and ((@author is null) or (@author is not null and Author = @author))
and ((@idProductManager is null) or (@idProductManager is not null and @idProductManager in (select ProductManager from ClaimPosition where IdClaim = [TenderClaim].Id)))
and ((@overdie is null) or (@overdie is not null and 
((@overdie = 1 and GETDATE() > ClaimDeadline  and ClaimStatus not in(1,8)) or (@overdie = 0 and GETDATE() < ClaimDeadline  and ClaimStatus not in(1,8)))))
and ((@tenderStartFrom is null and @tenderStartTo is null) or (@tenderStartFrom is not null and @tenderStartTo is not null
and ClaimDeadline BETWEEN @tenderStartFrom AND @tenderStartTo) or (@tenderStartFrom is null and @tenderStartTo is not null
and ClaimDeadline <= @tenderStartTo) or (@tenderStartFrom is not null and @tenderStartTo is null
and ClaimDeadline >= @tenderStartFrom))
GO
PRINT N'Выполняется создание [dbo].[get_que_pos_answer]...';


GO
CREATE PROCEDURE [dbo].[get_que_pos_answer] @id INT = NULL, @id_que_position int
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  t.id, id_que_position, answerer_sid, t.descr, p.id_question 
        FROM    QuePosAnswer t
		INNER JOIN QuestionPositions p ON t.id_que_position = p.id
        WHERE  t.enabled = 1 AND   ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND t.id = @id
                         )
                    )
					and
					t.id_que_position=@id_que_position
					order by t.id desc
    END
GO
PRINT N'Выполняется создание [dbo].[get_que_state_history]...';


GO
CREATE PROCEDURE [dbo].[get_que_state_history] @id_question INT
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  --st.name as que_state ,
		sh.id_que_state,
                sh.dattim1 ,
                sh.creator_sid
        FROM    QuestionStateHistory sh
                --INNER JOIN QuestionStates st ON st.id = sh.id_question
        WHERE   sh.enabled = 1
                AND sh.id_question = @id_question
				order by id DESC
    END
GO
PRINT N'Выполняется создание [dbo].[get_question]...';


GO
CREATE PROCEDURE [dbo].[get_question]
    @id INT = NULL ,
    @manager_sid VARCHAR(46) = NULL ,
    @lst_que_states NVARCHAR(100) = NULL ,
    @top INT
	,@prod_sid VARCHAR(46) = NULL 
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT top ( @top ) id ,
                manager_sid ,
                date_limit ,
                descr ,
                id_que_state ,
                que_state ,
                dattim1
        FROM    questions_view q
        WHERE   ( @id IS NULL
                  OR ( @id IS NOT NULL
                       AND @id > 0
                       AND q.id = @id
                     )
                )
                AND ( ( @manager_sid IS NULL
                        OR @manager_sid = ''
                      )
                      OR ( @manager_sid IS NOT NULL
                           AND @manager_sid != ''
                           AND q.manager_sid = @manager_sid
                         )
                    )
                AND ( ( @lst_que_states IS NULL
                        OR @lst_que_states = ''
                      )
                      OR ( @lst_que_states IS NOT NULL
                           AND @lst_que_states != ''
                           AND q.id_que_state IN (
                           SELECT   value
                           FROM     Split(@lst_que_states, ',') )
                         )
                    )
					AND ( ( @prod_sid IS NULL
                        OR @prod_sid = ''
                      )
                      OR ( @prod_sid IS NOT NULL
                           AND @prod_sid != ''
                           AND exists(SELECT 1 FROM QuestionPositions p WHERE p.ENABLED=1 AND p.id_question=q.id AND p.user_sid=@prod_sid)
                         )
                    )
        ORDER BY id DESC
    END
GO
PRINT N'Выполняется создание [dbo].[get_question_curr_state]...';


GO
CREATE PROCEDURE [dbo].[get_question_curr_state]
	@id_question INT
AS
BEGIN
	SET NOCOUNT ON;
	SELECT  st.id ,
                st.name ,
                UPPER(st.sys_name) AS sys_name,
				st.order_num
        FROM    Questions q INNER JOIN  QuestionStates st ON q.id_que_state = st.id
		WHERE q.id=@id_question
END
GO
PRINT N'Выполняется создание [dbo].[get_question_position]...';


GO
CREATE PROCEDURE [dbo].[get_question_position] @id INT = NULL, @id_question INT=null
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  id, id_question, user_sid, descr
        FROM    QuestionPositions t
        WHERE t.enabled = 1 AND ( @id IS NULL OR @id<=0
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND t.id = @id
                         )
                    )
					and (@id_question IS NULL OR @id_question <=0 OR (@id_question IS NOT NULL AND @id_question>0 and t.id_question = @id_question))
					order by id desc
    END
GO
PRINT N'Выполняется создание [dbo].[get_question_state]...';


GO
CREATE PROCEDURE [dbo].[get_question_state]
    @id INT = NULL ,
    @sys_name NVARCHAR(50) = NULL
AS
    BEGIN
        SET nocount ON;
        SELECT  id ,
                name ,
                UPPER(sys_name) AS sys_name,
				order_num
        FROM    QuestionStates
        WHERE   enabled = 1
                AND ( @id IS NULL
                      OR @id <= 0
                      OR ( @id > 0
                           AND @id IS NOT NULL
                           AND id = @id
                         )
                    )
                AND ( @sys_name IS NULL
                      OR @sys_name = ''
                      OR ( @sys_name IS NOT NULL
                           AND @sys_name <> ''
                           AND LOWER(sys_name) = LOWER(@sys_name)
                         )
                    )
    END
GO
PRINT N'Выполняется создание [dbo].[GetCertFile]...';


GO
CREATE PROCEDURE [dbo].[GetCertFile]
	@guid nvarchar(50)
AS
	begin 

	select fileDATA, fileName from ClaimCertFiles
	where fileGUID = @guid
	--id=@IdCert
	end
GO
PRINT N'Выполняется создание [dbo].[GetClaimsCalculatePositionsStatistics]...';


GO

CREATE procedure GetClaimsCalculatePositionsStatistics
(
	@ids nvarchar(max)
)
as
select [CalculateClaimPosition].IdClaim, ProductManager, IdPosition, Count([CalculateClaimPosition].IdClaim) 
from CalculateClaimPosition, ClaimPosition 
where [CalculateClaimPosition].Deleted = 0 and [ClaimPosition].Deleted = 0 
and IdPosition = [ClaimPosition].Id
and [CalculateClaimPosition].IdClaim in(select * from dbo.Split(@ids,',')) 
and PositionState in (2,4)
group by [CalculateClaimPosition].IdClaim, ProductManager, IdPosition;
GO
PRINT N'Выполняется создание [dbo].[GetClaimsPositionsStatistics]...';


GO

create procedure GetClaimsPositionsStatistics
(
	@ids nvarchar(max)
)
as
select IdClaim, ProductManager, Count(*) from ClaimPosition where Deleted = 0 and IdClaim in(select * from dbo.Split(@ids,',')) group by IdClaim, ProductManager;
GO
PRINT N'Выполняется создание [dbo].[GetProductsForClaim]...';


GO

create procedure GetProductsForClaim
(
	@id int
)
as
select ProductManager from ClaimPosition where Deleted = 0 and IdClaim = @id and (PositionState = 1 or PositionState = 3)
GO
PRINT N'Выполняется создание [dbo].[GetProductsForClaims]...';


GO

create procedure GetProductsForClaims
(
	@ids nvarchar(max)
)
as
select distinct IdClaim, ProductManager from ClaimPosition where Deleted = 0 and IdClaim in (select * from dbo.Split(@ids,','));
GO
PRINT N'Выполняется создание [dbo].[GetTenderClaimCount]...';


GO

create procedure GetTenderClaimCount
as
select count(*) from TenderClaim where Deleted = 0
GO
PRINT N'Выполняется создание [dbo].[HasClaimPosition]...';


GO

create procedure HasClaimPosition
(
	@id int
)
as
select count(*) from ClaimPosition where Deleted = 0 and IdClaim = @id
GO
PRINT N'Выполняется создание [dbo].[HasClaimTranmissedPosition]...';


GO

create procedure HasClaimTranmissedPosition
(
	@id int
)
as
select count(*) from ClaimPosition where Deleted = 0 and IdClaim = @id and PositionState > 1
GO
PRINT N'Выполняется создание [dbo].[IsPositionsReadyToConfirm]...';


GO

create procedure IsPositionsReadyToConfirm
(
	@ids nvarchar(max)
)
as
select IdPosition, count(*) from CalculateClaimPosition where Deleted = 0 and IdPosition in(select * from dbo.Split(@ids,',')) group by IdPosition;
GO
PRINT N'Выполняется создание [dbo].[LoadApproachingTenderClaim]...';


GO

create procedure LoadApproachingTenderClaim
as
select Id from TenderClaim where Deleted = 0 and ClaimStatus not in(4,5,8) and datediff(hour, GETDATE(), ClaimDeadline) <= 24
GO
PRINT N'Выполняется создание [dbo].[LoadCalculateClaimPositionForClaim]...';


GO

create procedure LoadCalculateClaimPositionForClaim
(
	@id int
)
as
select * from CalculateClaimPosition where Deleted = 0 and IdClaim = @id
GO
PRINT N'Выполняется создание [dbo].[LoadClaimCertList]...';


GO
CREATE PROCEDURE [dbo].[LoadClaimCertList]
	@IdClaim int 
AS
begin
	
SELECT id, fileDATA.PathName(), fileName, fileGUID
FROM dbo.ClaimCertFiles
where IdClaim=@IdClaim
end
GO
PRINT N'Выполняется создание [dbo].[LoadClaimPositionForTenderClaim]...';


GO

create procedure LoadClaimPositionForTenderClaim
(
	@id int
)
as
select * from ClaimPosition where Deleted = 0 and IdClaim = @id
GO
PRINT N'Выполняется создание [dbo].[LoadClaimPositionForTenderClaimForProduct]...';


GO

create procedure LoadClaimPositionForTenderClaimForProduct
(
	@id int,
	@product nvarchar(500)
)
as
select * from ClaimPosition where Deleted = 0 and IdClaim = @id and ProductManager = @product
GO
PRINT N'Выполняется создание [dbo].[LoadClaimStatus]...';


GO

create procedure LoadClaimStatus
as
select * from ClaimStatus
GO
PRINT N'Выполняется создание [dbo].[LoadCurrencies]...';


GO

create procedure LoadCurrencies
as
select * from Currency
GO
PRINT N'Выполняется создание [dbo].[LoadDealTypes]...';


GO

create procedure LoadDealTypes
as
select * from DealType
GO
PRINT N'Выполняется создание [dbo].[LoadDeliveryTimes]...';


GO

CREATE procedure [dbo].[LoadDeliveryTimes]
as
select * from DeliveryTime
GO
PRINT N'Выполняется создание [dbo].[LoadLastStatusHistoryForClaim]...';


GO

create procedure LoadLastStatusHistoryForClaim
(
	@idClaim int
)
as
select top(1) [ClaimStatusHistory].*, Value from ClaimStatusHistory, ClaimStatus where IdClaim = @idClaim and IdStatus = [ClaimStatus].Id order by RecordDate desc
GO
PRINT N'Выполняется создание [dbo].[LoadNoneCalculatePosition]...';


GO

create procedure LoadNoneCalculatePosition
(
	@id int
)
as
select * from ClaimPosition where Deleted = 0 and IdClaim = @id and (PositionState = 1 or PositionState = 3)
GO
PRINT N'Выполняется создание [dbo].[LoadOverdieTenderClaim]...';


GO

create procedure LoadOverdieTenderClaim
as
select Id from TenderClaim where Deleted = 0 and ClaimStatus in(2,3,6,7) and ClaimDeadline > GETDATE()
GO
PRINT N'Выполняется создание [dbo].[LoadPositionStates]...';


GO

create procedure LoadPositionStates
as
select * from PositionState
GO
PRINT N'Выполняется создание [dbo].[LoadProductManagersForClaim]...';


GO

create procedure LoadProductManagersForClaim
(
	@idClaim int
)
as
select distinct ProductManager from ClaimPosition where Deleted = 0 and IdClaim = @idClaim
GO
PRINT N'Выполняется создание [dbo].[LoadProtectFacts]...';


GO

create procedure LoadProtectFacts
as
select * from ProtectFact
GO
PRINT N'Выполняется создание [dbo].[LoadRoles]...';


GO

create procedure LoadRoles
as
select * from Roles
GO
PRINT N'Выполняется создание [dbo].[LoadStatusHistoryForClaim]...';


GO

CREATE procedure [dbo].[LoadStatusHistoryForClaim]
(
	@idClaim int
)
as
select [ClaimStatusHistory].*, Value from ClaimStatusHistory, ClaimStatus where IdClaim = @idClaim and IdStatus = [ClaimStatus].Id order by RecordDate
GO
PRINT N'Выполняется создание [dbo].[LoadTenderClaimById]...';


GO

create procedure LoadTenderClaimById
(
	@id int
)
as
select * from TenderClaim where Deleted = 0 and Id = @id
GO
PRINT N'Выполняется создание [dbo].[LoadTenderClaims]...';


GO

create procedure LoadTenderClaims
(
	@pageSize int
)
as
select top (@pageSize) * from TenderClaim where Deleted = 0 order by Id desc
GO
PRINT N'Выполняется создание [dbo].[LoadTenderStatus]...';


GO

create procedure LoadTenderStatus
as
select * from TenderStatus
GO
PRINT N'Выполняется создание [dbo].[save_que_pos_answer]...';


GO
CREATE PROCEDURE [dbo].[save_que_pos_answer]
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
PRINT N'Выполняется создание [dbo].[save_question]...';


GO
CREATE PROCEDURE [dbo].[save_question]
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
PRINT N'Выполняется создание [dbo].[save_question_position]...';


GO
CREATE PROCEDURE [dbo].[save_question_position]
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
PRINT N'Выполняется создание [dbo].[SaveCalculateClaimPosition]...';


GO

CREATE procedure [dbo].[SaveCalculateClaimPosition]
(
	@idPosition int,
	@idClaim int,
	@catalogNumber nvarchar(500) = '',
	@name nvarchar(1000) = '',
	@replaceValue nvarchar(1000) = '',
	@priceCurrency decimal(18,2) = -1,
	@sumCurrency decimal(18,2) = -1,
	@priceRub decimal(18,2) = -1,
	@sumRub decimal(18,2) = -1,
	@provider nvarchar(150) = '',
	@protectFact int = null,
	@protectCondition nvarchar(500) = '',
	@comment nvarchar(1500) = '',
	@author nvarchar(150),
  @currency int = NULL,
  @priceUsd decimal(18,2) = NULL,
  @priceEur decimal(18,2) = NULL,
  @priceEurRicoh decimal(18,2) = NULL,
  @priceRubl decimal(18,2) = NULL,
  @deliveryTime int = null
)
as
declare @id int;
insert into CalculateClaimPosition values(@idPosition, @idClaim, @catalogNumber, @name, @replaceValue, @priceCurrency, @sumCurrency,
		@priceRub, @sumRub, @provider, @protectFact, @protectCondition, @comment, @author, 0, null, null, NULL, @priceUsd, @priceEur, @priceEurRicoh, @priceRubl, @deliveryTime)
set @id = @@IDENTITY;
select @id;
GO
PRINT N'Выполняется создание [dbo].[SaveClaimCertFile]...';


GO
CREATE PROCEDURE [dbo].[SaveClaimCertFile]
	@IdClaim INT,
	@file VARBINARY(MAX),
	@fileName NVARCHAR(500)
AS
BEGIN
set NOCOUNT ON;
declare @id int
INSERT INTO ClaimCertFiles (IdClaim, fileDATA, fileName)
values(@IdClaim, @file, @fileName)
select @id=@@IDENTITY
select @id as id
END
GO
PRINT N'Выполняется создание [dbo].[SaveClaimPosition]...';


GO

CREATE procedure [dbo].[SaveClaimPosition]
(
	@idClaim int,
	@rowNumber int = -1,
	@catalogNumber nvarchar(500) = '',
	@name nvarchar(max),
	@replaceValue nvarchar(1000) = '',
	@unit nvarchar(10),
	@value int,
	@productManager nvarchar(500),
	@comment nvarchar(1500) = '',
	@price decimal(18,2) = -1,
	@sumMax decimal(18,2) = -1,
	@positionState int,
	@author nvarchar(150),
   @currency int,
	@priceTzr decimal(18,2) = -1,
	@sumTzr decimal(18,2) = -1,
	@priceNds decimal(18,2) = -1,
	@sumNds decimal(18,2) = -1
)
as
declare @id int;
insert into ClaimPosition values(@idClaim, @rowNumber, @catalogNumber, @name, @replaceValue, @unit,
	@value, @productManager, @comment, @price, @sumMax, @positionState, @author, 0, null, null, @currency,
	@priceTzr, @sumTzr, @priceNds, @sumNds)
set @id = @@IDENTITY;
select @id;
GO
PRINT N'Выполняется создание [dbo].[SaveClaimStatusHistory]...';


GO

create procedure SaveClaimStatusHistory
(
	@idClaim int,
	@idStatus int,
	@comment nvarchar(1000) = '',
	@idUser nvarchar(500),
	@recordDate datetime
)
as
insert into ClaimStatusHistory values(@recordDate, @idClaim, @idStatus, @comment, @idUser)
GO
PRINT N'Выполняется создание [dbo].[SaveTenderClaim]...';


GO

CREATE procedure [dbo].[SaveTenderClaim]
(
	@tenderNumber nvarchar(150) = '',
	@tenderStart datetime,
	@claimDeadline datetime,
	@kPDeadline datetime,
	@comment nvarchar(1000) = '',
	@customer nvarchar(150),
	@customerInn nvarchar(150)=NULL,
	@totalSum decimal(18,2) = -1,
	@dealType int,
	@tenderUrl nvarchar(1500) = '',
	@tenderStatus int,
	@manager nvarchar(500),
	@managerSubDivision nvarchar(500),
	@claimStatus int,
	@recordDate datetime,
	@author nvarchar(150),
	@currencyUsd decimal(18,2) = -1,
	@currencyEur decimal(18,2) = -1,
	@deliveryDate datetime = null,
	@deliveryPlace nvarchar(1000) = '',
	@auctionDate datetime = null,
	@deleted BIT,
	@idSumCurrency int = NULL,
	@deliveryDateEnd datetime = null
)
as
declare @id int;
insert into TenderClaim values(@tenderNumber, @tenderStart, @claimDeadline, @kPDeadline, @comment, @customer, 
	@customerInn, @totalSum, @dealType, @tenderUrl, @tenderStatus, @manager, @managerSubDivision, @claimStatus, @recordDate, 
	@deleted, @author, null, null, @currencyUsd, @currencyEur, @deliveryDate, @deliveryPlace, @auctionDate, @idSumCurrency, @deliveryDateEnd)
set @id = @@IDENTITY;
select @id;
GO
PRINT N'Выполняется создание [dbo].[SetPositionsToConfirm]...';


GO

create procedure SetPositionsToConfirm
(
	@ids nvarchar(max)
)
as
update ClaimPosition set PositionState = 2 where Deleted = 0 and Id in(select * from dbo.Split(@ids,','));
GO
PRINT N'Выполняется создание [dbo].[UpdateCalculateClaimPosition]...';


GO

CREATE procedure [dbo].[UpdateCalculateClaimPosition]
(
	@id int,
	@catalogNumber nvarchar(500)='',
	@name nvarchar(1000)='',
	@replaceValue nvarchar(1000) = '',
	@priceCurrency decimal(18,2) = -1,
	@sumCurrency decimal(18,2) = -1,
	@priceRub decimal(18,2) = -1,
	@sumRub decimal(18,2)=-1,
	@provider nvarchar(150) = '',
	@protectFact INT=NULL,
	@protectCondition nvarchar(500) = '',
	@comment nvarchar(1500) = '',
	@author nvarchar(150),
  @currency int = NULL,
  @priceUsd decimal(18,2) = NULL,
  @priceEur decimal(18,2) = NULL,
  @priceEurRicoh decimal(18,2) = NULL,
  @priceRubl decimal(18,2) = NULL,
  @deliveryTime int = null
)
as
Update CalculateClaimPosition set CatalogNumber = @catalogNumber, Name = @name, ReplaceValue = @replaceValue, 
	PriceCurrency = @priceCurrency, SumCurrency = @sumCurrency, PriceRub = @priceRub, SumRub = @sumRub, Provider = @provider, 
	ProtectFact = @protectFact, ProtectCondition = @protectCondition, Comment = @comment, Author = @author, Currency = @currency,
	PriceUsd = @priceUsd, PriceEur=@priceEur, PriceEurRicoh=@priceEurRicoh, PriceRubl=@priceRubl,DeliveryTime=@deliveryTime
	where Id = @id
GO
PRINT N'Выполняется создание [dbo].[UpdateClaimPosition]...';


GO

CREATE procedure [dbo].[UpdateClaimPosition]
(
	@id int,
	@rowNumber int = -1,
	@catalogNumber nvarchar(500) = '',
	@name nvarchar(max),
	@replaceValue nvarchar(1000) = '',
	@unit nvarchar(10),
	@value int,
	@productManager nvarchar(500),
	@comment nvarchar(1500) = '',
	@price decimal(18,2) = -1,
	@sumMax decimal(18,2) = -1,
	@positionState int,
	@author nvarchar(150),
  @currency int,
	@priceTzr decimal(18,2) = -1,
	@sumTzr decimal(18,2) = -1,
	@priceNds decimal(18,2) = -1,
	@sumNds decimal(18,2) = -1
)
as
update ClaimPosition set RowNumber = @rowNumber, CatalogNumber = @catalogNumber, Name = @name, 
	ReplaceValue = @replaceValue, Unit = @unit, Value = @value, ProductManager = @productManager, 
	Comment = @comment, Price = @price, SumMax = @sumMax, PositionState = @positionState, Author = @author,
	--Currency = @currency,
	 PriceTzr = @priceTzr, SumTzr = @sumTzr, PriceNds = @priceNds, SumNds = @sumNds where Id = @id
GO
PRINT N'Выполняется создание [dbo].[UpdateTenderClaimCurrency]...';


GO

create procedure UpdateTenderClaimCurrency
(
	@id int,
	@currencyUsd decimal(18,2) = -1,
	@currencyEur decimal(18,2) = -1
)
as
if @currencyUsd != -1
begin 
	update TenderClaim set CurrencyUsd = @currencyUsd where Id = @id
end
if @currencyEur != -1
begin 
	update TenderClaim set CurrencyEur = @currencyEur where Id = @id
end
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
DELETE QuestionStates

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
PRINT N'Существующие данные проверяются относительно вновь созданных ограничений';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[CalculateClaimPosition] WITH CHECK CHECK CONSTRAINT [FK_CalculateClaimPosition_ClaimPosition];

ALTER TABLE [dbo].[CalculateClaimPosition] WITH CHECK CHECK CONSTRAINT [FK_CalculateClaimPosition_Currency];

ALTER TABLE [dbo].[CalculateClaimPosition] WITH CHECK CHECK CONSTRAINT [FK_CalculateClaimPosition_ProtectFact];

ALTER TABLE [dbo].[CalculateClaimPosition] WITH CHECK CHECK CONSTRAINT [FK_CalculateClaimPosition_TenderClaim];

ALTER TABLE [dbo].[ClaimPosition] WITH CHECK CHECK CONSTRAINT [FK_ClaimPosition_Currency];

ALTER TABLE [dbo].[ClaimPosition] WITH CHECK CHECK CONSTRAINT [FK_ClaimPosition_PositionState];

ALTER TABLE [dbo].[ClaimPosition] WITH CHECK CHECK CONSTRAINT [FK_ClaimPosition_TenderClaim];

ALTER TABLE [dbo].[ClaimStatusHistory] WITH CHECK CHECK CONSTRAINT [FK_ClaimStatusHistory_ClaimStatus];

ALTER TABLE [dbo].[ClaimStatusHistory] WITH CHECK CHECK CONSTRAINT [FK_ClaimStatusHistory_TenderClaim];

ALTER TABLE [dbo].[TenderClaim] WITH CHECK CHECK CONSTRAINT [FK_TenderClaim_ClaimStatus];

ALTER TABLE [dbo].[TenderClaim] WITH CHECK CHECK CONSTRAINT [FK_TenderClaim_DealType];

ALTER TABLE [dbo].[TenderClaim] WITH CHECK CHECK CONSTRAINT [FK_TenderClaim_TenderStatus];


GO
PRINT N'Обновление завершено.';


GO
