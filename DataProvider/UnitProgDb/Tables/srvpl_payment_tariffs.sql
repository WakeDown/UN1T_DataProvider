CREATE TABLE [dbo].[srvpl_payment_tariffs] (
    [id_payment_tariff] INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id_user_role]      INT             NOT NULL,
    [name]              NVARCHAR (150)  NULL,
    [price]             DECIMAL (10, 2) NOT NULL,
    [descr]             NVARCHAR (500)  NULL,
    [enabled]           BIT             CONSTRAINT [DF_srvpl_payment_tariff_enabled] DEFAULT ((1)) NOT NULL,
    [dattim1]           DATETIME        CONSTRAINT [DF_srvpl_payment_tariff_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]           DATETIME        CONSTRAINT [DF_srvpl_payment_tariff_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [id_creator]        INT             NULL,
    [order_num]         INT             CONSTRAINT [DF_srvpl_payment_tariff_order_num] DEFAULT ((500)) NOT NULL,
    CONSTRAINT [PK_srvpl_payment_tariff] PRIMARY KEY CLUSTERED ([id_payment_tariff] ASC)
);

