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
    [PriceTzr]       DECIMAL (18, 2) DEFAULT ((-1)) NOT NULL,
    [SumTzr]         DECIMAL (18, 2) DEFAULT ((-1)) NOT NULL,
    [PriceNds]       DECIMAL (18, 2) DEFAULT ((-1)) NOT NULL,
    [SumNds]         DECIMAL (18, 2) DEFAULT ((-1)) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ClaimPosition_Currency] FOREIGN KEY ([Currency]) REFERENCES [dbo].[Currency] ([Id]),
    CONSTRAINT [FK_ClaimPosition_PositionState] FOREIGN KEY ([PositionState]) REFERENCES [dbo].[PositionState] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_ClaimPosition_TenderClaim] FOREIGN KEY ([IdClaim]) REFERENCES [dbo].[TenderClaim] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [i_idClaim_claimPosition]
    ON [dbo].[ClaimPosition]([IdClaim] ASC);

