CREATE PROCEDURE [dbo].[close_position] @id INT
AS
    BEGIN
        SET NOCOUNT ON;
        UPDATE  positions
        SET     enabled = 0, dattim2 = getdate()
        WHERE   id = @id
    END