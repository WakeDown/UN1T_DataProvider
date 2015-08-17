CREATE TABLE [dbo].[zipcl_claim_state_changes] (
    [id_claim_state_change] INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id_claim]              INT      NOT NULL,
    [id_claim_state]        INT      NOT NULL,
    [date_change]           DATETIME NOT NULL,
    [dattim1]               DATETIME CONSTRAINT [DF_zipcl_claim_state_changes_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]               DATETIME CONSTRAINT [DF_zipcl_claim_state_changes_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [enabled]               BIT      CONSTRAINT [DF_zipcl_claim_state_changes_enabled] DEFAULT ((1)) NOT NULL,
    [id_creator]            INT      NULL,
    [id_claim_state_from]   INT      NULL,
    [id_claim_state_to]     INT      NULL,
    CONSTRAINT [PK_zipcl_claim_state_changes] PRIMARY KEY CLUSTERED ([id_claim_state_change] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_id_claim]
    ON [dbo].[zipcl_claim_state_changes]([id_claim] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_id_claim_state]
    ON [dbo].[zipcl_claim_state_changes]([id_claim_state] ASC);

