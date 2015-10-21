CREATE PROCEDURE [dbo].[service_sheet_ordered_zip_item_get_list]
	@id_service_sheet int
	as begin
	set nocount on;

	select id, id_service_sheet, part_num, name, count, creator_sid, id_zip_claim_unit, dattim1 as date_create, creator_sid
	from service_sheet_ordered_zip_items
	where enabled=1 and id_service_sheet=@id_service_sheet
	end
