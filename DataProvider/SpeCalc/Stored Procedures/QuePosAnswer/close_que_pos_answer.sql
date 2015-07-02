CREATE PROCEDURE [dbo].[close_que_pos_answer] @id INT
AS
    BEGIN
        SET NOCOUNT ON;
        UPDATE  QuePosAnswer
        SET     enabled = 0, dattim2=getdate()
        WHERE   id = @id
    END
