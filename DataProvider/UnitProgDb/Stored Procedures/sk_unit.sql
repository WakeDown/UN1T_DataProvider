
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sk_unit]
	-- Add the parameters for the stored procedure here
    @action NVARCHAR(50) = NULL ,
    @sp_test BIT = NULL --переменная для тестирования
    ,
    @id_user INT = NULL ,
    @name NVARCHAR(50) = NULL ,
    @program_name NVARCHAR(150) = NULL ,
    @id_creator INT = NULL ,
    @id_city INT = NULL ,
    @is_close BIT = NULL ,
    @region NVARCHAR(150) = NULL ,
    @area NVARCHAR(150) = NULL ,
    @locality NVARCHAR(100) = NULL ,
    @coordinates GEOGRAPHY = NULL,
    @coord NVARCHAR(50) = NULL
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        DECLARE @log_params NVARCHAR(MAX) ,
            @id_program INT ,
            @def_dattim2 DATETIME ,
            @def_enabled BIT ,
            @def_order_num INT 
            
            /****===DEFAULT VALUES===****/
        SET @def_dattim2 = '3.3.3333'
        SET @def_enabled = 1
        SET @def_order_num = 500
    /*/>*/

        IF @id_program IS NULL
            BEGIN
                SELECT  @id_program = id_program
                FROM    programs p
                WHERE   p.enabled = 1
                        AND LOWER(p.sys_name) = LOWER(@program_name)
            END

       
        SELECT  @log_params = CASE WHEN @action IS NULL THEN ''
                                   ELSE ' @action='
                                        + CONVERT(NVARCHAR, @action)
                              END + CASE WHEN @sp_test IS NULL THEN ''
                                         ELSE ' @sp_test='
                                              + CONVERT(NVARCHAR, @sp_test)
                                    END + CASE WHEN @id_user IS NULL THEN ''
                                               ELSE ' @id_user='
                                                    + CONVERT(NVARCHAR, @id_user)
                                          END
                + CASE WHEN @program_name IS NULL THEN ''
                       ELSE ' @program_name='
                            + CONVERT(NVARCHAR, @program_name)
                  END + CASE WHEN @name IS NULL THEN ''
                             ELSE ' @name=' + CONVERT(NVARCHAR(150), @name)
                        END + CASE WHEN @id_creator IS NULL THEN ''
                                   ELSE ' @id_creator='
                                        + CONVERT(NVARCHAR(50), @id_creator)
                              END + CASE WHEN @id_city IS NULL THEN ''
                                         ELSE ' @id_city='
                                              + CONVERT(NVARCHAR(50), @id_city)
                                    END + CASE WHEN @region IS NULL THEN ''
                                               ELSE ' @region='
                                                    + CONVERT(NVARCHAR(150), @region)
                                          END
                + CASE WHEN @area IS NULL THEN ''
                       ELSE ' @area=' + CONVERT(NVARCHAR(150), @area)
                  END + CASE WHEN @locality IS NULL THEN ''
                             ELSE ' @locality='
                                  + CONVERT(NVARCHAR(100), @locality)
                        END + CASE WHEN @coordinates IS NULL THEN ''
                                   ELSE ' @coordinates='
                                        + CONVERT(NVARCHAR(50), @coordinates)
                              END + CASE WHEN @coord IS NULL THEN ''
                                     ELSE ' @coord='
                                          + CONVERT(NVARCHAR(50), @coord)
                                END 
                

        EXEC sk_log @action = 'insLog', @proc_name = 'sk_users',
            @id_program = @id_program, @params = @log_params

        --=================================
		--Cities
		--=================================	
        IF @action = 'insCity'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                INSERT  INTO dbo.cities
                        ( name ,
                          enabled ,
                          order_num ,
                          dattim1 ,
                          dattim2 ,
                          id_creator ,
                          region ,
                          area ,
                          locality ,
                          coordinates,
                          coord
                        )
                VALUES  ( @name , -- name - nvarchar(50)
                          @def_enabled , -- enabled - bit
                          @def_order_num ,  -- order_num - int
                          GETDATE() ,
                          @def_dattim2 ,
                          @id_creator ,
                          @region ,
                          @area ,
                          @locality ,
                          @coordinates,
                           @coord
                        )                        
		        
                SELECT  @id_city = @@IDENTITY
		        
                RETURN @id_city
            END
        ELSE
            IF @action = 'updCity'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                
                    SELECT  @name = ISNULL(@name,
                                           ( SELECT name
                                             FROM   cities c
                                             WHERE  c.id_city = @id_city
                                           ))
                    SELECT  @id_creator = ISNULL(@id_creator,
                                                 ( SELECT   id_creator
                                                   FROM     cities c
                                                   WHERE    c.id_city = @id_city
                                                 ))
                                                 
                                                 
                    SELECT  @region = ISNULL(@region,
                                             ( SELECT   region
                                               FROM     cities c
                                               WHERE    c.id_city = @id_city
                                             ))
                          
                    SELECT  @area = ISNULL(@area,
                                           ( SELECT area
                                             FROM   cities c
                                             WHERE  c.id_city = @id_city
                                           ))
                          
                    SELECT  @locality = ISNULL(@locality,
                                               ( SELECT locality
                                                 FROM   cities c
                                                 WHERE  c.id_city = @id_city
                                               ))
                          
                    SELECT  @coordinates = ISNULL(@coordinates,
                                                  ( SELECT  coordinates
                                                    FROM    cities c
                                                    WHERE   c.id_city = @id_city
                                                  ))
					
					 SELECT  @coord = ISNULL(@coord,
                                                  ( SELECT  coord
                                                    FROM    cities c
                                                    WHERE   c.id_city = @id_city
                                                  ))
					
					--Скрываем запись
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.cities
                            SET     enabled = 0 ,
                                    id_creator = @id_creator
                            WHERE   id_city = @id_city
                            
                            RETURN @id_city
                        END
					
                    UPDATE  dbo.cities
                    SET     name = @name ,
                            id_creator = @id_creator ,
                            region = @region ,
                            area = @area ,
                            locality = @locality ,
                            coordinates = @coordinates,
                            coord = @coord
                    WHERE   id_city = @id_city
                        
                    RETURN @id_city
                END
        IF @action = 'closeCity'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
            
                EXEC dbo.[sk_unit] @action = N'updCity', @id_city = @id_city,
                    @id_creator = @id_creator, @is_close = 1				
            END
	
	
    END
