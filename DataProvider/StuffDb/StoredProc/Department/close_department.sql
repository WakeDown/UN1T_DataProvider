CREATE PROCEDURE [dbo].[close_department] @id INT
AS
    BEGIN
        SET NOCOUNT ON;
        UPDATE  departments
        SET     enabled = 0, dattim2 = getdate()
        WHERE   id = @id
    END
