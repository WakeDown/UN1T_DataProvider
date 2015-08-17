CREATE PROCEDURE [dbo].[save_question_position]
    @id int = null, 
	@id_question int,
	@user_sid varchar(46), 
	@descr nvarchar(max),
	@creator_sid varchar(46)=null
AS
    BEGIN
	SET NOCOUNT ON;
        IF @id IS NOT NULL
            AND @id > 0
            AND EXISTS ( SELECT 1
                         FROM   QuestionPositions
                         WHERE  id = @id )
            BEGIN
                UPDATE  QuestionPositions
                SET     
				user_sid = @user_sid ,
                        descr = @descr
                WHERE   id = @id
            END
        ELSE
            BEGIN
                INSERT  INTO QuestionPositions
                        ( id_question,
						user_sid ,
                          descr ,
						  creator_sid
                        )
                VALUES  ( @id_question, @user_sid ,
                          @descr,
						   @creator_sid
                        )

						SELECT @id=@@IDENTITY
            END
	 
		SELECT @id AS id
    END