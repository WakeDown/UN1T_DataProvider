CREATE PROCEDURE [dbo].[get_que_pos_answer] @id INT = NULL, @id_que_position int
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  t.id, id_que_position, answerer_sid, t.descr, p.id_question 
        FROM    QuePosAnswer t
		INNER JOIN QuestionPositions p ON t.id_que_position = p.id
        WHERE  t.enabled = 1 AND   ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND t.id = @id
                         )
                    )
					and
					t.id_que_position=@id_que_position
					order by t.id desc
    END