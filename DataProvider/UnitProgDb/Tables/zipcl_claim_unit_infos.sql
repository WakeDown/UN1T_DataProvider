CREATE TABLE [dbo].[zipcl_claim_unit_infos] (
    [id_claim_unit_info] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [catalog_num]        NVARCHAR (50) NOT NULL,
    [descr]              NVARCHAR (50) NULL,
    [enabled]            BIT           CONSTRAINT [DF_zipcl_claim_unit_infos_enabled] DEFAULT ((1)) NOT NULL,
    [dattim1]            DATETIME      CONSTRAINT [DF_zipcl_claim_unit_infos_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]            DATETIME      CONSTRAINT [DF_zipcl_claim_unit_infos_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [id_creator]         INT           NULL,
    CONSTRAINT [PK_zipcl_claim_unit_infos] PRIMARY KEY CLUSTERED ([id_claim_unit_info] ASC)
);

