CREATE PROCEDURE [dbo].[close_department] @id INT
AS
    BEGIN
        SET NOCOUNT ON;
        UPDATE  departments
        SET     enabled = 0
        WHERE   id = @id
    END
