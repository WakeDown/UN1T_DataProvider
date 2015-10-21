CREATE PROCEDURE [dbo].[service_sheet_not_installed_zip_item_get_list]
	@id_service_sheet int
	as begin
	set nocount on;

	select ni.id, ni.id_service_sheet, o.part_num, o.name, o.count, ni.creator_sid, o.id_zip_claim_unit, ni.dattim1 as date_create
	from service_sheet_not_installed_zip_items ni
	left join service_sheet_ordered_zip_items o on o.id = ni.id_ordered_zip_item
	where ni.enabled=1 and ni.id_service_sheet=@id_service_sheet
	end

