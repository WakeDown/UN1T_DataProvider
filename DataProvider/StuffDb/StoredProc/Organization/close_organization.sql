CREATE PROCEDURE [dbo].[close_organization] @id INT
AS
    BEGIN
        SET NOCOUNT ON;
        UPDATE  organizations
        SET     enabled = 0, dattim2 = getdate()
        WHERE   id = @id
    END

