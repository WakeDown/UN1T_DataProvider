﻿CREATE PROCEDURE [dbo].[service_sheet_issued_zip_item_get]
	@id int
	as begin
	set nocount on;

	select id, id_service_sheet, part_num, name, count, creator_sid, id_zip_claim_unit, dattim1 as date_create, creator_sid, installed, installed_sid, installed_cancel_sid, installed_id_service_sheet
	from service_sheet_issued_zip_items
	where id=@id
	end