CREATE PROCEDURE [dbo].[close_employee] @id INT
AS
    BEGIN
        SET NOCOUNT ON;
        UPDATE  employees
        SET     enabled = 0, dattim2 = getdate()
        WHERE   id = @id
    END

