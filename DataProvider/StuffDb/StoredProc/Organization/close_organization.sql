CREATE PROCEDURE [dbo].[close_organization] @id INT
AS
    BEGIN
        SET NOCOUNT ON;
        UPDATE  organizations
        SET     enabled = 0
        WHERE   id = @id
    END

