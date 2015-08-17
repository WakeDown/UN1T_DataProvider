CREATE TABLE [dbo].[srvpl_device_types] (
    [id_device_type] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [name]           NVARCHAR (150) NOT NULL,
    [nickname]       NVARCHAR (100) NULL,
    [order_num]      INT            CONSTRAINT [DF_srvpl_device_types_order_num] DEFAULT ((500)) NOT NULL,
    [dattim1]        DATETIME       CONSTRAINT [DF_srvpl_device_types_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]        DATETIME       CONSTRAINT [DF_srvpl_device_types_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [enabled]        INT            CONSTRAINT [DF_srvpl_device_types_enabled] DEFAULT ((1)) NOT NULL,
    [sys_name]       NVARCHAR (50)  NULL,
    CONSTRAINT [PK_srvpl_device_types] PRIMARY KEY CLUSTERED ([id_device_type] ASC)
);

