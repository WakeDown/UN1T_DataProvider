CREATE TABLE [dbo].[srvpl_getPlanExecuteDeviceList_curr_month_cache] (
    [device]                 NVARCHAR (150)  NULL,
    [id_device]              INT             NULL,
    [plan_cnt]               INT             NULL,
    [done_cnt]               INT             NULL,
    [residue]                INT             NULL,
    [done_percent]           DECIMAL (10, 2) NULL,
    [address]                NVARCHAR (250)  NULL,
    [city]                   NVARCHAR (150)  NULL,
    [service_engeneer]       NVARCHAR (150)  NULL,
    [id_service_engeneer]    INT             NULL,
    [date_came]              DATETIME        NULL,
    [id_service_claim]       INT             NULL,
    [id_contractor]          INT             NULL,
    [date_cache]             DATETIME        CONSTRAINT [DF_srvpl_getPlanExecuteDeviceList_curr_month_cache_date_cache] DEFAULT (getdate()) NULL,
    [id_service_admin]       INT             NULL,
    [id_manager]             INT             NULL,
    [is_limit_device_claims] BIT             NULL
);

