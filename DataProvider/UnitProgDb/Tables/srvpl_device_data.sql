CREATE TABLE [dbo].[srvpl_device_data] (
    [id_device_data]        INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id_contract]           INT      NOT NULL,
    [id_device]             INT      NOT NULL,
    [counter]               INT      NOT NULL,
    [counter_colour]        INT      NULL,
    [volume_counter]        INT      NULL,
    [volume_counter_colour] INT      NULL,
    [date_month]            DATETIME NOT NULL,
    [dattim1]               DATETIME CONSTRAINT [DF_srvpl_device_data_dattim1] DEFAULT (getdate()) NOT NULL,
    [enabled]               BIT      CONSTRAINT [DF_srvpl_device_data_enabled] DEFAULT ((1)) NOT NULL,
    [is_average]            BIT      CONSTRAINT [DF_srvpl_device_data_is_average] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_srvpl_device_data] PRIMARY KEY CLUSTERED ([id_device_data] ASC)
);

