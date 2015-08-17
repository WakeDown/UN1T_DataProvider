CREATE TABLE [dbo].[zipcl_nomenclature_price] (
    [id_nomenclature]  INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [load_num]         INT             NULL,
    [name]             NVARCHAR (150)  NOT NULL,
    [catalog_num]      NVARCHAR (50)   NOT NULL,
    [nomenclature_num] NVARCHAR (50)   NULL,
    [price_rur]        DECIMAL (10, 2) NULL,
    [price_usd]        DECIMAL (10, 2) NULL,
    [price_eur]        DECIMAL (10, 2) NULL,
    [dattim1]          DATETIME        CONSTRAINT [DF_zipcl_nomenclature_price_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]          DATETIME        CONSTRAINT [DF_zipcl_nomenclature_price_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [enabled]          BIT             CONSTRAINT [DF_zipcl_nomenclature_price_enabled] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_zipcl_nomenclature_price] PRIMARY KEY CLUSTERED ([id_nomenclature] ASC)
);

