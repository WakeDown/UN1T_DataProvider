CREATE PROCEDURE [dbo].[save_service_issue_plan]
	@id int = null,
	@id_service_issue int = null,
	@id_service_issue_type int = null,
	@period_start date = null,
	@period_end date = null,
	@creator_sid varchar(46) = null
	as begin
	set nocount on;

	if not exists (select 1 from service_issue_plan where enabled=1 and id_service_issue=@id_service_issue and id_service_issue_type=@id_service_issue_type)
	begin
		insert into service_issue_plan (id_service_issue, id_service_issue_type, period_start, period_end, creator_sid)
		values (@id_service_issue, @id_service_issue_type, @period_start, @period_end, @creator_sid)
		set @id=SCOPE_IDENTITY()
		select @id as id
	end 
	else
	begin
		select top 1 1 as [exists], p.id, p.id_service_issue_type, p.id_service_issue, p.period_start, p.period_end, p.creator_sid from service_issue_plan p where enabled=1 and id_service_issue=@id_service_issue and id_service_issue_type=@id_service_issue_type
			
	end
	

	end
