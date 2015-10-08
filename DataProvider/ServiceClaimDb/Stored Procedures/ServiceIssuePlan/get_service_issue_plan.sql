CREATE PROCEDURE [dbo].[get_service_issue_plan]
	@id int = null,
	@id_service_issue int = null,
	@id_service_issue_type int = null
AS
	begin set nocount on;

	if @id is not null and @id > 0
	begin
	select id,id_service_issue, id_service_issue_type, period_start, period_end,creator_sid from service_issue_plan
	where id=@id
	end
	else 
	begin
		select id,id_service_issue, id_service_issue_type, period_start, period_end,creator_sid from service_issue_plan
	where enabled=1 and id_service_issue=@id_service_issue and id_service_issue_type=@id_service_issue_type
	end

	end
