CREATE TABLE [dbo].[zipcl_numenclature_change] (
    [catalog_num]      NVARCHAR (50) NOT NULL,
    [nomenclature_num] NVARCHAR (50) NOT NULL,
    [dattim1]          DATETIME      CONSTRAINT [DF_zipcl_numenclature_change_dattim1] DEFAULT (getdate()) NOT NULL,
    [load]             BIT           CONSTRAINT [DF_zipcl_numenclature_change_load] DEFAULT ((0)) NOT NULL
);

