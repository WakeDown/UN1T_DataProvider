CREATE TABLE [dbo].[user_groups] (
    [id_user_group] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [sys_name]      NVARCHAR (50)  NULL,
    [sid]           NVARCHAR (50)  NULL,
    [id_program]    INT            NULL,
    [name]          NVARCHAR (150) NULL,
    [dattim1]       DATETIME       CONSTRAINT [DF_user_groups_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]       DATETIME       CONSTRAINT [DF_user_groups_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [enabled]       BIT            CONSTRAINT [DF_user_groups_enabled] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_user_groups] PRIMARY KEY CLUSTERED ([id_user_group] ASC)
);

