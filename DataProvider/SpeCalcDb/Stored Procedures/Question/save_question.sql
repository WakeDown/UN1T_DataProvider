CREATE PROCEDURE [dbo].[save_question]
    @id int = null, 
	@manager_sid varchar(46), @date_limit datetime, @descr nvarchar(max)=null,
	@creator_sid varchar(46)=null,
	@id_que_state int = null
AS
    BEGIN
	SET NOCOUNT ON;
        IF @id IS NOT NULL
            AND @id > 0
            AND EXISTS ( SELECT 1
                         FROM   questions
                         WHERE  id = @id )
            BEGIN
                UPDATE  questions
                SET     manager_sid = @manager_sid ,
                        date_limit = @date_limit ,
                        descr = @descr
                WHERE   id = @id
            END
        ELSE
            BEGIN
                INSERT  INTO questions
                        ( manager_sid ,
                          date_limit ,
                          descr ,
						  creator_sid,
						id_que_state

                        )
                VALUES  ( @manager_sid ,
                          @date_limit ,
                          @descr,
						   @creator_sid,
						   @id_que_state
                        )

						SELECT @id=@@IDENTITY
            END
	 
		SELECT @id AS id
    END