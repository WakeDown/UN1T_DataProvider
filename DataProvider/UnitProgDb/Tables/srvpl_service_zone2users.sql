CREATE TABLE [dbo].[srvpl_service_zone2users] (
    [id_service_zone2user] INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id_service_zone]      INT      NOT NULL,
    [id_user]              INT      NOT NULL,
    [dattim1]              DATETIME CONSTRAINT [DF_srvpl_service_zone2users_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]              DATETIME CONSTRAINT [DF_srvpl_service_zone2users_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [enabled]              BIT      CONSTRAINT [DF_srvpl_service_zone2users_enabled] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_srvpl_service_zone2users] PRIMARY KEY CLUSTERED ([id_service_zone2user] ASC),
    CONSTRAINT [FK_srvpl_service_zone2users_srvpl_service_zones] FOREIGN KEY ([id_service_zone]) REFERENCES [dbo].[srvpl_service_zones] ([id_service_zone])
);

