CREATE TABLE [dbo].[srvpl_device2options] (
    [id_device2option] INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id_device]        INT      NOT NULL,
    [id_device_option] INT      NOT NULL,
    [dattim1]          DATETIME CONSTRAINT [DF_srvpl_device2options_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]          DATETIME CONSTRAINT [DF_srvpl_device2options_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [enabled]          BIT      CONSTRAINT [DF_srvpl_device2options_enabled] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_srvpl_device2options] PRIMARY KEY CLUSTERED ([id_device2option] ASC),
    CONSTRAINT [FK_srvpl_device2options_srvpl_device_options] FOREIGN KEY ([id_device_option]) REFERENCES [dbo].[srvpl_device_options] ([id_device_option]),
    CONSTRAINT [FK_srvpl_device2options_srvpl_devices] FOREIGN KEY ([id_device]) REFERENCES [dbo].[srvpl_devices] ([id_device])
);

