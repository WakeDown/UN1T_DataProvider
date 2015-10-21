CREATE PROCEDURE [dbo].[service_sheet_issued_zip_item_close]
	@id int, @deleter_sid varchar(46)
AS
    BEGIN
        SET NOCOUNT ON;
        UPDATE  service_sheet_issued_zip_items
        SET     enabled = 0, dattim2 = getdate(), deleter_sid=@deleter_sid
        WHERE   id = @id
    END
