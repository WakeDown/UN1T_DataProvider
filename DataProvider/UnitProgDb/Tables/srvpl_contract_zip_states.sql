CREATE TABLE [dbo].[srvpl_contract_zip_states] (
    [id_zip_state] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [name]         NVARCHAR (150) NULL,
    [order_num]    INT            CONSTRAINT [DF_srvpl_contract_zip_states_order_num] DEFAULT ((500)) NOT NULL,
    [dattim1]      DATETIME       CONSTRAINT [DF_srvpl_contract_zip_states_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]      DATETIME       CONSTRAINT [DF_srvpl_contract_zip_states_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [enabled]      BIT            CONSTRAINT [DF_srvpl_contract_zip_states_enabled] DEFAULT ((1)) NOT NULL,
    [sys_name]     NVARCHAR (50)  NULL,
    CONSTRAINT [PK_srvpl_contract_zip_states] PRIMARY KEY CLUSTERED ([id_zip_state] ASC)
);

