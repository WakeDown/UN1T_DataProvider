-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE ui_service_planing_2
	@action NVARCHAR(50) ,
    @sp_test BIT = NULL --переменная для тестирования
    ,
    @id_user INT = NULL ,
    @number NVARCHAR(150) = NULL ,
    @id_contract INT = NULL ,
    @id_service_type INT = NULL ,
    @id_contract_type INT = NULL ,
    @id_contractor INT = NULL ,
    @id_contract_status INT = NULL ,
    @id_manager INT = NULL ,
    @date_begin DATETIME = NULL ,
    @date_end DATETIME = NULL ,
    @id_creator INT = NULL ,
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
    @page_index INT = NULL ,
    @page_size INT = NULL ,
    @id_device_model INT = NULL ,
    @lst_id_device NVARCHAR(MAX) = NULL ,
    @is_linked BIT = NULL ,
    @planing_date DATETIME = NULL ,
    @id_service_claim INT = NULL ,
    @date_claim_begin DATETIME = NULL ,
    @date_claim_end DATETIME = NULL ,
    @date_came_begin DATETIME = NULL ,
    @date_came_end DATETIME = NULL ,
    @id_service_claim_status INT = NULL ,
    @id_device_type INT = NULL ,
    @is_active BIT = NULL ,
    @vendor NVARCHAR(150) = NULL ,
    @id_service_interval_plan_group INT = NULL ,
    @lst_id_contract2devices NVARCHAR(MAX) = NULL ,
    @not_in_plan_list BIT = NULL ,
    @id_service_admin INT = NULL ,
    @object_name NVARCHAR(150) = NULL ,
    @coord NVARCHAR(50) = NULL ,
    @no_device_linked BIT = NULL ,
    @id_zip_state INT = NULL ,
    @note NVARCHAR(150) = NULL ,
    @rows_count INT = NULL ,
    @contractor_name NVARCHAR(250) = NULL ,
    @contractor_inn NVARCHAR(20) = NULL ,
    @counter_colour INT = NULL ,
    @id_service_claim_type INT = NULL ,
    @id_feature INT = NULL ,
    @tariff DECIMAL(10, 2) = NULL ,
    @all BIT = NULL ,
    @date_month DATETIME = NULL ,
    @lst_schedule_dates NVARCHAR(4000) = NULL ,
    @add_scheduled_dates2service_plan BIT = NULL ,
    @inv_num NVARCHAR(50) = NULL ,
    @no_set INT = NULL ,
    @filter_text NVARCHAR(50) = NULL ,
    @id_contract_prolong INT = NULL ,
    @id_price_discount INT = NULL ,
    @order_by_name BIT = NULL ,
    @show_inn BIT = NULL ,
    @no_came BIT = NULL ,
    @is_done INT = NULL ,
    @id_srvpl_address INT = NULL ,
    @id_payment_tariff INT = NULL ,
    @id_user_role INT = NULL ,
    @id_user2user_role INT = NULL ,
    @show_no_graphicks BIT = NULL ,
    @lst_id_service_claim NVARCHAR(MAX) = NULL ,
    @id_akt_scan INT = NULL ,
    @id_adder INT = NULL ,
    @date_cames_add DATETIME = NULL ,
    @file_name NVARCHAR(50) = NULL ,
    @full_path NVARCHAR(150) = NULL ,
    @cames_add BIT = NULL ,
    @date_day DATETIME = NULL ,
    @already_exec INT = NULL ,
    @claim_count INT = NULL ,
    @norm_order INT = NULL ,
    @add_plan_when_deactive BIT = NULL ,
    @data_source NVARCHAR(50) = NULL ,
    @id_device_data INT = NULL ,
    @is_manual BIT = NULL ,
    @is_sys_admin BIT = NULL ,
    @handling_devices INT = NULL ,
    @is_handling_devices_contract BIT = NULL ,
    @max_volume INT = NULL ,
    @period_begin DATETIME = NULL ,
    @period_end DATETIME = NULL ,
    @wear_begin INT = NULL ,
    @wear_end INT = NULL ,
    @loading_begin INT = NULL ,
    @loading_end INT = NULL ,
    @lst_vendor NVARCHAR(500) = NULL ,
    @has_cames BIT = NULL ,
    @not_null_volume INT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--хранимая процедура для сложных гетов, которым нужна быстрая работа

    IF @action = 'getServiceClaimFullNameSelectionList'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
						
						
						
						
						
                        SELECT  t.id ,
                                --CONVERT(NVARCHAR(10),t.id)  + ' ' +
                                --скрываем аппарат если договор с ограничением по заявкам
                                CASE WHEN is_limit_device_claims = 1
                                          AND has_came = 0 THEN 'неизвестное'
                                     ELSE t.device
                                END + ', ' + CHAR(1) + ' ' + CHAR(1) + ' '
                                + CHAR(1)
                                + /*CONVERT(NVARCHAR, t.planing_date, 104)*/ RIGHT(CONVERT(VARCHAR, t.planing_date, 104),
                                                              7) + ', '
                                + CHAR(1) + ' ' + CHAR(1) + ' ' + CHAR(1)
                                + t.contractor + CHAR(1) + ' ' + CHAR(1) + ' '
                                + CHAR(1) + ISNULL(came_info, '') AS NAME
                        FROM    ( SELECT    sc.id_service_claim AS id ,
                                            dbo.srvpl_fnc('getDeviceShortCollectedNameNoBr',
                                                          NULL, sc.id_device,
                                                          NULL, NULL) AS device ,
						/*( SELECT    name_inn
                                              FROM      dbo.get_contractor(( SELECT
                                                              c.id_contractor
                                                              FROM
                                                              dbo.srvpl_contracts c
                                                              WHERE
                                                              c.id_contract = sc.id_contract
                                                              ))
                                            ) */
                                            c.contractor_name + '(ИНН '
                                            + c.contractor_inn + ')' AS contractor ,
                                            sc.planing_date ,
                                            ( SELECT TOP 1
                                                        '!!! обслужено '
                                                        + CONVERT(VARCHAR, ISNULL(scam.date_came,
                                                              ''), 104)
                                                        + ' инженер - '
                                                        + ISNULL(( SELECT
                                                              display_name
                                                              FROM
                                                              users u
                                                              WHERE
                                                              u.id_user = scam.id_service_engeneer
                                                              ), '')
                                              FROM      dbo.srvpl_service_cames scam
                                              WHERE     scam.enabled = 1
                                                        AND scam.id_service_claim = sc.id_service_claim
                                              ORDER BY  dattim1 DESC
                                            ) AS came_info ,
                                            CASE WHEN c.handling_devices IS NOT NULL
                                                      OR c.handling_devices > 0
                                                 THEN 1
                                                 ELSE 0
                                            END AS is_limit_device_claims ,
                                            CASE WHEN EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames cam
                                                              WHERE
                                                              cam.enabled = 1
                                                              AND cam.id_service_claim = sc.id_service_claim )
                                                 THEN 1
                                                 ELSE 0
                                            END AS has_came
                                  FROM      dbo.srvpl_service_claims sc
                                            INNER JOIN srvpl_contract2devices c2d ON sc.id_contract2devices = c2d.id_contract2devices
                                            INNER JOIN dbo.srvpl_contracts c ON sc.id_contract = c.id_contract
                                            INNER JOIN dbo.srvpl_devices d ON sc.id_device = d.id_device
                                  WHERE     sc.enabled = 1
                                            AND c2d.enabled = 1
                                            AND c.enabled = 1
                                            AND d.enabled = 1
                                            AND ( ( @id_service_claim IS NULL
                                                    OR @id_service_claim <= 0
                                                  )
                                                  OR ( @id_service_claim > 0
                                                       AND sc.id_service_claim = @id_service_claim
                                                     )
                                                )
                                            AND ( ( @id_service_came IS NULL
                                                    OR @id_service_came <= 0
                                                  )
                                                  OR ( @id_service_came > 0
                                                       AND EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scam
                                                              WHERE
                                                              scam.enabled = 1
                                                              AND scam.id_service_came = @id_service_came
                                                              AND scam.id_service_claim = sc.id_service_claim )
                                                     )
                                                )
						--Только текущий и предыдущие месяцы
                                            AND ( @id_service_came > 0
                                                  OR ( ( @id_service_came IS NULL
                                                         OR @id_service_came <= 0
                                                       )
                                                       AND ( ( YEAR(sc.planing_date) = YEAR(GETDATE())
                                                              AND MONTH(sc.planing_date) = MONTH(GETDATE())
                                                             )
                                                             OR ( YEAR(sc.planing_date) = YEAR(DATEADD(month,
                                                              -1, GETDATE()))
                                                              AND MONTH(sc.planing_date) = MONTH(DATEADD(month,
                                                              -1, GETDATE()))
                                                              )
                                                             OR ( YEAR(sc.planing_date) = YEAR(DATEADD(month,
                                                              -2, GETDATE()))
                                                              AND MONTH(sc.planing_date) = MONTH(DATEADD(month,
                                                              -2, GETDATE()))
                                                              )
                                                           )
                                                     )
                                                )
						--AND NOT EXISTS ( SELECT
						--                  1
						--                 FROM
						--                  dbo.srvpl_service_cames scam
						--                 WHERE
						--                  scam.enabled = 1
						--                  AND scam.id_service_claim = sc.id_service_claim )
                                            AND ( @serial_num IS NULL
                                                  OR @serial_num IS NOT NULL
                                                  AND ( d.serial_num LIKE '%'
                                                        + @serial_num + '%'
                                                          
                                                          --Выводим записи у договоров с ограничением заявок в месяц для которых не создано заявки
                                                        OR EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              srvpl_contract2devices c2d2
                                                              INNER JOIN dbo.srvpl_devices d2 ON c2d2.id_device = d2.id_device
                                                              WHERE
                                                              c2d2.enabled = 1
                                                              AND c2d2.id_contract = c.id_contract
                                                              AND d2.enabled = 1
                                                              AND NOT EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_claims cl2
                                                              WHERE
                                                              cl2.enabled = 1
                                                              AND cl2.id_contract2devices = c2d2.id_contract2devices )
                                                              AND ( c.handling_devices IS NOT NULL
                                                              AND c.handling_devices > 0
                                                              )
                                                              AND d2.serial_num LIKE '%'
                                                              + @serial_num
                                                              + '%' )
                                                      )
                                                )
                                ) AS T                                
                    END
END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ui_service_planing_2] TO [sqlUnit_prog]
    AS [dbo];

