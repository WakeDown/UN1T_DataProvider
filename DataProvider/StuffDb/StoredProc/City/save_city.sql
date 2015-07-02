CREATE PROCEDURE [dbo].[save_city]
	@id INT = NULL ,
    @name NVARCHAR(150) ,
	@creator_sid varchar(46)=null
AS
    BEGIN
	SET NOCOUNT ON;
        IF @id IS NOT NULL
            AND @id > 0
            AND EXISTS ( SELECT 1
                         FROM   cities
                         WHERE  id = @id )
            BEGIN
                UPDATE  cities
                SET     name = @name 
                WHERE   id = @id
            END
        ELSE
            BEGIN
                INSERT  INTO cities
                        ( name ,creator_sid
                        )
                VALUES  ( @name ,@creator_sid
                        )

						SELECT @id=@@IDENTITY
            END
	 
		SELECT @id AS id
    END
