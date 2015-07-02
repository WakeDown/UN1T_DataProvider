CREATE PROCEDURE [dbo].[get_que_state_history] @id_question INT
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  --st.name as que_state ,
		sh.id_que_state,
                sh.dattim1 ,
                sh.creator_sid
        FROM    QuestionStateHistory sh
                --INNER JOIN QuestionStates st ON st.id = sh.id_question
        WHERE   sh.enabled = 1
                AND sh.id_question = @id_question
				order by id DESC
    END	

