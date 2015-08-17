CREATE TABLE [dbo].[srvpl_devices] (
    [id_device]        INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [serial_num]       NVARCHAR (50)   NOT NULL,
    [inv_num]          NVARCHAR (50)   NULL,
    [counter]          INT             NULL,
    [age]              INT             NULL,
    [instalation_date] DATETIME        NULL,
    [dattim1]          DATETIME        CONSTRAINT [DF_srvpl_devices_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]          DATETIME        CONSTRAINT [DF_srvpl_devices_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [id_creator]       INT             NOT NULL,
    [enabled]          BIT             CONSTRAINT [DF_srvpl_devices_enabled] DEFAULT ((1)) NOT NULL,
    [old_id_device]    INT             NULL,
    [id_device_model]  INT             NOT NULL,
    [tariff]           DECIMAL (10, 2) NULL,
    [counter_colour]   INT             NULL,
    CONSTRAINT [PK_srvpl_devices] PRIMARY KEY CLUSTERED ([id_device] ASC),
    CONSTRAINT [FK_srvpl_devices_srvpl_device_models] FOREIGN KEY ([id_device_model]) REFERENCES [dbo].[srvpl_device_models] ([id_device_model])
);

