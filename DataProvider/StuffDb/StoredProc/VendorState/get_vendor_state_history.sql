CREATE PROCEDURE [dbo].[get_vendor_state_history]
	@id int
AS begin
set nocount on;
	select  vs.id,  v.name as vendor_name, vs.descr, date_end, o.name as organization_name, l.name as language, pic_data, 
	(select display_name FROM dbo.employees e WHERE e.ad_sid= vs.creator_sid) AS creator, vs.dattim1 AS date_create, vs.name
	from vendor_states vs 
	inner join vendors v on v.id=vs.id_vendor
	inner join organizations o on o.id=vs.id_organization
	inner join languages l on l.id=vs.id_language
	where vs.id=@id or old_id =@id
	order by vs.dattim2 desc
end
