CREATE TABLE [dbo].[zipcl_zip_group2cat_nums] (
    [id_zip_group2cat_num] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id_zip_group]         INT           NOT NULL,
    [catalog_num]          NVARCHAR (50) NOT NULL,
    [dattim1]              DATETIME      CONSTRAINT [DF_zipcl_zip_group2cat_num_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]              DATETIME      CONSTRAINT [DF_zipcl_zip_group2cat_num_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [enabled]              BIT           CONSTRAINT [DF_zipcl_zip_group2cat_num_enabled] DEFAULT ((1)) NOT NULL,
    [id_creator]           INT           NULL,
    [order_num]            INT           CONSTRAINT [DF_zipcl_zip_group2cat_num_order_num] DEFAULT ((500)) NOT NULL,
    CONSTRAINT [PK_zipcl_zip_group2cat_num] PRIMARY KEY CLUSTERED ([id_zip_group2cat_num] ASC)
);

