CREATE TABLE [dbo].[zipcl_user_filters] (
    [id_user_filter] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id_user]        INT            NOT NULL,
    [filter]         NVARCHAR (250) NULL,
    [enabled]        BIT            CONSTRAINT [DF_zipcl_user_filter_enabled] DEFAULT ((1)) NOT NULL,
    [dattim1]        DATETIME       CONSTRAINT [DF_zipcl_user_filters_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]        DATETIME       CONSTRAINT [DF_zipcl_user_filters_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    CONSTRAINT [PK_zipcl_user_filter] PRIMARY KEY CLUSTERED ([id_user_filter] ASC)
);

