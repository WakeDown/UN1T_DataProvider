CREATE TABLE [dbo].[user_states] (
    [id_state]  INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [name]      NVARCHAR (50) NOT NULL,
    [enabled]   BIT           CONSTRAINT [DF_statuses_enabled] DEFAULT ((1)) NOT NULL,
    [order_num] INT           CONSTRAINT [DF_statuses_order_num] DEFAULT ((50)) NOT NULL,
    [sys_name]  NVARCHAR (50) NULL,
    CONSTRAINT [PK_statuses] PRIMARY KEY CLUSTERED ([id_state] ASC)
);

