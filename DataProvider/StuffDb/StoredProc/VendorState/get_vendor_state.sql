CREATE PROCEDURE [dbo].[get_vendor_state]
	@id int
AS begin
set nocount on;
	select vs.id, vs.id_vendor , vs.descr, date_end, vs.id_organization, vs.id_language, pic_data, creator_sid
	from vendor_states  vs 	
	where vs.id=@id
end

