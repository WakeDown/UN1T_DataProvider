CREATE TABLE [dbo].[srvpl_user2user_roles] (
    [id_user2user_role] INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id_user]           INT      NOT NULL,
    [id_user_role]      INT      NOT NULL,
    [enabled]           BIT      NOT NULL,
    [dattim1]           DATETIME CONSTRAINT [DF_srvpl_user2payment_roles_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]           DATETIME CONSTRAINT [DF_srvpl_user2payment_roles_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [id_creator]        INT      NOT NULL,
    CONSTRAINT [PK_srvpl_user2payment_roles] PRIMARY KEY CLUSTERED ([id_user2user_role] ASC)
);

