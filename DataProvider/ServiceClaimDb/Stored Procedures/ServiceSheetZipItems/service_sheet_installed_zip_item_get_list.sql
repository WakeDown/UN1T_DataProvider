CREATE PROCEDURE [dbo].[service_sheet_installed_zip_item_get_list]
	@id_service_sheet int
	as begin
	set nocount on;

	select i.id, i.id_service_sheet, i.dattim1 as date_install, i.creator_sid as installed_sid, o.part_num, o.name, o.count, o.id_zip_claim_unit	
	from service_sheet_installed_zip_items i 
	left join service_sheet_ordered_zip_items o on o.id = i.id_ordered_zip_item
	where i.enabled=1 and i.id_service_sheet=@id_service_sheet
	end
