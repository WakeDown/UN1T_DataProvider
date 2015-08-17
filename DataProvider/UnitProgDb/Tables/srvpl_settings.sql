CREATE TABLE [dbo].[srvpl_settings] (
    [id_setting] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [name]       NVARCHAR (150) NOT NULL,
    [value]      NVARCHAR (MAX) NOT NULL,
    [descr]      NVARCHAR (MAX) NULL,
    [enabled]    BIT            CONSTRAINT [DF_srvpl_settings_enabled] DEFAULT ((1)) NOT NULL,
    [dattim1]    DATETIME       CONSTRAINT [DF_srvpl_settings_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]    DATETIME       CONSTRAINT [DF_srvpl_settings_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    CONSTRAINT [PK_srvpl_settings] PRIMARY KEY CLUSTERED ([id_setting] ASC)
);

