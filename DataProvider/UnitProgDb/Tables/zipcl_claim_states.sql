CREATE TABLE [dbo].[zipcl_claim_states] (
    [id_claim_state] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [name]           NVARCHAR (150) NOT NULL,
    [sys_name]       NVARCHAR (50)  NOT NULL,
    [dattim1]        DATETIME       CONSTRAINT [DF_zipcl_zip_claim_state_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]        DATETIME       CONSTRAINT [DF_zipcl_zip_claim_state_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [enabled]        BIT            CONSTRAINT [DF_zipcl_zip_claim_state_enabled] DEFAULT ((1)) NOT NULL,
    [order_num]      INT            CONSTRAINT [DF_zipcl_zip_claim_state_order_num] DEFAULT ((500)) NOT NULL,
    [history_order]  INT            NULL,
    [note]           NVARCHAR (10)  NULL,
    CONSTRAINT [PK_zipcl_zip_claim_state] PRIMARY KEY CLUSTERED ([id_claim_state] ASC)
);

