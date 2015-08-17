CREATE PROCEDURE [dbo].[get_org_state_image]
	@id_organization int
	as begin
	set nocount on;
	select id, data,id_organization from org_state_images o
	where enabled=1 and id_organization = @id_organization
	end
