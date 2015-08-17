CREATE VIEW [dbo].[questions_view]
	AS SELECT id, manager_sid, date_limit, dattim1, descr , id_que_state, (select name from QuestionStates qs where qs.id=q.id_que_state) as que_state
	FROM Questions q 
	where enabled = 1
