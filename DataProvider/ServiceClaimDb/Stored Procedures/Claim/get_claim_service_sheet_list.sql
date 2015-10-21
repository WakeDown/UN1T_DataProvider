CREATE PROCEDURE [dbo].[get_claim_service_sheet_list]
	@id_claim int
	as begin set nocount on;

	select c2cs.id_service_sheet as id, min(c2cs.dattim1) as date_create
	from 
	claim2claim_states c2cs 
	where c2cs.enabled=1 and c2cs.id_service_sheet IS NOT NULL AND c2cs.id_service_sheet > 0 and
	(@id_claim is null or @id_claim <= 0 or (@id_claim is not null and @id_claim > 0 and c2cs.id_claim=@id_claim)) 
	group by c2cs.id_service_sheet
	order by date_create desc
	end
