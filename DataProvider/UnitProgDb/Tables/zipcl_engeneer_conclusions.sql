CREATE TABLE [dbo].[zipcl_engeneer_conclusions] (
    [id_engeneer_conclusion] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [name]                   NVARCHAR (150) NOT NULL,
    [dattim1]                DATETIME       CONSTRAINT [DF_zipcl_engeneer_conclusion_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]                DATETIME       CONSTRAINT [DF_zipcl_engeneer_conclusion_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [enabled]                BIT            CONSTRAINT [DF_zipcl_engeneer_conclusion_enabled] DEFAULT ((1)) NOT NULL,
    [order_num]              INT            CONSTRAINT [DF_zipcl_engeneer_conclusion_order_num] DEFAULT ((500)) NOT NULL,
    CONSTRAINT [PK_zipcl_engeneer_conclusion] PRIMARY KEY CLUSTERED ([id_engeneer_conclusion] ASC)
);

