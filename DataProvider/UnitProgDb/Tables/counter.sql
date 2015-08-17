CREATE TABLE [dbo].[counter] (
    [id_counter] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id_program] INT            NOT NULL,
    [id_user]    INT            NOT NULL,
    [date_came]  DATETIME       NOT NULL,
    [descr]      NVARCHAR (150) NULL,
    [ip_address] NVARCHAR (50)  NULL,
    [user_login] NVARCHAR (50)  NULL,
    CONSTRAINT [PK_counter] PRIMARY KEY CLUSTERED ([id_counter] ASC)
);

