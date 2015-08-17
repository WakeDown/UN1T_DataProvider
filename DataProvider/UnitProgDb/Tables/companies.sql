CREATE TABLE [dbo].[companies] (
    [id_company]   INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [name]         NVARCHAR (100) NOT NULL,
    [display_name] NVARCHAR (50)  NULL,
    [id_city]      INT            NULL,
    [enabled]      BIT            CONSTRAINT [DF_companies_enabled] DEFAULT ((1)) NOT NULL,
    [order_num]    INT            CONSTRAINT [DF_companies_order_num] DEFAULT ((50)) NOT NULL,
    [dattim1]      DATETIME       CONSTRAINT [DF_companies_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]      DATETIME       CONSTRAINT [DF_companies_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [inn]          NVARCHAR (12)  NULL,
    [sys_name]     NVARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_companies] PRIMARY KEY CLUSTERED ([id_company] ASC)
);

