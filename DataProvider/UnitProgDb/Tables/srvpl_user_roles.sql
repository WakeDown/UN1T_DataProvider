CREATE TABLE [dbo].[srvpl_user_roles] (
    [id_user_role]      INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id_main_user_role] INT            NULL,
    [name]              NVARCHAR (50)  NOT NULL,
    [descr]             NVARCHAR (500) NULL,
    [sys_name]          NVARCHAR (50)  NULL,
    [dattim1]           DATETIME       CONSTRAINT [DF_srvpl_payment_roles_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]           DATETIME       CONSTRAINT [DF_srvpl_payment_roles_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [enabled]           BIT            CONSTRAINT [DF_srvpl_payment_roles_enabled] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_srvpl_payment_roles] PRIMARY KEY CLUSTERED ([id_user_role] ASC)
);

