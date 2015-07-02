CREATE PROCEDURE [dbo].[get_question]
    @id INT = NULL ,
    @manager_sid VARCHAR(46) = NULL ,
    @lst_que_states NVARCHAR(100) = NULL ,
    @top INT
	,@prod_sid VARCHAR(46) = NULL 
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT top ( @top ) id ,
                manager_sid ,
                date_limit ,
                descr ,
                id_que_state ,
                que_state ,
                dattim1
        FROM    questions_view q
        WHERE   ( @id IS NULL
                  OR ( @id IS NOT NULL
                       AND @id > 0
                       AND q.id = @id
                     )
                )
                AND ( ( @manager_sid IS NULL
                        OR @manager_sid = ''
                      )
                      OR ( @manager_sid IS NOT NULL
                           AND @manager_sid != ''
                           AND q.manager_sid = @manager_sid
                         )
                    )
                AND ( ( @lst_que_states IS NULL
                        OR @lst_que_states = ''
                      )
                      OR ( @lst_que_states IS NOT NULL
                           AND @lst_que_states != ''
                           AND q.id_que_state IN (
                           SELECT   value
                           FROM     Split(@lst_que_states, ',') )
                         )
                    )
					AND ( ( @prod_sid IS NULL
                        OR @prod_sid = ''
                      )
                      OR ( @prod_sid IS NOT NULL
                           AND @prod_sid != ''
                           AND exists(SELECT 1 FROM QuestionPositions p WHERE p.ENABLED=1 AND p.id_question=q.id AND p.user_sid=@prod_sid)
                         )
                    )
        ORDER BY id DESC
    END