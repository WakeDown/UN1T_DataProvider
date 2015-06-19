CREATE PROCEDURE [dbo].[save_organization]
    @id INT = NULL ,
    @name NVARCHAR(150)
AS
    BEGIN
	SET NOCOUNT ON;
        IF @id IS NOT NULL
            AND @id > 0
            AND EXISTS ( SELECT 1
                         FROM   organizations
                         WHERE  id = @id )
            BEGIN
                UPDATE  organizations
                SET     name = @name 
                WHERE   id = @id
            END
        ELSE
            BEGIN
                INSERT  INTO organizations
                        ( name 
                        )
                VALUES  ( @name 
                        )

						SELECT @id=@@IDENTITY
            END
	 
		SELECT @id AS id
    END
