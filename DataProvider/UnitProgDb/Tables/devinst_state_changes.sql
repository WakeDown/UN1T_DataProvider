CREATE TABLE [dbo].[devinst_state_changes] (
    [id_state_change]   INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id_device_install] INT      NOT NULL,
    [id_devinst_state]  INT      NOT NULL,
    [id_creator]        INT      NULL,
    [date_change]       DATETIME CONSTRAINT [DF_devinst_state_changes_date_change] DEFAULT (getdate()) NOT NULL,
    [enabled]           BIT      CONSTRAINT [DF_devinst_state_changes_enabled] DEFAULT ((1)) NOT NULL,
    [notifed]           BIT      NOT NULL,
    CONSTRAINT [PK_devinst_state_changes] PRIMARY KEY CLUSTERED ([id_state_change] ASC)
);

