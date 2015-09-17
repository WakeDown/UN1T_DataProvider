CREATE PROCEDURE [dbo].[get_last_service_sheet_id]
	@id_claim int
AS begin
set nocount on;
select top 1 c2cs.id_service_sheet 
from claim2claim_states c2cs where c2cs.id_claim=@id_claim and enabled=1
order by id desc

end
