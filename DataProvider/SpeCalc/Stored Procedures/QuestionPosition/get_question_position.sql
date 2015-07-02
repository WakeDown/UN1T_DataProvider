CREATE PROCEDURE [dbo].[get_question_position] @id INT = NULL, @id_question INT=null
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  id, id_question, user_sid, descr
        FROM    QuestionPositions t
        WHERE t.enabled = 1 AND ( @id IS NULL OR @id<=0
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND t.id = @id
                         )
                    )
					and (@id_question IS NULL OR @id_question <=0 OR (@id_question IS NOT NULL AND @id_question>0 and t.id_question = @id_question))
					order by id desc
    END