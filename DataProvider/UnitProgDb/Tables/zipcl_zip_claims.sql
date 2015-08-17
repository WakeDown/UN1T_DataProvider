CREATE TABLE [dbo].[zipcl_zip_claims] (
    [id_claim]               INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id_device]              INT            NULL,
    [serial_num]             NVARCHAR (50)  NULL,
    [device_model]           NVARCHAR (150) NULL,
    [contractor]             NVARCHAR (150) NULL,
    [id_contractor]          INT            NULL,
    [city]                   NVARCHAR (150) NULL,
    [id_city]                INT            NULL,
    [address]                NVARCHAR (150) NULL,
    [counter]                INT            NULL,
    [id_engeneer_conclusion] INT            NOT NULL,
    [id_claim_state]         INT            NOT NULL,
    [request_num]            NVARCHAR (50)  NULL,
    [descr]                  NVARCHAR (MAX) NULL,
    [dattim1]                DATETIME       CONSTRAINT [DF_zipcl_zip_claims_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]                DATETIME       CONSTRAINT [DF_zipcl_zip_claims_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [id_engeneer]            INT            NULL,
    [id_creator]             INT            NOT NULL,
    [enabled]                BIT            CONSTRAINT [DF_zipcl_zip_claims_enabled] DEFAULT ((1)) NOT NULL,
    [old_id_claim]           INT            NULL,
    [id_manager]             INT            NULL,
    [id_operator]            INT            NULL,
    [id_service_admin]       INT            NULL,
    [service_desk_num]       NVARCHAR (50)  NULL,
    [counter_colour]         INT            NULL,
    [cancel_comment]         NVARCHAR (500) NULL,
    [object_name]            NVARCHAR (150) NULL,
    [waybill_num]            NVARCHAR (50)  NULL,
    [et_state]               NVARCHAR (50)  NULL,
    [et_waybill_state]       NVARCHAR (50)  NULL,
    [contract_num]           NVARCHAR (50)  NULL,
    [contract_type]          NVARCHAR (50)  NULL,
    [id_et_way_claim_state]  INT            NULL,
    [contractor_sd_num]      NVARCHAR (50)  NULL,
    [et_plan_came_date]      NVARCHAR (50)  NULL,
    CONSTRAINT [PK_zipcl_zip_claims] PRIMARY KEY CLUSTERED ([id_claim] ASC)
);


GO
CREATE NONCLUSTERED INDEX [zipcl_zip_claims_stats_index]
    ON [dbo].[zipcl_zip_claims]([id_engeneer] ASC, [id_manager] ASC, [id_operator] ASC, [id_service_admin] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_enabled]
    ON [dbo].[zipcl_zip_claims]([enabled] DESC);


GO
CREATE NONCLUSTERED INDEX [idx_id_claim_state]
    ON [dbo].[zipcl_zip_claims]([id_claim_state] ASC);

