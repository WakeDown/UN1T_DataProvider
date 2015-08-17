CREATE TABLE [dbo].[srvpl_service_zone2devices] (
    [id_service_zone2devices] INT      NOT NULL,
    [id_service_zone]         INT      NOT NULL,
    [id_device]               INT      NOT NULL,
    [dattim1]                 DATETIME CONSTRAINT [DF_srvpl_service_zone2devices_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]                 DATETIME CONSTRAINT [DF_srvpl_service_zone2devices_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [enabled]                 BIT      CONSTRAINT [DF_srvpl_service_zone2devices_ensbled] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_srvpl_service_zone2devices] PRIMARY KEY CLUSTERED ([id_service_zone2devices] ASC),
    CONSTRAINT [FK_srvpl_service_zone2devices_srvpl_devices] FOREIGN KEY ([id_device]) REFERENCES [dbo].[srvpl_devices] ([id_device])
);

