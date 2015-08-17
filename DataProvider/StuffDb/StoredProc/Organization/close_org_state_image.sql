CREATE PROCEDURE [dbo].[close_org_state_image]@id INT
AS
    BEGIN
        SET NOCOUNT ON;
        UPDATE  org_state_images
        SET     enabled = 0, dattim2 = getdate()
        WHERE   id = @id
    END
