
-- =============================================
-- Author:		Anton Rekhov
-- Create date: 21.05.2014
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[sk_zip_claims]
    @action NVARCHAR(50) ,
    @sp_test BIT = NULL --переменная для тестирования
    ,
    @id_user INT = NULL ,
    @id_device INT = NULL ,
    @id_claim INT = NULL ,
    @serial_num NVARCHAR(50) = NULL ,
    @device_model NVARCHAR(150) = NULL ,
    @contractor NVARCHAR(150) = NULL ,
    @city NVARCHAR(150) = NULL ,
    @address NVARCHAR(150) = NULL ,
    @counter INT = NULL ,
    @id_engeneer_conclusion INT = NULL ,
    @id_claim_state INT = NULL ,
    @request_num NVARCHAR(50) = NULL ,
    @descr NVARCHAR(MAX) = NULL ,
    @id_engeneer INT = NULL ,
    @id_creator INT = NULL ,
    @is_close BIT = 0 ,
    @catalog_num NVARCHAR(50) = NULL ,
    @id_claim_unit INT = NULL ,
    @name NVARCHAR(150) = NULL ,
    @count INT = NULL ,
    @nomenclature_num NVARCHAR(50) = NULL ,
    @price_in DECIMAL(10, 2) = NULL ,
    @price_out DECIMAL(10, 2) = NULL ,
    @id_contractor INT = NULL ,
    @id_city INT = NULL ,
    @id_manager INT = NULL ,
    @id_service_admin INT = NULL ,
    @id_operator INT = NULL ,
    @service_desk_num NVARCHAR(50) = NULL ,
    @counter_colour INT = NULL ,
    @cancel_comment NVARCHAR(500) = NULL ,
    @object_name NVARCHAR(150) = NULL ,
    @waybill_num NVARCHAR(50) = NULL ,
    @delivery_time NVARCHAR(50) = NULL ,
    @filter NVARCHAR(250) = NULL ,
    @id_user_filter INT = NULL ,
    @contract_num NVARCHAR(50) = NULL ,
    @contract_type NVARCHAR(50) = NULL ,
    @et_state NVARCHAR(100) = NULL ,
    @et_waybill_state NVARCHAR(100) = NULL ,
    @id_et_way_claim_state INT = NULL ,
    @contractor_sd_num NVARCHAR(50) = NULL ,
    @id_zip_group INT = NULL ,
    @order_num INT = NULL ,
    @id_zip_group2cat_num INT = NULL ,
    @colour NVARCHAR(6) = NULL ,
    @id_claim_state_change INT = NULL ,
    @date_change DATETIME = NULL ,
    @id_claim_unit_info INT = NULL ,
    @no_nomenclature_num BIT = NULL ,
    @nomenclature_claim_num NVARCHAR(50) = NULL ,
    @price_request INT = NULL ,
    @id_supply_man INT = NULL ,
    @price_rur DECIMAL(10, 2) = NULL ,
    @price_usd DECIMAL(10, 2) = NULL ,
    @price_eur DECIMAL(10, 2) = NULL ,
    @load_num INT = NULL ,
    @id_srvpl_contract INT = NULL ,
    @id_contract_spec_price INT = NULL ,
    @id_nomenclature INT = NULL ,
    @price DECIMAL(10, 2) = NULL ,
    @nomenclature_name NVARCHAR(150) = NULL ,
    @id_claim_state_from INT = NULL ,
    @id_claim_state_to INT = NULL ,
    @et_plan_came_date NVARCHAR(50) = NULL ,
    @id_resp_supply INT = NULL ,
    @id_manager2operator INT = NULL,
    @is_return BIT = NULL
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
            @def_id_claim_state INT

	/****===DEFAULT VALUES===****/
        SET @def_dattim2 = '3.3.3333'
        SET @def_enabled = 1
        SET @def_order_num = 500
        SET @def_price = 0
        SELECT  @def_id_claim_state = id_claim_state
        FROM    dbo.zipcl_claim_states cs
        WHERE   cs.enabled = 1
                AND LOWER(cs.sys_name) = LOWER('NEW')
    /*/>*/

	--/>
        IF @action NOT LIKE 'get%'
            BEGIN
		--<Сохраняем в лог список параметров
                SELECT TOP 1
                        @id_program = id_program
                FROM    programs p
                WHERE   p.enabled = 1
                        AND LOWER(p.sys_name) = LOWER('SERVICEZIPCLAIM')

                SELECT  @log_params = CASE WHEN @action IS NULL THEN ''
                                           ELSE ' @action='
                                                + CONVERT(NVARCHAR, @action)
                                      END + CASE WHEN @sp_test IS NULL THEN ''
                                                 ELSE ' @sp_test='
                                                      + CONVERT(NVARCHAR, @sp_test)
                                            END
                        + CASE WHEN @id_user IS NULL THEN ''
                               ELSE ' @id_user='
                                    + CONVERT(NVARCHAR(MAX), @id_user)
                          END + CASE WHEN @id_device IS NULL THEN ''
                                     ELSE ' @id_device='
                                          + CONVERT(NVARCHAR(MAX), @id_device)
                                END + CASE WHEN @id_claim IS NULL THEN ''
                                           ELSE ' @id_claim='
                                                + CONVERT(NVARCHAR(MAX), @id_claim)
                                      END
                        + CASE WHEN @serial_num IS NULL THEN ''
                               ELSE ' @serial_num='
                                    + CONVERT(NVARCHAR(MAX), @serial_num)
                          END + CASE WHEN @device_model IS NULL THEN ''
                                     ELSE ' @device_model='
                                          + CONVERT(NVARCHAR(MAX), @device_model)
                                END + CASE WHEN @contractor IS NULL THEN ''
                                           ELSE ' @contractor='
                                                + CONVERT(NVARCHAR(MAX), @contractor)
                                      END + CASE WHEN @city IS NULL THEN ''
                                                 ELSE ' @city='
                                                      + CONVERT(NVARCHAR(MAX), @city)
                                            END
                        + CASE WHEN @address IS NULL THEN ''
                               ELSE ' @address='
                                    + CONVERT(NVARCHAR(MAX), @address)
                          END + CASE WHEN @counter IS NULL THEN ''
                                     ELSE ' @counter='
                                          + CONVERT(NVARCHAR(MAX), @counter)
                                END
                        + CASE WHEN @id_engeneer_conclusion IS NULL THEN ''
                               ELSE ' @id_engeneer_conclusion='
                                    + CONVERT(NVARCHAR(MAX), @id_engeneer_conclusion)
                          END + CASE WHEN @id_claim_state IS NULL THEN ''
                                     ELSE ' @id_claim_state='
                                          + CONVERT(NVARCHAR(MAX), @id_claim_state)
                                END + CASE WHEN @request_num IS NULL THEN ''
                                           ELSE ' @request_num='
                                                + CONVERT(NVARCHAR(MAX), @request_num)
                                      END + CASE WHEN @descr IS NULL THEN ''
                                                 ELSE ' @descr='
                                                      + CONVERT(NVARCHAR(MAX), @descr)
                                            END
                        + CASE WHEN @id_engeneer IS NULL THEN ''
                               ELSE ' @id_engeneer='
                                    + CONVERT(NVARCHAR(MAX), @id_engeneer)
                          END + CASE WHEN @id_creator IS NULL THEN ''
                                     ELSE ' @id_creator='
                                          + CONVERT(NVARCHAR(MAX), @id_creator)
                                END + CASE WHEN @is_close IS NULL THEN ''
                                           ELSE ' @is_close='
                                                + CONVERT(NVARCHAR(MAX), @is_close)
                                      END
                        + CASE WHEN @catalog_num IS NULL THEN ''
                               ELSE ' @catalog_num='
                                    + CONVERT(NVARCHAR(MAX), @catalog_num)
                          END + CASE WHEN @id_claim_unit IS NULL THEN ''
                                     ELSE ' @id_claim_unit='
                                          + CONVERT(NVARCHAR(MAX), @id_claim_unit)
                                END + CASE WHEN @name IS NULL THEN ''
                                           ELSE ' @name='
                                                + CONVERT(NVARCHAR(MAX), @name)
                                      END + CASE WHEN @count IS NULL THEN ''
                                                 ELSE ' @count='
                                                      + CONVERT(NVARCHAR(MAX), @count)
                                            END
                        + CASE WHEN @nomenclature_num IS NULL THEN ''
                               ELSE ' @nomenclature_num='
                                    + CONVERT(NVARCHAR(MAX), @nomenclature_num)
                          END + CASE WHEN @price_in IS NULL THEN ''
                                     ELSE ' @price_in='
                                          + CONVERT(NVARCHAR(MAX), @price_in)
                                END + CASE WHEN @price_out IS NULL THEN ''
                                           ELSE ' @price_out='
                                                + CONVERT(NVARCHAR(MAX), @price_out)
                                      END
                        + CASE WHEN @id_contractor IS NULL THEN ''
                               ELSE ' @id_contractor='
                                    + CONVERT(NVARCHAR(MAX), @id_contractor)
                          END + CASE WHEN @id_city IS NULL THEN ''
                                     ELSE ' @id_city='
                                          + CONVERT(NVARCHAR(MAX), @id_city)
                                END + CASE WHEN @id_manager IS NULL THEN ''
                                           ELSE ' @id_manager='
                                                + CONVERT(NVARCHAR(MAX), @id_manager)
                                      END
                        + CASE WHEN @id_service_admin IS NULL THEN ''
                               ELSE ' @id_service_admin='
                                    + CONVERT(NVARCHAR(MAX), @id_service_admin)
                          END + CASE WHEN @id_operator IS NULL THEN ''
                                     ELSE ' @id_operator='
                                          + CONVERT(NVARCHAR(MAX), @id_operator)
                                END
                        + CASE WHEN @service_desk_num IS NULL THEN ''
                               ELSE ' @service_desk_num='
                                    + CONVERT(NVARCHAR(MAX), @service_desk_num)
                          END + CASE WHEN @counter_colour IS NULL THEN ''
                                     ELSE ' @counter_colour='
                                          + CONVERT(NVARCHAR(MAX), @counter_colour)
                                END
                        + CASE WHEN @cancel_comment IS NULL THEN ''
                               ELSE ' @cancel_comment='
                                    + CONVERT(NVARCHAR(MAX), @cancel_comment)
                          END + CASE WHEN @object_name IS NULL THEN ''
                                     ELSE ' @object_name='
                                          + CONVERT(NVARCHAR(MAX), @object_name)
                                END + CASE WHEN @waybill_num IS NULL THEN ''
                                           ELSE ' @waybill_num='
                                                + CONVERT(NVARCHAR(MAX), @waybill_num)
                                      END
                        + CASE WHEN @delivery_time IS NULL THEN ''
                               ELSE ' @delivery_time='
                                    + CONVERT(NVARCHAR(MAX), @delivery_time)
                          END + CASE WHEN @filter IS NULL THEN ''
                                     ELSE ' @filter='
                                          + CONVERT(NVARCHAR(MAX), @filter)
                                END
                        + CASE WHEN @id_user_filter IS NULL THEN ''
                               ELSE ' @id_user_filter='
                                    + CONVERT(NVARCHAR(MAX), @id_user_filter)
                          END + CASE WHEN @contract_num IS NULL THEN ''
                                     ELSE ' @contract_num='
                                          + CONVERT(NVARCHAR(MAX), @contract_num)
                                END + CASE WHEN @contract_type IS NULL THEN ''
                                           ELSE ' @contract_type='
                                                + CONVERT(NVARCHAR(MAX), @contract_type)
                                      END
                        + CASE WHEN @et_state IS NULL THEN ''
                               ELSE ' @et_state='
                                    + CONVERT(NVARCHAR(MAX), @et_state)
                          END + CASE WHEN @et_waybill_state IS NULL THEN ''
                                     ELSE ' @et_waybill_state='
                                          + CONVERT(NVARCHAR(MAX), @et_waybill_state)
                                END
                        + CASE WHEN @id_et_way_claim_state IS NULL THEN ''
                               ELSE ' @id_et_way_claim_state='
                                    + CONVERT(NVARCHAR(MAX), @id_et_way_claim_state)
                          END + CASE WHEN @contractor_sd_num IS NULL THEN ''
                                     ELSE ' @contractor_sd_num='
                                          + CONVERT(NVARCHAR(MAX), @contractor_sd_num)
                                END + CASE WHEN @id_zip_group IS NULL THEN ''
                                           ELSE ' @id_zip_group='
                                                + CONVERT(NVARCHAR(MAX), @id_zip_group)
                                      END
                        + CASE WHEN @order_num IS NULL THEN ''
                               ELSE ' @order_num='
                                    + CONVERT(NVARCHAR(MAX), @order_num)
                          END
                        + CASE WHEN @id_zip_group2cat_num IS NULL THEN ''
                               ELSE ' @id_zip_group2cat_num='
                                    + CONVERT(NVARCHAR(MAX), @id_zip_group2cat_num)
                          END + CASE WHEN @colour IS NULL THEN ''
                                     ELSE ' @colour='
                                          + CONVERT(NVARCHAR(MAX), @colour)
                                END
                        + CASE WHEN @id_claim_state_change IS NULL THEN ''
                               ELSE ' @id_claim_state_change='
                                    + CONVERT(NVARCHAR(MAX), @id_claim_state_change)
                          END + CASE WHEN @date_change IS NULL THEN ''
                                     ELSE ' @date_change='
                                          + CONVERT(NVARCHAR(MAX), @date_change)
                                END
                        + CASE WHEN @id_claim_unit_info IS NULL THEN ''
                               ELSE ' @id_claim_unit_info='
                                    + CONVERT(NVARCHAR(MAX), @id_claim_unit_info)
                          END + CASE WHEN @no_nomenclature_num IS NULL THEN ''
                                     ELSE ' @no_nomenclature_num='
                                          + CONVERT(NVARCHAR(MAX), @no_nomenclature_num)
                                END
                        + CASE WHEN @nomenclature_claim_num IS NULL THEN ''
                               ELSE ' @nomenclature_claim_num='
                                    + CONVERT(NVARCHAR(MAX), @nomenclature_claim_num)
                          END + CASE WHEN @price_request IS NULL THEN ''
                                     ELSE ' @price_request='
                                          + CONVERT(NVARCHAR(MAX), @price_request)
                                END + CASE WHEN @id_supply_man IS NULL THEN ''
                                           ELSE ' @id_supply_man='
                                                + CONVERT(NVARCHAR(MAX), @id_supply_man)
                                      END
                        + CASE WHEN @price_rur IS NULL THEN ''
                               ELSE ' @price_rur='
                                    + CONVERT(NVARCHAR(MAX), @price_rur)
                          END + CASE WHEN @price_usd IS NULL THEN ''
                                     ELSE ' @price_usd='
                                          + CONVERT(NVARCHAR(MAX), @price_usd)
                                END + CASE WHEN @price_eur IS NULL THEN ''
                                           ELSE ' @price_eur='
                                                + CONVERT(NVARCHAR(MAX), @price_eur)
                                      END
                        + CASE WHEN @load_num IS NULL THEN ''
                               ELSE ' @load_num='
                                    + CONVERT(NVARCHAR(MAX), @load_num)
                          END
                        + CASE WHEN @id_contract_spec_price IS NULL THEN ''
                               ELSE ' @id_contract_spec_price='
                                    + CONVERT(NVARCHAR(MAX), @id_contract_spec_price)
                          END + CASE WHEN @id_srvpl_contract IS NULL THEN ''
                                     ELSE ' @id_srvpl_contract='
                                          + CONVERT(NVARCHAR(MAX), @id_srvpl_contract)
                                END
                        + CASE WHEN @id_nomenclature IS NULL THEN ''
                               ELSE ' @id_nomenclature='
                                    + CONVERT(NVARCHAR(MAX), @id_nomenclature)
                          END + CASE WHEN @price IS NULL THEN ''
                                     ELSE ' @price='
                                          + CONVERT(NVARCHAR(MAX), @price)
                                END
                        + CASE WHEN @nomenclature_name IS NULL THEN ''
                               ELSE ' @nomenclature_name='
                                    + CONVERT(NVARCHAR(MAX), @nomenclature_name)
                          END + CASE WHEN @id_claim_state_from IS NULL THEN ''
                                     ELSE ' @id_claim_state_from='
                                          + CONVERT(NVARCHAR(MAX), @id_claim_state_from)
                                END
                        + CASE WHEN @id_claim_state_to IS NULL THEN ''
                               ELSE ' @id_claim_state_to='
                                    + CONVERT(NVARCHAR(MAX), @id_claim_state_to)
                          END + CASE WHEN @et_plan_came_date IS NULL THEN ''
                                     ELSE ' @et_plan_came_date='
                                          + CONVERT(NVARCHAR(MAX), @et_plan_came_date)
                                END
                        + CASE WHEN @id_resp_supply IS NULL THEN ''
                               ELSE ' @id_resp_supply='
                                    + CONVERT(NVARCHAR(MAX), @id_resp_supply)
                          END + CASE WHEN @id_manager2operator IS NULL THEN ''
                                     ELSE ' @id_manager2operator='
                                          + CONVERT(NVARCHAR(MAX), @id_manager2operator)
                                END  + CASE WHEN @is_return IS NULL THEN ''
                                     ELSE ' @is_return='
                                          + CONVERT(NVARCHAR(MAX), @is_return)
                                END
                          
                                      
                                      
                EXEC sk_log @action = 'insLog', @proc_name = 'sk_zip_claims',
                    @id_program = @id_program, @params = @log_params,
                    @descr = @log_descr
			--/>
            END

	--=================================
	--Claims
	--=================================	
        IF @action = 'insClaim'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                INSERT  INTO dbo.zipcl_zip_claims
                        ( id_device ,
                          serial_num ,
                          device_model ,
                          contractor ,
                          city ,
                          address ,
                          counter ,
                          id_engeneer_conclusion ,
                          id_claim_state ,
                          request_num ,
                          descr ,
                          id_engeneer ,
                          id_creator ,
                          id_contractor ,
                          id_city ,
                          id_manager ,
                          id_operator ,
                          id_service_admin ,
                          dattim1 ,
                          dattim2 ,
                          enabled ,
                          old_id_claim ,
                          service_desk_num ,
                          counter_colour ,
                          cancel_comment ,
                          [object_name] ,
                          waybill_num ,
                          contract_num ,
                          contract_type ,
                          et_state ,
                          et_waybill_state ,
                          id_et_way_claim_state ,
                          contractor_sd_num ,
                          et_plan_came_date
                        )
                VALUES  ( @id_device , -- id_device - int
                          @serial_num , -- serial_num - nvarchar(50)
                          @device_model , -- device_model - nvarchar(150)
                          @contractor , -- contractor - nvarchar(150)
                          @city , -- city - nvarchar(150)
                          @address , -- address - nvarchar(150)
                          @counter , -- counter - int
                          @id_engeneer_conclusion , -- id_engeneer_conclusion - int
                          @id_claim_state , -- id_claim_state - int
                          @request_num , -- request_num - nvarchar(50)
                          @descr , -- descr - nvarchar(max)
                          @id_engeneer ,
                          @id_creator , -- id_creator - int
                          @id_contractor ,
                          @id_city ,
                          @id_manager ,
                          @id_operator ,
                          @id_service_admin ,
                          GETDATE() , -- dattim1 - datetime
                          @def_dattim2 , -- dattim2 - datetime
                          @def_enabled , -- enabled - bit
                          NULL ,
                          @service_desk_num ,
                          @counter_colour ,
                          @cancel_comment ,
                          @object_name ,
                          @waybill_num ,
                          @contract_num ,
                          @contract_type ,
                          @et_state ,
                          @et_waybill_state ,
                          @id_et_way_claim_state ,
                          @contractor_sd_num ,
                          @et_plan_came_date
                        )                        
		        
                SELECT  @id_claim = @@IDENTITY
		        
                RETURN @id_claim
            END
        ELSE
            IF @action = 'updClaim'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                
                --Храним историю
                    INSERT  INTO dbo.zipcl_zip_claims
                            ( id_device ,
                              serial_num ,
                              device_model ,
                              contractor ,
                              city ,
                              address ,
                              counter ,
                              id_engeneer_conclusion ,
                              id_claim_state ,
                              request_num ,
                              descr ,
                              id_engeneer ,
                              id_creator ,
                              id_contractor ,
                              id_city ,
                              id_manager ,
                              id_operator ,
                              id_service_admin ,
                              dattim1 ,
                              dattim2 ,
                              enabled ,
                              old_id_claim ,
                              service_desk_num ,
                              counter_colour ,
                              cancel_comment ,
                              [object_name] ,
                              waybill_num ,
                              contract_num ,
                              contract_type ,
                              et_state ,
                              et_waybill_state ,
                              id_et_way_claim_state ,
                              contractor_sd_num ,
                              et_plan_came_date
                            )
                            SELECT  id_device ,
                                    serial_num ,
                                    device_model ,
                                    contractor ,
                                    city ,
                                    address ,
                                    counter ,
                                    id_engeneer_conclusion ,
                                    id_claim_state ,
                                    request_num ,
                                    descr ,
                                    id_engeneer ,
                                    id_creator ,
                                    id_contractor ,
                                    id_city ,
                                    id_manager ,
                                    id_operator ,
                                    id_service_admin ,
                                    ISNULL(( SELECT TOP 1
                                                    cc.dattim2
                                             FROM   dbo.zipcl_zip_claims cc
                                             WHERE  cc.old_id_claim = c.id_claim
                                             ORDER BY cc.id_claim DESC
                                           ), dattim1) ,
                                    GETDATE() ,
                                    0 ,
                                    id_claim ,
                                    service_desk_num ,
                                    counter_colour ,
                                    cancel_comment ,
                                    [object_name] ,
                                    waybill_num ,
                                    contract_num ,
                                    contract_type ,
                                    et_state ,
                                    et_waybill_state ,
                                    id_et_way_claim_state ,
                                    contractor_sd_num ,
                                    et_plan_came_date
                            FROM    dbo.zipcl_zip_claims c
                            WHERE   c.id_claim = @id_claim
	
                    SELECT  @id_device = ISNULL(@id_device,
                                                ( SELECT    id_device
                                                  FROM      zipcl_zip_claims c
                                                  WHERE     c.id_claim = @id_claim
                                                ))
                    SELECT  @serial_num = ISNULL(@serial_num,
                                                 ( SELECT   serial_num
                                                   FROM     zipcl_zip_claims c
                                                   WHERE    c.id_claim = @id_claim
                                                 ))
                    SELECT  @device_model = ISNULL(@device_model,
                                                   ( SELECT device_model
                                                     FROM   zipcl_zip_claims c
                                                     WHERE  c.id_claim = @id_claim
                                                   ))
                    SELECT  @contractor = ISNULL(@contractor,
                                                 ( SELECT   contractor
                                                   FROM     zipcl_zip_claims c
                                                   WHERE    c.id_claim = @id_claim
                                                 ))
						
                    SELECT  @city = ISNULL(@city,
                                           ( SELECT city
                                             FROM   zipcl_zip_claims c
                                             WHERE  c.id_claim = @id_claim
                                           ))
                    SELECT  @address = ISNULL(@address,
                                              ( SELECT  address
                                                FROM    zipcl_zip_claims c
                                                WHERE   c.id_claim = @id_claim
                                              ))
                    SELECT  @counter = ISNULL(@counter,
                                              ( SELECT  counter
                                                FROM    zipcl_zip_claims c
                                                WHERE   c.id_claim = @id_claim
                                              ))
                    SELECT  @id_engeneer_conclusion = ISNULL(@id_engeneer_conclusion,
                                                             ( SELECT
                                                              id_engeneer_conclusion
                                                              FROM
                                                              zipcl_zip_claims c
                                                              WHERE
                                                              c.id_claim = @id_claim
                                                             ))                          
                    SELECT  @id_claim_state = ISNULL(@id_claim_state,
                                                     ( SELECT id_claim_state
                                                       FROM   zipcl_zip_claims c
                                                       WHERE  c.id_claim = @id_claim
                                                     ))
                    SELECT  @request_num = ISNULL(@request_num,
                                                  ( SELECT  request_num
                                                    FROM    zipcl_zip_claims c
                                                    WHERE   c.id_claim = @id_claim
                                                  ))  
                    SELECT  @descr = ISNULL(@descr,
                                            ( SELECT    descr
                                              FROM      zipcl_zip_claims c
                                              WHERE     c.id_claim = @id_claim
                                            ))
                    SELECT  @id_engeneer = ISNULL(@id_engeneer,
                                                  ( SELECT  id_engeneer
                                                    FROM    zipcl_zip_claims c
                                                    WHERE   c.id_claim = @id_claim
                                                  ))
                    SELECT  @id_creator = ISNULL(@id_creator,
                                                 ( SELECT   id_creator
                                                   FROM     zipcl_zip_claims c
                                                   WHERE    c.id_claim = @id_claim
                                                 ))   
                    SELECT  @id_contractor = ISNULL(@id_contractor,
                                                    ( SELECT  id_contractor
                                                      FROM    zipcl_zip_claims c
                                                      WHERE   c.id_claim = @id_claim
                                                    ))   
                    SELECT  @id_city = ISNULL(@id_city,
                                              ( SELECT  id_city
                                                FROM    zipcl_zip_claims c
                                                WHERE   c.id_claim = @id_claim
                                              )) 
                    SELECT  @id_manager = ISNULL(@id_manager,
                                                 ( SELECT   id_manager
                                                   FROM     zipcl_zip_claims c
                                                   WHERE    c.id_claim = @id_claim
                                                 )) 
                    SELECT  @id_operator = ISNULL(@id_operator,
                                                  ( SELECT  id_operator
                                                    FROM    zipcl_zip_claims c
                                                    WHERE   c.id_claim = @id_claim
                                                  )) 
                    SELECT  @id_service_admin = ISNULL(@id_service_admin,
                                                       ( SELECT
                                                              id_service_admin
                                                         FROM zipcl_zip_claims c
                                                         WHERE
                                                              c.id_claim = @id_claim
                                                       ))  
                    SELECT  @service_desk_num = ISNULL(@service_desk_num,
                                                       ( SELECT
                                                              service_desk_num
                                                         FROM zipcl_zip_claims c
                                                         WHERE
                                                              c.id_claim = @id_claim
                                                       )) 
                    SELECT  @counter_colour = ISNULL(@counter_colour,
                                                     ( SELECT counter_colour
                                                       FROM   zipcl_zip_claims c
                                                       WHERE  c.id_claim = @id_claim
                                                     ))  
                                                       
                    SELECT  @cancel_comment = ISNULL(@cancel_comment,
                                                     ( SELECT cancel_comment
                                                       FROM   zipcl_zip_claims c
                                                       WHERE  c.id_claim = @id_claim
                                                     ))  
                                                     
                    SELECT  @object_name = ISNULL(@object_name,
                                                  ( SELECT  [object_name]
                                                    FROM    zipcl_zip_claims c
                                                    WHERE   c.id_claim = @id_claim
                                                  )) 
                                                  
                    SELECT  @waybill_num = ISNULL(@waybill_num,
                                                  ( SELECT  waybill_num
                                                    FROM    zipcl_zip_claims c
                                                    WHERE   c.id_claim = @id_claim
                                                  )) 
                    SELECT  @contract_num = ISNULL(@contract_num,
                                                   ( SELECT contract_num
                                                     FROM   zipcl_zip_claims c
                                                     WHERE  c.id_claim = @id_claim
                                                   )) 
                                                  
                    SELECT  @contract_type = ISNULL(@contract_type,
                                                    ( SELECT  contract_type
                                                      FROM    zipcl_zip_claims c
                                                      WHERE   c.id_claim = @id_claim
                                                    )) 
                    SELECT  @et_state = ISNULL(@et_state,
                                               ( SELECT et_state
                                                 FROM   zipcl_zip_claims c
                                                 WHERE  c.id_claim = @id_claim
                                               )) 
                    SELECT  @et_waybill_state = ISNULL(@et_waybill_state,
                                                       ( SELECT
                                                              et_waybill_state
                                                         FROM zipcl_zip_claims c
                                                         WHERE
                                                              c.id_claim = @id_claim
                                                       )) 
                    SELECT  @id_et_way_claim_state = ISNULL(@id_et_way_claim_state,
                                                            ( SELECT
                                                              id_et_way_claim_state
                                                              FROM
                                                              zipcl_zip_claims c
                                                              WHERE
                                                              c.id_claim = @id_claim
                                                            )) 
                    SELECT  @contractor_sd_num = ISNULL(@contractor_sd_num,
                                                        ( SELECT
                                                              contractor_sd_num
                                                          FROM
                                                              zipcl_zip_claims c
                                                          WHERE
                                                              c.id_claim = @id_claim
                                                        )) 
                    SELECT  @et_plan_came_date = ISNULL(@et_plan_came_date,
                                                        ( SELECT
                                                              et_plan_came_date
                                                          FROM
                                                              zipcl_zip_claims c
                                                          WHERE
                                                              c.id_claim = @id_claim
                                                        ))  
                                               
					--Скрываем запись
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.zipcl_zip_claims
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0 ,
                                    id_creator = @id_creator
                            WHERE   id_claim = @id_claim
                            
                            RETURN @id_claim
                        END
					
                    UPDATE  dbo.zipcl_zip_claims
                    SET     id_device = @id_device ,
                            serial_num = @serial_num ,
                            device_model = @device_model ,
                            contractor = @contractor ,
                            city = @city ,
                            address = @address ,
                            counter = @counter ,
                            id_engeneer_conclusion = @id_engeneer_conclusion ,
                            id_claim_state = @id_claim_state ,
                            request_num = @request_num ,
                            descr = @descr ,
                            id_engeneer = @id_engeneer ,
                            id_creator = @id_creator ,
                            id_contractor = @id_contractor ,
                            id_city = @id_city ,
                            id_manager = @id_manager ,
                            id_operator = @id_operator ,
                            id_service_admin = @id_service_admin ,
                            service_desk_num = @service_desk_num ,
                            counter_colour = @counter_colour ,
                            cancel_comment = @cancel_comment ,
                            [OBJECT_NAME] = @object_name ,
                            waybill_num = @waybill_num ,
                            contract_num = @contract_num ,
                            contract_type = @contract_type ,
                            et_state = @et_state ,
                            et_waybill_state = @et_waybill_state ,
                            id_et_way_claim_state = @id_et_way_claim_state ,
                            contractor_sd_num = @contractor_sd_num ,
                            et_plan_came_date = @et_plan_came_date
                    WHERE   id_claim = @id_claim
                        
                    RETURN @id_claim
                END
        IF @action = 'closeClaim'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
            
                EXEC dbo.sk_zip_claims @action = N'updClaim',
                    @id_claim = @id_claim, @id_creator = @id_creator,
                    @is_close = 1				
            END
	
	--=================================
	--ClaimUnits
	--=================================	
        IF @action = 'insClaimUnit'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
				
                INSERT  INTO dbo.zipcl_claim_units
                        ( id_claim ,
                          catalog_num ,
                          name ,
                          count ,
                          nomenclature_num ,
                          price_in ,
                          price_out ,
                          dattim1 ,
                          dattim2 ,
                          enabled ,
                          id_creator ,
                          delivery_time ,
                          no_nomenclature_num ,
                          nomenclature_claim_num ,
                          price_request ,
                          id_supply_man ,
                          id_resp_supply,
                          is_return
                        )
                VALUES  ( @id_claim , -- id_claim - int
                          @catalog_num , -- catalog_num - nvarchar(50)
                          @name , -- name - nvarchar(150)
                          @count , -- count - int
                          @nomenclature_num , -- nomenclature_num - nvarchar(50)
                          @price_in , -- price_in - decimal
                          @price_out , -- price_out - decimal
                          GETDATE() , -- dattim1 - datetime
                          @def_dattim2 , -- dattim2 - datetime
                          @def_enabled ,-- enabled - bit
                          @id_creator ,
                          @delivery_time ,
                          @no_nomenclature_num ,
                          @nomenclature_claim_num ,
                          @price_request ,
                          @id_supply_man ,
                          @id_resp_supply,
                          @is_return
                        )
                        		                
                SELECT  @id_claim_unit = @@IDENTITY
		        
                RETURN @id_claim_unit
            END
        ELSE
            IF @action = 'updClaimUnit'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END		
                    
                
					--Храним историю
                    INSERT  INTO dbo.zipcl_claim_units
                            ( id_claim ,
                              catalog_num ,
                              name ,
                              count ,
                              nomenclature_num ,
                              price_in ,
                              price_out ,
                              dattim1 ,
                              dattim2 ,
                              enabled ,
                              id_creator ,
                              delivery_time ,
                              no_nomenclature_num ,
                              nomenclature_claim_num ,
                              price_request ,
                              id_supply_man ,
                              old_id_claim_unit ,
                              id_resp_supply,
                              is_return
                            )
                            SELECT  id_claim ,
                                    catalog_num ,
                                    name ,
                                    count ,
                                    nomenclature_num ,
                                    price_in ,
                                    price_out ,
                                    ISNULL(( SELECT TOP 1
                                                    cuu.dattim2
                                             FROM   dbo.zipcl_claim_units cuu
                                             WHERE  cuu.old_id_claim_unit = cu.id_claim_unit
                                             ORDER BY cuu.id_claim_unit DESC
                                           ), dattim1) ,
                                    GETDATE() ,
                                    0 ,
                                    id_creator ,
                                    delivery_time ,
                                    no_nomenclature_num ,
                                    nomenclature_claim_num ,
                                    price_request ,
                                    id_supply_man ,
                                    id_claim_unit ,
                                    id_resp_supply,
                                    is_return
                            FROM    zipcl_claim_units cu
                            WHERE   id_claim_unit = @id_claim_unit
                
                    SELECT  @id_claim = ISNULL(@id_claim,
                                               ( SELECT id_claim
                                                 FROM   dbo.zipcl_claim_units cu
                                                 WHERE  cu.id_claim_unit = @id_claim_unit
                                               ))
                                                 
                    SELECT  @catalog_num = ISNULL(@catalog_num,
                                                  ( SELECT  catalog_num
                                                    FROM    dbo.zipcl_claim_units cu
                                                    WHERE   cu.id_claim_unit = @id_claim_unit
                                                  ))
                                                 
                                                                     
                    SELECT  @name = ISNULL(@name,
                                           ( SELECT name
                                             FROM   dbo.zipcl_claim_units cu
                                             WHERE  cu.id_claim_unit = @id_claim_unit
                                           ))
                    SELECT  @count = ISNULL(@count,
                                            ( SELECT    count
                                              FROM      dbo.zipcl_claim_units cu
                                              WHERE     cu.id_claim_unit = @id_claim_unit
                                            ))
                                          
                    SELECT  @nomenclature_num = ISNULL(@nomenclature_num,
                                                       ( SELECT
                                                              nomenclature_num
                                                         FROM dbo.zipcl_claim_units cu
                                                         WHERE
                                                              cu.id_claim_unit = @id_claim_unit
                                                       ))
                                                 
                    SELECT  @price_in = ISNULL(@price_in,
                                               ( SELECT price_in
                                                 FROM   dbo.zipcl_claim_units cu
                                                 WHERE  cu.id_claim_unit = @id_claim_unit
                                               ))
                                                      
                    SELECT  @price_out = ISNULL(@price_out,
                                                ( SELECT    price_out
                                                  FROM      dbo.zipcl_claim_units cu
                                                  WHERE     cu.id_claim_unit = @id_claim_unit
                                                ))
                                                      
                    SELECT  @id_creator = ISNULL(@id_creator,
                                                 ( SELECT   id_creator
                                                   FROM     dbo.zipcl_claim_units cu
                                                   WHERE    cu.id_claim_unit = @id_claim_unit
                                                 ))
                                                 
                    SELECT  @delivery_time = ISNULL(@delivery_time,
                                                    ( SELECT  delivery_time
                                                      FROM    dbo.zipcl_claim_units cu
                                                      WHERE   cu.id_claim_unit = @id_claim_unit
                                                    ))
                    SELECT  @no_nomenclature_num = ISNULL(@no_nomenclature_num,
                                                          ( SELECT
                                                              no_nomenclature_num
                                                            FROM
                                                              dbo.zipcl_claim_units cu
                                                            WHERE
                                                              cu.id_claim_unit = @id_claim_unit
                                                          ))  
                    SELECT  @nomenclature_claim_num = ISNULL(@nomenclature_claim_num,
                                                             ( SELECT
                                                              nomenclature_claim_num
                                                              FROM
                                                              dbo.zipcl_claim_units cu
                                                              WHERE
                                                              cu.id_claim_unit = @id_claim_unit
                                                             )) 
                                                    
                    SELECT  @price_request = ISNULL(@price_request,
                                                    ( SELECT  price_request
                                                      FROM    dbo.zipcl_claim_units cu
                                                      WHERE   cu.id_claim_unit = @id_claim_unit
                                                    ))
                    SELECT  @id_supply_man = ISNULL(@id_supply_man,
                                                    ( SELECT  id_supply_man
                                                      FROM    dbo.zipcl_claim_units cu
                                                      WHERE   cu.id_claim_unit = @id_claim_unit
                                                    ))  
                                                    
                    SELECT  @id_resp_supply = ISNULL(@id_resp_supply,
                                                     ( SELECT id_resp_supply
                                                       FROM   dbo.zipcl_claim_units cu
                                                       WHERE  cu.id_claim_unit = @id_claim_unit
                                                     ))   
                                                     
                     SELECT  @is_return = ISNULL(@is_return,
                                                     ( SELECT is_return
                                                       FROM   dbo.zipcl_claim_units cu
                                                       WHERE  cu.id_claim_unit = @id_claim_unit
                                                     ))                                                                                                  
                                                    
                    --Очищаем поле                      
                    IF @nomenclature_num = 'delete'
                        BEGIN
                            SET @nomenclature_num = NULL
                        END  
                    
                    --Очищаем поле 
                    IF ( @price_in = -9999 )
                        BEGIN
                            SET @price_in = NULL
                        END
                          
                    --Очищаем поле           
                    IF ( @price_out = -9999 )
                        BEGIN
                            SET @price_out = NULL
                        END
                                                 
                                                 --Скрытие записи
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.zipcl_claim_units
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0 
                                    --id_creator = @id_creator
                            WHERE   id_claim_unit = @id_claim_unit
                            
                            RETURN @id_claim_unit
                        END
                                                 
                    UPDATE  dbo.zipcl_claim_units
                    SET     id_claim = @id_claim ,
                            catalog_num = @catalog_num ,
                            name = @name ,
                            count = @count ,
                            nomenclature_num = @nomenclature_num ,
                            price_in = @price_in ,
                            price_out = @price_out ,
                            id_creator = @id_creator ,
                            delivery_time = @delivery_time ,
                            no_nomenclature_num = @no_nomenclature_num ,
                            nomenclature_claim_num = @nomenclature_claim_num ,
                            price_request = @price_request ,
                            id_supply_man = @id_supply_man ,
                            id_resp_supply = @id_resp_supply,
                            is_return = @is_return
                    WHERE   id_claim_unit = @id_claim_unit
		        
                    RETURN @id_claim_unit
                END
            ELSE
                IF @action = 'closeClaimUnit'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                    
                        EXEC dbo.sk_zip_claims @action = N'updClaimUnit',
                            @id_claim_unit = @id_claim_unit,
                            @id_creator = @id_creator, @is_close = 1
					                
                    END
                    
     /*******USER_FILTER******/               
        IF @action = 'insUserFilter'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                INSERT  INTO dbo.zipcl_user_filters
                        ( id_user ,
                          filter ,
                          enabled ,
                          dattim1 ,
                          dattim2
                        )
                VALUES  ( @id_user ,
                          @filter ,
                          1 ,
                          GETDATE() ,
                          '3.3.3333'
                        )
				
                SELECT  @id_user_filter = @@IDENTITY
				
                RETURN @id_user_filter
            END
        ELSE
            IF @action = 'updUserFilter'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                        
                    SELECT  @id_user = ISNULL(@id_user,
                                              ( SELECT  id_user
                                                FROM    dbo.zipcl_user_filters t
                                                WHERE   t.id_user_filter = @id_user_filter
                                              ))
                                                   
                    SELECT  @filter = ISNULL(@filter,
                                             ( SELECT   filter
                                               FROM     dbo.zipcl_user_filters t
                                               WHERE    t.id_user_filter = @id_user_filter
                                             ))
                       
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.zipcl_user_filters
                            SET     enabled = 0 ,
                                    dattim2 = GETDATE()
                            WHERE   id_user_filter = @id_user_filter
                            
                            RETURN @id_user_filter
                        END 
                                                                         
                        
                    UPDATE  dbo.zipcl_user_filters
                    SET     id_user = @id_user ,
                            filter = @filter
                    WHERE   id_user_filter = @id_user_filter
		
                    RETURN @id_user_filter
                END
            ELSE
                IF @action = 'closeUserFilter'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                  
                        EXEC dbo.sk_service_planing @action = N'updUserFilter',
                            @id_user_filter = @id_user_filter, @is_close = 1
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
		
                INSERT  INTO dbo.zipcl_zip_groups
                        ( name ,
                          order_num ,
                          dattim1 ,
                          dattim2 ,
                          enabled ,
                          id_creator ,
                          colour
				        )
                VALUES  ( @name , -- id_user - int
                          @def_order_num ,
                          GETDATE() , -- dattim1 - datetime
                          @def_dattim2 , -- dattim2 - datetime
                          @def_enabled , -- enabled - bit
                          @id_creator ,
                          @colour
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
                                             FROM   dbo.zipcl_zip_groups t
                                             WHERE  t.id_zip_group = @id_zip_group
                                           ))                       
                        
                    --SELECT  @sys_name = ISNULL(@sys_name,
                    --                                  ( SELECT
                    --                                          sys_name
                    --                                    FROM  dbo.zipcl_zip_groups t
                    --                                    WHERE t.id_zip_group = @id_zip_group
                    --                                  ))   
                                                      
                    SELECT  @order_num = ISNULL(@order_num,
                                                ( SELECT    order_num
                                                  FROM      dbo.zipcl_zip_groups t
                                                  WHERE     t.id_zip_group = @id_zip_group
                                                ))  
                    SELECT  @id_creator = ISNULL(@id_creator,
                                                 ( SELECT   id_creator
                                                   FROM     dbo.zipcl_zip_groups t
                                                   WHERE    t.id_zip_group = @id_zip_group
                                                 )) 
                    SELECT  @colour = ISNULL(@colour,
                                             ( SELECT   colour
                                               FROM     dbo.zipcl_zip_groups t
                                               WHERE    t.id_zip_group = @id_zip_group
                                             )) 
                    
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.zipcl_zip_groups
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0
                            WHERE   id_zip_group = @id_zip_group
                        END 
                        
                    UPDATE  dbo.zipcl_zip_groups
                    SET     name = @name ,
                            order_num = @order_num ,
                            id_creator = @id_creator ,
                            colour = @colour
                    WHERE   id_zip_group = @id_zip_group
		
                    
                END
            ELSE
                IF @action = 'closeZipGroup'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                  
                        EXEC dbo.sk_zip_claims @action = N'updZipGroup',
                            @id_zip_group = @id_zip_group, @is_close = 1,
                            @id_creator = @id_creator
                    END
                    
    --=================================
	--ZipGroup2CatNums
	--=================================	
        IF @action = 'insZipGroup2CatNum'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                INSERT  INTO dbo.zipcl_zip_group2cat_nums
                        ( id_zip_group ,
                          catalog_num ,
                          order_num ,
                          dattim1 ,
                          dattim2 ,
                          enabled ,
                          id_creator
				        )
                VALUES  ( @id_zip_group ,
                          @catalog_num ,
                          @def_order_num ,
                          GETDATE() , -- dattim1 - datetime
                          @def_dattim2 , -- dattim2 - datetime
                          @def_enabled , -- enabled - bit
                          @id_creator
				        )
            END
        ELSE
            IF @action = 'updZipGroup2CatNum'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                        
                    SELECT  @id_zip_group = ISNULL(@id_zip_group,
                                                   ( SELECT id_zip_group
                                                     FROM   dbo.zipcl_zip_group2cat_nums t
                                                     WHERE  t.id_zip_group2cat_num = @id_zip_group2cat_num
                                                   ))  
                    SELECT  @catalog_num = ISNULL(@catalog_num,
                                                  ( SELECT  catalog_num
                                                    FROM    dbo.zipcl_zip_group2cat_nums t
                                                    WHERE   t.id_zip_group2cat_num = @id_zip_group2cat_num
                                                  ))                                                         
                        
                    SELECT  @order_num = ISNULL(@order_num,
                                                ( SELECT    order_num
                                                  FROM      dbo.zipcl_zip_group2cat_nums t
                                                  WHERE     t.id_zip_group2cat_num = @id_zip_group2cat_num
                                                ))  
                    SELECT  @id_creator = ISNULL(@id_creator,
                                                 ( SELECT   id_creator
                                                   FROM     dbo.zipcl_zip_group2cat_nums t
                                                   WHERE    t.id_zip_group2cat_num = @id_zip_group2cat_num
                                                 )) 
                    
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.zipcl_zip_group2cat_nums
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0
                            WHERE   id_zip_group2cat_num = @id_zip_group2cat_num
                        END 
                        
                    UPDATE  dbo.zipcl_zip_group2cat_nums
                    SET     id_zip_group = @id_zip_group ,
                            catalog_num = @catalog_num ,
                            order_num = @order_num ,
                            id_creator = @id_creator
                    WHERE   id_zip_group2cat_num = @id_zip_group2cat_num
		
                    
                END
            ELSE
                IF @action = 'closeZipGroup2CatNum'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                  
                        EXEC dbo.sk_zip_claims @action = N'updZipGroup2CatNum',
                            @id_zip_group2cat_num = @id_zip_group2cat_num,
                            @is_close = 1, @id_creator = @id_creator
                    END
                    
    --=================================
	--ClaimStateChange
	--=================================	
        IF @action = 'insClaimStateChange'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                INSERT  INTO dbo.zipcl_claim_state_changes
                        ( id_claim ,
                          id_claim_state ,
                          date_change ,
                          dattim1 ,
                          dattim2 ,
                          enabled ,
                          id_creator ,
                          id_claim_state_from ,
                          id_claim_state_to
				        )
                VALUES  ( @id_claim ,
                          @id_claim_state ,
                          @date_change ,
                          GETDATE() , -- dattim1 - datetime
                          @def_dattim2 , -- dattim2 - datetime
                          @def_enabled , -- enabled - bit
                          @id_creator ,
                          @id_claim_state_from ,
                          @id_claim_state_to
				        )
            END
        ELSE
            IF @action = 'updClaimStateChange'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                    
                    SELECT  @id_claim = ISNULL(@id_claim,
                                               ( SELECT id_claim
                                                 FROM   dbo.zipcl_claim_state_changes t
                                                 WHERE  t.id_claim_state_change = @id_claim_state_change
                                               ))      
                    SELECT  @id_claim_state = ISNULL(@id_claim_state,
                                                     ( SELECT id_claim_state
                                                       FROM   dbo.zipcl_claim_state_changes t
                                                       WHERE  t.id_claim_state_change = @id_claim_state_change
                                                     ))  
                    SELECT  @date_change = ISNULL(@date_change,
                                                  ( SELECT  date_change
                                                    FROM    dbo.zipcl_claim_state_changes t
                                                    WHERE   t.id_claim_state_change = @id_claim_state_change
                                                  ))  
                    SELECT  @id_creator = ISNULL(@id_creator,
                                                 ( SELECT   id_creator
                                                   FROM     dbo.zipcl_claim_state_changes t
                                                   WHERE    t.id_claim_state_change = @id_claim_state_change
                                                 )) 
                    
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.zipcl_claim_state_changes
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0
                            WHERE   id_claim_state_change = @id_claim_state_change
                        END 
                        
                    UPDATE  dbo.zipcl_claim_state_changes
                    SET     id_claim = @id_claim ,
                            id_claim_state = @id_claim_state ,
                            date_change = @date_change ,
                            id_creator = @id_creator
                    WHERE   id_claim_state_change = @id_claim_state_change
		
                    
                END
            ELSE
                IF @action = 'closeClaimStateChange'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                  
                        EXEC dbo.sk_zip_claims @action = N'updClaimStateChange',
                            @id_claim_state_change = @id_claim_state_change,
                            @is_close = 1, @id_creator = @id_creator
                    END
                    
                    --=================================
	--ClaimUnitInfo
	--=================================	
        IF @action = 'insClaimUnitInfo'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                INSERT  INTO dbo.zipcl_claim_unit_infos
                        ( catalog_num ,
                          descr ,
                          dattim1 ,
                          dattim2 ,
                          enabled ,
                          id_creator
				        )
                VALUES  ( @catalog_num ,
                          @descr ,
                          GETDATE() , -- dattim1 - datetime
                          @def_dattim2 , -- dattim2 - datetime
                          @def_enabled , -- enabled - bit
                          @id_creator
				        )
            END
        ELSE
            IF @action = 'updClaimUnitInfo'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                        
                        
                    SELECT  @catalog_num = ISNULL(@catalog_num,
                                                  ( SELECT  catalog_num
                                                    FROM    dbo.zipcl_claim_unit_infos t
                                                    WHERE   t.id_claim_unit_info = @id_claim_unit_info
                                                  ))      
                    SELECT  @descr = ISNULL(@descr,
                                            ( SELECT    descr
                                              FROM      dbo.zipcl_claim_unit_infos t
                                              WHERE     t.id_claim_unit_info = @id_claim_unit_info
                                            ))  
                    SELECT  @id_creator = ISNULL(@id_creator,
                                                 ( SELECT   id_creator
                                                   FROM     dbo.zipcl_claim_unit_infos t
                                                   WHERE    t.id_claim_unit_info = @id_claim_unit_info
                                                 )) 
                    
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.zipcl_claim_unit_infos
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0
                            WHERE   id_claim_unit_info = @id_claim_unit_info
                        END 
                        
                    UPDATE  dbo.zipcl_claim_unit_infos
                    SET     catalog_num = @catalog_num ,
                            descr = @descr ,
                            id_creator = @id_creator
                    WHERE   id_claim_unit_info = @id_claim_unit_info
		
                    
                END
            ELSE
                IF @action = 'closeClaimUnitInfo'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                  
                        EXEC dbo.sk_zip_claims @action = N'updClaimUnitInfo',
                            @id_claim_unit_info = @id_claim_unit_info,
                            @is_close = 1, @id_creator = @id_creator
                    END
                    
	--=================================
	--ClaimUnitStateChange
	--=================================	
        IF @action = 'insClaimUnitStateChange'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                INSERT  INTO dbo.zipcl_claim_unit_state_changes
                        ( id_claim_unit ,
                          id_creator ,
                          id_claim_state ,
                          dattim1 
				        )
                VALUES  ( @id_claim_unit ,
                          @id_creator ,
                          @id_claim_state ,
                          GETDATE()
                        )
            END
    --=================================
	--NomenclaturePrice
	--=================================	
        IF @action = 'insNomenclaturePrice'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                INSERT  INTO dbo.zipcl_nomenclature_price
                        ( load_num ,
                          catalog_num ,
                          nomenclature_num ,
                          name ,
                          price_rur ,
                          price_usd ,
                          price_eur ,
                          dattim1 ,
                          dattim2 ,
                          enabled 
				        )
                VALUES  ( @load_num ,
                          @catalog_num ,
                          @nomenclature_num ,
                          @name ,
                          @price_rur ,
                          @price_usd ,
                          @price_eur ,
                          GETDATE() ,
                          @def_dattim2 ,
                          @def_enabled
                        )
            END
        ELSE
            IF @action = 'closeNomenclaturePriceList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
		
                    UPDATE  zipcl_nomenclature_price
                    SET     ENABLED = 0 ,
                            dattim2 = GETDATE()
                    WHERE   load_num = @load_num
                END
                
     --=================================
	--SrvplContractSpecPrice
	--=================================	
        IF @action = 'insSrvplContractSpecPrice'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                INSERT  INTO dbo.zipcl_srvpl_contract_spec_prices
                        ( id_srvpl_contract ,
                          id_nomenclature ,
                          nomenclature_name ,
                          catalog_num ,
                          price ,
                          dattim1 ,
                          dattim2 ,
                          enabled ,
                          id_creator
				        )
                VALUES  ( @id_srvpl_contract ,
                          @id_nomenclature ,
                          @nomenclature_name ,
                          @catalog_num ,
                          @price ,
                          GETDATE() ,
                          @def_dattim2 ,
                          @def_enabled ,
                          @id_creator
                        )
            END
        ELSE
            IF @action = 'updSrvplContractSpecPrice'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
		
                    SELECT  @id_srvpl_contract = ISNULL(@id_srvpl_contract,
                                                        ( SELECT
                                                              id_srvpl_contract
                                                          FROM
                                                              dbo.zipcl_srvpl_contract_spec_prices t
                                                          WHERE
                                                              t.id_contract_spec_price = @id_contract_spec_price
                                                        ))      
                    SELECT  @id_nomenclature = ISNULL(@id_nomenclature,
                                                      ( SELECT
                                                              id_nomenclature
                                                        FROM  dbo.zipcl_srvpl_contract_spec_prices t
                                                        WHERE t.id_contract_spec_price = @id_contract_spec_price
                                                      ))  
                    SELECT  @nomenclature_name = ISNULL(@nomenclature_name,
                                                        ( SELECT
                                                              nomenclature_name
                                                          FROM
                                                              dbo.zipcl_srvpl_contract_spec_prices t
                                                          WHERE
                                                              t.id_contract_spec_price = @id_contract_spec_price
                                                        ))                                  
                    SELECT  @catalog_num = ISNULL(@catalog_num,
                                                  ( SELECT  catalog_num
                                                    FROM    dbo.zipcl_srvpl_contract_spec_prices t
                                                    WHERE   t.id_contract_spec_price = @id_contract_spec_price
                                                  ))   
                    SELECT  @price = ISNULL(@price,
                                            ( SELECT    id_srvpl_contract
                                              FROM      dbo.zipcl_srvpl_contract_spec_prices t
                                              WHERE     t.id_contract_spec_price = @id_contract_spec_price
                                            ))   
                    SELECT  @id_creator = ISNULL(@id_creator,
                                                 ( SELECT   id_creator
                                                   FROM     dbo.zipcl_srvpl_contract_spec_prices t
                                                   WHERE    t.id_contract_spec_price = @id_contract_spec_price
                                                 ))                              
                    
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.zipcl_srvpl_contract_spec_prices
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0
                            WHERE   id_contract_spec_price = @id_contract_spec_price
                        END 
                        
                    UPDATE  dbo.zipcl_srvpl_contract_spec_prices
                    SET     id_srvpl_contract = @id_srvpl_contract ,
                            id_nomenclature = @id_nomenclature ,
                            nomenclature_name = @nomenclature_name ,
                            catalog_num = @catalog_num ,
                            price = @price ,
                            id_creator = @id_creator
                    WHERE   id_contract_spec_price = @id_contract_spec_price
                END
            ELSE
                IF @action = 'closeSrvplContractSpecPrice'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
		
                        EXEC dbo.sk_zip_claims @action = N'updSrvplContractSpecPrice',
                            @id_contract_spec_price = @id_contract_spec_price,
                            @is_close = 1, @id_creator = @id_creator
                    END
                    
    --=================================
	--Manager2Operator
	--=================================	
	
        IF @action = 'insManager2Operator'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                INSERT  INTO dbo.zipcl_manager2operators
                        ( id_manager ,
                          id_operator ,
                          dattim1 ,
                          dattim2 ,
                          enabled ,
                          id_creator
				        )
                VALUES  ( @id_manager ,
                          @id_operator ,
                          GETDATE() ,
                          @def_dattim2 ,
                          @def_enabled ,
                          @id_creator
                        )
            END
        ELSE
            IF @action = 'updManager2Operator'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
		
                    SELECT  @id_manager = ISNULL(@id_manager,
                                                 ( SELECT   id_manager
                                                   FROM     dbo.zipcl_manager2operators t
                                                   WHERE    t.id_manager2operator = @id_manager2operator
                                                 ))      
                    SELECT  @id_operator = ISNULL(@id_operator,
                                                  ( SELECT  id_operator
                                                    FROM    dbo.zipcl_manager2operators t
                                                    WHERE   t.id_manager2operator = @id_manager2operator
                                                  ))   
                    SELECT  @id_creator = ISNULL(@id_creator,
                                                 ( SELECT   id_creator
                                                   FROM     dbo.zipcl_manager2operators t
                                                   WHERE    t.id_manager2operator = @id_manager2operator
                                                 ))                               
                    
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.zipcl_manager2operators
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0
                            WHERE   id_manager2operator = @id_manager2operator
                        END 
                        
                    UPDATE  dbo.zipcl_manager2operators
                    SET     id_manager = @id_manager ,
                            id_operator = @id_operator ,
                            id_creator = @id_creator
                    WHERE   id_manager2operator = @id_manager2operator
                END
            ELSE
                IF @action = 'closeManager2Operator'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
						
                        UPDATE  dbo.zipcl_manager2operators
                        SET     ENABLED = 0
                        WHERE   ENABLED = 1
                                AND id_manager = @id_manager
						
                        --IF @id_manager2operator IS NULL
                        --    BEGIN
                        --        SELECT TOP 1
                        --                @id_manager2operator = id_manager2operator
                        --        FROM    zipcl_manager2operators
                        --        WHERE   ENABLED = 1
                        --                AND id_manager = @id_manager
                        --                AND id_operator = @id_operator
                        --    END
						
                        --EXEC dbo.sk_zip_claims @action = N'updManager2Operator',
                        --    @id_manager2operator = @id_manager2operator,
                        --    @is_close = 1, @id_creator = @id_creator
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
				
				RETURN @id
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
                        
                         IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.srvpl_
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0
                            WHERE   id = @id
                            
                            RETURN @id
                        END 
                        
                        UPDATE  dbo.srvpl_
                    SET     
                    WHERE   id = @id
		
                   RETURN @id
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
