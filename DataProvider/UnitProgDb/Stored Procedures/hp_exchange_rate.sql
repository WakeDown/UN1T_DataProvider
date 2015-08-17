-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[hp_exchange_rate]
    @action NVARCHAR(50) ,
    @descr NVARCHAR(150) = NULL ,
    @id_user INT = NULL ,
    @id_currency INT = NULL ,
    @id_relation_currency INT = NULL ,
    @price DECIMAL(10, 4) = NULL ,
    @currency_sys_name NVARCHAR(50) = NULL ,
    @date_rate DATE = NULL
AS
    BEGIN
        SET NOCOUNT ON;
	
	--<Variables>
        DECLARE @error_text NVARCHAR(MAX) ,
            @id_program INT ,
            @var_int INT ,
            @log_params NVARCHAR(MAX) ,
            @log_descr NVARCHAR(MAX) ,
            @var_str NVARCHAR(MAX) ,
            @def_dattim2 DATETIME ,
            @def_enabled BIT ,
            @cbr_code NVARCHAR(10) ,
            @mail_subject NVARCHAR(1000) ,
            @mail_body NVARCHAR(MAX)
            
        SET @def_dattim2 = '3.3.3333'
        SET @def_enabled = 1
            
    --</Variables>
        IF @action NOT LIKE 'get%'
            BEGIN
		--<Сохраняем в лог список параметров
                SELECT TOP 1
                        @id_program = id_program
                FROM    programs p
                WHERE   p.enabled = 1
                        AND LOWER(p.sys_name) = LOWER('EXCHANGERATE')

                SELECT  @log_params = CASE WHEN @action IS NULL THEN ''
                                           ELSE ' @action='
                                                + CONVERT(NVARCHAR(100), @action)
                                      END + CASE WHEN @id_user IS NULL THEN ''
                                                 ELSE ' @id_user='
                                                      + CONVERT(NVARCHAR(MAX), @id_user)
                                            END
                        + CASE WHEN @id_currency IS NULL THEN ''
                               ELSE ' @id_currency='
                                    + CONVERT(NVARCHAR(MAX), @id_currency)
                          END
                        + CASE WHEN @id_relation_currency IS NULL THEN ''
                               ELSE ' @id_relation_currency='
                                    + CONVERT(NVARCHAR(MAX), @id_relation_currency)
                          END + CASE WHEN @price IS NULL THEN ''
                                     ELSE ' @price='
                                          + CONVERT(NVARCHAR(MAX), @price)
                                END
                        + CASE WHEN @currency_sys_name IS NULL THEN ''
                               ELSE ' @currency_sys_name='
                                    + CONVERT(NVARCHAR(MAX), @currency_sys_name)
                          END + CASE WHEN @date_rate IS NULL THEN ''
                                     ELSE ' @date_rate='
                                          + CONVERT(NVARCHAR(MAX), @date_rate)
                                END                               

                EXEC sk_log @action = 'insLog',
                    @proc_name = 'hp_exchange_rate', @id_program = @id_program,
                    @params = @log_params, @descr = @log_descr
			--/>
            END
            
        IF @action = 'loadExchangeRatesFromCbrWebService'
            BEGIN
                DECLARE @url NVARCHAR(4000) ,
                    @obj INT ,
                    @response VARCHAR(8000) ,
                    @date_req1 NVARCHAR(20) ,
                    @date_req2 NVARCHAR(20) ,
                    @h INT 
                    
                --SET @date_req1 = CONVERT(NVARCHAR, GETDATE(), 103)
                SET @date_req1 = CONVERT(NVARCHAR, DATEADD(DAY, -1, GETDATE()), 103)
                SET @date_req2 = CONVERT(NVARCHAR, DATEADD(DAY, 1, GETDATE()), 103)

                DECLARE curs CURSOR LOCAL
                FOR
                    SELECT  id_currency ,
                            cbr_code
                    FROM    currency c
                    WHERE   c.ENABLED = 1

                OPEN curs
                FETCH NEXT                        
                        FROM curs
				INTO @id_currency, @cbr_code

                WHILE @@FETCH_STATUS = 0
                    BEGIN
                        SET @url = 'http://www.cbr.ru/scripts/XML_dynamic.asp?date_req1='
                            + @date_req1 + '&date_req2=' + @date_req2
                            + '&VAL_NM_RQ=' + ISNULL(@cbr_code, '')
                
                        EXEC sp_OACreate 'MSXML2.ServerXMLHttp', @obj OUT
                        EXEC sp_OAMethod @obj, 'Open', NULL, 'GET', @url,
                            false
                        EXEC sp_OAMethod @obj, 'send'
                        EXEC sp_OAGetProperty @obj, 'responseText',
                            @response OUT
                        EXEC sp_OADestroy @obj
						
						--Паникуем если не вернулось нам ответа
                        IF @response IS NULL
                            BEGIN
                                SET @mail_subject = 'Проблема с загрузкой курсов валют на SQL Server '
                                    + @@SERVERNAME
                                SET @mail_body = @mail_subject
		
                                --EXEC sk_send_message @action = 'sendSupportEmail',
                                --    @id_program = @id_program,
                                --    @subject = @mail_subject,
                                --    @body = @mail_body
                            END
						
						
                        EXEC sp_xml_preparedocument @h OUTPUT, @response
						
--Выбирается последняя существующая дата курса валюты
                        SELECT  @price = price ,
                                @date_rate = [date]
                        FROM    ( SELECT    CONVERT(MONEY, REPLACE(Value, ',',
                                                              '.')) AS price ,
                                            CONVERT(DATE, [Date], 104) AS [date]
                                  FROM      OPENXML (@h, '//Record', 0)
WITH ( [Id] NVARCHAR(10), [Date] VARCHAR(10) ,Name VARCHAR(99) './Name', Value VARCHAR(10) './Value' )
                                ) AS t
                        ORDER BY t.[date]

                        EXEC sp_xml_removedocument @h


                        IF @price IS NOT NULL
                            AND NOT EXISTS ( SELECT 1
                                             FROM   dbo.exchange_rate er
                                             WHERE  er.enabled = 1
                                                    AND er.id_currency = @id_currency
                                                    AND date_rate = @date_rate )
                            BEGIN
                                EXEC dbo.hp_exchange_rate @action = 'insExchangeRate',
                                    @id_currency = @id_currency,
                                    @date_rate = @date_rate, @price = @price
                            END
		
                        FETCH NEXT                        
                        FROM curs
				INTO @id_currency, @cbr_code
                    END
                CLOSE curs

				DEALLOCATE curs
            END
            
        IF @action = 'insExchangeRate'
            BEGIN
				--id_currency - это валюта для которой указывается стоимость
                IF @id_currency IS NULL
                    AND @currency_sys_name IS NOT NULL
                    BEGIN
                        SELECT  @id_currency = id_currency
                        FROM    currency c
                        WHERE   UPPER(sys_name) = UPPER(@currency_sys_name)
                    END              
				
				--id_relation_currency - это валюта к которой строится отношение USD/RUR, EUR/RUR
                IF @id_relation_currency IS NULL
                    BEGIN
                        SELECT  @id_relation_currency = id_currency
                        FROM    currency c
                        WHERE   UPPER(sys_name) = 'RUR'
                    END
            
                INSERT  INTO exchange_rate
                        ( id_currency ,
                          id_relation_currency ,
                          date_rate ,
                          price ,
                          dattim1 ,
                          dattim2 ,
                          enabled
				        )
                VALUES  ( @id_currency ,
                          @id_relation_currency ,
                          @date_rate ,
                          @price ,
                          GETDATE() ,
                          @def_dattim2 ,
                          @def_enabled
				        )
            END
            
        IF @action = 'getExchangeRatesOnDate'
            BEGIN
                SELECT  c.name ,
                        c.sys_name ,
                        dbo.get_currency_price(c.sys_name, @date_rate) AS price ,
                        @date_rate AS date_price
                FROM    dbo.currency c
                WHERE   c.ENABLED = 1
                
            END
    END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[hp_exchange_rate] TO [sqlUnit_prog]
    AS [dbo];

