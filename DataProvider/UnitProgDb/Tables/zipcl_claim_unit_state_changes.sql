CREATE TABLE [dbo].[zipcl_claim_unit_state_changes] (
    [id_claim_unit_state_changes] INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id_claim_unit]               INT      NOT NULL,
    [id_creator]                  INT      NULL,
    [id_claim_state]              INT      NOT NULL,
    [dattim1]                     DATETIME NOT NULL,
    [id_claim_state_from]         INT      NULL,
    [id_claim_state_to]           INT      NULL,
    CONSTRAINT [PK_zipcl_claim_unit_state_changes] PRIMARY KEY CLUSTERED ([id_claim_unit_state_changes] ASC)
);

