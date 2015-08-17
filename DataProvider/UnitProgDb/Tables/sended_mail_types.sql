CREATE TABLE [dbo].[sended_mail_types] (
    [id_sended_mail_type] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id_program]          INT            NOT NULL,
    [sys_name]            NVARCHAR (150) NOT NULL,
    CONSTRAINT [PK_sended_mail_types] PRIMARY KEY CLUSTERED ([id_sended_mail_type] ASC)
);

