CREATE PROCEDURE [dbo].[close_doc_meet_link]
    @id INT = NULL ,
    @id_document INT = NULL ,
    @id_department INT = NULL ,
    @id_position INT = NULL ,
    @id_employee INT = NULL ,
    @deleter_sid VARCHAR(46)
AS
    BEGIN
        SET NOCOUNT ON;

        IF ( @id IS NOT NULL
             AND @id > 0
           )
            BEGIN
                UPDATE  document_meet_links
                SET     ENABLED = 0 ,
                        dattim2 = GETDATE() ,
                        deleter_sid = @deleter_sid
                WHERE   id = @id
            END
    
        IF ( @id_document IS NOT NULL
             AND @id_document > 0
             AND @id_department IS NOT NULL
             AND @id_department > 0
           )
            BEGIN
                UPDATE  document_meet_links
                SET     ENABLED = 0 ,
                        dattim2 = GETDATE() ,
                        deleter_sid = @deleter_sid
                WHERE   id_document = @id_document
                        AND id_department = @id_department
            END
    
        IF ( @id_document IS NOT NULL
             AND @id_document > 0
             AND @id_position IS NOT NULL
             AND @id_position > 0
           )
            BEGIN
                UPDATE  document_meet_links
                SET     ENABLED = 0 ,
                        dattim2 = GETDATE() ,
                        deleter_sid = @deleter_sid
                WHERE   id_document = @id_document
                        AND id_position = @id_position
            END
    
        IF ( @id_document IS NOT NULL
             AND @id_document > 0
             AND @id_employee IS NOT NULL
             AND @id_employee > 0
           )
            BEGIN
                UPDATE  document_meet_links
                SET     ENABLED = 0 ,
                        dattim2 = GETDATE() ,
                        deleter_sid = @deleter_sid
                WHERE   id_document = @id_document
                        AND id_employee = @id_employee
            END
    
    END
