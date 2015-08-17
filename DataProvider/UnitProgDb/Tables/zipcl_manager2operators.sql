CREATE TABLE [dbo].[zipcl_manager2operators] (
    [id_manager2operator] INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id_manager]          INT      NOT NULL,
    [id_operator]         INT      NOT NULL,
    [id_creator]          INT      NULL,
    [dattim1]             DATETIME CONSTRAINT [DF_zipcl_manager2operators_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]             DATETIME CONSTRAINT [DF_zipcl_manager2operators_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [enabled]             BIT      CONSTRAINT [DF_zipcl_manager2operators_enabled] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_zipcl_manager2operators] PRIMARY KEY CLUSTERED ([id_manager2operator] ASC)
);

