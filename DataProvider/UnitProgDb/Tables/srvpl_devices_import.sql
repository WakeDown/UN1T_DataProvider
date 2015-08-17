CREATE TABLE [dbo].[srvpl_devices_import] (
    [id]                  INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id_model]            INT            NULL,
    [model_name]          NVARCHAR (150) NULL,
    [serial_num]          NVARCHAR (50)  NULL,
    [instal_date]         DATETIME       NULL,
    [adf]                 BIT            NULL,
    [finisher]            BIT            NULL,
    [tray]                BIT            NULL,
    [dattim1]             DATETIME       CONSTRAINT [DF_srvpl_devices_import_dattim1] DEFAULT (getdate()) NOT NULL,
    [import]              BIT            CONSTRAINT [DF_srvpl_devices_import_import] DEFAULT ((0)) NOT NULL,
    [date_import]         DATETIME       NULL,
    [id_contract]         INT            NULL,
    [id_service_admin]    INT            NULL,
    [id_service_interval] INT            NULL,
    [id_city]             INT            NULL,
    [address]             NVARCHAR (150) NULL,
    [object_name]         NVARCHAR (150) NULL,
    [contact_name]        NVARCHAR (150) NULL,
    CONSTRAINT [PK_srvpl_devices_import] PRIMARY KEY CLUSTERED ([id] ASC)
);

