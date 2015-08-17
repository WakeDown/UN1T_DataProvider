CREATE TABLE [dbo].[log_tab] (
    [id_log]      BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id_program]  INT            NOT NULL,
    [proc_name]   NVARCHAR (150) NOT NULL,
    [params]      NVARCHAR (MAX) NOT NULL,
    [descr]       NVARCHAR (MAX) NULL,
    [dattim]      DATETIME       NOT NULL,
    [user]        NVARCHAR (50)  NOT NULL,
    [error_level] INT            CONSTRAINT [DF_log_tab_error_level] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_log] PRIMARY KEY CLUSTERED ([id_log] ASC)
);

