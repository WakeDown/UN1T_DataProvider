CREATE TABLE [dbo].[srvpl_service_intervals] (
    [id_service_interval]            INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [name]                           NVARCHAR (150) NOT NULL,
    [nickname]                       NVARCHAR (100) NULL,
    [descr]                          NVARCHAR (MAX) NULL,
    [order_num]                      INT            CONSTRAINT [DF_srvpl_service_intervals_order_num] DEFAULT ((500)) NOT NULL,
    [enabled]                        BIT            CONSTRAINT [DF_srvpl_service_intervals_enabled] DEFAULT ((1)) NOT NULL,
    [dattim1]                        DATETIME       CONSTRAINT [DF_srvpl_service_intervals_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]                        DATETIME       CONSTRAINT [DF_srvpl_service_intervals_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [id_service_interval_plan_group] INT            NULL,
    [per_month]                      INT            NULL,
    CONSTRAINT [PK_srvpl_service_intervals] PRIMARY KEY CLUSTERED ([id_service_interval] ASC),
    CONSTRAINT [FK_srvpl_service_intervals_srvpl_service_interval_plan_group] FOREIGN KEY ([id_service_interval_plan_group]) REFERENCES [dbo].[srvpl_service_interval_plan_groups] ([id_service_interval_plan_group])
);

