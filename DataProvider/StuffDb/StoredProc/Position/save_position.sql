CREATE PROCEDURE [dbo].[save_position]
	@id INT = NULL ,
    @name NVARCHAR(150)
AS
    BEGIN
	SET NOCOUNT ON;
        IF @id IS NOT NULL
            AND @id > 0
            AND EXISTS ( SELECT 1
                         FROM   positions
                         WHERE  id = @id )
            BEGIN
                UPDATE  positions
                SET     name = @name 
                WHERE   id = @id
            END
        ELSE
            BEGIN
                INSERT  INTO positions
                        ( name 
                        )
                VALUES  ( @name 
                        )

						SELECT @id=@@IDENTITY
            END
	 
		SELECT @id AS id
    END
