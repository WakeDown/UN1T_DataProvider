CREATE TABLE [dbo].[zipcl_srvpl_contract_spec_prices] (
    [id_contract_spec_price] INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id_srvpl_contract]      INT             NOT NULL,
    [id_nomenclature]        INT             NULL,
    [nomenclature_name]      NVARCHAR (150)  NULL,
    [catalog_num]            NVARCHAR (50)   NULL,
    [price]                  DECIMAL (10, 2) NOT NULL,
    [enabled]                BIT             CONSTRAINT [DF_zipcl_contract_spec_price_enabled] DEFAULT ((1)) NOT NULL,
    [dattim1]                DATETIME        CONSTRAINT [DF_zipcl_contract_spec_price_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]                DATETIME        CONSTRAINT [DF_zipcl_contract_spec_price_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [id_creator]             INT             NULL,
    CONSTRAINT [PK_zipcl_contract_spec_price] PRIMARY KEY CLUSTERED ([id_contract_spec_price] ASC)
);

