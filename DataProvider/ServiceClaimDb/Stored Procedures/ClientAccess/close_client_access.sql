CREATE PROCEDURE [dbo].[close_client_access] @id INT, @deleter_sid varchar(46)
AS
    BEGIN
        SET NOCOUNT ON;
        UPDATE  client_access
        SET     enabled = 0, dattim2 = getdate(), deleter_sid=@deleter_sid
        WHERE   id = @id
    END
