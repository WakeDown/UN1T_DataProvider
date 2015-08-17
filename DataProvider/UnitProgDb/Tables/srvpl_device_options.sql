CREATE TABLE [dbo].[srvpl_device_options] (
    [id_device_option] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [name]             NVARCHAR (150) NOT NULL,
    [nickname]         NVARCHAR (100) NULL,
    [descr]            NVARCHAR (MAX) NULL,
    [order_num]        INT            CONSTRAINT [DF_srvpl_device_options_order_num] DEFAULT ((500)) NOT NULL,
    [enabled]          BIT            CONSTRAINT [DF_srvpl_device_options_enabled] DEFAULT ((1)) NOT NULL,
    [dattim1]          DATETIME       CONSTRAINT [DF_srvpl_device_options_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]          DATETIME       CONSTRAINT [DF_srvpl_device_options_dattim2] DEFAULT ('3.3.3333') NULL,
    [sys_name]         NVARCHAR (50)  NULL,
    CONSTRAINT [PK_srvpl_device_options] PRIMARY KEY CLUSTERED ([id_device_option] ASC)
);

