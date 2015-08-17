CREATE TABLE [dbo].[srvpl_contract2devices] (
    [id_contract2devices]     INT               IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id_contract]             INT               NOT NULL,
    [id_device]               INT               NOT NULL,
    [id_service_interval]     INT               NOT NULL,
    [id_city]                 INT               NOT NULL,
    [address]                 NVARCHAR (250)    NULL,
    [contact_name]            NVARCHAR (150)    NULL,
    [comment]                 NVARCHAR (MAX)    NULL,
    [id_creator]              INT               NOT NULL,
    [dattim1]                 DATETIME          CONSTRAINT [DF_srvpl_contract2devices_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]                 DATETIME          CONSTRAINT [DF_srvpl_contract2devices_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [enabled]                 BIT               CONSTRAINT [DF_srvpl_contract2devices_enabled] DEFAULT ((1)) NOT NULL,
    [id_service_admin]        INT               NULL,
    [object_name]             NVARCHAR (150)    NULL,
    [coordinates]             [sys].[geography] NULL,
    [coord]                   NVARCHAR (50)     NULL,
    [old_id_contract2devices] INT               NULL,
    CONSTRAINT [PK_srvpl_contract2devices] PRIMARY KEY CLUSTERED ([id_contract2devices] ASC),
    CONSTRAINT [FK_srvpl_contract2devices_srvpl_contracts] FOREIGN KEY ([id_contract]) REFERENCES [dbo].[srvpl_contracts] ([id_contract]),
    CONSTRAINT [FK_srvpl_contract2devices_srvpl_devices] FOREIGN KEY ([id_device]) REFERENCES [dbo].[srvpl_devices] ([id_device]),
    CONSTRAINT [FK_srvpl_contract2devices_srvpl_service_intervals] FOREIGN KEY ([id_service_interval]) REFERENCES [dbo].[srvpl_service_intervals] ([id_service_interval])
);


GO
CREATE NONCLUSTERED INDEX [srvpl_c2d_full_idx]
    ON [dbo].[srvpl_contract2devices]([id_contract] ASC, [id_device] ASC, [id_service_admin] ASC);

