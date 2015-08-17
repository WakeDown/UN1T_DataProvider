CREATE PROCEDURE [dbo].[save_position]
	@id INT = NULL ,
    @name NVARCHAR(500),
	@creator_sid varchar(46)=NULL,
	@name_rod NVARCHAR(500),
	@name_dat nvarchar(500)
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
                SET     name = @name , name_rod=@name_rod, name_dat=@name_dat
                WHERE   id = @id
            END
        ELSE
            BEGIN
                INSERT  INTO positions
                        ( name  ,creator_sid, name_rod,name_dat
                        )
                VALUES  ( @name  ,@creator_sid, @name_rod,@name_dat
                        )

						SELECT @id=@@IDENTITY
            END
	 
		SELECT @id AS id
    END
