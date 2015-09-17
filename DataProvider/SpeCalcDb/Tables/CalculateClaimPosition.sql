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
    [SumRub]           DECIMAL (18, 2) NULL,
    [Provider]         NVARCHAR (150)  NULL,
    [ProtectFact]      INT             NULL,
    [ProtectCondition] NVARCHAR (500)  NULL,
    [Comment]          NVARCHAR (1000) NULL,
    [Author]           NVARCHAR (150)  NULL,
    [Deleted]          BIT             NOT NULL DEFAULT 0,
    [DeletedUser]      NVARCHAR (150)  NULL,
    [DeleteDate]       DATETIME        NULL,
    [Currency]         INT             NULL,
    [PriceUsd]         DECIMAL (18, 2) NULL,
    [PriceEur]         DECIMAL (18, 2) NULL,
    [PriceEurRicoh]    DECIMAL (18, 2) NULL,
    [PriceRubl]        DECIMAL (18, 2) NULL,
    [DeliveryTime]     INT             NULL,
    [Version] INT NOT NULL DEFAULT 0, 
    [RecordDate] DATETIME NOT NULL DEFAULT getdate(), 
    [LastModifer] VARCHAR(46) NULL, 
    [IdCalcPosParent] INT NULL, 
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_CalculateClaimPosition_ClaimPosition] FOREIGN KEY ([IdPosition]) REFERENCES [dbo].[ClaimPosition] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_CalculateClaimPosition_Currency] FOREIGN KEY ([Currency]) REFERENCES [dbo].[Currency] ([Id]),
    CONSTRAINT [FK_CalculateClaimPosition_ProtectFact] FOREIGN KEY ([ProtectFact]) REFERENCES [dbo].[ProtectFact] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_CalculateClaimPosition_TenderClaim] FOREIGN KEY ([IdClaim]) REFERENCES [dbo].[TenderClaim] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [i_idClaim_calculateClaimPosition]
    ON [dbo].[CalculateClaimPosition]([IdClaim] ASC);


GO
CREATE NONCLUSTERED INDEX [i_idPosition_calculateClaimPosition]
    ON [dbo].[CalculateClaimPosition]([IdPosition] ASC);

