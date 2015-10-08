CREATE PROCEDURE [dbo].[get_vendor_state_prev_version]
	@id int
AS
	begin set nocount on;

	select vs_old.id, (select name from vendors v where v.id=vs_old.id_vendor) as vendor_name , vs_old.descr, vs_old.date_end, 
	(select name from organizations o where o.id=vs_old.id_organization) as organization_name, (select name from languages l where l.id=vs_old.id_language) as language, vs_old.pic_data, vs_old.creator_sid, vs_old.name
from vendor_states vs inner join vendor_states vs_old on vs.id=vs_old.old_id AND vs_old.id = (SELECT MAX(id) FROM vendor_states old WHERE old.old_id=@id)
where vs.id=@id 

	end
