CREATE TABLE [dbo].[srvpl_service_claim_types] (
    [id_service_claim_type] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [name]                  NVARCHAR (50) NOT NULL,
    [order_num]             INT           CONSTRAINT [DF_srvpl_service_came_types_order_num] DEFAULT ((500)) NOT NULL,
    [enabled]               BIT           CONSTRAINT [DF_srvpl_service_came_types_enabled] DEFAULT ((1)) NOT NULL,
    [sys_name]              NVARCHAR (50) NULL,
    CONSTRAINT [PK_srvpl_service_came_types] PRIMARY KEY CLUSTERED ([id_service_claim_type] ASC)
);

