CREATE PROCEDURE [dbo].[close_question] @id INT
AS
    BEGIN
        SET NOCOUNT ON;
        UPDATE  Questions
        SET     enabled = 0, dattim2=getdate()
        WHERE   id = @id
    END
