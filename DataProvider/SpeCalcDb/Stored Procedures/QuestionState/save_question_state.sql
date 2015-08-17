CREATE PROCEDURE [dbo].[save_question_state]
    @id_question INT ,
    @id_que_state INT ,
    @creator_sid VARCHAR(46) ,
    @descr NVARCHAR(MAX) = NULL
AS
    BEGIN 
        SET NOCOUNT ON;
        BEGIN TRY
            BEGIN TRANSACTION t1
            INSERT  INTO QuestionStateHistory
                    ( id_question ,
                      id_que_state ,
                      creator_sid ,
                      descr
                    )
            VALUES  ( @id_question ,
                      @id_que_state ,
                      @creator_sid ,
                      @descr
                    )

            UPDATE  Questions
            SET     id_que_state = @id_que_state
            WHERE   id = @id_question
            COMMIT TRANSACTION t1
        END TRY

        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION t1
            DECLARE @error_text NVARCHAR(MAX)
            SELECT  @error_text = ERROR_MESSAGE()
                    + ' Изменения не были сохранены!'

            RAISERROR (
								@error_text
								,16
								,1
								)
        END CATCH
	
    END
