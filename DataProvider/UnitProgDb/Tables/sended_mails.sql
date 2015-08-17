CREATE TABLE [dbo].[sended_mails] (
    [id_sended_mail]      INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id_sended_mail_type] INT            NOT NULL,
    [dattim]              DATETIME       NOT NULL,
    [uid]                 NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_sended_mails] PRIMARY KEY CLUSTERED ([id_sended_mail] ASC)
);

