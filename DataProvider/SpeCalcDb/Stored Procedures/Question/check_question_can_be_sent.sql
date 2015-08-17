CREATE PROCEDURE [dbo].[check_question_can_be_sent] @id_question INT
AS
    BEGIN
        SET NOCOUNT ON;

        IF EXISTS ( SELECT  1
                    FROM    QuestionPositions p
                    WHERE   enabled = 1
                            AND id_question = @id_question)
            BEGIN
                SELECT  1 as result
            END
        ELSE
            BEGIN
                SELECT  0 as result
            END
    END