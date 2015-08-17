CREATE TABLE [dbo].[programs] (
    [id_program] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [name]       NVARCHAR (50)  NOT NULL,
    [sys_name]   NVARCHAR (50)  NOT NULL,
    [descr]      NVARCHAR (MAX) NULL,
    [dattim1]    DATETIME       CONSTRAINT [DF_programs_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]    DATETIME       CONSTRAINT [DF_programs_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [enabled]    BIT            CONSTRAINT [DF_programs_enabled] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_programs] PRIMARY KEY CLUSTERED ([id_program] ASC)
);

