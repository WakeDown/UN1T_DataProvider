CREATE PROCEDURE [dbo].[get_service_issue]
	@id int 
AS
	begin set nocount on
	select id, id_claim, date_plan, specialist_sid, descr, creator_sid, dattim1 as date_create  from service_issue
	end
