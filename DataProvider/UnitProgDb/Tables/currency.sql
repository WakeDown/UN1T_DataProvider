CREATE TABLE [dbo].[currency] (
    [id_currency] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [name]        NVARCHAR (50) NOT NULL,
    [sys_name]    NVARCHAR (50) NOT NULL,
    [cbr_code]    NVARCHAR (20) NULL,
    [enabled]     BIT           CONSTRAINT [DF_currency_enabled] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_currency] PRIMARY KEY CLUSTERED ([id_currency] ASC)
);

