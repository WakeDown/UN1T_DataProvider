CREATE TABLE [dbo].[devinst_states] (
    [id_devinst_state] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [name]             NVARCHAR (50) NOT NULL,
    [sys_name]         NVARCHAR (50) NOT NULL,
    [dattim1]          DATETIME      CONSTRAINT [DF_devinst_states_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]          DATETIME      CONSTRAINT [DF_devinst_states_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [enabled]          BIT           CONSTRAINT [DF_devinst_states_enabled] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_devinst_states] PRIMARY KEY CLUSTERED ([id_devinst_state] ASC)
);

