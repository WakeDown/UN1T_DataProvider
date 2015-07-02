CREATE PROCEDURE [dbo].[save_que_pos_answer]
    @id int = null, 
	@answerer_sid varchar(46), 
	@id_que_position int, 
	@descr nvarchar(max),
	@creator_sid varchar(46)=null
AS
    BEGIN
	SET NOCOUNT ON;
        IF @id IS NOT NULL
            AND @id > 0
            AND EXISTS ( SELECT 1
                         FROM   QuePosAnswer
                         WHERE  id = @id )
            BEGIN
                UPDATE  QuePosAnswer
                SET     answerer_sid = @answerer_sid ,
                        descr = @descr
                WHERE   id = @id
            END
        ELSE
            BEGIN
                INSERT  INTO QuePosAnswer
                        ( answerer_sid ,
                          id_que_position ,
                          descr ,
						  creator_sid
                        )
                VALUES  ( @answerer_sid ,
                          @id_que_position ,
                          @descr,
						   @creator_sid
                        )

						SELECT @id=@@IDENTITY
            END
	 
		SELECT @id AS id
    END