CREATE TABLE [dbo].[srvpl_service_zones] (
    [id_service_zone] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [name]            NVARCHAR (150) NOT NULL,
    [nickname]        NVARCHAR (100) NULL,
    [descr]           NVARCHAR (MAX) NULL,
    [order_num]       INT            CONSTRAINT [DF_srvpl_service_zones_order_num] DEFAULT ((500)) NOT NULL,
    [enabled]         BIT            CONSTRAINT [DF_srvpl_service_zones_enabled] DEFAULT ((1)) NOT NULL,
    [dattim1]         DATETIME       CONSTRAINT [DF_srvpl_service_zones_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]         DATETIME       CONSTRAINT [DF_srvpl_service_zones_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    CONSTRAINT [PK_srvpl_service_zones] PRIMARY KEY CLUSTERED ([id_service_zone] ASC)
);

