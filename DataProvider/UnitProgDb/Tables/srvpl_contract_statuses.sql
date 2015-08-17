CREATE TABLE [dbo].[srvpl_contract_statuses] (
    [id_contract_status] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [name]               NVARCHAR (150) NOT NULL,
    [nickname]           NVARCHAR (100) NULL,
    [descr]              NVARCHAR (MAX) NULL,
    [order_num]          INT            CONSTRAINT [DF_srvpl_contract_statuses_order_num] DEFAULT ((500)) NOT NULL,
    [enabled]            BIT            CONSTRAINT [DF_srvpl_contract_statuses_enabled] DEFAULT ((1)) NOT NULL,
    [dattim1]            DATETIME       CONSTRAINT [DF_srvpl_contract_statuses_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]            DATETIME       CONSTRAINT [DF_srvpl_contract_statuses_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [sys_name]           NVARCHAR (50)  NULL,
    [mark]               BIT            NULL,
    [visible]            BIT            CONSTRAINT [DF_srvpl_contract_statuses_visible] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_srvpl_contract_statuses] PRIMARY KEY CLUSTERED ([id_contract_status] ASC)
);

