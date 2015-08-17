CREATE TABLE [dbo].[srvpl_tariff_features] (
    [id_feature] INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [sys_name]   NVARCHAR (50)   NOT NULL,
    [name]       NVARCHAR (150)  NOT NULL,
    [value]      NVARCHAR (50)   NULL,
    [price]      DECIMAL (10, 2) NOT NULL,
    [enabled]    BIT             CONSTRAINT [DF_srvpl_tariff_features_enabled] DEFAULT ((1)) NOT NULL,
    [dattim1]    DATETIME        CONSTRAINT [DF_srvpl_tariff_features_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]    DATETIME        CONSTRAINT [DF_srvpl_tariff_features_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [order_num]  INT             CONSTRAINT [DF_srvpl_tariff_features_order_num] DEFAULT ((500)) NOT NULL,
    [id_creator] INT             NULL,
    CONSTRAINT [PK_srvpl_tariff_features] PRIMARY KEY CLUSTERED ([id_feature] ASC)
);

