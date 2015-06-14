CREATE PROCEDURE [dbo].[close_employee] @id INT
AS
    BEGIN
        SET NOCOUNT ON;
        UPDATE  employees
        SET     enabled = 0
        WHERE   id = @id
    END

