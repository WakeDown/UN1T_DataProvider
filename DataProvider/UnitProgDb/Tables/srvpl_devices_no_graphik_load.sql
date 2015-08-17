CREATE TABLE [dbo].[srvpl_devices_no_graphik_load] (
    [id]                  INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [contractor]          NVARCHAR (150) NOT NULL,
    [number]              NVARCHAR (50)  NULL,
    [id_contract]         INT            NULL,
    [id_device]           INT            NULL,
    [serial_num]          NVARCHAR (50)  NULL,
    [id_service_interval] INT            NULL,
    [service_interval]    NVARCHAR (150) NULL,
    [date_start]          DATETIME       NULL,
    [load]                BIT            CONSTRAINT [DF_srvpl_devices_no_graphik_load_load] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_srvpl_devices_no_graphik_load] PRIMARY KEY CLUSTERED ([id] ASC)
);

