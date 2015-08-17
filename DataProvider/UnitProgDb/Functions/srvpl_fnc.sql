-- =============================================
-- Author:		Anton Rekhov
-- Create date: 18.03.2014
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[srvpl_fnc]
    (
      @action NVARCHAR(150) ,
      @name NVARCHAR(50) = NULL ,
      @id INT = NULL ,
      @date DATETIME = NULL ,
      @date2 DATETIME = NULL
    )
RETURNS NVARCHAR(MAX)
AS
    BEGIN
        DECLARE @result NVARCHAR(MAX) ,
            @new_line NVARCHAR(10) ,
            @var_int INT
        
        SET @new_line = '<br />'

        IF @action = 'getSettingsValue'
            BEGIN
                SELECT  @result = s.value
                FROM    srvpl_settings s
                WHERE   s.enabled = 1
                        AND LOWER(s.name) = LOWER(@name)	
            END
        ELSE
            IF @action = 'getDeviceTariffPrice'
                BEGIN
                --Получаем общую цену на устройство по тарифу
                    SELECT  @var_int = 
							--ЛОгика тарифа на 21.09.2014 
							--Если (Способ печате = Лазерный картридж) Тариф конечный = Тариф предварительный * 0.9
							--Если (Способ печате = Струйный картридж) Тариф конечный = Тариф предварительный * 0.7
							--Если (Скорость печати > 89) Тариф конечный = Тариф предварительный * 1.5
							--Сделано так что если коэффициент по скорости не 1,5, то ставится 1, так же сделано что если способ печати не лазуер и не струйный, то ставится 1, поэтому условие (CASE WHEN speed_coefficient > 1 THEN speed_coefficient ELSE ctype_coefficient END) вполне подходит на 21.09.2014
                            tariff_pre
                            * ( CASE WHEN speed_coefficient > 1
                                     THEN speed_coefficient
                                     ELSE ctype_coefficient
                                END )
                    FROM    ( SELECT    
										--Тариф предварительный
                                        ISNULL(t.speed_price, 0)
                                        + ISNULL(t.pformat_price, 0)
                                        + ISNULL(t.ptype_price, 0)
                                        + ISNULL(t.age_price, 0)
                                        + ISNULL(t.adf_option_price, 0)
                                        + ISNULL(t.finisher_option_price, 0)
                                        + ISNULL(t.tray_option_price, 0) AS tariff_pre ,
                                        ISNULL(ctype_coefficient, 1) AS ctype_coefficient ,
                                        ISNULL(speed_coefficient, 1) AS speed_coefficient
                              FROM      ( SELECT 
--Скорость
                                                    ( SELECT TOP 1
                                                              price * m.speed
                                                      FROM    srvpl_tariff_features
                                                      WHERE   ENABLED = 1
                                                              AND UPPER(sys_name) = 'SPEED'
                                                    ) AS speed_price ,
--формат печати
                                                    ( SELECT TOP 1
                                                              price
                                                      FROM    srvpl_tariff_features tf
                                                              INNER JOIN dbo.srvpl_device_imprints di ON m.id_device_imprint = di.id_device_imprint
                                                      WHERE   tf.ENABLED = 1
                                                              AND UPPER(tf.sys_name) = UPPER(di.sys_name)
                                                    ) AS pformat_price ,
--Тип печати
                                                    ( SELECT TOP 1
                                                              price
                                                      FROM    srvpl_tariff_features tf
                                                              INNER JOIN dbo.srvpl_print_types pt ON m.id_print_type = pt.id_print_type
                                                      WHERE   tf.ENABLED = 1
                                                              AND UPPER(tf.sys_name) = UPPER(pt.sys_name)
                                                    ) AS ptype_price ,
--Возраст
                                                    ( SELECT TOP 1
                                                              price
                                                      FROM    srvpl_tariff_features tf
                                                      WHERE   tf.ENABLED = 1
                                                              AND UPPER(tf.sys_name) = 'AGE'
                                                              + CONVERT(NVARCHAR(10), CASE
                                                              WHEN d.age > 5
                                                              THEN 5
                                                              ELSE CASE
                                                              WHEN d.age IS NULL
                                                              THEN 3
                                                              ELSE d.age
                                                              END
                                                              END)
                                                    ) AS age_price ,
--Опция ADF
                                                    ( SELECT TOP 1
                                                              price
                                                      FROM    srvpl_tariff_features tf
                                                      WHERE   tf.ENABLED = 1
                                                              AND UPPER(tf.sys_name) = ( SELECT
                                                              UPPER(do.sys_name)
                                                              FROM
                                                              dbo.srvpl_device2options d2o
                                                              INNER JOIN dbo.srvpl_device_options do ON do.id_device_option = d2o.id_device_option
                                                              WHERE
                                                              d2o.enabled = 1
                                                              AND d2o.id_device = d.id_device
                                                              AND UPPER(do.sys_name) = 'OPTADF'
                                                              )
                                                    ) AS adf_option_price ,
 --Опция Finisher
                                                    ( SELECT TOP 1
                                                              price
                                                      FROM    srvpl_tariff_features tf
                                                      WHERE   tf.ENABLED = 1
                                                              AND UPPER(tf.sys_name) = ( SELECT
                                                              UPPER(do.sys_name)
                                                              FROM
                                                              dbo.srvpl_device2options d2o
                                                              INNER JOIN dbo.srvpl_device_options do ON do.id_device_option = d2o.id_device_option
                                                              WHERE
                                                              d2o.enabled = 1
                                                              AND d2o.id_device = d.id_device
                                                              AND UPPER(do.sys_name) = 'OPTFIN'
                                                              )
                                                    ) AS finisher_option_price ,
--Опция Tray
                                                    ( SELECT TOP 1
                                                              price
                                                      FROM    srvpl_tariff_features tf
                                                      WHERE   tf.ENABLED = 1
                                                              AND UPPER(tf.sys_name) = ( SELECT
                                                              UPPER(do.sys_name)
                                                              FROM
                                                              dbo.srvpl_device2options d2o
                                                              INNER JOIN dbo.srvpl_device_options do ON do.id_device_option = d2o.id_device_option
                                                              WHERE
                                                              d2o.enabled = 1
                                                              AND d2o.id_device = d.id_device
                                                              AND UPPER(do.sys_name) = 'OPTTRAY'
                                                              )
                                                    ) AS tray_option_price ,
                                                    --Способ печати
                                                    ( SELECT TOP 1
                                                              price
                                                      FROM    srvpl_tariff_features tf
                                                      WHERE   tf.ENABLED = 1
                                                              AND UPPER(tf.sys_name) = ( SELECT
                                                              UPPER(sys_name)
                                                              FROM
                                                              dbo.srvpl_cartridge_types ct
                                                              WHERE
                                                              ct.id_cartridge_type = m.id_cartridge_type
                                                              )
                                                    ) AS ctype_coefficient ,
                                                    ( SELECT TOP 1
                                                              price
                                                      FROM    srvpl_tariff_features tf
                                                      WHERE   tf.ENABLED = 1
                                                              AND UPPER(tf.sys_name) = 'SPEEDUND89'
                                                              AND m.speed > 89
                                                    ) AS speed_coefficient
                                          FROM      dbo.srvpl_devices d
                                                    INNER JOIN dbo.srvpl_device_models m ON d.id_device_model = m.id_device_model
                                          WHERE     d.id_device = @id
                                        ) AS t
                            ) AS tt
                
                    SET @result = CONVERT(NVARCHAR(50), @var_int)
                END
            ELSE
                IF @action = 'checkDeviceIsLinkedNow'
                    BEGIN
				--Проверка привязан ли в данный момент устройство к договору
	
                        IF EXISTS ( SELECT  1
                                    FROM    dbo.srvpl_contract2devices c2d
                                    WHERE   c2d.enabled = 1
                                            AND c2d.id_device = @id
                                            AND CONVERT(DATE, GETDATE()) BETWEEN CONVERT(DATE, c2d.dattim1)
                                                              AND
                                                              CONVERT(DATE, c2d.dattim2)
                                            AND dbo.srvpl_fnc('checkContractIsActiveNow',
                                                              NULL,
                                                              c2d.id_contract,
                                                              NULL, NULL) = '1' )
                            BEGIN
                                SET @result = '1'	
                            END
                        ELSE
                            BEGIN
                                SET @result = '0'
                            END
	
                    END            
                ELSE
                    IF @action = 'checkContractIsActiveNow'
                        BEGIN
				--Проверка активен ли договор
	
                            IF EXISTS ( SELECT  1
                                        FROM    dbo.srvpl_contracts c
                                        INNER JOIN dbo.srvpl_contract_statuses st ON c.id_contract_status = st.id_contract_status
                                        WHERE   c.enabled = 1
                                        AND st.enabled = 1
                                        AND upper(st.sys_name) not IN ('DEACTIVE')
                                                AND c.id_contract = @id
                                                AND CONVERT(DATE, GETDATE()) BETWEEN CONVERT(DATE, c.date_begin)
                                                              AND
                                                              CONVERT(DATE, c.date_end) )
                                                              
                            --TODO: добавить проверку статуса
                                BEGIN
                                    SET @result = '1'	
                                END
                            ELSE
                                BEGIN
                                    SET @result = '0'
                                END
	
                        END
                    ELSE
                        IF @action = 'checkContractNotEndedNow'
                            BEGIN
				--Проверка не закончилось ли действие договора (может быть будущим числом)
	
                                IF EXISTS ( SELECT  1
                                            FROM    dbo.srvpl_contracts c
                                            INNER JOIN dbo.srvpl_contract_statuses st ON c.id_contract_status = st.id_contract_status
                                            WHERE   c.enabled = 1
                                                    AND c.id_contract = @id
                                                    AND st.enabled = 1
                                        AND upper(st.sys_name)  not IN ('DEACTIVE')
                                                    AND CONVERT(DATE, GETDATE()) <= CONVERT(DATE, c.date_end) )
                            --TODO: добавить проверку статуса
                                    BEGIN
                                        SET @result = '1'	
                                    END
                                ELSE
                                    BEGIN
                                        SET @result = '0'
                                    END
	
                            END
                        ELSE
                            IF @action = 'checkContractIsActiveOnMonth'
                                BEGIN
				--Проверка активен ли договор на определенный месяц
	
                                    IF EXISTS ( SELECT  1
                                                FROM    dbo.srvpl_contracts c
                                                INNER JOIN dbo.srvpl_contract_statuses st ON c.id_contract_status = st.id_contract_status
                                                WHERE   c.enabled = 1
                                                        AND c.id_contract = @id
                                                        AND st.enabled = 1
                                        AND upper(st.sys_name)  not IN ('DEACTIVE')
                                                        AND CONVERT(DATE, @date) BETWEEN CONVERT(DATE, CONVERT(NVARCHAR, YEAR(c.date_begin))
                                                              + '-'
                                                              + +CONVERT(NVARCHAR, MONTH(c.date_begin))
                                                              + '-' + '01')
                                                              AND
                                                              CONVERT(DATE,CONVERT(NVARCHAR,
                                                              DATEADD(s, -1, DATEADD(mm, DATEDIFF(m, 0, c.date_end) + 1, 0))
                                                              )
                                                              ))
                                                              
                                                              
                                            --AND YEAR(@date) BETWEEN YEAR(c.date_begin) AND year(c.date_end)
                                            --AND MONTH(@date) BETWEEN MONTH(c.date_begin) AND MONTH(c.date_end))
                            --TODO: добавить проверку статуса
                                        BEGIN
                                            SET @result = '1'	
                                        END
                                    ELSE
                                        BEGIN
                                            SET @result = '0'
                                        END
                                END
                            ELSE
                                IF @action = 'checkContractIsActiveOnDate'
                                    BEGIN
				--Проверка активен ли договор на определенную дату
	
                                        IF EXISTS ( SELECT  1
                                                    FROM    dbo.srvpl_contracts c
                                                    INNER JOIN dbo.srvpl_contract_statuses st ON c.id_contract_status = st.id_contract_status
                                                    WHERE   c.enabled = 1
                                                            AND c.id_contract = @id
                                                            AND st.enabled = 1
                                        AND upper(st.sys_name)  not IN ('DEACTIVE')
                                                            AND CONVERT(DATE, @date) BETWEEN CONVERT(DATE, c.date_begin)
                                                              AND
                                                              CONVERT(DATE, c.date_end) )
                                            BEGIN
                                                SET @result = '1'	
                                            END
                                        ELSE
                                            BEGIN
                                                SET @result = '0'
                                            END
	
                                    END
                                ELSE
                                    IF @action = 'getDeviceModelCollectedName'
                                        BEGIN
                        
                                            SELECT  @result = ISNULL(t.vendor,
                                                              '') + ' '
                                                    + ISNULL(t.name, '')
                                                    + ' (скорость: '
                                                    + ISNULL(CONVERT(NVARCHAR(12), t.speed),
                                                             'не указано')
                                                    + ', формат: '
                                                    + ISNULL(CONVERT(NVARCHAR(150), t.imprint),
                                                             'не указано')
                                                    + ', тип: '
                                                    + ISNULL(CONVERT(NVARCHAR(150), t.print_type),
                                                             'не указано')
                                                    + ', способ: '
                                                    + ISNULL(CONVERT(NVARCHAR(150), t.cartridge_type),
                                                             'не указано')
                                                    + ')'
                                            FROM    ( SELECT  dm.vendor ,
                                                              dm.name ,
                                                              dm.speed ,
                                                              ( SELECT
                                                              name
                                                              FROM
                                                              dbo.srvpl_device_imprints di
                                                              WHERE
                                                              di.id_device_imprint = dm.id_device_imprint
                                                              ) AS imprint ,
                                                              ( SELECT
                                                              name
                                                              FROM
                                                              dbo.srvpl_print_types pt
                                                              WHERE
                                                              pt.id_print_type = dm.id_print_type
                                                              ) AS print_type ,
                                                              ( SELECT
                                                              name
                                                              FROM
                                                              dbo.srvpl_cartridge_types ct
                                                              WHERE
                                                              ct.id_cartridge_type = dm.id_cartridge_type
                                                              ) AS cartridge_type
                                                      FROM    dbo.srvpl_device_models dm
                                                      WHERE   dm.id_device_model = @id
                                                    ) AS t
                        
                                        END
                                    ELSE
                                        IF @action = 'getDeviceModelShortCollectedName'
                                            BEGIN
                        
                                                SELECT  @result = ISNULL(t.vendor,
                                                              '') + ' '
                                                        + ISNULL(t.name, '')
                                                FROM    ( SELECT
                                                              dm.vendor ,
                                                              dm.name /*,
                                                dm.speed ,
                                                ( SELECT    name
                                                  FROM      dbo.srvpl_device_imprints di
                                                  WHERE     di.id_device_imprint = dm.id_device_imprint
                                                ) AS imprint ,
                                                ( SELECT    name
                                                  FROM      dbo.srvpl_print_types pt
                                                  WHERE     pt.id_print_type = dm.id_print_type
                                                ) AS print_type ,
                                                ( SELECT    name
                                                  FROM      dbo.srvpl_cartridge_types ct
                                                  WHERE     ct.id_cartridge_type = dm.id_cartridge_type
                                                ) AS cartridge_type*/
                                                          FROM
                                                              dbo.srvpl_device_models dm
                                                          WHERE
                                                              dm.id_device_model = @id
                                                        ) AS t
                        
                                            END
                                        ELSE
                                            IF @action = 'getDeviceCollectedName'
                                                BEGIN
                                                    SELECT  @result = dbo.srvpl_fnc('getDeviceModelCollectedName',
                                                              NULL,
                                                              d.id_device_model,
                                                              NULL, NULL)
                                                    FROM    dbo.srvpl_devices d
                                                    WHERE   d.id_device = @id
                        
                                                END
                                            ELSE
                                                IF @action = 'getDeviceShortCollectedName'
                                                    BEGIN
                                                        SELECT
                                                              @result = dbo.srvpl_fnc('getDeviceModelShortCollectedName',
                                                              NULL,
                                                              d.id_device_model,
                                                              NULL, NULL)
                                                              + ' <br /> №'
                                                              + ISNULL(d.serial_num,
                                                              '')
                                                        FROM  dbo.srvpl_devices d
                                                        WHERE d.id_device = @id
                        
                                                    END
                                                ELSE
                                                    IF @action = 'getDeviceShortCollectedNameNoBr'
                                                        BEGIN
                                                            SELECT
                                                              @result = dbo.srvpl_fnc('getDeviceModelShortCollectedName',
                                                              NULL,
                                                              d.id_device_model,
                                                              NULL, NULL)
                                                              + ' №'
                                                              + ISNULL(d.serial_num,
                                                              '')
                                                            FROM
                                                              dbo.srvpl_devices d
                                                            WHERE
                                                              d.id_device = @id
                        
                                                        END
                                                    ELSE
                                                        IF @action = 'getDeviceShortCollectedNameNoSerialNoBr'
                                                            BEGIN
                                                              SELECT
                                                              @result = dbo.srvpl_fnc('getDeviceModelShortCollectedName',
                                                              NULL,
                                                              d.id_device_model,
                                                              NULL, NULL)
                                                              FROM
                                                              dbo.srvpl_devices d
                                                              WHERE
                                                              d.id_device = @id
                        
                                                            END
                                                        ELSE
                                                            IF @action = 'getDeviceShortCollectedNameSerialFirst'
                                                              BEGIN
                                                              SELECT
                                                              @result = '№'
                                                              + ISNULL(d.serial_num,
                                                              '-') + ' '
                                                              + dbo.srvpl_fnc('getDeviceModelShortCollectedName',
                                                              NULL,
                                                              d.id_device_model,
                                                              NULL, NULL)
                                                              FROM
                                                              dbo.srvpl_devices d
                                                              WHERE
                                                              d.id_device = @id
                        
                                                              END
                                                            ELSE
                                                              IF @action = 'getContract2DevicesCollectedName'
                                                              BEGIN
                        
                                                              SELECT
                                                              @result = t.device
                                                              + ' <strong>адрес:</strong> '
                                                              + ISNULL(CONVERT(NVARCHAR(150), city),
                                                              '') + ', '
                                                              + ISNULL(CONVERT(NVARCHAR(MAX), t.address),
                                                              'не указано')
                                                              + ' <strong>интервал:</strong> '
                                                              + ISNULL(CONVERT(NVARCHAR(150), t.service_interval),
                                                              'не указано')
                                                              FROM
                                                              ( SELECT
                                                              dbo.srvpl_fnc('getDeviceCollectedName',
                                                              NULL,
                                                              c2d.id_device,
                                                              NULL, NULL) AS device ,
                                                              ( SELECT
                                                              name
                                                              FROM
                                                              dbo.cities c
                                                              WHERE
                                                              c.id_city = c2d.id_city
                                                              ) AS city ,
                                                              c2d.address ,
                                                              ( SELECT
                                                              si.name
                                                              FROM
                                                              dbo.srvpl_service_intervals si
                                                              WHERE
                                                              si.id_service_interval = c2d.id_service_interval
                                                              ) AS service_interval
                                                              FROM
                                                              dbo.srvpl_contract2devices c2d
                                                              WHERE
                                                              c2d.id_contract2devices = @id
                                                              ) AS t
                        
                                                              END
                                                              ELSE
                                                              IF @action = 'getContract2DevicesShortCollectedName'
                                                              BEGIN
                        
                                                              SELECT
                                                              @result = t.device /*+ ' <strong>адрес:</strong> '
                                    + ISNULL(CONVERT(NVARCHAR(150), city),
                                             '') + ', '
                                    + ISNULL(CONVERT(NVARCHAR(max), t.address),
                                             'не указано') + ' <strong>интервал:</strong> '
                                    + ISNULL(CONVERT(NVARCHAR(150), t.service_interval),
                                             'не указано')*/
                                                              FROM
                                                              ( SELECT
                                                              dbo.srvpl_fnc('getDeviceShortCollectedNameSerialFirst',
                                                              NULL,
                                                              c2d.id_device,
                                                              NULL, NULL) AS device ,
                                                              ( SELECT
                                                              name
                                                              FROM
                                                              dbo.cities c
                                                              WHERE
                                                              c.id_city = c2d.id_city
                                                              ) AS city ,
                                                              c2d.address ,
                                                              ( SELECT
                                                              si.name
                                                              FROM
                                                              dbo.srvpl_service_intervals si
                                                              WHERE
                                                              si.id_service_interval = c2d.id_service_interval
                                                              ) AS service_interval
                                                              FROM
                                                              dbo.srvpl_contract2devices c2d
                                                              WHERE
                                                              c2d.id_contract2devices = @id
                                                              ) AS t
                        
                                                              END
                                                              ELSE
                                                              IF @action = 'getContractCollectedName'
                                                              BEGIN
                        
                                                              SELECT
                                                              @result = ' <strong>'
                                                              + '№'
                                                              + t.contract_num
                                                              + '</strong>'
                                                              + t.date_begin
                                                              + '-'
                                                              + t.date_end
                                                              + CASE
                                                              WHEN t.residue > 0
                                                              THEN ' ('
                                                              + CONVERT(NVARCHAR, t.residue)
                                                              + 'д.)'
                                                              ELSE ''
                                                              END + @new_line
                                                              + '<strong>Контрагент:</strong> '
                                                              + t.name_inn
                                                              + @new_line
                                                              + '<strong>Сумма:</strong> '
                                                              + price + 'р.'
                                                              FROM
                                                              ( SELECT
                                                              c.number AS contract_num ,
                                                        /*( SELECT
                                                              name_inn
                                                          FROM
                                                              dbo.get_contractor(c.id_contractor)
                                                        ) */
                                                              c.contractor_name
                                                              + ' (ИНН '
                                                              + c.contractor_inn
                                                              + ')' AS name_inn ,
                                                              CONVERT(NVARCHAR(12), c.price) AS price ,
                                                              CONVERT(NVARCHAR, c.date_begin, 104) AS date_begin ,
                                                              CONVERT(NVARCHAR, c.date_end, 104) AS date_end ,
                                                              DATEDIFF(DAY,
                                                              GETDATE(),
                                                              c.date_end) AS residue
                                                              FROM
                                                              dbo.srvpl_contracts c
                                                              WHERE
                                                              c.id_contract = @id
                                                              ) AS t
                        
                                                              END  
                                                              ELSE
                                                              IF @action = 'getContractCollectedNameNoAmount'
                                                              BEGIN
                        
                                                              SELECT
                                                              @result = ' <strong>'
                                                              + '№'
                                                              + t.contract_num
                                                              + '</strong>'
                                                              + t.date_begin
                                                              + '-'
                                                              + t.date_end
                                                              + CASE
                                                              WHEN t.residue > 0
                                                              THEN ' ('
                                                              + CONVERT(NVARCHAR, t.residue)
                                                              + 'д.)'
                                                              ELSE ''
                                                              END + @new_line
                                                              + '<strong>Контрагент:</strong> '
                                                              + t.name_inn
                                                              FROM
                                                              ( SELECT
                                                              c.number AS contract_num ,
                                                        /*( SELECT
                                                              name_inn
                                                          FROM
                                                              dbo.get_contractor(c.id_contractor)
                                                        )*/
                                                              c.contractor_name
                                                              + ' (ИНН '
                                                              + c.contractor_inn
                                                              + ')' AS name_inn ,
                                                              CONVERT(NVARCHAR(12), c.price) AS price ,
                                                              CONVERT(NVARCHAR, c.date_begin, 104) AS date_begin ,
                                                              CONVERT(NVARCHAR, c.date_end, 104) AS date_end ,
                                                              DATEDIFF(DAY,
                                                              GETDATE(),
                                                              c.date_end) AS residue
                                                              FROM
                                                              dbo.srvpl_contracts c
                                                              WHERE
                                                              c.id_contract = @id
                                                              ) AS t
                        
                                                              END  
                                                              ELSE
                                                              IF @action = 'getContractShortCollectedName'
                                                              BEGIN
                        
                                                              SELECT
                                                              @result = '№'
                                                              + c.number + ' '
                                                              + c.contractor_name
                                                              + ' (ИНН '
                                                              + c.contractor_inn
                                                              + ')'
                                                /*( SELECT  name_inn
                                                    FROM    dbo.get_contractor(c.id_contractor)
                                                  )*/
                                                              FROM
                                                              dbo.srvpl_contracts c
                                                              WHERE
                                                              c.id_contract = @id                                    
                        
                                                              END                                                       
	
        RETURN @result
    END
