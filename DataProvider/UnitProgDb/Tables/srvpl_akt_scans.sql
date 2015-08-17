CREATE TABLE [dbo].[srvpl_akt_scans] (
    [id_akt_scan]    INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [name]           NVARCHAR (50)  NOT NULL,
    [file_name]      NVARCHAR (50)  NOT NULL,
    [full_path]      NVARCHAR (150) NOT NULL,
    [cames_add]      BIT            CONSTRAINT [DF_srvpl_akt_scans_cames_add] DEFAULT ((0)) NOT NULL,
    [date_cames_add] DATETIME       NULL,
    [id_adder]       INT            NULL,
    [dattim1]        DATETIME       CONSTRAINT [DF_srvpl_akt_scans_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]        DATETIME       CONSTRAINT [DF_srvpl_akt_scans_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [enabled]        BIT            CONSTRAINT [DF_srvpl_akt_scans_enabled] DEFAULT ((1)) NOT NULL,
    [id_creator]     INT            NULL,
    CONSTRAINT [PK_srvpl_akt_scans] PRIMARY KEY CLUSTERED ([id_akt_scan] ASC)
);

