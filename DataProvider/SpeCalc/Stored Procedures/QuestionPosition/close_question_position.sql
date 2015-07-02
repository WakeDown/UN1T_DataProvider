CREATE PROCEDURE [dbo].[close_question_position] @id INT
AS
    BEGIN
        SET NOCOUNT ON;
        UPDATE  QuestionPositions
        SET     enabled = 0, dattim2=getdate()
        WHERE   id = @id
    END
