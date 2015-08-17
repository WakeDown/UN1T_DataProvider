CREATE PROCEDURE [dbo].[close_document] 
	@id int,
	@deleter_sid varchar(46)
AS
BEGIN
	SET NOCOUNT ON;

    UPDATE documents 
    SET ENABLED = 0, dattim2=GETDATE(), deleter_sid = @deleter_sid
    WHERE id=@id
    
    UPDATE document_meet_links
    SET ENABLED = 0, dattim2=GETDATE(), deleter_sid = @deleter_sid
    WHERE ENABLED = 1 and id_document=@id
END