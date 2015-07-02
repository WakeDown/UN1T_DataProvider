CREATE PROCEDURE [dbo].[get_question_curr_state]
	@id_question INT
AS
BEGIN
	SET NOCOUNT ON;
	SELECT  st.id ,
                st.name ,
                UPPER(st.sys_name) AS sys_name,
				st.order_num
        FROM    Questions q INNER JOIN  QuestionStates st ON q.id_que_state = st.id
		WHERE q.id=@id_question
END
