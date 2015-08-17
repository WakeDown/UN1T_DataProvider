CREATE TABLE [dbo].[srvpl_device_imprints] (
    [id_device_imprint] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [name]              NVARCHAR (150) NOT NULL,
    [nickname]          NVARCHAR (100) NULL,
    [descr]             NVARCHAR (MAX) NULL,
    [order_num]         INT            CONSTRAINT [DF_srvpl_device_imprints_order_num] DEFAULT ((500)) NOT NULL,
    [dattim1]           DATETIME       CONSTRAINT [DF_srvpl_device_imprints_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]           DATETIME       CONSTRAINT [DF_srvpl_device_imprints_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [enabled]           BIT            CONSTRAINT [DF_srvpl_device_imprints_enabled] DEFAULT ((1)) NOT NULL,
    [sys_name]          NVARCHAR (50)  NULL,
    CONSTRAINT [PK_srvpl_device_imprints] PRIMARY KEY CLUSTERED ([id_device_imprint] ASC)
);

