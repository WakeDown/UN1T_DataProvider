CREATE TABLE [dbo].[zipcl_claim_units] (
    [id_claim_unit]          INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id_claim]               INT             NOT NULL,
    [catalog_num]            NVARCHAR (50)   NOT NULL,
    [name]                   NVARCHAR (150)  NOT NULL,
    [count]                  INT             NOT NULL,
    [nomenclature_num]       NVARCHAR (50)   NULL,
    [price_in]               DECIMAL (10, 2) NULL,
    [price_out]              DECIMAL (10, 2) NULL,
    [dattim1]                DATETIME        CONSTRAINT [DF_zipcl_claim_units_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]                DATETIME        CONSTRAINT [DF_zipcl_claim_units_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [enabled]                BIT             CONSTRAINT [DF_zipcl_claim_units_enabled] DEFAULT ((1)) NOT NULL,
    [id_creator]             INT             NOT NULL,
    [delivery_time]          NVARCHAR (50)   NULL,
    [no_nomenclature_num]    BIT             NULL,
    [nomenclature_claim_num] NVARCHAR (50)   NULL,
    [price_request]          BIT             NULL,
    [id_supply_man]          INT             NULL,
    [old_id_claim_unit]      INT             NULL,
    [id_resp_supply]         INT             NULL,
    [is_return]              BIT             NULL,
    CONSTRAINT [PK_zipcl_claim_units] PRIMARY KEY CLUSTERED ([id_claim_unit] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_id_claim]
    ON [dbo].[zipcl_claim_units]([id_claim] DESC);


GO
CREATE NONCLUSTERED INDEX [idx_enabled]
    ON [dbo].[zipcl_claim_units]([enabled] DESC);

