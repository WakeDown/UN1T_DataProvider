CREATE PROCEDURE [dbo].[get_document_list]	 
	@id_department INT = NULL,
	@id_position INT = NULL,
	@id_employee INT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	with deps as (
   select id, id_parent
   from dbo.departments
   where id = @id_department
   union all
   select c.id, c.id_parent
   from departments c
     join deps p on p.id_parent = c.id 
) 


	SELECT d.id, d.NAME, d.data_sid
	FROM documents d 
	WHERE d.ENABLED = 1 AND 
((@id_department IS NULL OR @id_department <= 0 OR (@id_department IS NOT NULL AND @id_department > 0 AND EXISTS(SELECT 1 FROM document_meet_links dml WHERE dml.enabled=1 and dml.id_document = d.id AND dml.id_department in (select id
from deps))))

or 
	(@id_position IS NULL OR @id_position <= 0 OR (@id_position IS NOT NULL AND @id_position > 0 AND EXISTS(SELECT 1 FROM document_meet_links dml WHERE dml.enabled=1 and dml.id_document = d.id AND dml.id_position = @id_position)))

or 
	(@id_employee IS NULL OR @id_employee <= 0 OR (@id_employee IS NOT NULL AND @id_employee > 0 AND EXISTS(SELECT 1 FROM document_meet_links dml WHERE dml.enabled=1 and dml.id_document = d.id AND dml.id_employee = @id_employee)))
	)	order by d.name		
END
