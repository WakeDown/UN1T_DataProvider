CREATE TABLE [dbo].[srvpl_getPlanExecuteServManagerContractorList_curr_month_cache] (
    [contractor]    NVARCHAR (150)  NULL,
    [id_contractor] INT             NOT NULL,
    [id_manager]    INT             NOT NULL,
    [plan_cnt]      INT             NULL,
    [done_cnt]      INT             NULL,
    [residue]       INT             NULL,
    [done_percent]  DECIMAL (10, 2) NULL,
    [date_cache]    DATETIME        CONSTRAINT [DF_srvpl_getPlanExecuteServManagerContractorList_curr_month_cache_date_cache] DEFAULT (getdate()) NOT NULL
);

