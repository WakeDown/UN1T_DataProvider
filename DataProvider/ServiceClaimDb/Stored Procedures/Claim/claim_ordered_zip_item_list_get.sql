CREATE PROCEDURE [dbo].[claim_ordered_zip_item_list_get]
@claim_id int,
	@id_service_sheet int = null
	as begin
	set nocount on;
	select zi.id, zi.id_service_sheet, zi.part_num, zi.name, zi.count, zi.creator_sid, zi.id_zip_claim_unit, zi.dattim1 as date_create, zi.creator_sid,
	case when inst.id is null then 0 else 1 end as installed,
	inst.creator_sid as installed_sid,
	inst.id_service_sheet as installed_id_service_sheet,
	inst.creator_sid as installed_sid,
	inst.dattim1 as date_install
	from service_sheet_ordered_zip_items zi
	left join service_sheet_installed_zip_items inst on zi.id = inst.id_ordered_zip_item AND inst.enabled=1
	inner join service_sheet sh on zi.id_service_sheet=sh.id
	
	where zi.enabled=1 and sh.enabled=1 and sh.id_claim=@claim_id 
	AND (inst.id_service_sheet IS NULL OR inst.id_service_sheet=@id_service_sheet)
	--and (@not_in_id_service_sheet is null or @not_in_id_service_sheet <= 0 or (sh.id != @not_in_id_service_sheet and sh.id != @not_in_id_service_sheet))
	--and zi.installed = 0

	end
