CREATE TABLE [dbo].[devinst_state_notify_recipients] (
    [id_state_notify_recipient] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id_state_notify]           INT           NOT NULL,
    [sys_name]                  NVARCHAR (50) NOT NULL,
    [id_user_group]             INT           NULL,
    [enabled]                   BIT           CONSTRAINT [DF_devinst_state_notify_recipients_enabled] DEFAULT ((1)) NOT NULL,
    [order_num]                 INT           CONSTRAINT [DF_devinst_state_notify_recipients_order_num] DEFAULT ((500)) NOT NULL,
    CONSTRAINT [PK_devinst_state_notify_recipients] PRIMARY KEY CLUSTERED ([id_state_notify_recipient] ASC)
);

