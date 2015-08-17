CREATE TABLE [dbo].[srvpl_cartridge_types] (
    [id_cartridge_type] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [name]              NVARCHAR (150) NOT NULL,
    [nickname]          NVARCHAR (100) NULL,
    [descr]             NVARCHAR (MAX) NULL,
    [order_num]         INT            CONSTRAINT [DF_srvpl_cartridge_types_order_num] DEFAULT ((500)) NOT NULL,
    [enabled]           BIT            CONSTRAINT [DF_srvpl_cartridge_types_enabled] DEFAULT ((1)) NOT NULL,
    [dattim1]           DATETIME       CONSTRAINT [DF_srvpl_cartridge_types_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]           DATETIME       CONSTRAINT [DF_srvpl_cartridge_types_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [sys_name]          NVARCHAR (50)  NULL,
    CONSTRAINT [PK_srvpl_cartridge_type] PRIMARY KEY CLUSTERED ([id_cartridge_type] ASC)
);

