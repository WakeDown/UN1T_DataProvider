﻿CREATE PROCEDURE [dbo].[get_service_sheet]
	@id int = null,
	@id_claim int = null,
	@id_claim2claim_state int = null
	as begin set nocount on;

	select s.id, c2cs.id_claim, c2cs.id as id_claim2claim_state, case when s.process_enabled=1 then 1 else 0 end as process_enabled, 
	case when s.device_enabled=1 then 1 else 0 end as device_enabled, case when s.zip_claim=1 then 1 else 0 end as zip_claim, s.zip_claim_number, 
	s.counter_mono, s.counter_color, counter_total, case when no_counter=1 then 1 else 0 end as no_counter,
	s.dattim1 as date_create, s.descr, case when counter_unavailable=1 then 1 else 0 end as counter_unavailable, counter_descr
	from service_sheet s 
	inner join claim2claim_states c2cs on s.id=c2cs.id_service_sheet
	where s.enabled=1 and c2cs.enabled=1 and
	(@id is null or @id <= 0 or (@id is not null and @id > 0 and s.id=@id)) and 
	(@id_claim is null or @id_claim <= 0 or (@id_claim is not null and @id_claim > 0 and c2cs.id_claim=@id_claim)) 
	and 
	(@id_claim2claim_state is null or @id_claim2claim_state <= 0 or (@id_claim2claim_state is not null and @id_claim2claim_state > 0 and c2cs.id=@id_claim2claim_state)) 

	end