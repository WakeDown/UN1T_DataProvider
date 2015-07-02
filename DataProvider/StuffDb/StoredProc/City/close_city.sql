CREATE PROCEDURE [dbo].[close_city]@id INT
AS
    BEGIN
        SET NOCOUNT ON;
        UPDATE  cities
        SET     enabled = 0, dattim2 = getdate()
        WHERE   id = @id
    END

