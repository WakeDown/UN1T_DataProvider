CREATE TABLE [dbo].[srvpl_device_models] (
    [id_device_model]   INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id_device_type]    INT             NOT NULL,
    [name]              NVARCHAR (150)  NOT NULL,
    [nickname]          NVARCHAR (100)  NULL,
    [speed]             DECIMAL (10, 2) NULL,
    [id_device_imprint] INT             NULL,
    [id_print_type]     INT             NULL,
    [id_cartridge_type] INT             NULL,
    [dattim1]           DATETIME        CONSTRAINT [DF_srvpl_device_models_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]           DATETIME        CONSTRAINT [DF_srvpl_device_models_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [enabled]           BIT             CONSTRAINT [DF_srvpl_device_models_enabled] DEFAULT ((1)) NOT NULL,
    [vendor]            NVARCHAR (150)  NOT NULL,
    [max_volume]        INT             NULL,
    CONSTRAINT [PK_srvpl_device_models] PRIMARY KEY CLUSTERED ([id_device_model] ASC)
);

