CREATE TABLE [dbo].[srvpl_getPlanExecuteServAdminContractorList_curr_month_cache] (
    [contractor]       NVARCHAR (150)  NULL,
    [id_contractor]    INT             NOT NULL,
    [id_service_admin] INT             NOT NULL,
    [plan_cnt]         INT             NULL,
    [done_cnt]         INT             NULL,
    [residue]          INT             NULL,
    [done_percent]     DECIMAL (10, 2) NULL,
    [date_cache]       DATETIME        CONSTRAINT [DF_srvpl_getPlanExecuteServAdminContractorList_curr_month_cache_date_cache] DEFAULT (getdate()) NOT NULL
);

