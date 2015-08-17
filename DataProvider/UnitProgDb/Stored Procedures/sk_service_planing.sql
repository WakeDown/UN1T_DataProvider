
-- =============================================
-- Author:		Anton Rekhov
-- Create date: 10.03.2014
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[sk_service_planing]
    @action NVARCHAR(50) ,
    @sp_test BIT = NULL --переменная для тестирования
    ,
    @id_user INT = NULL ,
    @id_contract INT = NULL ,
    @number NVARCHAR(150) = NULL ,
    @id_service_type INT = NULL ,
    @id_contract_type INT = NULL ,
    @id_contractor INT = NULL ,
    @id_contract_status INT = NULL ,
    @id_manager INT = NULL ,
    @id_creator INT = NULL ,
    @date_begin DATETIME = NULL ,
    @date_end DATETIME = NULL ,
    @is_close BIT = NULL ,
    @model NVARCHAR(150) = NULL ,
    @serial_num NVARCHAR(50) = NULL ,
    @speed DECIMAL = NULL ,
    @id_device_imprint INT = NULL ,
    @id_print_type INT = NULL ,
    @id_cartridge_type INT = NULL ,
    @counter INT = NULL ,
    @age INT = NULL ,
    @instalation_date DATETIME = NULL ,
    @id_device INT = NULL ,
    @id_service_interval INT = NULL ,
    @id_city INT = NULL ,
    @address NVARCHAR(250) = NULL ,
    @contact_name NVARCHAR(150) = NULL ,
    @comment NVARCHAR(MAX) = NULL ,
    @id_contract2devices INT = NULL ,
    @name NVARCHAR(150) = NULL ,
    @nickname NVARCHAR(100) = NULL ,
    @descr NVARCHAR(MAX) = NULL ,
    @order_num INT = NULL ,
    @id_device_option INT = NULL ,
    @id_device2option INT = NULL ,
    @id_service_action_type INT = NULL ,
    @id_service_zone INT = NULL ,
    @date_came DATETIME = NULL ,
    @id_service_came INT = NULL ,
    @claim_num NVARCHAR(12) = NULL ,
    @id_service_engeneer INT = NULL ,
    @id_service_zone2devices INT = NULL ,
    @id_service_zone2user INT = NULL ,
    @price DECIMAL(10, 2) = NULL ,
    @id_device_model INT = NULL , 
    --, @lst_id_device NVARCHAR(MAX) = NULL
    @planing_date DATETIME = NULL ,
    @id_service_claim INT = NULL ,
    @id_service_claim_status INT = NULL ,
    @id_device_type INT = NULL ,
    @vendor NVARCHAR(150) = NULL ,
    @id_service_admin INT = NULL ,
    @object_name NVARCHAR(150) = NULL ,
    @coord NVARCHAR(50) = NULL ,
    @id_zip_state INT = NULL ,
    @note NVARCHAR(150) = NULL ,
    @contractor_name NVARCHAR(250) = NULL ,
    @contractor_inn NVARCHAR(20) = NULL ,
    @counter_colour INT = NULL ,
    @id_service_claim_type INT = NULL ,
    @id_feature INT = NULL ,
    @tariff DECIMAL(10, 2) = NULL ,
    @inv_num NVARCHAR(50) = NULL ,
    @id_zip_group INT = NULL ,
    @id_contract_prolong INT = NULL ,
    @id_price_discount INT = NULL ,
    @id_srvpl_address INT = NULL ,
    @id_payment_tariff INT = NULL ,
    @id_user_role INT = NULL ,
    @id_user2user_role INT = NULL ,
    @period_reduction BIT = NULL ,
    @id_akt_scan INT = NULL ,
    @id_adder INT = NULL ,
    @date_cames_add DATETIME = NULL ,
    @file_name NVARCHAR(50) = NULL ,
    @full_path NVARCHAR(150) = NULL ,
    @cames_add BIT = NULL ,
    @date_month DATETIME = NULL ,
    @id_device_data INT = NULL ,
    @volume_counter INT = NULL ,
    @volume_counter_colour INT = NULL ,
    @handling_devices INT = NULL,
    @max_volume INT = NULL,
    @is_average BIT = NULL
AS
    BEGIN
        SET NOCOUNT ON;

	--<Переменные
        DECLARE @error_text NVARCHAR(MAX) ,
            @mail_text NVARCHAR(MAX) ,
            @id_program INT ,
            @var_int INT ,
            @log_params NVARCHAR(MAX) ,
            @log_descr NVARCHAR(MAX) ,
            @def_dattim2 DATETIME ,
            @def_enabled BIT ,
            @def_order_num INT ,
            @def_price DECIMAL(10, 2) ,
            @def_id_service_claim_status INT

	/****===DEFAULT VALUES===****/
        SET @def_dattim2 = '3.3.3333'
        SET @def_enabled = 1
        SET @def_order_num = 500
        SET @def_price = 0
        SELECT  @def_id_service_claim_status = id_service_claim_status
        FROM    dbo.srvpl_service_claim_statuses scs
        WHERE   scs.enabled = 1
                AND LOWER(scs.sysname) = LOWER('NEW')
    /*/>*/

	--/>
        IF @action NOT LIKE 'get%'
            BEGIN
		--<Сохраняем в лог список параметров
                SELECT TOP 1
                        @id_program = id_program
                FROM    programs p
                WHERE   p.enabled = 1
                        AND LOWER(p.sys_name) = LOWER('SERVICEPLANING')

                SELECT  @log_params = CASE WHEN @action IS NULL THEN ''
                                           ELSE ' @action='
                                                + CONVERT(NVARCHAR, @action)
                                      END + CASE WHEN @sp_test IS NULL THEN ''
                                                 ELSE ' @sp_test='
                                                      + CONVERT(NVARCHAR, @sp_test)
                                            END
                        + CASE WHEN @id_user IS NULL THEN ''
                               ELSE ' @id_user=' + CONVERT(NVARCHAR, @id_user)
                          END + CASE WHEN @id_contract IS NULL THEN ''
                                     ELSE ' @id_contract='
                                          + CONVERT(NVARCHAR, @id_contract)
                                END + CASE WHEN @number IS NULL THEN ''
                                           ELSE ' @number='
                                                + CONVERT(NVARCHAR, @number)
                                      END
                        + CASE WHEN @id_service_type IS NULL THEN ''
                               ELSE ' @id_service_type='
                                    + CONVERT(NVARCHAR, @id_service_type)
                          END + CASE WHEN @id_contract_type IS NULL THEN ''
                                     ELSE ' @id_contract_type='
                                          + CONVERT(NVARCHAR, @id_contract_type)
                                END + CASE WHEN @id_contractor IS NULL THEN ''
                                           ELSE ' @id_contractor='
                                                + CONVERT(NVARCHAR, @id_contractor)
                                      END
                        + CASE WHEN @id_contract_status IS NULL THEN ''
                               ELSE ' @id_contract_status='
                                    + CONVERT(NVARCHAR, @id_contract_status)
                          END + CASE WHEN @id_manager IS NULL THEN ''
                                     ELSE ' @id_manager='
                                          + CONVERT(NVARCHAR, @id_manager)
                                END + CASE WHEN @id_creator IS NULL THEN ''
                                           ELSE ' @id_creator='
                                                + CONVERT(NVARCHAR, @id_creator)
                                      END
                        + CASE WHEN @date_begin IS NULL THEN ''
                               ELSE ' @date_begin='
                                    + CONVERT(NVARCHAR, @date_begin)
                          END + CASE WHEN @date_end IS NULL THEN ''
                                     ELSE ' @date_end='
                                          + CONVERT(NVARCHAR, @date_end)
                                END + CASE WHEN @is_close IS NULL THEN ''
                                           ELSE ' @is_close='
                                                + CONVERT(NVARCHAR, @is_close)
                                      END + CASE WHEN @model IS NULL THEN ''
                                                 ELSE ' @model='
                                                      + CONVERT(NVARCHAR, @model)
                                            END
                        + CASE WHEN @serial_num IS NULL THEN ''
                               ELSE ' @serial_num='
                                    + CONVERT(NVARCHAR, @serial_num)
                          END + CASE WHEN @speed IS NULL THEN ''
                                     ELSE ' @speed='
                                          + CONVERT(NVARCHAR, @speed)
                                END
                        + CASE WHEN @id_device_imprint IS NULL THEN ''
                               ELSE ' @id_device_imprint='
                                    + CONVERT(NVARCHAR, @id_device_imprint)
                          END + CASE WHEN @id_print_type IS NULL THEN ''
                                     ELSE ' @id_print_type='
                                          + CONVERT(NVARCHAR, @id_print_type)
                                END
                        + CASE WHEN @id_cartridge_type IS NULL THEN ''
                               ELSE ' @id_cartridge_type='
                                    + CONVERT(NVARCHAR, @id_cartridge_type)
                          END + CASE WHEN @counter IS NULL THEN ''
                                     ELSE ' @counter='
                                          + CONVERT(NVARCHAR, @counter)
                                END + CASE WHEN @age IS NULL THEN ''
                                           ELSE ' @age='
                                                + CONVERT(NVARCHAR, @age)
                                      END
                        + CASE WHEN @instalation_date IS NULL THEN ''
                               ELSE ' @instalation_date='
                                    + CONVERT(NVARCHAR, @instalation_date)
                          END + CASE WHEN @id_device IS NULL THEN ''
                                     ELSE ' @id_device='
                                          + CONVERT(NVARCHAR, @id_device)
                                END
                        + CASE WHEN @id_service_interval IS NULL THEN ''
                               ELSE ' @id_service_interval='
                                    + CONVERT(NVARCHAR, @id_service_interval)
                          END + CASE WHEN @id_city IS NULL THEN ''
                                     ELSE ' @id_city='
                                          + CONVERT(NVARCHAR, @id_city)
                                END + CASE WHEN @address IS NULL THEN ''
                                           ELSE ' @address='
                                                + CONVERT(NVARCHAR, @address)
                                      END
                        + CASE WHEN @contact_name IS NULL THEN ''
                               ELSE ' @contact_name='
                                    + CONVERT(NVARCHAR, @contact_name)
                          END + CASE WHEN @comment IS NULL THEN ''
                                     ELSE ' @comment='
                                          + CONVERT(NVARCHAR, @comment)
                                END
                        + CASE WHEN @id_contract2devices IS NULL THEN ''
                               ELSE ' @id_contract2devices='
                                    + CONVERT(NVARCHAR, @id_contract2devices)
                          END + CASE WHEN @name IS NULL THEN ''
                                     ELSE ' @name=' + CONVERT(NVARCHAR, @name)
                                END + CASE WHEN @nickname IS NULL THEN ''
                                           ELSE ' @nickname='
                                                + CONVERT(NVARCHAR, @nickname)
                                      END + CASE WHEN @descr IS NULL THEN ''
                                                 ELSE ' @descr='
                                                      + CONVERT(NVARCHAR, @descr)
                                            END
                        + CASE WHEN @order_num IS NULL THEN ''
                               ELSE ' @order_num='
                                    + CONVERT(NVARCHAR, @order_num)
                          END + CASE WHEN @id_device_option IS NULL THEN ''
                                     ELSE ' @id_device_option='
                                          + CONVERT(NVARCHAR, @id_device_option)
                                END
                        + CASE WHEN @id_device2option IS NULL THEN ''
                               ELSE ' @id_device2option='
                                    + CONVERT(NVARCHAR, @id_device2option)
                          END
                        + CASE WHEN @id_service_action_type IS NULL THEN ''
                               ELSE ' @id_service_action_type='
                                    + CONVERT(NVARCHAR, @id_service_action_type)
                          END + CASE WHEN @id_service_zone IS NULL THEN ''
                                     ELSE ' @id_service_zone='
                                          + CONVERT(NVARCHAR, @id_service_zone)
                                END + CASE WHEN @date_came IS NULL THEN ''
                                           ELSE ' @date_came='
                                                + CONVERT(NVARCHAR, @date_came)
                                      END
                        + CASE WHEN @id_service_came IS NULL THEN ''
                               ELSE ' @id_service_came='
                                    + CONVERT(NVARCHAR, @id_service_came)
                          END + CASE WHEN @claim_num IS NULL THEN ''
                                     ELSE ' @claim_num='
                                          + CONVERT(NVARCHAR, @claim_num)
                                END
                        + CASE WHEN @id_service_engeneer IS NULL THEN ''
                               ELSE ' @id_service_engeneer='
                                    + CONVERT(NVARCHAR, @id_service_engeneer)
                          END
                        + CASE WHEN @id_service_zone2devices IS NULL THEN ''
                               ELSE ' @id_service_zone2devices='
                                    + CONVERT(NVARCHAR, @id_service_zone2devices)
                          END
                        + CASE WHEN @id_service_zone2user IS NULL THEN ''
                               ELSE ' @id_service_zone2user='
                                    + CONVERT(NVARCHAR, @id_service_zone2user)
                          END + CASE WHEN @price IS NULL THEN ''
                                     ELSE ' @price='
                                          + CONVERT(NVARCHAR, @price)
                                END
                        + CASE WHEN @id_device_model IS NULL THEN ''
                               ELSE ' @id_device_model='
                                    + CONVERT(NVARCHAR, @id_device_model)
                          END
                          
                          /*+ CASE WHEN @lst_id_device IS NULL THEN ''
                                           ELSE ' @lst_id_device='
                                                + CONVERT(NVARCHAR(MAX), @lst_id_device)
                                      END*/
                        + CASE WHEN @planing_date IS NULL THEN ''
                               ELSE ' @planing_date='
                                    + CONVERT(NVARCHAR(MAX), @planing_date)
                          END + CASE WHEN @id_service_claim IS NULL THEN ''
                                     ELSE ' @id_service_claim='
                                          + CONVERT(NVARCHAR(MAX), @id_service_claim)
                                END
                        + CASE WHEN @id_service_claim_status IS NULL THEN ''
                               ELSE ' @id_service_claim_status='
                                    + CONVERT(NVARCHAR(MAX), @id_service_claim_status)
                          END + CASE WHEN @id_device_type IS NULL THEN ''
                                     ELSE ' @id_device_type='
                                          + CONVERT(NVARCHAR(MAX), @id_device_type)
                                END + CASE WHEN @vendor IS NULL THEN ''
                                           ELSE ' @vendor='
                                                + CONVERT(NVARCHAR(MAX), @vendor)
                                      END
                        + CASE WHEN @id_service_admin IS NULL THEN ''
                               ELSE ' @id_service_admin='
                                    + CONVERT(NVARCHAR(MAX), @id_service_admin)
                          END + CASE WHEN @object_name IS NULL THEN ''
                                     ELSE ' @object_name='
                                          + CONVERT(NVARCHAR(MAX), @object_name)
                                END + CASE WHEN @coord IS NULL THEN ''
                                           ELSE ' @coord='
                                                + CONVERT(NVARCHAR(MAX), @coord)
                                      END
                        + CASE WHEN @id_zip_state IS NULL THEN ''
                               ELSE ' @id_zip_state='
                                    + CONVERT(NVARCHAR(MAX), @id_zip_state)
                          END + CASE WHEN @note IS NULL THEN ''
                                     ELSE ' @note='
                                          + CONVERT(NVARCHAR(MAX), @note)
                                END
                        + CASE WHEN @contractor_name IS NULL THEN ''
                               ELSE ' @contractor_name='
                                    + CONVERT(NVARCHAR(MAX), @contractor_name)
                          END + CASE WHEN @contractor_inn IS NULL THEN ''
                                     ELSE ' @contractor_inn='
                                          + CONVERT(NVARCHAR(MAX), @contractor_inn)
                                END
                        + CASE WHEN @counter_colour IS NULL THEN ''
                               ELSE ' @counter_colour='
                                    + CONVERT(NVARCHAR(MAX), @counter_colour)
                          END
                        + CASE WHEN @id_service_claim_type IS NULL THEN ''
                               ELSE ' @id_service_claim_type='
                                    + CONVERT(NVARCHAR(MAX), @id_service_claim_type)
                          END + CASE WHEN @id_feature IS NULL THEN ''
                                     ELSE ' @id_feature='
                                          + CONVERT(NVARCHAR(MAX), @id_feature)
                                END + CASE WHEN @tariff IS NULL THEN ''
                                           ELSE ' @tariff='
                                                + CONVERT(NVARCHAR(MAX), @tariff)
                                      END + CASE WHEN @inv_num IS NULL THEN ''
                                                 ELSE ' @inv_num='
                                                      + CONVERT(NVARCHAR(MAX), @inv_num)
                                            END
                        + CASE WHEN @id_zip_group IS NULL THEN ''
                               ELSE ' @id_zip_group='
                                    + CONVERT(NVARCHAR(MAX), @id_zip_group)
                          END + CASE WHEN @id_contract_prolong IS NULL THEN ''
                                     ELSE ' @id_contract_prolong='
                                          + CONVERT(NVARCHAR(MAX), @id_contract_prolong)
                                END
                        + CASE WHEN @id_price_discount IS NULL THEN ''
                               ELSE ' @id_price_discount='
                                    + CONVERT(NVARCHAR(MAX), @id_price_discount)
                          END + CASE WHEN @id_srvpl_address IS NULL THEN ''
                                     ELSE ' @id_srvpl_address='
                                          + CONVERT(NVARCHAR(MAX), @id_srvpl_address)
                                END
                        + CASE WHEN @id_payment_tariff IS NULL THEN ''
                               ELSE ' @id_payment_tariff='
                                    + CONVERT(NVARCHAR(MAX), @id_payment_tariff)
                          END + CASE WHEN @id_user_role IS NULL THEN ''
                                     ELSE ' @id_user_role='
                                          + CONVERT(NVARCHAR(MAX), @id_user_role)
                                END
                        + CASE WHEN @id_user2user_role IS NULL THEN ''
                               ELSE ' @id_user2user_role='
                                    + CONVERT(NVARCHAR(MAX), @id_user2user_role)
                          END + CASE WHEN @period_reduction IS NULL THEN ''
                                     ELSE ' @period_reduction='
                                          + CONVERT(NVARCHAR(MAX), @period_reduction)
                                END + CASE WHEN @id_akt_scan IS NULL THEN ''
                                           ELSE ' @id_akt_scan='
                                                + CONVERT(NVARCHAR(MAX), @id_akt_scan)
                                      END
                        + CASE WHEN @id_adder IS NULL THEN ''
                               ELSE ' @id_adder='
                                    + CONVERT(NVARCHAR(MAX), @id_adder)
                          END + CASE WHEN @date_cames_add IS NULL THEN ''
                                     ELSE ' @date_cames_add ='
                                          + CONVERT(NVARCHAR(MAX), @date_cames_add)
                                END + CASE WHEN @file_name IS NULL THEN ''
                                           ELSE ' @file_name  ='
                                                + CONVERT(NVARCHAR(MAX), @file_name)
                                      END
                        + CASE WHEN @full_path IS NULL THEN ''
                               ELSE ' @full_path='
                                    + CONVERT(NVARCHAR(MAX), @full_path)
                          END + CASE WHEN @cames_add IS NULL THEN ''
                                     ELSE ' @cames_add='
                                          + CONVERT(NVARCHAR(MAX), @cames_add)
                                END + CASE WHEN @date_month IS NULL THEN ''
                                           ELSE ' @date_month='
                                                + CONVERT(NVARCHAR(MAX), @date_month)
                                      END
                        + CASE WHEN @id_device_data IS NULL THEN ''
                               ELSE ' @id_device_data='
                                    + CONVERT(NVARCHAR(MAX), @id_device_data)
                          END + CASE WHEN @volume_counter IS NULL THEN ''
                                     ELSE ' @volume_counter='
                                          + CONVERT(NVARCHAR(MAX), @volume_counter)
                                END
                        + CASE WHEN @volume_counter_colour IS NULL THEN ''
                               ELSE ' @volume_counter='
                                    + CONVERT(NVARCHAR(MAX), @volume_counter_colour)
                          END + CASE WHEN @handling_devices IS NULL THEN ''
                                     ELSE ' @handling_devices='
                                          + CONVERT(NVARCHAR(MAX), @handling_devices)
                                END + CASE WHEN @max_volume IS NULL THEN ''
                                     ELSE ' @max_volume='
                                          + CONVERT(NVARCHAR(MAX), @max_volume)
                                END + CASE WHEN @is_average IS NULL THEN ''
                                     ELSE ' @is_average='
                                          + CONVERT(NVARCHAR(MAX), @is_average)
                                END

                EXEC sk_log @action = 'insLog',
                    @proc_name = 'sk_service_planing',
                    @id_program = @id_program, @params = @log_params,
                    @descr = @log_descr
			--/>
            END

	--=================================
	--Contracts
	--=================================	
        IF @action = 'insContract'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                SELECT  @price = ISNULL(@price, @def_price)
		
                INSERT  INTO dbo.srvpl_contracts
                        ( number ,
                          id_service_type ,
                          id_contract_type ,
                          id_contractor ,
                          id_contract_status ,
                          id_manager ,
                          date_begin ,
                          date_end ,
                          price ,
                          id_creator ,
                          dattim1 ,
                          dattim2 ,
                          enabled ,
                          old_id_contract ,
                          id_zip_state ,
                          note ,
                          contractor_name ,
                          contractor_inn ,
                          id_contract_prolong ,
                          id_price_discount ,
                          handling_devices
		                )
                VALUES  ( @number ,
                          @id_service_type , -- id_service_type - int
                          @id_contract_type , -- id_contract_type - int
                          @id_contractor , -- id_contractor - int
                          @id_contract_status , -- id_contract_status - int
                          @id_manager , -- id_manager - int
                          @date_begin , -- date_begin - datetime
                          @date_end , -- date_end - datetime                          
                          @price , -- price - decimal(10, 2)
                          @id_creator , -- id_creator - int
                          GETDATE() , -- dattim1 - datetime
                          @def_dattim2 , -- dattim2 - datetime
                          @def_enabled , -- enabled - bit
                          NULL , -- old_id_contract - int
                          @id_zip_state ,
                          @note ,
                          @contractor_name ,
                          @contractor_inn ,
                          @id_contract_prolong ,
                          @id_price_discount ,
                          @handling_devices
		                )
		        
                SELECT  @id_contract = @@IDENTITY
		        
                RETURN @id_contract
            END
        ELSE
            IF @action = 'updContract'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                
                --Храним историю
                    INSERT  INTO dbo.srvpl_contracts
                            ( number ,
                              id_service_type ,
                              id_contract_type ,
                              id_contractor ,
                              id_contract_status ,
                              id_manager ,
                              date_begin ,
                              date_end ,
                              price ,
                              id_creator ,
                              dattim1 ,
                              dattim2 ,
                              enabled ,
                              old_id_contract ,
                              id_zip_state ,
                              note ,
                              contractor_name ,
                              contractor_inn ,
                              id_contract_prolong ,
                              id_price_discount ,
                              period_reduction ,
                              handling_devices
		                    )
                            SELECT  number ,
                                    id_service_type ,
                                    id_contract_type ,
                                    id_contractor ,
                                    id_contract_status ,
                                    id_manager ,
                                    date_begin ,
                                    date_end ,
                                    price ,
                                    id_creator ,
                                    dattim1 ,
                                    GETDATE() ,
                                    0 ,
                                    id_contract ,
                                    id_zip_state ,
                                    note ,
                                    contractor_name ,
                                    contractor_inn ,
                                    id_contract_prolong ,
                                    id_price_discount ,
                                    period_reduction ,
                                    handling_devices
                            FROM    dbo.srvpl_contracts c
                            WHERE   c.id_contract = @id_contract
					
                    SELECT  @number = ISNULL(@number,
                                             ( SELECT   number
                                               FROM     srvpl_contracts c
                                               WHERE    c.id_contract = @id_contract
                                             ))
					
                    SELECT  @id_service_type = ISNULL(@id_service_type,
                                                      ( SELECT
                                                              id_service_type
                                                        FROM  srvpl_contracts c
                                                        WHERE c.id_contract = @id_contract
                                                      ))
                    SELECT  @id_contract_type = ISNULL(@id_contract_type,
                                                       ( SELECT
                                                              id_contract_type
                                                         FROM srvpl_contracts c
                                                         WHERE
                                                              c.id_contract = @id_contract
                                                       ))
                    SELECT  @id_contractor = ISNULL(@id_contractor,
                                                    ( SELECT  id_contractor
                                                      FROM    srvpl_contracts c
                                                      WHERE   c.id_contract = @id_contract
                                                    ))
                    SELECT  @id_contract_status = ISNULL(@id_contract_status,
                                                         ( SELECT
                                                              id_contract_status
                                                           FROM
                                                              srvpl_contracts c
                                                           WHERE
                                                              c.id_contract = @id_contract
                                                         ))
						
                    SELECT  @id_manager = ISNULL(@id_manager,
                                                 ( SELECT   id_manager
                                                   FROM     srvpl_contracts c
                                                   WHERE    c.id_contract = @id_contract
                                                 ))
                                                 
                    SELECT  @date_begin = ISNULL(@date_begin,
                                                 ( SELECT   date_begin
                                                   FROM     srvpl_contracts c
                                                   WHERE    c.id_contract = @id_contract
                                                 ))
                    SELECT  @date_end = ISNULL(@date_end,
                                               ( SELECT date_end
                                                 FROM   srvpl_contracts c
                                                 WHERE  c.id_contract = @id_contract
                                               ))
                         
                                               
                                               
                    SELECT  @price = ISNULL(@price,
                                            ( SELECT    price
                                              FROM      srvpl_contracts c
                                              WHERE     c.id_contract = @id_contract
                                            ))                           
                    SELECT  @id_creator = ISNULL(@id_creator,
                                                 ( SELECT   id_creator
                                                   FROM     srvpl_contracts c
                                                   WHERE    c.id_contract = @id_contract
                                                 ))
                                                 
                    SELECT  @id_zip_state = ISNULL(@id_zip_state,
                                                   ( SELECT id_zip_state
                                                     FROM   srvpl_contracts c
                                                     WHERE  c.id_contract = @id_contract
                                                   ))
                                                 
                    SELECT  @note = ISNULL(@note,
                                           ( SELECT note
                                             FROM   srvpl_contracts c
                                             WHERE  c.id_contract = @id_contract
                                           ))
                    SELECT  @contractor_name = ISNULL(@contractor_name,
                                                      ( SELECT
                                                              contractor_name
                                                        FROM  srvpl_contracts c
                                                        WHERE c.id_contract = @id_contract
                                                      ))
                    SELECT  @contractor_inn = ISNULL(@contractor_inn,
                                                     ( SELECT contractor_inn
                                                       FROM   srvpl_contracts c
                                                       WHERE  c.id_contract = @id_contract
                                                     ))
                    SELECT  @id_contract_prolong = ISNULL(@id_contract_prolong,
                                                          ( SELECT
                                                              id_contract_prolong
                                                            FROM
                                                              srvpl_contracts c
                                                            WHERE
                                                              c.id_contract = @id_contract
                                                          ))                                
                    SELECT  @id_price_discount = ISNULL(@id_price_discount,
                                                        ( SELECT
                                                              id_price_discount
                                                          FROM
                                                              srvpl_contracts c
                                                          WHERE
                                                              c.id_contract = @id_contract
                                                        ))       
                    SELECT  @period_reduction = ISNULL(@period_reduction,
                                                       ( SELECT
                                                              period_reduction
                                                         FROM srvpl_contracts c
                                                         WHERE
                                                              c.id_contract = @id_contract
                                                       ))  
                                                       
                    SELECT  @handling_devices = ISNULL(@handling_devices,
                                                       ( SELECT
                                                              handling_devices
                                                         FROM srvpl_contracts c
                                                         WHERE
                                                              c.id_contract = @id_contract
                                                       ))
                                                       
                     IF       @handling_devices = -999
                     BEGIN
						SET @handling_devices = NULL
                     
                     end 
					
					--Скрываем запись
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.srvpl_contracts
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0 ,
                                    id_creator = @id_creator
                            WHERE   id_contract = @id_contract
                            
                            RETURN @id_contract
                        END
                        
                    UPDATE  dbo.srvpl_contracts
                    SET     number = @number ,
                            id_service_type = @id_service_type ,
                            id_contract_type = @id_contract_type ,
                            id_contractor = @id_contractor ,
                            id_contract_status = @id_contract_status ,
                            id_manager = @id_manager ,
                            date_begin = @date_begin ,
                            date_end = @date_end ,
                            price = @price ,
                            id_creator = @id_creator ,
                            id_zip_state = @id_zip_state ,
                            note = @note ,
                            contractor_name = @contractor_name ,
                            contractor_inn = @contractor_inn ,
                            id_contract_prolong = @id_contract_prolong ,
                            id_price_discount = @id_price_discount ,
                            period_reduction = @period_reduction ,
                            handling_devices = @handling_devices
                    WHERE   id_contract = @id_contract
                    
                    
                        
                    RETURN @id_contract
                END
        IF @action = 'closeContract'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
            
                EXEC dbo.sk_service_planing @action = N'updContract',
                    @id_contract = @id_contract, @id_creator = @id_creator,
                    @is_close = 1				
            END
	
	--=================================
	--Devices
	--=================================	
        IF @action = 'insDevice'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
				
                INSERT  INTO dbo.srvpl_devices
                        ( id_device_model ,
                          serial_num ,
                          --speed ,
                          --id_device_imprint ,
                          --id_print_type ,
                          --id_cartridge_type ,
                          counter ,
                          age ,
                          instalation_date ,
                          dattim1 ,
                          dattim2 ,
                          id_creator ,
                          enabled ,
                          old_id_device ,
                          tariff ,
                          inv_num ,
                          counter_colour
		                )
                VALUES  ( @id_device_model , -- model - nvarchar(150)
                          @serial_num , -- serial_num - nvarchar(50)
                          --@speed , -- speed - decimal
                          --@id_device_imprint , -- id_device_imprint - int
                          --@id_print_type , -- id_print_type - int
                          --@id_cartridge_type , -- id_cartridge_type - int
                          @counter , -- counter - int
                          @age , -- age - int
                          @instalation_date , -- instalation_date - datetime
                          GETDATE() , -- dattim1 - datetime
                          @def_dattim2 , -- dattim2 - datetime
                          @id_creator , -- id_creator - int
                          @def_enabled , -- enabled - bit
                          NULL , -- old_id_device - int
                          @tariff ,
                          @inv_num ,
                          @counter_colour
		                )
		                
                SELECT  @id_device = @@IDENTITY
		        
                RETURN @id_device
            END
        ELSE
            IF @action = 'updDevice'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
		
                    INSERT  INTO dbo.srvpl_devices
                            ( id_device_model ,
                              serial_num ,
                              /*speed ,
                              id_device_imprint ,
                              id_print_type ,
                              id_cartridge_type ,*/
                              counter ,
                              age ,
                              instalation_date ,
                              dattim1 ,
                              dattim2 ,
                              id_creator ,
                              enabled ,
                              old_id_device ,
                              tariff ,
                              inv_num ,
                              counter_colour
		                    )
                            SELECT  id_device_model ,
                                    serial_num ,
                                    /*speed ,
                                    id_device_imprint ,
                                    id_print_type ,
                                    id_cartridge_type ,*/
                                    counter ,
                                    age ,
                                    instalation_date ,
                                    dattim1 ,
                                    GETDATE() ,
                                    id_creator ,
                                    0 ,
                                    id_device ,
                                    tariff ,
                                    inv_num ,
                                    counter_colour
                            FROM    dbo.srvpl_devices d
                            WHERE   d.id_device = @id_device
                
                    SELECT  @id_device_model = ISNULL(@id_device_model,
                                                      ( SELECT
                                                              id_device_model
                                                        FROM  dbo.srvpl_devices d
                                                        WHERE d.id_device = @id_device
                                                      ))
                                                 
                    SELECT  @serial_num = ISNULL(@serial_num,
                                                 ( SELECT   serial_num
                                                   FROM     dbo.srvpl_devices d
                                                   WHERE    d.id_device = @id_device
                                                 ))
                                                 
                                                                     
                    SELECT  @counter = ISNULL(@counter,
                                              ( SELECT  counter
                                                FROM    dbo.srvpl_devices d
                                                WHERE   d.id_device = @id_device
                                              ))
                    SELECT  @age = ISNULL(@age,
                                          ( SELECT  age
                                            FROM    dbo.srvpl_devices d
                                            WHERE   d.id_device = @id_device
                                          ))
                                          
                    SELECT  @instalation_date = ISNULL(@instalation_date,
                                                       ( SELECT
                                                              instalation_date
                                                         FROM dbo.srvpl_devices d
                                                         WHERE
                                                              d.id_device = @id_device
                                                       ))
                                                 
                    SELECT  @id_creator = ISNULL(@id_creator,
                                                 ( SELECT   id_creator
                                                   FROM     dbo.srvpl_devices d
                                                   WHERE    d.id_device = @id_device
                                                 ))
                                                 
                    SELECT  @tariff = ISNULL(@tariff,
                                             ( SELECT   tariff
                                               FROM     dbo.srvpl_devices d
                                               WHERE    d.id_device = @id_device
                                             ))
                    SELECT  @inv_num = ISNULL(@inv_num,
                                              ( SELECT  inv_num
                                                FROM    dbo.srvpl_devices d
                                                WHERE   d.id_device = @id_device
                                              ))
                                                 
                    SELECT  @counter_colour = ISNULL(@counter_colour,
                                                     ( SELECT counter_colour
                                                       FROM   dbo.srvpl_devices d
                                                       WHERE  d.id_device = @id_device
                                                     ))
                                                 
                                                 
                                                 --Скрытие записи
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.srvpl_devices
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0 ,
                                    id_creator = @id_creator
                            WHERE   id_device = @id_device
                            
                            RETURN @id_device
                        END
                               
                               --Не обновляем счетчики так как информация хранится в отдельной таблице srvpl_Device_data
                                                 
                    UPDATE  dbo.srvpl_devices
                    SET     id_device_model = @id_device_model ,
                            serial_num = @serial_num ,
                            inv_num = @inv_num ,
                            /*speed = @speed ,
                            id_device_imprint = @id_device_imprint ,
                            id_print_type = @id_print_type ,
                            id_cartridge_type = @id_cartridge_type ,*/
                            --counter = @counter ,
                            age = @age ,
                            instalation_date = @instalation_date ,
                            id_creator = @id_creator ,
                            tariff = @tariff --,
                            --counter_colour = @counter_colour
                    WHERE   id_device = @id_device
                
                    RETURN @id_device
                END
            ELSE
                IF @action = 'closeDevice'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                    
                        EXEC dbo.sk_service_planing @action = N'updDevice',
                            @id_device = @id_device, @id_creator = @id_creator,
                            @is_close = 1
					                
                    END
                  
    --=================================
	--DeviceData 
	--=================================	  
        IF @action = 'insDeviceData'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
				
				IF @is_average IS NULL
				BEGIN
					SET @is_average = 0
					END
				
                INSERT  INTO dbo.srvpl_device_data
                        ( id_device ,
                          counter ,
                          counter_colour ,
                          date_month ,
                          dattim1 ,
                          enabled ,
                          id_contract ,
                          volume_counter ,
                          volume_counter_colour,
                          is_average                 
		                )
                VALUES  ( @id_device ,
                          @counter ,
                          @counter_colour ,
                          @date_month ,
                          GETDATE() ,
                          @def_enabled ,
                          @id_contract ,
                          @volume_counter ,
                          @volume_counter_colour,
                          @is_average
		                )
		        
            END
        ELSE
            IF @action = 'updDeviceData'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                        
                    --SELECT  @id_device = ISNULL(@id_device,
                    --                            ( SELECT    id_device
                    --                              FROM      dbo.srvpl_device_data d
                    --                              WHERE     d.id_device_data = @id_device_data
                    --                            ))
                                                 
                    SELECT  @counter = ISNULL(@counter,
                                              ( SELECT  counter
                                                FROM    dbo.srvpl_device_data d
                                                WHERE   d.id_device_data = @id_device_data
                                              ))
                    SELECT  @counter_colour = ISNULL(@counter_colour,
                                                     ( SELECT counter_colour
                                                       FROM   dbo.srvpl_device_data d
                                                       WHERE  d.id_device_data = @id_device_data
                                                     ))
                    SELECT  @date_month = ISNULL(@date_month,
                                                 ( SELECT   date_month
                                                   FROM     dbo.srvpl_device_data d
                                                   WHERE    d.id_device_data = @id_device_data
                                                 ))
                    
                    SELECT  @volume_counter = ISNULL(@volume_counter,
                                                     ( SELECT volume_counter
                                                       FROM   dbo.srvpl_device_data d
                                                       WHERE  d.id_device_data = @id_device_data
                                                     ))
                                                     
                    SELECT  @volume_counter_colour = ISNULL(@volume_counter_colour,
                                                            ( SELECT
                                                              volume_counter_colour
                                                              FROM
                                                              dbo.srvpl_device_data d
                                                              WHERE
                                                              d.id_device_data = @id_device_data
                                                            ))
                                                            
                                                            SELECT @is_average =  ISNULL(@is_average,
                                                            ( SELECT
                                                              is_average
                                                              FROM
                                                              dbo.srvpl_device_data d
                                                              WHERE
                                                              d.id_device_data = @id_device_data
                                                            ))
                                                 
                    UPDATE  dbo.srvpl_device_data
                    SET     --id_device = @id_device ,
                            counter = @counter ,
                            counter_colour = @counter_colour ,
                            date_month = @date_month ,
                            volume_counter = @volume_counter ,
                            volume_counter_colour = @volume_counter_colour,
                            is_average = @is_average
                    WHERE   id_device_data = @id_device_data
                END
            ELSE               
                    
                    
    --=================================
	--Contract2Devices 
	--=================================	
                IF @action = 'insContract2Devices'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                    
                        INSERT  INTO dbo.srvpl_contract2devices
                                ( id_contract ,
                                  id_device ,
                                  id_service_interval ,
                                  id_city ,
                                  address ,
                                  contact_name ,
                                  comment ,
                                  id_creator ,
                                  dattim1 ,
                                  dattim2 ,
                                  enabled ,
                                  id_service_admin ,
                                  [object_name] ,
                                  coord
                                )
                        VALUES  ( @id_contract , -- id_contract - int
                                  @id_device , -- id_device - int
                                  @id_service_interval , -- id_service_interval - int
                                  @id_city , -- id_city - int
                                  @address , -- address - nvarchar(250)
                                  @contact_name , -- contact_name - nvarchar(150)
                                  @comment , -- comment - nvarchar(max)
                                  @id_creator ,
                                  GETDATE() , -- dattim1 - datetime
                                  @def_dattim2 , -- dattim2 - datetime
                                  @def_enabled ,-- enabled - bit
                                  @id_service_admin ,
                                  @object_name ,
                                  @coord
                                )
                        
                        SELECT  @id_contract2devices = @@IDENTITY
		        
                        RETURN @id_contract2devices
                    END
                ELSE
                    IF @action = 'updContract2Devices'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END
                        
                            INSERT  INTO dbo.srvpl_contract2devices
                                    ( id_contract ,
                                      id_device ,
                                      id_service_interval ,
                                      id_city ,
                                      address ,
                                      contact_name ,
                                      comment ,
                                      id_service_admin ,
                                      [object_name] ,
                                      coordinates ,
                                      coord ,
                                      dattim1 ,
                                      dattim2 ,
                                      id_creator ,
                                      enabled ,
                                      old_id_contract2devices
		                            )
                                    SELECT  id_contract ,
                                            id_device ,
                                            id_service_interval ,
                                            id_city ,
                                            address ,
                                            contact_name ,
                                            comment ,
                                            id_service_admin ,
                                            [object_name] ,
                                            coordinates ,
                                            coord ,
                                            dattim1 ,
                                            GETDATE() ,
                                            id_creator ,
                                            0 ,
                                            id_contract2devices
                                    FROM    dbo.srvpl_contract2devices c2d
                                    WHERE   id_contract2devices = @id_contract2devices  
					
                            IF @id_contract = 0
                                BEGIN
                                    SET @id_contract = NULL
                                END
					
                            SELECT  @id_contract = ISNULL(@id_contract,
                                                          ( SELECT
                                                              id_contract
                                                            FROM
                                                              dbo.srvpl_contract2devices t
                                                            WHERE
                                                              t.id_contract2devices = @id_contract2devices
                                                          ))
					
                            SELECT  @id_device = ISNULL(@id_device,
                                                        ( SELECT
                                                              id_device
                                                          FROM
                                                              dbo.srvpl_contract2devices t
                                                          WHERE
                                                              t.id_contract2devices = @id_contract2devices
                                                        ))
                                                 
                            SELECT  @id_service_interval = ISNULL(@id_service_interval,
                                                              ( SELECT
                                                              id_service_interval
                                                              FROM
                                                              dbo.srvpl_contract2devices t
                                                              WHERE
                                                              t.id_contract2devices = @id_contract2devices
                                                              ))
                                                 
                            SELECT  @id_city = ISNULL(@id_city,
                                                      ( SELECT
                                                              id_city
                                                        FROM  dbo.srvpl_contract2devices t
                                                        WHERE t.id_contract2devices = @id_contract2devices
                                                      ))
                                                 
                            SELECT  @address = ISNULL(@address,
                                                      ( SELECT
                                                              address
                                                        FROM  dbo.srvpl_contract2devices t
                                                        WHERE t.id_contract2devices = @id_contract2devices
                                                      ))
                                                 
                            SELECT  @contact_name = ISNULL(@contact_name,
                                                           ( SELECT
                                                              contact_name
                                                             FROM
                                                              dbo.srvpl_contract2devices t
                                                             WHERE
                                                              t.id_contract2devices = @id_contract2devices
                                                           ))
                                                 
                            SELECT  @comment = ISNULL(@comment,
                                                      ( SELECT
                                                              comment
                                                        FROM  dbo.srvpl_contract2devices t
                                                        WHERE t.id_contract2devices = @id_contract2devices
                                                      ))
                                                 
                            SELECT  @id_creator = ISNULL(@id_creator,
                                                         ( SELECT
                                                              id_creator
                                                           FROM
                                                              dbo.srvpl_contract2devices t
                                                           WHERE
                                                              t.id_contract2devices = @id_contract2devices
                                                         ))
                                                 
                            SELECT  @id_service_admin = ISNULL(@id_service_admin,
                                                              ( SELECT
                                                              id_service_admin
                                                              FROM
                                                              dbo.srvpl_contract2devices t
                                                              WHERE
                                                              t.id_contract2devices = @id_contract2devices
                                                              ))
                            SELECT  @object_name = ISNULL(@object_name,
                                                          ( SELECT
                                                              [object_name]
                                                            FROM
                                                              dbo.srvpl_contract2devices t
                                                            WHERE
                                                              t.id_contract2devices = @id_contract2devices
                                                          ))
                            SELECT  @coord = ISNULL(@coord,
                                                    ( SELECT  coord
                                                      FROM    dbo.srvpl_contract2devices t
                                                      WHERE   t.id_contract2devices = @id_contract2devices
                                                    ))
                          
                            IF @is_close = 1
                                BEGIN
                                    UPDATE  dbo.srvpl_contract2devices
                                    SET     dattim2 = GETDATE() ,
                                            enabled = 0
                                --id_creator = @id_creator                                
                                    WHERE   id_contract2devices = @id_contract2devices  
                            
                                END 
                                                 
                            UPDATE  dbo.srvpl_contract2devices
                            SET     id_contract = @id_contract ,
                                    id_device = @id_device ,
                                    id_service_interval = @id_service_interval ,
                                    id_city = @id_city ,
                                    address = @address ,
                                    contact_name = @contact_name ,
                                    comment = @comment ,
                            --id_creator = @id_creator
                                    id_service_admin = @id_service_admin ,
                                    [object_name] = @object_name ,
                                    coord = @coord
                            WHERE   id_contract2devices = @id_contract2devices    
                    
                            RETURN @id_contract2devices       
                        END
                    ELSE
                        IF @action = 'closeContract2Devices'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END
                  
                                EXEC dbo.sk_service_planing @action = N'updContract2Devices',
                                    @id_contract2devices = @id_contract2devices,
                                    @is_close = 1, @id_creator = @id_creator         
                            END
    
    --=================================
	--DeviceModels
	--=================================	
        IF @action = 'insDeviceModel'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
				
                SELECT  @nickname = ISNULL(@nickname, @name)
				
                INSERT  INTO dbo.srvpl_device_models
                        ( vendor ,
                          name ,
                          nickname ,
                          enabled ,
                          dattim1 ,
                          dattim2 ,
                          speed ,
                          id_device_type ,
                          id_device_imprint ,
                          id_cartridge_type ,
                          id_print_type,
                          max_volume
		                )
                VALUES  ( @vendor ,
                          @name , -- name - nvarchar(150)
                          @nickname , -- nickname - nvarchar(100)
                          @def_enabled , -- enabled - bit
                          GETDATE() , -- dattim1 - datetime
                          @def_dattim2 , -- dattim2 - datetime
                          @speed ,
                          @id_device_type ,
                          @id_device_imprint ,
                          @id_cartridge_type ,
                          @id_print_type,
                          @max_volume
		                )
            END
        ELSE
            IF @action = 'updDeviceModel'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
					
                    SELECT  @vendor = ISNULL(@vendor,
                                             ( SELECT   vendor
                                               FROM     dbo.srvpl_device_models t
                                               WHERE    t.id_device_model = @id_device_model
                                             ))
					
                    SELECT  @name = ISNULL(@name,
                                           ( SELECT name
                                             FROM   dbo.srvpl_device_models t
                                             WHERE  t.id_device_model = @id_device_model
                                           ))
                                                 
                    SELECT  @nickname = ISNULL(@nickname,
                                               ( SELECT nickname
                                                 FROM   dbo.srvpl_device_models t
                                                 WHERE  t.id_device_model = @id_device_model
                                               ))
                    SELECT  @speed = ISNULL(@speed,
                                            ( SELECT    speed
                                              FROM      dbo.srvpl_device_models t
                                              WHERE     t.id_device_model = @id_device_model
                                            ))
                    SELECT  @id_device_type = ISNULL(@id_device_type,
                                                     ( SELECT id_device_type
                                                       FROM   dbo.srvpl_device_models t
                                                       WHERE  t.id_device_model = @id_device_model
                                                     ))
                    SELECT  @id_device_imprint = ISNULL(@id_device_imprint,
                                                        ( SELECT
                                                              id_device_imprint
                                                          FROM
                                                              dbo.srvpl_device_models t
                                                          WHERE
                                                              t.id_device_model = @id_device_model
                                                        ))
                                          
                    SELECT  @id_print_type = ISNULL(@id_print_type,
                                                    ( SELECT  id_print_type
                                                      FROM    dbo.srvpl_device_models t
                                                      WHERE   t.id_device_model = @id_device_model
                                                    ))
                                                 
                    SELECT  @id_cartridge_type = ISNULL(@id_cartridge_type,
                                                        ( SELECT
                                                              id_cartridge_type
                                                          FROM
                                                              dbo.srvpl_device_models t
                                                          WHERE
                                                              t.id_device_model = @id_device_model
                                                        ))    
                                                        
                                                             SELECT  @max_volume = ISNULL(@max_volume,
                                                        ( SELECT
                                                              max_volume
                                                          FROM
                                                              dbo.srvpl_device_models t
                                                          WHERE
                                                              t.id_device_model = @id_device_model
                                                        ))                    
					
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.srvpl_device_models
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0
                            WHERE   id_device_model = @id_device_model
                        END
					
                    UPDATE  dbo.srvpl_device_models
                    SET     @vendor = @vendor ,
                            @name = @name ,
                            @nickname = @nickname ,
                            speed = @speed ,
                            id_device_type = @id_device_type ,
                            id_device_imprint = @id_device_imprint ,
                            id_cartridge_type = @id_cartridge_type ,
                            id_print_type = @id_print_type,
                            max_volume = @max_volume
                    WHERE   id_device_model = @id_device_model
                END
            ELSE
                IF @action = 'closeDeviceModel'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                  
                        EXEC dbo.sk_service_planing @action = N'updDeviceModel',
                            @id_device_model = @id_device_model, @is_close = 1,
                            @id_creator = @id_creator
                    END                
                    
	--=================================
	--CartridgeTypes
	--=================================	
        IF @action = 'insCartridgeType'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
				
                SELECT  @nickname = ISNULL(@nickname, @name)
				
                INSERT  INTO dbo.srvpl_cartridge_types
                        ( name ,
                          nickname ,
                          descr ,
                          order_num ,
                          enabled ,
                          dattim1 ,
                          dattim2
		                )
                VALUES  ( @name , -- name - nvarchar(150)
                          @nickname , -- nickname - nvarchar(100)
                          @descr , -- descr - nvarchar(max)
                          @def_order_num , -- order_num - int
                          @def_enabled , -- enabled - bit
                          GETDATE() , -- dattim1 - datetime
                          @def_dattim2  -- dattim2 - datetime
		                )
            END
        ELSE
            IF @action = 'updCartridgeType'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
					
                    SELECT  @name = ISNULL(@name,
                                           ( SELECT name
                                             FROM   dbo.srvpl_cartridge_types t
                                             WHERE  t.id_cartridge_type = @id_cartridge_type
                                           ))
                                                 
                    SELECT  @nickname = ISNULL(@nickname,
                                               ( SELECT nickname
                                                 FROM   dbo.srvpl_cartridge_types t
                                                 WHERE  t.id_cartridge_type = @id_cartridge_type
                                               ))
                                                 
                    SELECT  @descr = ISNULL(@descr,
                                            ( SELECT    descr
                                              FROM      dbo.srvpl_cartridge_types t
                                              WHERE     t.id_cartridge_type = @id_cartridge_type
                                            ))
                                                 
                    SELECT  @order_num = ISNULL(@order_num,
                                                ( SELECT    order_num
                                                  FROM      dbo.srvpl_cartridge_types t
                                                  WHERE     t.id_cartridge_type = @id_cartridge_type
                                                ))                                                 
					
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.srvpl_cartridge_types
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0
                            WHERE   id_cartridge_type = @id_cartridge_type
                        END
					
                    UPDATE  dbo.srvpl_cartridge_types
                    SET     @name = @name ,
                            @nickname = @nickname ,
                            @descr = @descr ,
                            @order_num = @order_num
                    WHERE   id_cartridge_type = @id_cartridge_type
		
                    
		
                END
            ELSE
                IF @action = 'closeCartridgeType'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                  
                        EXEC dbo.sk_service_planing @action = N'updCartridgeType',
                            @id_cartridge_type = @id_cartridge_type,
                            @is_close = 1, @id_creator = @id_creator
                    END
	
	
	--=================================
	--ContractStatuses
	--=================================	
        IF @action = 'insContractStatus'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
				
                SELECT  @nickname = ISNULL(@nickname, @name)
				
                INSERT  INTO dbo.srvpl_contract_statuses
                        ( name ,
                          nickname ,
                          descr ,
                          order_num ,
                          enabled ,
                          dattim1 ,
                          dattim2
				        )
                VALUES  ( @name , -- name - nvarchar(150)
                          @nickname , -- nickname - nvarchar(100)
                          @descr , -- descr - nvarchar(max)
                          @def_order_num , -- order_num - int
                          @def_enabled , -- enabled - bit
                          GETDATE() , -- dattim1 - datetime
                          @def_dattim2  -- dattim2 - datetime
				        )
            END
        ELSE
            IF @action = 'updContractStatus'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                        
                    SELECT  @name = ISNULL(@name,
                                           ( SELECT name
                                             FROM   dbo.srvpl_contract_statuses t
                                             WHERE  t.id_contract_status = @id_contract_status
                                           ))   
                    SELECT  @nickname = ISNULL(@nickname,
                                               ( SELECT nickname
                                                 FROM   dbo.srvpl_contract_statuses t
                                                 WHERE  t.id_contract_status = @id_contract_status
                                               ))   
                    SELECT  @descr = ISNULL(@descr,
                                            ( SELECT    descr
                                              FROM      dbo.srvpl_contract_statuses t
                                              WHERE     t.id_contract_status = @id_contract_status
                                            ))   
                    SELECT  @order_num = ISNULL(@order_num,
                                                ( SELECT    order_num
                                                  FROM      dbo.srvpl_contract_statuses t
                                                  WHERE     t.id_contract_status = @id_contract_status
                                                ))                        
                        
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.srvpl_contract_statuses
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0
                            WHERE   id_contract_status = @id_contract_status
                        END 
                        
                    UPDATE  dbo.srvpl_contract_statuses
                    SET     name = @name ,
                            nickname = @nickname ,
                            descr = @descr ,
                            order_num = @order_num
                    WHERE   id_contract_status = @id_contract_status
		
                    
                END
            ELSE
                IF @action = 'closeContractStatus'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                  
                        EXEC dbo.sk_service_planing @action = N'updContractStatus',
                            @id_contract_status = @id_contract_status,
                            @is_close = 1, @id_creator = @id_creator
                    END
				
				--=================================
	--ContractTypes
	--=================================	
        IF @action = 'insContractType'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
				
                SELECT  @nickname = ISNULL(@nickname, @name)
				
                INSERT  INTO dbo.srvpl_contract_types
                        ( name ,
                          nickname ,
                          descr ,
                          order_num ,
                          enabled ,
                          dattim1 ,
                          dattim2
				        )
                VALUES  ( @name , -- name - nvarchar(150)
                          @nickname , -- nickname - nvarchar(100)
                          @descr , -- descr - nvarchar(max)
                          @def_order_num , -- order_num - int
                          @def_enabled , -- enabled - bit
                          GETDATE() , -- dattim1 - datetime
                          @def_dattim2  -- dattim2 - datetime
				        )
            END
        ELSE
            IF @action = 'updContractType'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                        
                    SELECT  @name = ISNULL(@name,
                                           ( SELECT name
                                             FROM   dbo.srvpl_contract_types t
                                             WHERE  t.id_contract_type = @id_contract_type
                                           ))   
                    SELECT  @nickname = ISNULL(@nickname,
                                               ( SELECT nickname
                                                 FROM   dbo.srvpl_contract_types t
                                                 WHERE  t.id_contract_type = @id_contract_type
                                               ))   
                    SELECT  @descr = ISNULL(@descr,
                                            ( SELECT    descr
                                              FROM      dbo.srvpl_contract_types t
                                              WHERE     t.id_contract_type = @id_contract_type
                                            ))   
                    SELECT  @order_num = ISNULL(@order_num,
                                                ( SELECT    order_num
                                                  FROM      dbo.srvpl_contract_types t
                                                  WHERE     t.id_contract_type = @id_contract_type
                                                ))   
                                  
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.srvpl_contract_types
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0
                            WHERE   id_contract_type = @id_contract_type
                        END                                     
                        
                    UPDATE  dbo.srvpl_contract_types
                    SET     name = @name ,
                            nickname = @nickname ,
                            descr = @descr ,
                            order_num = @order_num
                    WHERE   id_contract_type = @id_contract_type
		
                    
                END
            ELSE
                IF @action = 'closeContractType'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                  
                        EXEC dbo.sk_service_planing @action = N'updContractType',
                            @id_contract_type = @id_contract_type,
                            @is_close = 1, @id_creator = @id_creator
                    END
                    
                    --=================================
	--DeviceImprints
	--=================================	
        IF @action = 'insDeviceImprint'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
				
                SELECT  @nickname = ISNULL(@nickname, @name)
				
                INSERT  INTO dbo.srvpl_device_imprints
                        ( name ,
                          nickname ,
                          descr ,
                          order_num ,
                          dattim1 ,
                          dattim2 ,
                          enabled
				        )
                VALUES  ( @name , -- name - nvarchar(150)
                          @nickname , -- nickname - nvarchar(100)
                          @descr , -- descr - nvarchar(max)
                          @def_order_num , -- order_num - int                          
                          GETDATE() , -- dattim1 - datetime
                          @def_dattim2 ,  -- dattim2 - datetime
                          @def_enabled  -- enabled - bit
				        )
            END
        ELSE
            IF @action = 'updDeviceImprint'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                        
                    SELECT  @name = ISNULL(@name,
                                           ( SELECT name
                                             FROM   dbo.srvpl_device_imprints t
                                             WHERE  t.id_device_imprint = @id_device_imprint
                                           ))   
                    SELECT  @nickname = ISNULL(@nickname,
                                               ( SELECT nickname
                                                 FROM   dbo.srvpl_device_imprints t
                                                 WHERE  t.id_device_imprint = @id_device_imprint
                                               ))   
                    SELECT  @descr = ISNULL(@descr,
                                            ( SELECT    descr
                                              FROM      dbo.srvpl_device_imprints t
                                              WHERE     t.id_device_imprint = @id_device_imprint
                                            ))   
                    SELECT  @order_num = ISNULL(@order_num,
                                                ( SELECT    order_num
                                                  FROM      dbo.srvpl_device_imprints t
                                                  WHERE     t.id_device_imprint = @id_device_imprint
                                                ))   
                               
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.srvpl_device_imprints
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0
                            WHERE   id_device_imprint = @id_device_imprint
                        END             
                        
                    UPDATE  dbo.srvpl_device_imprints
                    SET     name = @name ,
                            nickname = @nickname ,
                            descr = @descr ,
                            order_num = @order_num
                    WHERE   id_device_imprint = @id_device_imprint
		
                    
                END
            ELSE
                IF @action = 'closeDeviceImprint'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                  
                        EXEC dbo.sk_service_planing @action = N'updDeviceImprint',
                            @id_device_imprint = @id_device_imprint,
                            @is_close = 1, @id_creator = @id_creator
                    END
	
	--=================================
	--DeviceOptions
	--=================================	
        IF @action = 'insDeviceOption'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                SELECT  @nickname = ISNULL(@nickname, @name)
		
                INSERT  INTO dbo.srvpl_device_options
                        ( name ,
                          nickname ,
                          descr ,
                          order_num ,
                          enabled ,
                          dattim1 ,
                          dattim2
				        )
                VALUES  ( @name , -- name - nvarchar(150)
                          @nickname , -- nickname - nvarchar(100)
                          @descr , -- descr - nvarchar(max)
                          @def_order_num , -- order_num - int 
                          @def_enabled ,  -- enabled - bit                         
                          GETDATE() , -- dattim1 - datetime
                          @def_dattim2   -- dattim2 - datetime
				        )
            END
        ELSE
            IF @action = 'updDeviceOption'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                        
                    SELECT  @name = ISNULL(@name,
                                           ( SELECT name
                                             FROM   dbo.srvpl_device_options t
                                             WHERE  t.id_device_option = @id_device_option
                                           ))          
                    SELECT  @nickname = ISNULL(@nickname,
                                               ( SELECT nickname
                                                 FROM   dbo.srvpl_device_options t
                                                 WHERE  t.id_device_option = @id_device_option
                                               ))          
                    SELECT  @descr = ISNULL(@descr,
                                            ( SELECT    descr
                                              FROM      dbo.srvpl_device_options t
                                              WHERE     t.id_device_option = @id_device_option
                                            ))          
                    SELECT  @order_num = ISNULL(@order_num,
                                                ( SELECT    order_num
                                                  FROM      dbo.srvpl_device_options t
                                                  WHERE     t.id_device_option = @id_device_option
                                                ))          
                    
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.srvpl_
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0
                            WHERE   id_device_option = @id_device_option
                        END                   
                        
                    UPDATE  dbo.srvpl_device_options
                    SET     name = @name ,
                            nickname = @nickname ,
                            descr = @descr ,
                            order_num = @order_num
                    WHERE   id_device_option = @id_device_option
		
                    
                END
            ELSE
                IF @action = 'closeDeviceOption'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                  
                        EXEC dbo.sk_service_planing @action = N'updDeviceOption',
                            @id_device_option = @id_device_option,
                            @is_close = 1, @id_creator = @id_creator
                    END
	
	--=================================
	--Device2Options
	--=================================	
        IF @action = 'insDevice2Options'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                SELECT  @nickname = ISNULL(@nickname, @name)
		
                INSERT  INTO dbo.srvpl_device2options
                        ( id_device ,
                          id_device_option ,
                          dattim1 ,
                          dattim2 ,
                          enabled
				        )
                VALUES  ( @id_device , -- id_device - int
                          @id_device_option , -- id_device_option - int
                          GETDATE() , -- dattim1 - datetime
                          @def_dattim2 , -- dattim2 - datetime
                          @def_enabled  -- enabled - bit
				        )
            END
        ELSE
            IF @action = 'updDevice2Options'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                        
                    SELECT  @id_device = ISNULL(@id_device,
                                                ( SELECT    id_device
                                                  FROM      dbo.srvpl_device2options t
                                                  WHERE     t.id_device2option = @id_device2option
                                                ))       
                                                 
                    SELECT  @id_device_option = ISNULL(@id_device_option,
                                                       ( SELECT
                                                              id_device_option
                                                         FROM dbo.srvpl_device2options t
                                                         WHERE
                                                              t.id_device2option = @id_device2option
                                                       ))                                            
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.srvpl_device2options
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0
                            WHERE   id_device2option = @id_device2option
                        END 
                        
                    UPDATE  dbo.srvpl_device2options
                    SET     @id_device = @id_device ,
                            @id_device_option = @id_device_option
                    WHERE   id_device2option = @id_device2option
		
                    
                END
            ELSE
                IF @action = 'closeDevice2Options'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                  
                        EXEC dbo.sk_service_planing @action = N'updDevice2Options',
                            @id_device2option = @id_device2option,
                            @is_close = 1, @id_creator = @id_creator
                    END
                ELSE
                    IF @action = 'closeDevice2Options4Device'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END
						
                            UPDATE  dbo.srvpl_device2options
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0
                            WHERE   enabled = 1
                                    AND id_device = @id_device
                        END
	
	--=================================
	--PrintTypes
	--=================================	
        IF @action = 'insPrintType'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
				
                SELECT  @nickname = ISNULL(@nickname, @name)
				
                INSERT  INTO dbo.srvpl_print_types
                        ( name ,
                          nickname ,
                          descr ,
                          order_num ,
                          enabled ,
                          dattim1 ,
                          dattim2
				        )
                VALUES  ( @name , -- name - nvarchar(150)
                          @nickname , -- nickname - nvarchar(100)
                          @descr , -- descr - nvarchar(max)
                          @def_order_num , -- order_num - int 
                          @def_enabled ,  -- enabled - bit                         
                          GETDATE() , -- dattim1 - datetime
                          @def_dattim2   -- dattim2 - datetime
				        )
            END
        ELSE
            IF @action = 'updPrintType'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                        
                    SELECT  @name = ISNULL(@name,
                                           ( SELECT name
                                             FROM   dbo.srvpl_print_types t
                                             WHERE  t.id_print_type = @id_print_type
                                           ))
                        
                    SELECT  @nickname = ISNULL(@nickname,
                                               ( SELECT nickname
                                                 FROM   dbo.srvpl_print_types t
                                                 WHERE  t.id_print_type = @id_print_type
                                               )) 
                                                 
                    SELECT  @descr = ISNULL(@descr,
                                            ( SELECT    descr
                                              FROM      dbo.srvpl_print_types t
                                              WHERE     t.id_print_type = @id_print_type
                                            ))
                                                   
                    SELECT  @order_num = ISNULL(@order_num,
                                                ( SELECT    order_num
                                                  FROM      dbo.srvpl_print_types t
                                                  WHERE     t.id_print_type = @id_print_type
                                                ))
                       
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.srvpl_print_types
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0
                            WHERE   id_print_type = @id_print_type
                        END                                                     
                        
                    UPDATE  dbo.srvpl_print_types
                    SET     name = @name ,
                            nickname = @nickname ,
                            descr = @descr ,
                            order_num = @order_num
                    WHERE   id_print_type = @id_print_type
		
                    
                END
            ELSE
                IF @action = 'closePrintType'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                  
                        EXEC dbo.sk_service_planing @action = N'updPrintType',
                            @id_print_type = @id_print_type, @is_close = 1,
                            @id_creator = @id_creator
                    END
	
	--=================================
	--ServiceActionTypes
	--=================================	
        IF @action = 'insServiceActionType'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                SELECT  @nickname = ISNULL(@nickname, @name)
		
                INSERT  INTO dbo.srvpl_service_action_types
                        ( name ,
                          nickname ,
                          descr ,
                          order_num ,
                          enabled ,
                          dattim1 ,
                          dattim2
				        )
                VALUES  ( @name , -- name - nvarchar(150)
                          @nickname , -- nickname - nvarchar(100)
                          @descr , -- descr - nvarchar(max)
                          @def_order_num , -- order_num - int 
                          @def_enabled ,  -- enabled - bit                         
                          GETDATE() , -- dattim1 - datetime
                          @def_dattim2   -- dattim2 - datetime
				        )
            END
        ELSE
            IF @action = 'updServiceActionType'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                        
                    SELECT  @name = ISNULL(@name,
                                           ( SELECT name
                                             FROM   dbo.srvpl_service_action_types t
                                             WHERE  t.id_service_action_type = @id_service_action_type
                                           ))   
                    SELECT  @nickname = ISNULL(@nickname,
                                               ( SELECT nickname
                                                 FROM   dbo.srvpl_service_action_types t
                                                 WHERE  t.id_service_action_type = @id_service_action_type
                                               ))   
                    SELECT  @descr = ISNULL(@descr,
                                            ( SELECT    descr
                                              FROM      dbo.srvpl_service_action_types t
                                              WHERE     t.id_service_action_type = @id_service_action_type
                                            ))   
                    SELECT  @order_num = ISNULL(@order_num,
                                                ( SELECT    order_num
                                                  FROM      dbo.srvpl_service_action_types t
                                                  WHERE     t.id_service_action_type = @id_service_action_type
                                                ))   
                                                                      
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.srvpl_service_action_types
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0
                            WHERE   id_service_action_type = @id_service_action_type
                        END 
                        
                    UPDATE  dbo.srvpl_service_action_types
                    SET     name = @name ,
                            nickname = @nickname ,
                            descr = @descr ,
                            order_num = @order_num
                    WHERE   id_service_action_type = @id_service_action_type
		
                    
                END
            ELSE
                IF @action = 'closeServiceActionType'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                  
                        EXEC dbo.sk_service_planing @action = N'updServiceActionType',
                            @id_service_action_type = @id_service_action_type,
                            @is_close = 1, @id_creator = @id_creator
                    END
	
	--=================================
	--ServiceIntervals
	--=================================	
        IF @action = 'insServiceInterval'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
                    
                SELECT  @nickname = ISNULL(@nickname, @name)
		
                INSERT  INTO dbo.srvpl_service_intervals
                        ( name ,
                          nickname ,
                          descr ,
                          order_num ,
                          enabled ,
                          dattim1 ,
                          dattim2
				        )
                VALUES  ( @name , -- name - nvarchar(150)
                          @nickname , -- nickname - nvarchar(100)
                          @descr , -- descr - nvarchar(max)
                          @def_order_num , -- order_num - int 
                          @def_enabled ,  -- enabled - bit                         
                          GETDATE() , -- dattim1 - datetime
                          @def_dattim2   -- dattim2 - datetime
				        )
            END
        ELSE
            IF @action = 'updServiceInterval'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                        
                    SELECT  @name = ISNULL(@name,
                                           ( SELECT name
                                             FROM   dbo.srvpl_service_intervals t
                                             WHERE  t.id_service_interval = @id_service_interval
                                           )) 
                    SELECT  @nickname = ISNULL(@nickname,
                                               ( SELECT nickname
                                                 FROM   dbo.srvpl_service_intervals t
                                                 WHERE  t.id_service_interval = @id_service_interval
                                               )) 
                    SELECT  @descr = ISNULL(@descr,
                                            ( SELECT    descr
                                              FROM      dbo.srvpl_service_intervals t
                                              WHERE     t.id_service_interval = @id_service_interval
                                            )) 
                    SELECT  @order_num = ISNULL(@order_num,
                                                ( SELECT    order_num
                                                  FROM      dbo.srvpl_service_intervals t
                                                  WHERE     t.id_service_interval = @id_service_interval
                                                ))
                    
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.srvpl_service_intervals
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0
                            WHERE   id_service_interval = @id_service_interval
                        END                                                   
                        
                    UPDATE  dbo.srvpl_service_intervals
                    SET     name = @name ,
                            nickname = @nickname ,
                            descr = @descr ,
                            order_num = @order_num
                    WHERE   id_service_interval = @id_service_interval
		
                    
                END
            ELSE
                IF @action = 'closeServiceInterval'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                  
                        EXEC dbo.sk_service_planing @action = N'updServiceInterval',
                            @id_service_interval = @id_service_interval,
                            @is_close = 1, @id_creator = @id_creator
                    END
	
	--=================================
	--ServiceCames
	--=================================	
        IF @action = 'insServiceCame'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                SELECT  @nickname = ISNULL(@nickname, @name)
		
                INSERT  INTO dbo.srvpl_service_cames
                        ( id_service_claim ,
                          date_came ,
                          descr ,
                          counter ,
                          id_service_engeneer ,
                          id_service_action_type ,
                          dattim1 ,
                          dattim2 ,
                          enabled ,
                          id_creator ,
                          counter_colour ,
                          id_akt_scan
				        )
                VALUES  ( @id_service_claim , -- id_device - int
                          @date_came , -- date_came - datetime
                          @descr , -- descr - nvarchar(max)
                          @counter , -- counter - int
                          @id_service_engeneer ,
                          @id_service_action_type , -- id_service_action_type - int
                          GETDATE() , -- dattim1 - datetime
                          @def_dattim2 , -- dattim2 - datetime
                          @def_enabled , -- enabled - bit
                          @id_creator ,-- id_creator - int
                          @counter_colour ,
                          @id_akt_scan
				        )
            END
        ELSE
            IF @action = 'updServiceCameDevice'
                BEGIN
--Это КОСТЫЛЬ но необходимая вещь
                    IF @id_device IS NOT NULL
                        AND @id_device > 0
                        BEGIN

                            UPDATE  dbo.srvpl_service_claims
                            SET     id_device = @id_device
                            WHERE   id_service_claim = @id_service_claim   
                        END
                END                
            ELSE
                IF @action = 'updServiceCame'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                        
                        SELECT  @id_service_claim = ISNULL(@id_service_claim,
                                                           ( SELECT
                                                              id_service_claim
                                                             FROM
                                                              dbo.srvpl_service_cames t
                                                             WHERE
                                                              t.id_service_came = @id_service_came
                                                           ))
                        SELECT  @date_came = ISNULL(@date_came,
                                                    ( SELECT  date_came
                                                      FROM    dbo.srvpl_service_cames t
                                                      WHERE   t.id_service_came = @id_service_came
                                                    ))
                        SELECT  @descr = ISNULL(@descr,
                                                ( SELECT    descr
                                                  FROM      dbo.srvpl_service_cames t
                                                  WHERE     t.id_service_came = @id_service_came
                                                ))
                        SELECT  @counter = ISNULL(@counter,
                                                  ( SELECT  counter
                                                    FROM    dbo.srvpl_service_cames t
                                                    WHERE   t.id_service_came = @id_service_came
                                                  ))
                        SELECT  @id_service_engeneer = ISNULL(@id_service_engeneer,
                                                              ( SELECT
                                                              id_service_engeneer
                                                              FROM
                                                              dbo.srvpl_service_cames t
                                                              WHERE
                                                              t.id_service_came = @id_service_came
                                                              ))
                        SELECT  @id_service_action_type = ISNULL(@id_service_action_type,
                                                              ( SELECT
                                                              id_service_action_type
                                                              FROM
                                                              dbo.srvpl_service_cames t
                                                              WHERE
                                                              t.id_service_came = @id_service_came
                                                              ))
                                                             
                        SELECT  @counter_colour = ISNULL(@counter_colour,
                                                         ( SELECT
                                                              counter_colour
                                                           FROM
                                                              dbo.srvpl_service_cames t
                                                           WHERE
                                                              t.id_service_came = @id_service_came
                                                         ))
                        SELECT  @id_akt_scan = ISNULL(@id_akt_scan,
                                                      ( SELECT
                                                              id_akt_scan
                                                        FROM  dbo.srvpl_service_cames t
                                                        WHERE t.id_service_came = @id_service_came
                                                      ))                                 
                                                             
                    
                        IF @is_close = 1
                            BEGIN
                                UPDATE  dbo.srvpl_service_cames
                                SET     dattim2 = GETDATE() ,
                                        enabled = 0
                                WHERE   id_service_came = @id_service_came
                            END                                                     
                        
                        UPDATE  dbo.srvpl_service_cames
                        SET     id_service_claim = @id_service_claim ,
                                date_came = @date_came ,
                                descr = @descr ,
                                counter = @counter ,
                                id_service_engeneer = @id_service_engeneer ,
                                id_service_action_type = @id_service_action_type ,
                                counter_colour = @counter_colour ,
                                id_akt_scan = @id_akt_scan
                        WHERE   id_service_came = @id_service_came
		
                     
                    END
                ELSE
                    IF @action = 'closeServiceCame'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END
                  
                            EXEC dbo.sk_service_planing @action = N'updServiceCame',
                                @id_service_came = @id_service_came,
                                @is_close = 1, @id_creator = @id_creator
                        END
	
	--=================================
	--ServiceClaims
	--=================================	
        IF @action = 'insServiceClaim'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
				
                SELECT  @id_service_claim_status = ISNULL(@id_service_claim_status,
                                                          @def_id_service_claim_status)
				
                INSERT  INTO dbo.srvpl_service_claims
                        ( id_contract2devices ,
                          id_contract ,
                          id_device ,
                          planing_date ,
                          id_service_claim_type ,
                          number ,
                          id_service_engeneer ,
                          descr ,
                          dattim1 ,
                          dattim2 ,
                          enabled ,
                          id_creator ,
                          order_num ,
                          id_service_claim_status ,
                          id_service_admin
				        )
                VALUES  ( @id_contract2devices ,
                          @id_contract ,
                          @id_device ,
                          @planing_date ,
                          @id_service_claim_type ,
                          @number ,
                          @id_service_engeneer ,
                          @descr ,
                          GETDATE() ,
                          @def_dattim2 ,
                          @def_enabled ,
                          @id_creator ,
                          @def_order_num ,
                          @id_service_claim_status ,
                          @id_service_admin
				        )
            END
        ELSE
            IF @action = 'updServiceClaim'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                               
                    SELECT  @id_contract2devices = ISNULL(@id_contract2devices,
                                                          ( SELECT
                                                              id_contract2devices
                                                            FROM
                                                              dbo.srvpl_service_claims t
                                                            WHERE
                                                              t.id_service_claim = @id_service_claim
                                                          ))
                                        
                    SELECT  @id_contract = ISNULL(@id_contract,
                                                  ( SELECT  id_contract
                                                    FROM    dbo.srvpl_service_claims t
                                                    WHERE   t.id_service_claim = @id_service_claim
                                                  ))
                    SELECT  @id_device = ISNULL(@id_device,
                                                ( SELECT    id_device
                                                  FROM      dbo.srvpl_service_claims t
                                                  WHERE     t.id_service_claim = @id_service_claim
                                                ))
                    SELECT  @planing_date = ISNULL(@planing_date,
                                                   ( SELECT planing_date
                                                     FROM   dbo.srvpl_service_claims t
                                                     WHERE  t.id_service_claim = @id_service_claim
                                                   ))
                    SELECT  @id_service_claim_type = ISNULL(@id_service_claim_type,
                                                            ( SELECT
                                                              id_service_claim_type
                                                              FROM
                                                              dbo.srvpl_service_claims t
                                                              WHERE
                                                              t.id_service_claim = @id_service_claim
                                                            ))
                    SELECT  @number = ISNULL(@number,
                                             ( SELECT   number
                                               FROM     dbo.srvpl_service_claims t
                                               WHERE    t.id_service_claim = @id_service_claim
                                             ))
                    SELECT  @id_service_engeneer = ISNULL(@id_service_engeneer,
                                                          ( SELECT
                                                              id_service_engeneer
                                                            FROM
                                                              dbo.srvpl_service_claims t
                                                            WHERE
                                                              t.id_service_claim = @id_service_claim
                                                          ))
                    SELECT  @descr = ISNULL(@descr,
                                            ( SELECT    descr
                                              FROM      dbo.srvpl_service_claims t
                                              WHERE     t.id_service_claim = @id_service_claim
                                            ))
                    SELECT  @order_num = ISNULL(@order_num,
                                                ( SELECT    order_num
                                                  FROM      dbo.srvpl_service_claims t
                                                  WHERE     t.id_service_claim = @id_service_claim
                                                ))                                              
                    SELECT  @id_service_claim_status = ISNULL(@id_service_claim_status,
                                                              ( SELECT
                                                              id_service_claim_status
                                                              FROM
                                                              dbo.srvpl_service_claims t
                                                              WHERE
                                                              t.id_service_claim = @id_service_claim
                                                              )) 
                                                              
                    SELECT  @id_service_admin = ISNULL(@id_service_admin,
                                                       ( SELECT
                                                              id_service_admin
                                                         FROM dbo.srvpl_service_claims t
                                                         WHERE
                                                              t.id_service_claim = @id_service_claim
                                                       )) 
                    
                    
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.srvpl_service_claims
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0
                            WHERE   id_service_claim = @id_service_claim
                        END                                                      
                        
                    UPDATE  dbo.srvpl_service_claims
                    SET     id_contract2devices = @id_contract2devices ,
                            id_contract = @id_contract ,
                            id_device = @id_device ,
                            planing_date = @planing_date ,
                            id_service_claim_type = @id_service_claim_type ,
                            number = @number ,
                            id_service_engeneer = @id_service_engeneer ,
                            descr = @descr ,
                            order_num = @order_num ,
                            id_service_claim_status = @id_service_claim_status ,
                            id_service_admin = @id_service_admin
                    WHERE   id_service_claim = @id_service_claim
		
                    
                END
            ELSE
                IF @action = 'closeServiceClaim'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                  
                        EXEC dbo.sk_service_planing @action = N'updServiceClaim',
                            @id_service_claim = @id_service_claim,
                            @is_close = 1, @id_creator = @id_creator
                    END
                ELSE
                    IF @action = 'closeServiceClaimList'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END
                  
                            UPDATE  sc
                            SET     sc.dattim2 = GETDATE() ,
                                    sc.enabled = 0
                            FROM    dbo.srvpl_service_claims sc
                            WHERE   sc.enabled = 1
                                    AND sc.id_contract = @id_contract
                                    AND sc.id_device = @id_device
                                    --Не прошлое
                                    AND CONVERT(DATE,sc.planing_date) >= CONVERT(DATE,GETDATE())
                                    --Нет отметки об обслуживании
                                    AND NOT EXISTS ( SELECT 1
                                                     FROM   dbo.srvpl_service_cames scam
                                                     WHERE  scam.enabled = 1
                                                            AND scam.id_service_claim = sc.id_service_claim )
                        END
	
	--=================================
	--ServiceTypes
	--=================================	
        IF @action = 'insServiceType'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                SELECT  @nickname = ISNULL(@nickname, @name)
		
                INSERT  INTO dbo.srvpl_service_types
                        ( name ,
                          nickname ,
                          descr ,
                          order_num ,
                          enabled ,
                          dattim1 ,
                          dattim2
				        )
                VALUES  ( @name , -- name - nvarchar(150)
                          @nickname , -- nickname - nvarchar(100)
                          @descr , -- descr - nvarchar(max)
                          @def_order_num , -- order_num - int 
                          @def_enabled ,  -- enabled - bit                         
                          GETDATE() , -- dattim1 - datetime
                          @def_dattim2   -- dattim2 - datetime
				        )
            END
        ELSE
            IF @action = 'updServiceType'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                        
                    SELECT  @name = ISNULL(@name,
                                           ( SELECT name
                                             FROM   dbo.srvpl_service_types t
                                             WHERE  t.id_service_type = @id_service_type
                                           ))
                    SELECT  @nickname = ISNULL(@nickname,
                                               ( SELECT nickname
                                                 FROM   dbo.srvpl_service_types t
                                                 WHERE  t.id_service_type = @id_service_type
                                               ))
                    SELECT  @descr = ISNULL(@descr,
                                            ( SELECT    descr
                                              FROM      dbo.srvpl_service_types t
                                              WHERE     t.id_service_type = @id_service_type
                                            ))
                    SELECT  @order_num = ISNULL(@order_num,
                                                ( SELECT    order_num
                                                  FROM      dbo.srvpl_service_types t
                                                  WHERE     t.id_service_type = @id_service_type
                                                ))
                    
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.srvpl_service_types
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0
                            WHERE   id_service_type = @id_service_type
                        END                                                      
                        
                    UPDATE  dbo.srvpl_service_types
                    SET     name = @name ,
                            nickname = @nickname ,
                            descr = @descr ,
                            order_num = @order_num
                    WHERE   id_service_type = @id_service_type
		
                    
                END
            ELSE
                IF @action = 'closeServiceType'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                  
                        EXEC dbo.sk_service_planing @action = N'updServiceType',
                            @id_service_type = @id_service_type, @is_close = 1,
                            @id_creator = @id_creator
                    END
	
	--=================================
	--ServiceZones
	--=================================	
        IF @action = 'insServiceZone'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                SELECT  @nickname = ISNULL(@nickname, @name)
		
                INSERT  INTO dbo.srvpl_service_zones
                        ( name ,
                          nickname ,
                          descr ,
                          order_num ,
                          enabled ,
                          dattim1 ,
                          dattim2
				        )
                VALUES  ( @name , -- name - nvarchar(150)
                          @nickname , -- nickname - nvarchar(100)
                          @descr , -- descr - nvarchar(max)
                          @def_order_num , -- order_num - int 
                          @def_enabled ,  -- enabled - bit                         
                          GETDATE() , -- dattim1 - datetime
                          @def_dattim2   -- dattim2 - datetime
				        )
            END
        ELSE
            IF @action = 'updServiceZone'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                        
                    SELECT  @name = ISNULL(@name,
                                           ( SELECT name
                                             FROM   dbo.srvpl_service_zones t
                                             WHERE  t.id_service_zone = @id_service_zone
                                           )) 
                                                                        
                    SELECT  @nickname = ISNULL(@nickname,
                                               ( SELECT nickname
                                                 FROM   dbo.srvpl_service_zones t
                                                 WHERE  t.id_service_zone = @id_service_zone
                                               ))
                                                 
                    SELECT  @descr = ISNULL(@descr,
                                            ( SELECT    descr
                                              FROM      dbo.srvpl_service_zones t
                                              WHERE     t.id_service_zone = @id_service_zone
                                            ))
                                                 
                    SELECT  @order_num = ISNULL(@order_num,
                                                ( SELECT    order_num
                                                  FROM      dbo.srvpl_service_zones t
                                                  WHERE     t.id_service_zone = @id_service_zone
                                                ))
                    
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.srvpl_service_zones
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0
                            WHERE   id_service_zone = @id_service_zone
                        END     
                        
                    UPDATE  dbo.srvpl_service_zones
                    SET     name = @name ,
                            nickname = @nickname ,
                            descr = @descr ,
                            order_num = @order_num
                    WHERE   id_service_zone = @id_service_zone
		
                    
                END
            ELSE
                IF @action = 'closeServiceZone'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                  
                        EXEC dbo.sk_service_planing @action = N'updServiceZone',
                            @id_service_zone = @id_service_zone, @is_close = 1,
                            @id_creator = @id_creator
                    END
                    
	--=================================
	--ServiceZone2Devices
	--=================================	
        IF @action = 'insServiceZone2Devices'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                SELECT  @nickname = ISNULL(@nickname, @name)
		
                INSERT  INTO dbo.srvpl_service_zone2devices
                        ( id_service_zone ,
                          id_device ,
                          dattim1 ,
                          dattim2 ,
                          enabled
				        )
                VALUES  ( @id_service_zone , -- id_service_zone - int
                          @id_device , -- id_device - int
                          GETDATE() , -- dattim1 - datetime
                          @def_dattim2 , -- dattim2 - datetime
                          @def_enabled  -- ensbled - bit
				        )
            END
        ELSE
            IF @action = 'updServiceZone2Devices'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                        
                    SELECT  @id_service_zone = ISNULL(@id_service_zone,
                                                      ( SELECT
                                                              id_service_zone
                                                        FROM  dbo.srvpl_service_zone2devices t
                                                        WHERE t.id_service_zone2devices = @id_service_zone2devices
                                                      ))                        
                        
                    SELECT  @id_device = ISNULL(@id_device,
                                                ( SELECT    id_device
                                                  FROM      dbo.srvpl_service_zone2devices t
                                                  WHERE     t.id_service_zone2devices = @id_service_zone2devices
                                                ))
                    
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.srvpl_service_zone2devices
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0
                            WHERE   id_service_zone2devices = @id_service_zone2devices
                        END 
                        
                    UPDATE  dbo.srvpl_service_zone2devices
                    SET     id_service_zone = @id_service_zone ,
                            id_device = @id_device
                    WHERE   id_service_zone2devices = @id_service_zone2devices
		
                    
                END
            ELSE
                IF @action = 'closeServiceZone2Devices'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                  
                        EXEC dbo.sk_service_planing @action = N'updServiceZone2Devices',
                            @id_service_zone2devices = @id_service_zone2devices,
                            @is_close = 1, @id_creator = @id_creator
                    END
	
	--=================================
	--ServiceZone2Users
	--=================================	
        IF @action = 'insServiceZone2Users'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                SELECT  @nickname = ISNULL(@nickname, @name)
		
                INSERT  INTO dbo.srvpl_service_zone2users
                        ( id_service_zone ,
                          id_user ,
                          dattim1 ,
                          dattim2 ,
                          enabled
				        )
                VALUES  ( @id_service_zone , -- id_service_zone - int
                          @id_user , -- id_user - int
                          GETDATE() , -- dattim1 - datetime
                          @def_dattim2 , -- dattim2 - datetime
                          @def_enabled  -- enabled - bit
				        )
            END
        ELSE
            IF @action = 'updServiceZone2Users'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                        
                    SELECT  @id_service_zone = ISNULL(@id_service_zone,
                                                      ( SELECT
                                                              id_service_zone
                                                        FROM  dbo.srvpl_service_zone2users t
                                                        WHERE t.id_service_zone2user = @id_service_zone2user
                                                      ))                       
                        
                    SELECT  @id_user = ISNULL(@id_user,
                                              ( SELECT  id_user
                                                FROM    dbo.srvpl_service_zone2users t
                                                WHERE   t.id_service_zone2user = @id_service_zone2user
                                              )) 
                    
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.srvpl_service_zone2users
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0
                            WHERE   id_service_zone2user = @id_service_zone2user
                        END 
                        
                    UPDATE  dbo.srvpl_service_zone2users
                    SET     id_service_zone = @id_service_zone ,
                            id_user = @id_user
                    WHERE   id_service_zone2user = @id_service_zone2user
		
                    
                END
            ELSE
                IF @action = 'closeServiceZone2Users'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                  
                        EXEC dbo.sk_service_planing @action = N'updServiceZone2Users',
                            @id_service_zone2user = @id_service_zone2user,
                            @is_close = 1, @id_creator = @id_creator
                    END
                    
    --=================================
	--TariffFeatures
	--=================================	
        IF @action = 'insTariffFeature'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
            --    INSERT  INTO dbo.srvpl_service_zone2users
            --            ( id_service_zone ,
            --              id_user ,
            --              dattim1 ,
            --              dattim2 ,
            --              enabled
				        --)
            --    VALUES  ( @id_service_zone , -- id_service_zone - int
            --              @id_user , -- id_user - int
            --              GETDATE() , -- dattim1 - datetime
            --              @def_dattim2 , -- dattim2 - datetime
            --              @def_enabled  -- enabled - bit
				        --)
            END
        ELSE
            IF @action = 'updTariffFeature'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                        
                    --SELECT  @name = ISNULL(@name,
                    --                                  ( SELECT
                    --                                          name
                    --                                    FROM  dbo.srvpl_tariff_features t
                    --                                    WHERE t.id_feature = @id_feature
                    --                                  ))                       
                        
                    --SELECT  @sys_name = ISNULL(@sys_name,
                    --                                  ( SELECT
                    --                                          sys_name
                    --                                    FROM  dbo.srvpl_tariff_features t
                    --                                    WHERE t.id_feature = @id_feature
                    --                                  ))   
                                                      
                    --                                  SELECT  @value = ISNULL(@value,
                    --                                  ( SELECT
                    --                                          value
                    --                                    FROM  dbo.srvpl_tariff_features t
                    --                                    WHERE t.id_feature = @id_feature
                    --                                  ))  
                    SELECT  @price = ISNULL(@price,
                                            ( SELECT    price
                                              FROM      dbo.srvpl_tariff_features t
                                              WHERE     t.id_feature = @id_feature
                                            )) 
                    
                    --IF @is_close = 1
                    --    BEGIN
                    --        UPDATE  dbo.srvpl_service_zone2users
                    --        SET     dattim2 = GETDATE() ,
                    --                enabled = 0
                    --        WHERE   id_service_zone2user = @id_service_zone2user
                    --    END 
                        
                    UPDATE  dbo.srvpl_tariff_features
                    SET     price = @price ,
                            id_creator = @id_creator
                    WHERE   id_feature = @id_feature
		
                    
                END
                
    --=================================
	--PaymentTariff
	--=================================	
        IF @action = 'insPaymentTariff'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
            --    INSERT  INTO dbo.srvpl_service_zone2users
            --            ( id_service_zone ,
            --              id_user ,
            --              dattim1 ,
            --              dattim2 ,
            --              enabled
				        --)
            --    VALUES  ( @id_service_zone , -- id_service_zone - int
            --              @id_user , -- id_user - int
            --              GETDATE() , -- dattim1 - datetime
            --              @def_dattim2 , -- dattim2 - datetime
            --              @def_enabled  -- enabled - bit
				        --)
            END
        ELSE
            IF @action = 'updPaymentTariff'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                        
                    --SELECT  @name = ISNULL(@name,
                    --                                  ( SELECT
                    --                                          name
                    --                                    FROM  dbo.srvpl_tariff_features t
                    --                                    WHERE t.id_feature = @id_feature
                    --                                  ))                       
                        
                    --SELECT  @sys_name = ISNULL(@sys_name,
                    --                                  ( SELECT
                    --                                          sys_name
                    --                                    FROM  dbo.srvpl_tariff_features t
                    --                                    WHERE t.id_feature = @id_feature
                    --                                  ))   
                                                      
                    --                                  SELECT  @value = ISNULL(@value,
                    --                                  ( SELECT
                    --                                          value
                    --                                    FROM  dbo.srvpl_tariff_features t
                    --                                    WHERE t.id_feature = @id_feature
                    --                                  ))  
                    SELECT  @price = ISNULL(@price,
                                            ( SELECT    price
                                              FROM      dbo.srvpl_payment_role_tariffs t
                                              WHERE     t.id_user_role = @id_user_role
                                            )) 
                    
                    --IF @is_close = 1
                    --    BEGIN
                    --        UPDATE  dbo.srvpl_service_zone2users
                    --        SET     dattim2 = GETDATE() ,
                    --                enabled = 0
                    --        WHERE   id_service_zone2user = @id_service_zone2user
                    --    END 
                        
                    UPDATE  dbo.srvpl_payment_tariffs
                    SET     price = @price ,
                            id_creator = @id_creator
                    WHERE   id_user_role = @id_user_role
		
                    
                END   
                
    --=================================
	--User2UserRole
	--=================================	
        IF @action = 'insUser2UserRole'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
                INSERT  INTO dbo.srvpl_user2user_roles
                        ( id_user_role ,
                          id_user ,
                          dattim1 ,
                          dattim2 ,
                          enabled ,
                          id_creator
				        )
                VALUES  ( @id_user_role ,
                          @id_user , -- id_user - int
                          GETDATE() , -- dattim1 - datetime
                          @def_dattim2 , -- dattim2 - datetime
                          @def_enabled , -- enabled - bit
                          @id_creator
				        )
            END
        ELSE
            IF @action = 'updUser2UserRole'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                        
                    SELECT  @id_user_role = ISNULL(@id_user_role,
                                                   ( SELECT id_user_role
                                                     FROM   dbo.srvpl_user2user_roles t
                                                     WHERE  t.id_user2user_role = @id_user2user_role
                                                   ))                       
                        
                    SELECT  @id_user = ISNULL(@id_user,
                                              ( SELECT  id_user
                                                FROM    dbo.srvpl_user2user_roles t
                                                WHERE   t.id_user2user_role = @id_user2user_role
                                              )) 
                    SELECT  @id_creator = ISNULL(@id_creator,
                                                 ( SELECT   id_creator
                                                   FROM     dbo.srvpl_user2user_roles t
                                                   WHERE    t.id_user2user_role = @id_user2user_role
                                                 )) 
                    
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.srvpl_user2user_roles
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0
                            WHERE   id_user2user_role = @id_user2user_role
                        END 
                        
                    UPDATE  dbo.srvpl_user2user_roles
                    SET     id_user_role = @id_user_role ,
                            id_user = @id_user ,
                            id_creator = @id_creator
                    WHERE   id_user2user_role = @id_user2user_role
		
                    
                END
            ELSE
                IF @action = 'closeUser2UserRole'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                  
                        EXEC dbo.sk_service_planing @action = N'updUser2UserRole',
                            @id_user_role = @id_user_role, @is_close = 1,
                            @id_creator = @id_creator
                    END                     
                
    --=================================
	--ZipGroups
	--=================================	
        IF @action = 'insZipGroup'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                INSERT  INTO dbo.srvpl_zip_groups
                        ( name ,
                          order_num ,
                          dattim1 ,
                          dattim2 ,
                          enabled ,
                          id_creator
				        )
                VALUES  ( @name , -- id_user - int
                          @def_order_num ,
                          GETDATE() , -- dattim1 - datetime
                          @def_dattim2 , -- dattim2 - datetime
                          @def_enabled , -- enabled - bit
                          @id_creator
				        )
            END
        ELSE
            IF @action = 'updZipGroup'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                        
                    SELECT  @name = ISNULL(@name,
                                           ( SELECT name
                                             FROM   dbo.srvpl_zip_groups t
                                             WHERE  t.id_zip_group = @id_zip_group
                                           ))                       
                        
                    --SELECT  @sys_name = ISNULL(@sys_name,
                    --                                  ( SELECT
                    --                                          sys_name
                    --                                    FROM  dbo.srvpl_zip_groups t
                    --                                    WHERE t.id_zip_group = @id_zip_group
                    --                                  ))   
                                                      
                    SELECT  @order_num = ISNULL(@order_num,
                                                ( SELECT    order_num
                                                  FROM      dbo.srvpl_zip_groups t
                                                  WHERE     t.id_zip_group = @id_zip_group
                                                ))  
                    SELECT  @id_creator = ISNULL(@id_creator,
                                                 ( SELECT   id_creator
                                                   FROM     dbo.srvpl_zip_groups t
                                                   WHERE    t.id_zip_group = @id_zip_group
                                                 )) 
                    
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.srvpl_zip_groups
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0
                            WHERE   id_zip_group = @id_zip_group
                        END 
                        
                    UPDATE  dbo.srvpl_zip_groups
                    SET     name = @name ,
                            order_num = @order_num ,
                            id_creator = @id_creator
                    WHERE   id_zip_group = @id_zip_group
		
                    
                END
            ELSE
                IF @action = 'closeZipGroup'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                  
                        EXEC dbo.sk_service_planing @action = N'updZipGroup',
                            @id_zip_group = @id_zip_group, @is_close = 1,
                            @id_creator = @id_creator
                    END
                    
                    --=================================
	--SrvplAddress
	--=================================	
        IF @action = 'insSrvplAddress'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                INSERT  INTO dbo.srvpl_addresses
                        ( name ,
                          order_num ,
                          dattim1 ,
                          dattim2 ,
                          enabled ,
                          id_creator
				        )
                VALUES  ( @name , -- id_user - int
                          @def_order_num ,
                          GETDATE() , -- dattim1 - datetime
                          @def_dattim2 , -- dattim2 - datetime
                          @def_enabled ,  -- enabled - bit
                          @id_creator
				        )
            END
        ELSE
            IF @action = 'updSrvplAddress'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                        
                    SELECT  @name = ISNULL(@name,
                                           ( SELECT name
                                             FROM   dbo.srvpl_addresses t
                                             WHERE  t.id_srvpl_address = @id_srvpl_address
                                           ))                       
                        
                    SELECT  @order_num = ISNULL(@order_num,
                                                ( SELECT    order_num
                                                  FROM      dbo.srvpl_addresses t
                                                  WHERE     t.id_srvpl_address = @id_srvpl_address
                                                ))  
                    SELECT  @id_creator = ISNULL(@id_creator,
                                                 ( SELECT   id_creator
                                                   FROM     dbo.srvpl_addresses t
                                                   WHERE    t.id_srvpl_address = @id_srvpl_address
                                                 )) 
                    
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.srvpl_addresses
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0
                            WHERE   id_srvpl_address = @id_srvpl_address
                        END 
                        
                    UPDATE  dbo.srvpl_addresses
                    SET     name = @name ,
                            order_num = @order_num ,
                            id_creator = @id_creator
                    WHERE   id_srvpl_address = @id_srvpl_address
		
                    
                END
            ELSE
                IF @action = 'closeSrvplAddress'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                  
                        EXEC dbo.sk_service_planing @action = N'updSrvplAddress',
                            @id_srvpl_address = @id_srvpl_address,
                            @is_close = 1, @id_creator = @id_creator
                    END
                    
    --=================================
	--AktScan
	--=================================	
        IF @action = 'insAktScan'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                INSERT  INTO dbo.srvpl_akt_scans
                        ( name ,
                          [file_name] ,
                          full_path ,
                          cames_add ,
                          date_cames_add ,
                          id_adder ,
                          dattim1 ,
                          dattim2 ,
                          enabled ,
                          id_creator
				        )
                VALUES  ( @name ,
                          @file_name ,
                          @full_path ,
                          0 ,
                          NULL ,
                          NULL ,
                          GETDATE() ,
                          @def_dattim2 ,
                          @def_enabled ,
                          @id_creator
				        )
            END
        ELSE
            IF @action = 'updAktScan'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                        
                    SELECT  @name = ISNULL(@name,
                                           ( SELECT name
                                             FROM   dbo.srvpl_akt_scans t
                                             WHERE  t.id_akt_scan = @id_akt_scan
                                           ))                       
                        
                    SELECT  @file_name = ISNULL(@file_name,
                                                ( SELECT    [file_name]
                                                  FROM      dbo.srvpl_akt_scans t
                                                  WHERE     t.id_akt_scan = @id_akt_scan
                                                ))  
                    SELECT  @full_path = ISNULL(@full_path,
                                                ( SELECT    full_path
                                                  FROM      dbo.srvpl_akt_scans t
                                                  WHERE     t.id_akt_scan = @id_akt_scan
                                                ))
                    SELECT  @cames_add = ISNULL(@cames_add,
                                                ( SELECT    cames_add
                                                  FROM      dbo.srvpl_akt_scans t
                                                  WHERE     t.id_akt_scan = @id_akt_scan
                                                ))    
                    SELECT  @date_cames_add = ISNULL(@date_cames_add,
                                                     ( SELECT date_cames_add
                                                       FROM   dbo.srvpl_akt_scans t
                                                       WHERE  t.id_akt_scan = @id_akt_scan
                                                     )) 
                    SELECT  @id_adder = ISNULL(@id_adder,
                                               ( SELECT id_adder
                                                 FROM   dbo.srvpl_akt_scans t
                                                 WHERE  t.id_akt_scan = @id_akt_scan
                                               ))   
                    SELECT  @id_creator = ISNULL(@id_creator,
                                                 ( SELECT   id_creator
                                                   FROM     dbo.srvpl_akt_scans t
                                                   WHERE    t.id_akt_scan = @id_akt_scan
                                                 )) 
                    
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.srvpl_akt_scans
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0
                            WHERE   id_akt_scan = @id_akt_scan
                        END 
                        
                    UPDATE  dbo.srvpl_akt_scans
                    SET     name = @name ,
                            [file_name] = @file_name ,
                            full_path = @full_path ,
                            cames_add = @cames_add ,
                            date_cames_add = @date_cames_add ,
                            id_adder = @id_adder ,
                            id_creator = @id_creator
                    WHERE   id_akt_scan = @id_akt_scan
		
                    
                END
            ELSE
                IF @action = 'closeAktScan'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                  
                        EXEC dbo.sk_service_planing @action = N'updAktScan',
                            @id_akt_scan = @id_akt_scan, @is_close = 1,
                            @id_creator = @id_creator
                    END
	
	/*******TEMPLATE******/
	
	/*
	
	--=================================
	--
	--=================================	
        IF @action = 'ins'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
				INSERT  INTO dbo.srvpl_
            END
            ELSE
            IF @action = 'upd'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                        
                        SELECT  @ = ISNULL(@,
                                                 ( SELECT   
                                                   FROM     dbo.srvpl_ t
                                                   WHERE    t.id_ = @id_
                                                 ))                        
                        
                        UPDATE  dbo.srvpl_
                    SET     
                    WHERE   id = @id
		
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.srvpl_
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0
                            WHERE   id = @id
                        END 
				END
				ELSE
                IF @action = 'close'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                  
                        EXEC dbo.sk_service_planing @action = N'upd',
							@id = @id,
                            @is_close = 1, @id_creator = @id_creator
                    END
                    
        */
    END
