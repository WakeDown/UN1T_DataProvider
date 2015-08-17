CREATE TABLE [dbo].[exchange_rate] (
    [id_exchange_rate]     INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id_currency]          INT             NOT NULL,
    [id_relation_currency] INT             NOT NULL,
    [date_rate]            DATE            NOT NULL,
    [price]                DECIMAL (10, 4) NOT NULL,
    [dattim1]              DATETIME        CONSTRAINT [DF_exchange_rate_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]              DATETIME        CONSTRAINT [DF_exchange_rate_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [enabled]              BIT             CONSTRAINT [DF_exchange_rate_enabled] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_exchange_rate] PRIMARY KEY CLUSTERED ([id_exchange_rate] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_exchange_rate_date_rate]
    ON [dbo].[exchange_rate]([date_rate] DESC);

