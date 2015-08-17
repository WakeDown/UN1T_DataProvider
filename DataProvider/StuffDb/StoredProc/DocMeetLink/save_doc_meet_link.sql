CREATE PROCEDURE [dbo].[save_doc_meet_link] 
	@id_document INT,
	@id_department INT = NULL,
	@id_position INT = NULL,
	@id_employee INT = NULL,
	@creator_sid varchar(46) = null
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @id int
    INSERT INTO document_meet_links (id_document, id_department, id_position, id_employee, creator_sid)
    VALUES (@id_document, @id_department, @id_position, @id_employee, @creator_sid)
    SET @id = @@IDENTITY
    SELECT @id AS id
END
