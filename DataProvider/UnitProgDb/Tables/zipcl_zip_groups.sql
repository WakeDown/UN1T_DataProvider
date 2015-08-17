CREATE TABLE [dbo].[zipcl_zip_groups] (
    [id_zip_group] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [name]         NVARCHAR (50) NOT NULL,
    [dattim1]      DATETIME      CONSTRAINT [DF_srvpl_zip_groups_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]      DATETIME      CONSTRAINT [DF_srvpl_zip_groups_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [order_num]    NCHAR (10)    CONSTRAINT [DF_srvpl_zip_groups_order_num] DEFAULT ((500)) NOT NULL,
    [id_creator]   NCHAR (10)    NULL,
    [enabled]      BIT           CONSTRAINT [DF_srvpl_zip_groups_enabled] DEFAULT ((1)) NOT NULL,
    [colour]       NVARCHAR (6)  NULL,
    CONSTRAINT [PK_srvpl_zip_groups] PRIMARY KEY CLUSTERED ([id_zip_group] ASC)
);

