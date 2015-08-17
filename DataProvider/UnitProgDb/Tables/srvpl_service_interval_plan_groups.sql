CREATE TABLE [dbo].[srvpl_service_interval_plan_groups] (
    [id_service_interval_plan_group] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [name]                           NVARCHAR (150) NOT NULL,
    [dattim1]                        DATETIME       CONSTRAINT [DF_srvpl_service_interval_plan_group_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]                        DATETIME       CONSTRAINT [DF_srvpl_service_interval_plan_group_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [enabled]                        BIT            CONSTRAINT [DF_srvpl_service_interval_plan_group_enabled] DEFAULT ((1)) NOT NULL,
    [order_num]                      INT            CONSTRAINT [DF_srvpl_service_interval_plan_group_order_num] DEFAULT ((500)) NOT NULL,
    [sys_name]                       NVARCHAR (50)  NULL,
    [color]                          NVARCHAR (10)  NULL,
    CONSTRAINT [PK_srvpl_service_interval_plan_group] PRIMARY KEY CLUSTERED ([id_service_interval_plan_group] ASC)
);

