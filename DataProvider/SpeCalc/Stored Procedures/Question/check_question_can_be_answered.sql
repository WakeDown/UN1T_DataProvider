CREATE PROCEDURE [dbo].[check_question_can_be_answered] @id_question INT
AS
    BEGIN
        SET NOCOUNT ON;

        IF EXISTS ( SELECT  1
                    FROM    QuestionPositions p
                    WHERE   enabled = 1
                            AND id_question = @id_question
                            AND NOT EXISTS ( SELECT 1
                                             FROM   QuePosAnswer a
                                             WHERE  a.enabled = 1
                                                    AND a.id_que_position = p.id ) )
            BEGIN
                SELECT  0 as result
            END
        ELSE
            BEGIN
                SELECT  1 as result
            END
    END
