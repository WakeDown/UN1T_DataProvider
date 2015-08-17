CREATE PROCEDURE [dbo].[get_doc_meet_link_list]
	@id_document int
AS
begin
set nocount on;
	select id_department, id_position, id_employee from document_meet_links
	where enabled=1 and id_document=@id_document
end
