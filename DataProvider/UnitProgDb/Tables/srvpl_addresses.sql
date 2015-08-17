CREATE TABLE [dbo].[srvpl_addresses] (
    [id_srvpl_address] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [name]             NVARCHAR (250) NOT NULL,
    [enabled]          BIT            CONSTRAINT [DF_srvpl_addresses_enabled] DEFAULT ((1)) NOT NULL,
    [dattim1]          DATETIME       CONSTRAINT [DF_srvpl_addresses_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]          DATETIME       CONSTRAINT [DF_srvpl_addresses_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [order_num]        INT            CONSTRAINT [DF_srvpl_addresses_order_num] DEFAULT ((500)) NOT NULL,
    [id_creator]       INT            NULL,
    CONSTRAINT [PK_srvpl_addresses] PRIMARY KEY CLUSTERED ([id_srvpl_address] ASC)
);

