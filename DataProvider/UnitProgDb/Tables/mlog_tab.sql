CREATE TABLE [dbo].[mlog_tab] (
    [id_mlog_tab] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id_program]  INT            NOT NULL,
    [params]      NVARCHAR (MAX) NOT NULL,
    [subject]     NVARCHAR (100) NULL,
    [body]        NVARCHAR (MAX) NULL,
    [recipients]  NVARCHAR (MAX) NULL,
    [dattim]      DATETIME       NOT NULL,
    [user]        NVARCHAR (50)  NOT NULL,
    [descr]       NVARCHAR (MAX) NULL,
    [error_level] INT            CONSTRAINT [DF_mlog_tab_error_level] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_mlog_tab] PRIMARY KEY CLUSTERED ([id_mlog_tab] ASC)
);

