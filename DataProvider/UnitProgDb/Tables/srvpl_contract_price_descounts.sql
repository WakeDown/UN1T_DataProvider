CREATE TABLE [dbo].[srvpl_contract_price_descounts] (
    [id_price_discount] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [name]              NVARCHAR (50) NOT NULL,
    [sys_name]          NVARCHAR (50) NULL,
    [discount]          INT           NOT NULL,
    [enabled]           BIT           CONSTRAINT [DF_srvpl_contract_price_descounts_enabled] DEFAULT ((1)) NOT NULL,
    [dattim1]           DATETIME      CONSTRAINT [DF_srvpl_contract_price_descounts_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]           DATETIME      CONSTRAINT [DF_srvpl_contract_price_descounts_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [order_num]         INT           CONSTRAINT [DF_srvpl_contract_price_descounts_order_num] DEFAULT ((500)) NOT NULL,
    CONSTRAINT [PK_srvpl_contract_price_descounts] PRIMARY KEY CLUSTERED ([id_price_discount] ASC)
);

