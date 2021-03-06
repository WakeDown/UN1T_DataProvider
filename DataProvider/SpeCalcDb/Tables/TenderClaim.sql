﻿CREATE TABLE [dbo].[TenderClaim] (
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
    [CurrencyUsd]        DECIMAL (18, 2) DEFAULT ((-1)) NOT NULL,
    [CurrencyEur]        DECIMAL (18, 2) DEFAULT ((-1)) NOT NULL,
    [DeliveryDate]       DATETIME        NULL,
    [DeliveryPlace]      NVARCHAR (1000) DEFAULT ('') NOT NULL,
    [AuctionDate]        DATETIME        NULL,
    [IdSumCurrency]      INT             NULL,
    [DeliveryDateEnd]    DATETIME        NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_TenderClaim_ClaimStatus] FOREIGN KEY ([ClaimStatus]) REFERENCES [dbo].[ClaimStatus] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_TenderClaim_DealType] FOREIGN KEY ([DealType]) REFERENCES [dbo].[DealType] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_TenderClaim_TenderStatus] FOREIGN KEY ([TenderStatus]) REFERENCES [dbo].[TenderStatus] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE
);


GO

CREATE INDEX [IX_TenderClaim_IdManager] ON [dbo].[TenderClaim] ([Manager], [ClaimStatus])

GO

CREATE INDEX [IX_TenderClaim_ClaimState] ON [dbo].[TenderClaim] ([ClaimStatus])
