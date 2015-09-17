CREATE PROCEDURE [dbo].[get_expires_vendor_state_list]
	AS begin
set nocount on;
	select vs.id,  v.name as vendor_name, vs.descr, date_end, o.name as organization_name, l.name as language, pic_data
	from vendor_states vs 
	inner join vendors v on v.id=vs.id_vendor
	inner join organizations o on o.id=vs.id_organization
	inner join languages l on l.id=vs.id_language
	where vs.enabled=1 and expired_delivery_sent = 0 
end
