CREATE TABLE [dbo].[devinst_state_notifys] (
    [id_state_notify]  INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id_devinst_state] INT            NOT NULL,
    [sys_name]         NVARCHAR (50)  NOT NULL,
    [name]             NVARCHAR (50)  NULL,
    [text]             NVARCHAR (500) NULL,
    [order_num]        INT            CONSTRAINT [DF_devinst_state_notifys_order_num] DEFAULT ((500)) NOT NULL,
    [enabled]          BIT            CONSTRAINT [DF_devinst_state_notifys_enabled] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_devinst_state_notifys] PRIMARY KEY CLUSTERED ([id_state_notify] ASC)
);

