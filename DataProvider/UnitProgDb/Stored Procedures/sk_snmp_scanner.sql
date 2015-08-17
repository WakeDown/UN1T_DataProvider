-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sk_snmp_scanner]
    @action NVARCHAR(50) ,
    @sys_info NVARCHAR(MAX) = NULL ,
    @id_exchange INT = NULL ,
    @id_contractor INT = NULL ,
    @id_device INT = NULL ,
    @serial_num NVARCHAR(MAX) = NULL ,
    @counter INT = NULL ,
    @counter_color INT = NULL ,
    @date_request DATETIME = NULL ,
    @exchange_type NVARCHAR(50) = NULL
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @log_params NVARCHAR(MAX) ,
            @id_program INT ,
            @def_dattim2 DATETIME ,
            @def_enabled BIT ,
            @def_order_num INT ,
            @id_exchange_type INT ,
            @h INT ,
            @xml AS XML ,
            @host NVARCHAR(MAX) ,
            @var_str NVARCHAR(MAX) ,
            @str_counter NVARCHAR(MAX) ,
            @var_int INT ,
            @prog_version NVARCHAR(10)
            
            /****===DEFAULT VALUES===****/
        SET @def_dattim2 = '3.3.3333'
        SET @def_enabled = 1
        SET @def_order_num = 500
    /*/>*/


        SELECT TOP 1
                @id_program = id_program
        FROM    programs p
        WHERE   p.enabled = 1
                AND LOWER(p.sys_name) = LOWER('SNMPSCANNER')

        IF @action NOT LIKE 'get%'
            BEGIN
                SELECT  @log_params = CASE WHEN @action IS NULL THEN ''
                                           ELSE ' @action='
                                                + CONVERT(NVARCHAR(50), @action)
                                      END
                        + CASE WHEN @sys_info IS NULL THEN ''
                               ELSE ' @sys_info='
                                    + CONVERT(NVARCHAR(MAX), @sys_info)
                          END + CASE WHEN @id_exchange IS NULL THEN ''
                                     ELSE ' @id_exchange='
                                          + CONVERT(NVARCHAR(MAX), @id_exchange)
                                END + CASE WHEN @id_contractor IS NULL THEN ''
                                           ELSE ' @id_contractor='
                                                + CONVERT(NVARCHAR(MAX), @id_contractor)
                                      END
                        + CASE WHEN @id_device IS NULL THEN ''
                               ELSE ' @id_device='
                                    + CONVERT(NVARCHAR(MAX), @id_device)
                          END + CASE WHEN @serial_num IS NULL THEN ''
                                     ELSE ' @serial_num='
                                          + CONVERT(NVARCHAR(MAX), @serial_num)
                                END + CASE WHEN @counter IS NULL THEN ''
                                           ELSE ' @counter='
                                                + CONVERT(NVARCHAR(MAX), @counter)
                                      END
                        + CASE WHEN @counter_color IS NULL THEN ''
                               ELSE ' @counter_color='
                                    + CONVERT(NVARCHAR(MAX), @counter_color)
                          END + CASE WHEN @date_request IS NULL THEN ''
                                     ELSE ' @date_request='
                                          + CONVERT(NVARCHAR(MAX), @date_request)
                                END + CASE WHEN @exchange_type IS NULL THEN ''
                                           ELSE ' @exchange_type='
                                                + CONVERT(NVARCHAR(MAX), @exchange_type)
                                      END

                EXEC sk_log @action = 'insLog', @proc_name = 'sk_snmp_scanner',
                    @id_program = @id_program, @params = @log_params
            END
            
        IF @action = 'insExchange'
            BEGIN
                SELECT  @id_exchange_type = id_exchange_type
                FROM    dbo.snmp_exchange_types
                WHERE   UPPER(sys_name) = UPPER(@exchange_type)
				
                SELECT  @sys_info = CONVERT(NVARCHAR(MAX), @sys_info)
				
                INSERT  INTO dbo.snmp_exchanges
                        ( sys_info ,
                          id_exchange_type ,
                          dattim1 ,
                          decrypted
                        )
                VALUES  ( @sys_info ,
                          @id_exchange_type ,
                          GETDATE() ,
                          0
                        )
            END 
        ELSE
            IF @action = 'decryptExchangeAndInsertRequest'
                BEGIN
                
                    SELECT  @sys_info = sys_info
                    FROM    dbo.snmp_exchanges
                    WHERE   id_exchange = @id_exchange

                    SET @xml = CONVERT(XML, @sys_info)

                    DECLARE curs CURSOR STATIC
                    FOR
                        SELECT  b.value('@serialNum', 'nvarchar(max)') AS serialNum ,
                                CONVERT(DATETIME, b.value('@date',
                                                          'nvarchar(max)'), 104) AS [date] ,
                                b.value('@host', 'nvarchar(max)') AS host ,
                                b.value('@value', 'nvarchar(max)') AS [counter]
                        FROM    @xml.nodes('/DeviceRequestRoot/DeviceRequestList/DeviceRequest')
                                AS a ( b ) 
            
                    SET @id_contractor = ( SELECT TOP 1
                                                    b.value('@idContractor',
                                                            'nvarchar(max)')
                                           FROM     @xml.nodes('/DeviceRequestRoot/SysInfo')
                                                    AS a ( b )
                                         ) 
                    SET @prog_version = ( SELECT TOP 1
                                                    b.value('@progVersion',
                                                            'nvarchar(max)')
                                          FROM      @xml.nodes('/DeviceRequestRoot/SysInfo')
                                                    AS a ( b )
                                        ) 
                            
                    OPEN curs
                    
                    IF @@CURSOR_ROWS > 0
                        BEGIN
                    
                            FETCH NEXT
                            FROM curs
                            INTO @serial_num, @date_request, @host,
                                @str_counter
                            
                    
                            WHILE @@FETCH_STATUS = 0
                                BEGIN	
    
                                    SET @var_str = 'STRING: '
                            
                                    SET @serial_num = REPLACE(@serial_num,
                                                              '''', '')
                                    SET @id_device = NULL
                                                              
                                    IF LEN(@serial_num) > LEN(@var_str) + 1
                                        BEGIN
                                            SELECT  @serial_num = RIGHT(@serial_num,
                                                              LEN(@serial_num)
                                                              - ( CHARINDEX(LOWER(@var_str),
                                                              LOWER(@serial_num))
                                                              + LEN(@var_str)
                                                              - 1 ))
                                            SET @serial_num = RTRIM(LTRIM(@serial_num))
                                    
               
                                            SELECT  @id_device = id_device
                                            FROM    dbo.srvpl_devices d
                                            WHERE   d.enabled = 1
                                                    AND LOWER(d.serial_num) = LOWER(@serial_num)
                                        END
                                   
                                    SET @counter = NULL
                                    SET @var_str = 'Counter32: ' 
                                    IF CHARINDEX('Counter32: ', @str_counter) > 0
                                        BEGIN
                                            IF LEN(@str_counter) > LEN(@var_str)
                                                + 1
                                                BEGIN                          
                                                    SELECT  @str_counter = RIGHT(@str_counter,
                                                              LEN(@str_counter)
                                                              - ( CHARINDEX(LOWER(@var_str),
                                                              LOWER(@str_counter))
                                                              + LEN(@var_str)
                                                              - 1 ))      
                                                    SET @counter = CONVERT(INT, RTRIM(LTRIM(@str_counter)))     
                                                END
                                        END
                                    ELSE
                                        IF CHARINDEX('INTEGER: ', @str_counter) > 0
                                            BEGIN
                                                SET @counter = NULL
                                                SET @var_str = 'INTEGER: ' 
                                                IF LEN(@str_counter) > LEN(@var_str)
                                                    + 1
                                                    BEGIN                          
                                                        SELECT
                                                              @str_counter = RIGHT(@str_counter,
                                                              LEN(@str_counter)
                                                              - ( CHARINDEX(LOWER(@var_str),
                                                              LOWER(@str_counter))
                                                              + LEN(@var_str)
                                                              - 1 ))      
                                                        SET @counter = CONVERT(INT, RTRIM(LTRIM(@str_counter)))     
                                                    END
                                            END
									
                                    INSERT  INTO dbo.snmp_requests
                                            ( id_exchange ,
                                              id_contractor ,
                                              id_device ,
                                              serial_num ,
                                              counter ,
                                              counter_color ,
                                              date_request ,
                                              dattim1 ,
                                              prog_version ,
                                              host
                                            )
                                    VALUES  ( @id_exchange , -- id_exchange - int
                                              @id_contractor , -- id_contractor - int
                                              @id_device , -- id_device - int
                                              @serial_num , -- serial_num - nvarchar(50)
                                              @counter , -- counter - int
                                              @counter_color , -- counter_color - int
                                              @date_request , -- date_request - datetime
                                              GETDATE() ,  -- dattim1 - datetime
                                              @prog_version ,
                                              @host
                                            )
                                            
                                    EXEC dbo.ui_service_planing @action = 'setDeviceData',
                                        @id_device = @id_device,
                                        @counter = @counter,
                                        @counter_colour = @counter_color,
                                        @planing_date = @date_request,
                                        @id_contractor = @id_contractor     
                
                                    UPDATE  dbo.snmp_exchanges
                                    SET     decrypted = 1
                                    WHERE   id_exchange = @id_exchange
									
                                    FETCH NEXT
                            FROM curs
                            INTO @serial_num, @date_request, @host,
                                        @str_counter
                                END
                        END
                    CLOSE curs

                    DEALLOCATE curs
                END
            
        IF @action = 'insRequest'
            BEGIN
                INSERT  INTO dbo.snmp_requests
                        ( id_exchange ,
                          id_contractor ,
                          id_device ,
                          serial_num ,
                          counter ,
                          counter_color ,
                          date_request ,
                          dattim1
				        )
                VALUES  ( @id_exchange , -- id_exchange - int
                          @id_contractor , -- id_contractor - int
                          @id_device , -- id_device - int
                          @serial_num , -- serial_num - nvarchar(50)
                          @counter , -- counter - int
                          @counter_color , -- counter_color - int
                          @date_request , -- date_request - datetime
                          GETDATE()  -- dattim1 - datetime
				        )
            END           
    END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[sk_snmp_scanner] TO [sqlUnit_prog]
    AS [dbo];

