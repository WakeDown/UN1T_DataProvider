CREATE TABLE [dbo].[srvpl_device_model_max_volume_load] (
    [id_device_model] INT      NOT NULL,
    [max_volume]      INT      NULL,
    [loaded]          BIT      CONSTRAINT [DF_srvpl_device_model_max_volume_load_loaded] DEFAULT ((0)) NOT NULL,
    [date_load]       DATETIME NULL
);

