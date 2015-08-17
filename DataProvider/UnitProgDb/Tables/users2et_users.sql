CREATE TABLE [dbo].[users2et_users] (
    [id_users2et_users] INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id_user]           INT      NOT NULL,
    [id_et_user]        INT      NOT NULL,
    [dattim1]           DATETIME CONSTRAINT [DF_users2et_users_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]           DATETIME CONSTRAINT [DF_users2et_users_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [enabled]           BIT      CONSTRAINT [DF_users2et_users_enabled] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_users2et_users] PRIMARY KEY CLUSTERED ([id_users2et_users] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Сопоставление пользователей и пользователей Эталон', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'users2et_users';

