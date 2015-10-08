CREATE PROCEDURE [dbo].[get_service_issue_plan_list]
	@period_start date,
	@period_end date,
	@id_service_issue_type int = null
AS
	Set nocount on;
	select id,id_service_issue, id_service_issue_type, period_start, period_end,creator_sid 
	from service_issue_plan
	where period_start >= @period_start and period_end<=@period_end

RETURN 0
