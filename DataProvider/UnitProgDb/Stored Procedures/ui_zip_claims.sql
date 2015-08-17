
-- =============================================
-- Author:		Anton Rekhov
-- Create date: 21.05.2014
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[ui_zip_claims]
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
    @price_in NVARCHAR(13) = NULL ,
    @price_out NVARCHAR(13) = NULL ,
    --@price_in DECIMAL(10, 2) = NULL ,
    --@price_out DECIMAL(10, 2) = NULL ,
    @id_contractor INT = NULL ,
    @id_city INT = NULL ,
    @id_manager INT = NULL ,
    @id_service_admin INT = NULL ,
    @id_operator INT = NULL ,
    @date_begin DATETIME = NULL ,
    @date_end DATETIME = NULL ,
    @not_in_system BIT = NULL ,
    @lst_claim_states NVARCHAR(50) = NULL ,
    @lst_et_claim_states NVARCHAR(50) = NULL ,
    @lst_waybill_claim_states NVARCHAR(50) = NULL ,
    @service_desk_num NVARCHAR(50) = NULL ,
    @row_num INT = NULL ,
    @counter_colour INT = NULL ,
    @cancel_comment NVARCHAR(500) = NULL ,
    @object_name NVARCHAR(150) = NULL ,
    @waybill_num NVARCHAR(50) = NULL ,
    @get_all BIT = NULL ,
    @rows_count INT = NULL ,
    @delivery_time NVARCHAR(50) = NULL ,
    @filter NVARCHAR(250) = NULL ,
    @id_user_filter INT = NULL ,
    @contract_num NVARCHAR(60) = NULL ,
    @contract_type NVARCHAR(60) = NULL ,
    @id_et_way_claim_state INT = NULL ,
    @start_row INT = NULL ,
    @end_row INT = NULL ,
    @from_top BIT = NULL ,
    @contractor_sd_num NVARCHAR(50) = NULL ,
    @inv_num NVARCHAR(50) = NULL ,
    @order_num INT = NULL ,
    @id_zip_group INT = NULL ,
    @id_zip_group2cat_num INT = NULL ,
    @in_group BIT = NULL ,
    @no_group BIT = NULL ,
    @colour NVARCHAR(6) = NULL ,
    @is_top BIT = NULL ,
    @id_supply_man INT = NULL ,
    @id_claim_unit_info INT = NULL ,
    @supply_list BIT = NULL ,
    @if_set_price_done BIT = NULL ,
    @ip_address NVARCHAR(50) = NULL ,
    @user_login NVARCHAR(50) = NULL ,
    @no_nomenclature_num BIT = NULL ,
    @nomenclature_claim_num NVARCHAR(50) = NULL ,
    @price_request INT = NULL ,
    @load_num INT = NULL ,
    @price_rur DECIMAL(10, 2) = NULL ,
    @price_usd DECIMAL(10, 2) = NULL ,
    @price_eur DECIMAL(10, 2) = NULL ,
    @id_srvpl_contract INT = NULL ,
    @id_contract_spec_price INT = NULL ,
    @id_nomenclature INT = NULL ,
    @price DECIMAL(10, 2) = NULL ,
    @nomenclature_name NVARCHAR(150) = NULL ,
    @id_resp_supply INT = NULL ,
    @id_manager2operator INT = NULL ,
    @is_return BIT = NULL
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
            @pr_in DECIMAL(10, 2) ,
            @pr_out DECIMAL(10, 2) ,
            @mail_subject NVARCHAR(150) ,
            @mail_text NVARCHAR(4000) ,
            @mail_address NVARCHAR(4000) ,
            @root_url NVARCHAR(30) ,
            @id_sended_mail_type INT ,
            @et_state NVARCHAR(50) ,
            @et_waybill_state NVARCHAR(50) ,
            @date_now DATETIME ,
            @curr_id_claim_state INT
            
        SET @root_url = 'http://dsu-zip.un1t.group/'
        SET @date_now = GETDATE()
		
	--</Variables>
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
                                                + CONVERT(NVARCHAR(100), @action)
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
                                END + CASE WHEN @date_begin IS NULL THEN ''
                                           ELSE ' @date_begin='
                                                + CONVERT(NVARCHAR(MAX), @date_begin)
                                      END
                        + CASE WHEN @date_end IS NULL THEN ''
                               ELSE ' @date_end='
                                    + CONVERT(NVARCHAR(MAX), @date_end)
                          END + CASE WHEN @lst_claim_states IS NULL THEN ''
                                     ELSE ' @lst_claim_states='
                                          + CONVERT(NVARCHAR(MAX), @lst_claim_states)
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
                                      END + CASE WHEN @get_all IS NULL THEN ''
                                                 ELSE ' @get_all='
                                                      + CONVERT(NVARCHAR(MAX), @get_all)
                                            END
                        + CASE WHEN @rows_count IS NULL THEN ''
                               ELSE ' @rows_count='
                                    + CONVERT(NVARCHAR(MAX), @rows_count)
                          END + CASE WHEN @lst_et_claim_states IS NULL THEN ''
                                     ELSE ' @lst_et_claim_states='
                                          + CONVERT(NVARCHAR(MAX), @lst_et_claim_states)
                                END
                        + CASE WHEN @lst_waybill_claim_states IS NULL THEN ''
                               ELSE ' @lst_waybill_claim_states='
                                    + CONVERT(NVARCHAR(MAX), @lst_waybill_claim_states)
                          END + CASE WHEN @delivery_time IS NULL THEN ''
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
                        + CASE WHEN @id_et_way_claim_state IS NULL THEN ''
                               ELSE ' @id_et_way_claim_state='
                                    + CONVERT(NVARCHAR(MAX), @id_et_way_claim_state)
                          END + CASE WHEN @start_row IS NULL THEN ''
                                     ELSE ' @start_row='
                                          + CONVERT(NVARCHAR(MAX), @start_row)
                                END + CASE WHEN @end_row IS NULL THEN ''
                                           ELSE ' @end_row='
                                                + CONVERT(NVARCHAR(MAX), @end_row)
                                      END
                        + CASE WHEN @from_top IS NULL THEN ''
                               ELSE ' @from_top='
                                    + CONVERT(NVARCHAR(MAX), @from_top)
                          END + CASE WHEN @contractor_sd_num IS NULL THEN ''
                                     ELSE ' @contractor_sd_num='
                                          + CONVERT(NVARCHAR(MAX), @contractor_sd_num)
                                END + CASE WHEN @inv_num IS NULL THEN ''
                                           ELSE ' @inv_num='
                                                + CONVERT(NVARCHAR(MAX), @inv_num)
                                      END
                        + CASE WHEN @id_zip_group IS NULL THEN ''
                               ELSE ' @id_zip_group='
                                    + CONVERT(NVARCHAR(MAX), @id_zip_group)
                          END + CASE WHEN @order_num IS NULL THEN ''
                                     ELSE ' @order_num='
                                          + CONVERT(NVARCHAR(MAX), @order_num)
                                END
                        + CASE WHEN @id_zip_group2cat_num IS NULL THEN ''
                               ELSE ' @id_zip_group2cat_num='
                                    + CONVERT(NVARCHAR(MAX), @id_zip_group2cat_num)
                          END + CASE WHEN @in_group IS NULL THEN ''
                                     ELSE ' @in_group='
                                          + CONVERT(NVARCHAR(MAX), @in_group)
                                END + CASE WHEN @no_group IS NULL THEN ''
                                           ELSE ' @no_group='
                                                + CONVERT(NVARCHAR(MAX), @no_group)
                                      END + CASE WHEN @colour IS NULL THEN ''
                                                 ELSE ' @colour='
                                                      + CONVERT(NVARCHAR(MAX), @colour)
                                            END
                        + CASE WHEN @is_top IS NULL THEN ''
                               ELSE ' @is_top='
                                    + CONVERT(NVARCHAR(MAX), @is_top)
                          END + CASE WHEN @id_supply_man IS NULL THEN ''
                                     ELSE ' @id_supply_man='
                                          + CONVERT(NVARCHAR(MAX), @id_supply_man)
                                END
                        + CASE WHEN @id_claim_unit_info IS NULL THEN ''
                               ELSE ' @id_claim_unit_info='
                                    + CONVERT(NVARCHAR(MAX), @id_claim_unit_info)
                          END + CASE WHEN @supply_list IS NULL THEN ''
                                     ELSE ' @supply_list='
                                          + CONVERT(NVARCHAR(MAX), @supply_list)
                                END
                        + CASE WHEN @if_set_price_done IS NULL THEN ''
                               ELSE ' @if_set_price_done='
                                    + CONVERT(NVARCHAR(MAX), @if_set_price_done)
                          END + CASE WHEN @ip_address IS NULL THEN ''
                                     ELSE ' @ip_address='
                                          + CONVERT(NVARCHAR(MAX), @ip_address)
                                END + CASE WHEN @user_login IS NULL THEN ''
                                           ELSE ' @user_login='
                                                + CONVERT(NVARCHAR(MAX), @user_login)
                                      END
                        + CASE WHEN @no_nomenclature_num IS NULL THEN ''
                               ELSE ' @no_nomenclature_num='
                                    + CONVERT(NVARCHAR(MAX), @no_nomenclature_num)
                          END
                        + CASE WHEN @nomenclature_claim_num IS NULL THEN ''
                               ELSE ' @nomenclature_claim_num='
                                    + CONVERT(NVARCHAR(MAX), @nomenclature_claim_num)
                          END + CASE WHEN @price_request IS NULL THEN ''
                                     ELSE ' @price_request='
                                          + CONVERT(NVARCHAR(MAX), @price_request)
                                END + CASE WHEN @load_num IS NULL THEN ''
                                           ELSE ' @load_num='
                                                + CONVERT(NVARCHAR(MAX), @load_num)
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
                        + CASE WHEN @id_srvpl_contract IS NULL THEN ''
                               ELSE ' @id_srvpl_contract='
                                    + CONVERT(NVARCHAR(MAX), @id_srvpl_contract)
                          END
                        + CASE WHEN @id_contract_spec_price IS NULL THEN ''
                               ELSE ' @id_contract_spec_price='
                                    + CONVERT(NVARCHAR(MAX), @id_contract_spec_price)
                          END + CASE WHEN @id_nomenclature IS NULL THEN ''
                                     ELSE ' @id_nomenclature='
                                          + CONVERT(NVARCHAR(MAX), @id_nomenclature)
                                END + CASE WHEN @price IS NULL THEN ''
                                           ELSE ' @price='
                                                + CONVERT(NVARCHAR(MAX), @price)
                                      END
                        + CASE WHEN @nomenclature_name IS NULL THEN ''
                               ELSE ' @nomenclature_name='
                                    + CONVERT(NVARCHAR(MAX), @nomenclature_name)
                          END + CASE WHEN @id_resp_supply IS NULL THEN ''
                                     ELSE ' @id_resp_supply='
                                          + CONVERT(NVARCHAR(MAX), @id_resp_supply)
                                END
                        + CASE WHEN @id_manager2operator IS NULL THEN ''
                               ELSE ' @id_manager2operator='
                                    + CONVERT(NVARCHAR(MAX), @id_manager2operator)
                          END + CASE WHEN @is_return IS NULL THEN ''
                                     ELSE ' @is_return='
                                          + CONVERT(NVARCHAR(MAX), @is_return)
                                END
                                 

                EXEC sk_log @action = 'insLog', @proc_name = 'ui_zip_claims',
                    @id_program = @id_program, @params = @log_params,
                    @descr = @log_descr
			--/>
            END

	--=================================
	--Claims
	--=================================	
        IF @action = 'getClientZipViewClaimList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
                SELECT  *
                FROM    ( SELECT    * ,
                                    ROW_NUMBER() OVER ( ORDER BY ttt.id_claim DESC ) AS row_num
                          FROM      ( SELECT    tt.id_claim ,
                                                tt.device ,
                                                tt.serial_num ,
                                                tt.device_model ,
                                                tt.contractor ,
                                                tt.city ,
                                                tt.address ,
                                                tt.counter ,
                                                tt.id_engeneer_conclusion ,
                                                tt.id_claim_state ,
                                                ( SELECT    id_claim_state
                                                  FROM      dbo.zipcl_claim_states
                                                  WHERE     name = et_waybill_state
                                                ) AS id_waybill_claim_state ,
                                    --tt.id_et_claim_state ,
                                                tt.request_num ,
                                                tt.descr ,
                                                tt.engeneer ,
                                                tt.id_creator ,
                                                tt.id_contractor ,
                                                tt.contractor_col_name ,
                                                tt.id_city ,
                                                tt.zip_unit_count ,
                                                --tt.price_in_sum ,
                                                tt.price_out_sum AS price_sum ,
                                                ( CASE WHEN claim_state_sys_name IN (
                                                            'PRICEOK',
                                                            'ETORDER',
                                                            'ETDOCS', 'ETSHIP',
                                                            'ETPREP' )
                                                       THEN CASE
                                                              WHEN ( et_state IS NOT NULL
                                                              AND LTRIM(RTRIM(et_state)) != ''
                                                              )
                                                              THEN '<div class="lightlow nowrap">Статус требования:</div><div>'
                                                              + et_state
                                                              + '</div>'
                                                              ELSE ''
                                                            END
                                                            + --№ накладной
                                                       CASE WHEN ( et_waybill_state IS NOT NULL
                                                              AND LTRIM(RTRIM(et_waybill_state)) != ''
                                                              )
                                                            THEN '<div class="lightlow nowrap">Статус трансп. заявки:</div><div>'
                                                              + tt.et_waybill_state
                                                              + '</div>'
                                                            ELSE ''
                                                       END
                                                       ELSE ISNULL(claim_state,
                                                              'отсутствует')
                                                  END ) AS claim_state ,
                                                tt.service_admin ,
                                                tt.operator ,
                                                tt.manager ,
                                                tt.display_price_states ,
                                                tt.display_done_state ,
                                                tt.display_send_state ,
                                                tt.display_price_set ,
                                                tt.date_create ,
                                                tt.cancel_comment ,
                                                tt.service_desk_num ,
                                                tt.fault_state ,
                                                tt.waybill_num ,
                                                tt.contractor_sd_num
                                      FROM      ( SELECT    t.id_claim ,
                                                            ISNULL(t.device,
                                                              t.device_curr) AS device ,
                                                            t.serial_num ,
                                                            t.device_model ,
                                                            t.contractor ,
                                                            t.city ,
                                                            t.address ,
                                                            t.counter ,
                                                            t.id_engeneer_conclusion ,
                                                            CASE
                                                              WHEN t.id_claim_state NOT IN (
                                                              SELECT
                                                              id_claim_state
                                                              FROM
                                                              dbo.zipcl_claim_states
                                                              WHERE
                                                              sys_name IN (
                                                              'DONE' ) )
                                                              AND et_state IS NOT NULL
                                                              AND LTRIM(RTRIM(et_state)) != ''
                                                              THEN ( SELECT
                                                              id_claim_state
                                                              FROM
                                                              dbo.zipcl_claim_states
                                                              WHERE
                                                              name = et_state
                                                              )
                                                              ELSE t.id_claim_state
                                                            END AS id_claim_state ,
                                                /*CASE WHEN t.id_claim_state IN (
                                                          SELECT
                                                              id_claim_state
                                                          FROM
                                                              dbo.zipcl_claim_states
                                                          WHERE
                                                              sys_name IN (
                                                              'DONE', 'PRICEOK' ) ) AND (et_state IS NULL
                                                          or LTRIM(RTRIM(et_state)) = '') THEN t.id_claim_state ELSE NULL END as id_claim_state,*/
                                                          --t.id_claim_state,
                                                /*( SELECT    id_claim_state
                                                  FROM      dbo.zipcl_claim_states
                                                  WHERE     name = et_state
                                                ) AS id_et_claim_state ,*/
                                                            t.request_num ,
                                                            t.descr ,
                                                            t.engeneer ,
                                                            t.id_creator ,
                                                            t.id_contractor ,
                                                            t.contractor_col_name ,
                                                            t.id_city ,
                                                            t.cancel_comment ,
                                                            ISNULL(zip_unit_count,
                                                              0) AS zip_unit_count ,
                                                /*ISNULL(CONVERT(NVARCHAR(13), price_in_sum),
                                                       'нет') AS price_in_sum ,
                                                ISNULL(CONVERT(NVARCHAR(13), price_out_sum),
                                                       'нет') AS price_out_sum ,*/
                                                            price_in_sum ,
                                                            price_out_sum ,
                                                            claim_state_sys_name ,
                                                            et_state ,
                                                            claim_state ,
                                                            ( CASE
                                                              WHEN t.et_waybill_state = 'Закрыто'
                                                              THEN 'Доставлено'
                                                              ELSE t.et_waybill_state
                                                              END ) AS et_waybill_state ,
                                                            ISNULL(service_admin,
                                                              '-') AS service_admin ,
                                                            ISNULL(operator,
                                                              '-') AS operator ,
                                                            ISNULL(manager,
                                                              '-') AS manager ,
                                                            ISNULL(display_price_states,
                                                              0) AS display_price_states ,
                                                            ISNULL(display_done_state,
                                                              0) AS display_done_state ,
                                                            ISNULL(display_send_state,
                                                              1) AS display_send_state ,
                                                            ISNULL(display_price_set,
                                                              0) AS display_price_set ,
                                                            ( CONVERT(NVARCHAR, t.dattim1, 104)
                                                              + ' ('
                                                              + CONVERT(NVARCHAR, day_diff)
                                                              + ' дн.)' ) AS date_create ,
                                                            t.service_desk_num ,
                                                            CASE
                                                              WHEN t.id_engeneer_conclusion = 2
                                                              THEN 'bg-danger'
                                                              ELSE ''
                                                            END AS fault_state ,
                                                            t.waybill_num ,
                                                            t.contractor_sd_num
                                                  FROM      ( SELECT
                                                              id_claim ,
                                                              id_device ,
                                                              serial_num ,
                                                              device_model ,
                                                              contractor ,
                                                              c.city ,
                                                              address ,
                                                              counter ,
                                                              id_engeneer_conclusion ,
                                                              id_claim_state ,
                                                              request_num ,
                                                              descr ,
                                                              u.display_name AS engeneer ,
                                                              id_creator ,
                                                              id_contractor ,
                                                              c.id_city ,
                                                              c.cancel_comment ,
                          --(SELECT name FROM dbo.cities cit WHERE cit.id_city = c.id_city) AS city,
                                                              dbo.srvpl_fnc('getDeviceShortCollectedNameNoBr',
                                                              NULL,
                                                              c.id_device,
                                                              NULL, NULL) AS device ,
                                                              ( ISNULL(c.device_model,
                                                              '') + ' №'
                                                              + c.serial_num ) AS device_curr ,
                                                              ( 
                                                              --SELECT TOP 1
                                                              --name_inn
                                                              --FROM
                                                              --dbo.get_contractor(c.id_contractor)
                                                              c.contractor ) AS contractor_col_name ,
                                                              ( SELECT
                                                              COUNT(1)
                                                              FROM
                                                              dbo.zipcl_claim_units cu
                                                              WHERE
                                                              cu.enabled = 1
                                                              AND cu.id_claim = c.id_claim
                                                              ) AS zip_unit_count ,
                                                              ( SELECT
                                                              SUM(cu.price_in)
                                                              FROM
                                                              dbo.zipcl_claim_units cu
                                                              WHERE
                                                              cu.enabled = 1
                                                              AND cu.id_claim = c.id_claim
                                                              ) AS price_in_sum ,
                                                              ( SELECT
                                                              SUM(cu.price_out)
                                                              FROM
                                                              dbo.zipcl_claim_units cu
                                                              WHERE
                                                              cu.enabled = 1
                                                              AND cu.id_claim = c.id_claim
                                                              ) AS price_out_sum ,
                                                              ( SELECT
                                                              name
                                                              FROM
                                                              dbo.zipcl_claim_states cst
                                                              WHERE
                                                              cst.id_claim_state = c.id_claim_state
                                                              ) AS claim_state ,
                                                              ( SELECT
                                                              cst.sys_name
                                                              FROM
                                                              dbo.zipcl_claim_states cst
                                                              WHERE
                                                              cst.id_claim_state = c.id_claim_state
                                                              ) AS claim_state_sys_name ,
                                                              et_state ,
                                                              et_waybill_state ,
                                                              ( SELECT
                                                              display_name
                                                              FROM
                                                              users uu
                                                              WHERE
                                                              uu.id_user = c.id_service_admin
                                                              ) AS service_admin ,
                                                              ( SELECT
                                                              display_name
                                                              FROM
                                                              users uu
                                                              WHERE
                                                              uu.id_user = c.id_operator
                                                              ) AS operator ,
                                                              ( SELECT
                                                              display_name
                                                              FROM
                                                              users uu
                                                              WHERE
                                                              uu.id_user = c.id_manager
                                                              ) AS manager ,
                                                              ( SELECT
                                                              CASE
                                                              WHEN st.order_num IN (
                                                              3, 10 ) THEN 1
                                                              ELSE 0
                                                              END
                                                              FROM
                                                              dbo.zipcl_claim_states st
                                                              WHERE
                                                              st.id_claim_state = c.id_claim_state
                                                              ) AS display_price_states ,
                                                              ( SELECT
                                                              CASE
                                                              WHEN st.sys_name IN (
                                                              'PRICEOK',
                                                              'ETORDER',
                                                              'ETDOCS',
                                                              'ETSHIP',
                                                              'ETPREP' )
                                                              THEN 1
                                                              ELSE 0
                                                              END
                                                              FROM
                                                              dbo.zipcl_claim_states st
                                                              WHERE
                                                              st.id_claim_state = c.id_claim_state
                                                              ) AS display_done_state ,
                                                              ( SELECT
                                                              CASE
                                                              WHEN st.order_num <= 1
                                                              THEN 1
                                                              ELSE 0
                                                              END
                                                              FROM
                                                              dbo.zipcl_claim_states st
                                                              WHERE
                                                              st.id_claim_state = c.id_claim_state
                                                              ) AS display_send_state ,
                                                              ( SELECT
                                                              CASE
                                                              WHEN st.order_num IN (
                                                              2, 7 ) THEN 1
                                                              ELSE 0
                                                              END
                                                              FROM
                                                              dbo.zipcl_claim_states st
                                                              WHERE
                                                              st.id_claim_state = c.id_claim_state
                                                              ) AS display_price_set ,
                                                              c.dattim1 ,
                                                              DATEDIFF(DAY,
                                                              c.dattim1,
                                                              GETDATE()) AS day_diff ,
                                                              c.service_desk_num ,
                                                              c.waybill_num ,
                                                              c.contractor_sd_num
                                                              FROM
                                                              dbo.zipcl_zip_claims c
                                                              INNER JOIN dbo.users u ON c.id_engeneer = u.id_user
                                                              WHERE
                                                              c.old_id_claim IS NULL
                                                              AND c.enabled = 1                                    
		--<Filters>
									/********************   id_claim   **********************/
                                                              AND ( ( @id_claim IS NULL
                                                              OR @id_claim <= 0
                                                              )
                                                              OR ( @id_claim > 0
                                                              AND c.id_claim = @id_claim
                                                              )
                                                              ) 
                                        /********************   serial_num   **********************/
                                                              AND ( @serial_num IS NULL
                                                              OR ( serial_num IS NOT NULL
                                                              AND c.serial_num LIKE '%'
                                                              + @serial_num
                                                              + '%'
                                                              )
                                                              ) 
                                    /********************   id_manager   **********************/
                                                              AND ( ( @id_manager IS NULL
                                                              OR @id_manager <= 0
                                                              )
                                                              OR ( @id_manager > 0
                                                              AND c.id_manager = @id_manager
                                                              )
                                                              ) 
                                        /********************   id_engeneer   **********************/
                                                              AND ( ( @id_engeneer IS NULL
                                                              OR @id_engeneer <= 0
                                                              )
                                                              OR ( @id_engeneer > 0
                                                              AND c.id_engeneer = @id_engeneer
                                                              )
                                                              )
                                        /********************   id_contractor   **********************/
                                                              --AND 
                                                              --( ( @id_contractor IS NULL
                                                              --OR @id_contractor <= 0
                                                              --)
                                                              --OR ( @id_contractor > 0
                                                              AND c.id_contractor = @id_contractor
                                                              --)
                                                              --)
                                        
                                         /********************   date_begin   **********************/
                                                              AND ( @date_begin IS NULL
                                                              OR ( @date_begin IS NOT NULL
                                                              AND CONVERT(DATE, c.dattim1) >= CONVERT(DATE, @date_begin)
                                                              )
                                                              )
                                         /********************   date_end   **********************/
                                                              AND ( @date_end IS NULL
                                                              OR ( @date_end IS NOT NULL
                                                              AND CONVERT(DATE, c.dattim1) <= CONVERT(DATE, @date_end)
                                                              )
                                                              )
									
                                                        
		--</Filters>
                                                            ) AS T
                                                ) AS tt
                                    ) AS ttt
                          WHERE     /********************   id_claim_state   **********************/
                                    ( @lst_claim_states IS NULL
                                      OR ( @lst_claim_states IS NOT NULL
                                           AND ttt.id_claim_state IN (
                                           SELECT   value
                                           FROM     dbo.Split(@lst_claim_states,
                                                              ',') )
                                         )
                                    )
                                    /********************   id_et_claim_state   **********************/
                        /*AND ( @lst_et_claim_states IS NULL
                              OR ( @lst_et_claim_states IS NOT NULL
                                   AND ttt.id_et_claim_state IN (
                                   SELECT   value
                                   FROM     dbo.Split(@lst_et_claim_states,
                                                      ',') )
                                 )
                            )*/
                                    /********************   id_waybill_claim_state   **********************/
                                    AND ( @lst_waybill_claim_states IS NULL
                                          OR ( @lst_waybill_claim_states IS NOT NULL
                                               AND ttt.id_waybill_claim_state IN (
                                               SELECT   value
                                               FROM     dbo.Split(@lst_waybill_claim_states,
                                                              ',') )
                                             )
                                        )
                        ) AS tttt
                WHERE   /********************   rows_count   **********************/
                        ( ( @rows_count IS NULL
                            OR @rows_count <= 0
                          )
                          OR ( @rows_count > 0
                               AND tttt.row_num <= @rows_count
                             )
                        )
                ORDER BY tttt.id_claim DESC
            END  
        ELSE
            IF @action = 'getClaimList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                    SELECT  *
                    FROM    ( SELECT    * ,
                                        ROW_NUMBER() OVER ( ORDER BY ttt.id_claim DESC ) AS row_num
                              FROM      ( SELECT    tt.id_claim ,
                                                    tt.device ,
                                                    tt.serial_num ,
                                                    tt.device_model ,
                                                    tt.contractor ,
                                                    tt.city ,
                                                    tt.address ,
                                                    tt.counter ,
                                                    tt.id_engeneer_conclusion ,
                                                    tt.id_claim_state ,
                                                    ( SELECT  id_claim_state
                                                      FROM    dbo.zipcl_claim_states
                                                      WHERE   name = et_waybill_state
                                                    ) AS id_waybill_claim_state ,
                                    --tt.id_et_claim_state ,
                                                    tt.request_num ,
                                                    tt.descr ,
                                                    tt.engeneer ,
                                                    tt.id_creator ,
                                                    tt.id_contractor ,
                                                    tt.contractor_col_name ,
                                                    tt.id_city ,
                                                    tt.zip_unit_count ,
                                                    tt.price_in_sum ,
                                                    tt.price_out_sum ,
                                                    ( CASE WHEN claim_state_sys_name IN (
                                                              'PRICEOK',
                                                              'ETORDER',
                                                              'ETDOCS',
                                                              'ETSHIP',
                                                              'ETPREP' )
                                                           THEN CASE
                                                              WHEN ( et_state IS NOT NULL
                                                              AND LTRIM(RTRIM(et_state)) != ''
                                                              )
                                                              THEN '<div class="lightlow nowrap">Статус требования:</div><div>'
                                                              + et_state
                                                              + '</div>'
                                                              ELSE ISNULL(claim_state,
                                                              'отсутствует')
                                                              END
                                                              + --№ накладной
                                                       CASE WHEN ( et_waybill_state IS NOT NULL
                                                              AND LTRIM(RTRIM(et_waybill_state)) != ''
                                                              )
                                                            THEN '<div class="lightlow nowrap">Статус трансп. заявки:</div><div>'
                                                              + tt.et_waybill_state
                                                              + '</div>'
                                                            ELSE ''
                                                       END ELSE ISNULL(claim_state,
                                                              'отсутствует')
                                                      END ) AS claim_state ,
                                                      --Приход план
                                                    CASE WHEN ( request_num IS NOT NULL
                                                              AND LTRIM(RTRIM(request_num)) != ''
                                                              )
                                                         THEN et_plan_came_date
                                                         ELSE 'Не указан номер требования'
                                                    END AS et_plan_came_date ,
                                                    tt.service_admin ,
                                                    tt.operator ,
                                                    tt.manager ,
                                                    tt.display_price_states ,
                                                    tt.display_done_state ,
                                                    tt.display_send_state ,
                                                    tt.display_price_set ,
                                                    tt.date_create ,
                                                    tt.cancel_comment ,
                                                    tt.service_desk_num ,
                                                    tt.fault_state ,
                                                    tt.waybill_num ,
                                                    ( SELECT  city
                                                      FROM    users eng_u
                                                      WHERE   eng_u.id_user = tt.id_engeneer
                                                    ) AS engeneer_city ,
                                                    ( SELECT  company
                                                      FROM    users eng_u
                                                      WHERE   eng_u.id_user = tt.id_engeneer
                                                    ) AS engeneer_org ,
                                                    ( SELECT  position
                                                      FROM    users eng_u
                                                      WHERE   eng_u.id_user = tt.id_engeneer
                                                    ) AS engeneer_pos ,
                                                    tt.contractor_sd_num
                                          FROM      ( SELECT  t.id_engeneer ,
                                                              t.id_claim ,
                                                              ISNULL(t.device,
                                                              t.device_curr) AS device ,
                                                              t.serial_num ,
                                                              t.device_model ,
                                                              t.contractor ,
                                                              t.city ,
                                                              t.address ,
                                                              t.counter ,
                                                              t.id_engeneer_conclusion ,
                                                              CASE
                                                              WHEN t.id_claim_state NOT IN (
                                                              SELECT
                                                              id_claim_state
                                                              FROM
                                                              dbo.zipcl_claim_states
                                                              WHERE
                                                              sys_name IN (
                                                              'DONE' ) )
                                                              AND et_state IS NOT NULL
                                                              AND LTRIM(RTRIM(et_state)) != ''
                                                              THEN ( SELECT
                                                              id_claim_state
                                                              FROM
                                                              dbo.zipcl_claim_states
                                                              WHERE
                                                              name = et_state
                                                              )
                                                              ELSE t.id_claim_state
                                                              END AS id_claim_state ,
                                                /*CASE WHEN t.id_claim_state IN (
                                                          SELECT
                                                              id_claim_state
                                                          FROM
                                                              dbo.zipcl_claim_states
                                                          WHERE
                                                              sys_name IN (
                                                              'DONE', 'PRICEOK' ) ) AND (et_state IS NULL
                                                          or LTRIM(RTRIM(et_state)) = '') THEN t.id_claim_state ELSE NULL END as id_claim_state,*/
                                                          --t.id_claim_state,
                                                /*( SELECT    id_claim_state
                                                  FROM      dbo.zipcl_claim_states
                                                  WHERE     name = et_state
                                                ) AS id_et_claim_state ,*/
                                                              t.request_num ,
                                                              t.descr ,
                                                              t.engeneer ,
                                                              t.id_creator ,
                                                              t.id_contractor ,
                                                              t.contractor_col_name ,
                                                              t.id_city ,
                                                              t.cancel_comment ,
                                                              ISNULL(zip_unit_count,
                                                              0) AS zip_unit_count ,
                                                /*ISNULL(CONVERT(NVARCHAR(13), price_in_sum),
                                                       'нет') AS price_in_sum ,
                                                ISNULL(CONVERT(NVARCHAR(13), price_out_sum),
                                                       'нет') AS price_out_sum ,*/
                                                              price_in_sum ,
                                                              price_out_sum ,
                                                              claim_state_sys_name ,
                                                              et_state ,
                                                              claim_state ,
                                                              ( CASE
                                                              WHEN t.et_waybill_state = 'Закрыто'
                                                              THEN 'Доставлено'
                                                              ELSE t.et_waybill_state
                                                              END ) AS et_waybill_state ,
                                                              ISNULL(service_admin,
                                                              '-') AS service_admin ,
                                                              ISNULL(operator,
                                                              '-') AS operator ,
                                                              ISNULL(manager,
                                                              '-') AS manager ,
                                                              ISNULL(display_price_states,
                                                              0) AS display_price_states ,
                                                              ISNULL(display_done_state,
                                                              0) AS display_done_state ,
                                                              ISNULL(display_send_state,
                                                              1) AS display_send_state ,
                                                              ISNULL(display_price_set,
                                                              0) AS display_price_set ,
                                                              ( CONVERT(NVARCHAR, t.dattim1, 104)
                                                              + ' ('
                                                              + CONVERT(NVARCHAR, day_diff)
                                                              + ' дн.)' ) AS date_create ,
                                                              t.service_desk_num ,
                                                              CASE
                                                              WHEN t.id_engeneer_conclusion = 2
                                                              THEN 'bg-danger'
                                                              ELSE ''
                                                              END AS fault_state ,
                                                              t.waybill_num ,
                                                              t.contractor_sd_num ,
                                                              t.et_plan_came_date
                                                      FROM    ( SELECT
                                                              id_engeneer ,
                                                              id_claim ,
                                                              id_device ,
                                                              serial_num ,
                                                              device_model ,
                                                              contractor ,
                                                              c.city ,
                                                              address ,
                                                              counter ,
                                                              id_engeneer_conclusion ,
                                                              id_claim_state ,
                                                              request_num ,
                                                              descr ,
                                                              u.display_name AS engeneer ,
                                                              id_creator ,
                                                              id_contractor ,
                                                              c.id_city ,
                                                              c.cancel_comment ,
                          --(SELECT name FROM dbo.cities cit WHERE cit.id_city = c.id_city) AS city,
                                                              dbo.srvpl_fnc('getDeviceShortCollectedName',
                                                              NULL,
                                                              c.id_device,
                                                              NULL, NULL) AS device ,
                                                              ( ISNULL(c.device_model,
                                                              '') + ' №'
                                                              + c.serial_num ) AS device_curr ,
                                                              ( 
                                                              --SELECT TOP 1
                                                              --name_inn
                                                              --FROM
                                                              --dbo.get_contractor(c.id_contractor)
                                                              c.contractor ) AS contractor_col_name ,
                                                              ( SELECT
                                                              COUNT(1)
                                                              FROM
                                                              dbo.zipcl_claim_units cu
                                                              WHERE
                                                              cu.enabled = 1
                                                              AND cu.id_claim = c.id_claim
                                                              ) AS zip_unit_count ,
                                                              ( SELECT
                                                              SUM(cu.price_in)
                                                              FROM
                                                              dbo.zipcl_claim_units cu
                                                              WHERE
                                                              cu.enabled = 1
                                                              AND cu.id_claim = c.id_claim
                                                              ) AS price_in_sum ,
                                                              ( SELECT
                                                              SUM(cu.price_out)
                                                              FROM
                                                              dbo.zipcl_claim_units cu
                                                              WHERE
                                                              cu.enabled = 1
                                                              AND cu.id_claim = c.id_claim
                                                              ) AS price_out_sum ,
                                                              ( SELECT
                                                              name
                                                              FROM
                                                              dbo.zipcl_claim_states cst
                                                              WHERE
                                                              cst.id_claim_state = c.id_claim_state
                                                              ) AS claim_state ,
                                                              ( SELECT
                                                              cst.sys_name
                                                              FROM
                                                              dbo.zipcl_claim_states cst
                                                              WHERE
                                                              cst.id_claim_state = c.id_claim_state
                                                              ) AS claim_state_sys_name ,
                                                              /*( SELECT
                                                              ixvblg5apxsh COLLATE Cyrillic_General_CI_AS
                                                              FROM
                                                              [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_ixvblg5apz51
                                                              WHERE
                                                              ixvblg5apz4e COLLATE Cyrillic_General_CI_AS = c.request_num
                                                              ) AS*/
                                                              et_state ,
                                                              /*( SELECT
                                                              IXVBLG5ZD4K7 COLLATE Cyrillic_General_CI_AS
                                                              FROM
                                                              [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_IXVBLG5ZO8B9
                                                              WHERE
                                                              IXVBLG5ZCSPK COLLATE Cyrillic_General_CI_AS = c.waybill_num
                                                              ) AS */
                                                              et_waybill_state ,
                                                              ( SELECT
                                                              display_name
                                                              FROM
                                                              users uu
                                                              WHERE
                                                              uu.id_user = c.id_service_admin
                                                              ) AS service_admin ,
                                                              ( SELECT
                                                              display_name
                                                              FROM
                                                              users uu
                                                              WHERE
                                                              uu.id_user = c.id_operator
                                                              ) AS operator ,
                                                              ( SELECT
                                                              display_name
                                                              FROM
                                                              users uu
                                                              WHERE
                                                              uu.id_user = c.id_manager
                                                              ) AS manager ,
                                                              ( SELECT
                                                              CASE
                                                              WHEN st.order_num IN (
                                                              3, 10 ) THEN 1
                                                              ELSE 0
                                                              END
                                                              FROM
                                                              dbo.zipcl_claim_states st
                                                              WHERE
                                                              st.id_claim_state = c.id_claim_state
                                                              ) AS display_price_states ,
                                                              ( SELECT
                                                              CASE
                                                              WHEN st.sys_name IN (
                                                              'PRICEOK',
                                                              'ETORDER',
                                                              'ETDOCS',
                                                              'ETSHIP',
                                                              'ETPREP' )
                                                              THEN 1
                                                              ELSE 0
                                                              END
                                                              FROM
                                                              dbo.zipcl_claim_states st
                                                              WHERE
                                                              st.id_claim_state = c.id_claim_state
                                                              ) AS display_done_state ,
                                                              ( SELECT
                                                              CASE
                                                              WHEN st.order_num <= 1
                                                              THEN 1
                                                              ELSE 0
                                                              END
                                                              FROM
                                                              dbo.zipcl_claim_states st
                                                              WHERE
                                                              st.id_claim_state = c.id_claim_state
                                                              ) AS display_send_state ,
                                                              ( SELECT
                                                              CASE
                                                              WHEN st.order_num IN (
                                                              2, 7 ) THEN 1
                                                              ELSE 0
                                                              END
                                                              FROM
                                                              dbo.zipcl_claim_states st
                                                              WHERE
                                                              st.id_claim_state = c.id_claim_state
                                                              ) AS display_price_set ,
                                                              c.dattim1 ,
                                                              DATEDIFF(DAY,
                                                              c.dattim1,
                                                              GETDATE()) AS day_diff ,
                                                              c.service_desk_num ,
                                                              c.waybill_num ,
                                                              c.contractor_sd_num ,
                                                              c.et_plan_came_date
                                                              FROM
                                                              dbo.zipcl_zip_claims c
                                                              INNER JOIN dbo.users u ON c.id_engeneer = u.id_user
                                                              WHERE
                                                              c.old_id_claim IS NULL
                                                              AND c.enabled = 1                                    
		--<Filters>
									/********************   id_claim   **********************/
                                                              AND ( ( @id_claim IS NULL
                                                              OR @id_claim <= 0
                                                              )
                                                              OR ( @id_claim > 0
                                                              AND c.id_claim = @id_claim
                                                              )
                                                              ) 
                                                              /********************   SD number   **********************/
                                                              AND ( @service_desk_num IS NULL
                                                              OR ( @service_desk_num IS NOT NULL
                                                              AND c.service_desk_num = @service_desk_num
                                                              )
                                                              ) 
                                                              /********************  contractor SD number   **********************/
                                                              AND ( @contractor_sd_num IS NULL
                                                              OR ( @contractor_sd_num IS NOT NULL
                                                              AND c.contractor_sd_num = @contractor_sd_num
                                                              )
                                                              ) 
                                        /********************   serial_num   **********************/
                                                              AND ( @serial_num IS NULL
                                                              OR ( serial_num IS NOT NULL
                                                              AND c.serial_num LIKE '%'
                                                              + @serial_num
                                                              + '%'
                                                              )
                                                              ) 
                                    /********************   id_manager   **********************/
                                                              AND ( ( @id_manager IS NULL
                                                              OR @id_manager <= 0
                                                              )
                                                              OR ( @id_manager > 0
                                                              AND c.id_manager = @id_manager
                                                              )
                                                              ) 
                                        /********************   id_engeneer   **********************/
                                                              AND ( ( @id_engeneer IS NULL
                                                              OR @id_engeneer <= 0
                                                              )
                                                              OR ( @id_engeneer > 0
                                                              AND c.id_engeneer = @id_engeneer
                                                              )
                                                              )
                                        /********************   id_operator   **********************/
                                                              AND ( ( @id_operator IS NULL
                                                              OR @id_operator <= 0
                                                              )
                                                              OR ( @id_operator > 0
                                                              AND c.id_operator = @id_operator
                                                              )
                                                              )
                                        /********************   id_service_admin   **********************/
                                                              AND ( ( @id_service_admin IS NULL
                                                              OR @id_service_admin <= 0
                                                              )
                                                              OR ( @id_service_admin > 0
                                                              AND c.id_service_admin = @id_service_admin
                                                              )
                                                              )
                                        /********************   id_contractor   **********************/
                                                              AND ( ( @id_contractor IS NULL
                                                              OR @id_contractor <= 0
                                                              )
                                                              OR ( @id_contractor > 0
                                                              AND c.id_contractor = @id_contractor
                                                              )
                                                              )
                                        
                                         /********************   date_begin   **********************/
                                                              AND ( @date_begin IS NULL
                                                              OR ( @date_begin IS NOT NULL
                                                              AND CONVERT(DATE, c.dattim1) >= CONVERT(DATE, @date_begin)
                                                              )
                                                              )
                                         /********************   date_end   **********************/
                                                              AND ( @date_end IS NULL
                                                              OR ( @date_end IS NOT NULL
                                                              AND CONVERT(DATE, c.dattim1) <= CONVERT(DATE, @date_end)
                                                              )
                                                              )
                                        /********************   not_in_system   **********************/
                                        --Устройства которые не были найдены в системе
                                                              AND ( @not_in_system IS NULL
                                                              OR ( @not_in_system = 1
                                                              AND c.id_device IS NOT NULL
                                                              )
                                                              OR ( @not_in_system = 0
                                                              AND c.id_device IS NULL
                                                              )
                                                              )
									/********************   NUMBER   **********************/
                                    /*AND ( @number IS NULL
                                          OR ( @number IS NOT NULL
                                               AND c.number LIKE '%' + @number
                                               + '%'
                                             )
                                        ) */
									
                                                        
		--</Filters>
                                                              ) AS T
                                                    ) AS tt
                                        ) AS ttt
                              WHERE     /********************   id_claim_state   **********************/
                                        ( @lst_claim_states IS NULL
                                          OR ( @lst_claim_states IS NOT NULL
                                               AND ttt.id_claim_state IN (
                                               SELECT   value
                                               FROM     dbo.Split(@lst_claim_states,
                                                              ',') )
                                             )
                                        )
                                    /********************   id_et_claim_state   **********************/
                        /*AND ( @lst_et_claim_states IS NULL
                              OR ( @lst_et_claim_states IS NOT NULL
                                   AND ttt.id_et_claim_state IN (
                                   SELECT   value
                                   FROM     dbo.Split(@lst_et_claim_states,
                                                      ',') )
                                 )
                            )*/
                                    /********************   id_waybill_claim_state   **********************/
                                        AND ( @lst_waybill_claim_states IS NULL
                                              OR ( @lst_waybill_claim_states IS NOT NULL
                                                   AND ttt.id_waybill_claim_state IN (
                                                   SELECT   value
                                                   FROM     dbo.Split(@lst_waybill_claim_states,
                                                              ',') )
                                                 )
                                            )
                            ) AS tttt
                    WHERE   /********************   rows_count   **********************/
                            ( ( @rows_count IS NULL
                                OR @rows_count <= 0
                              )
                              OR ( @rows_count > 0
                                   AND tttt.row_num <= @rows_count
                                 )
                            )
                    ORDER BY tttt.id_claim DESC
                END            
            ELSE
                IF @action = 'getClaimSelectionList'
                    BEGIN
                        SELECT  NULL
                    END
                ELSE
                    IF @action = 'getClaim'
                        BEGIN
                            SELECT  id_claim ,
                                    id_device ,
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
                                    ( SELECT    CASE WHEN st.order_num IN ( 3,
                                                              10 ) THEN 1
                                                     ELSE 0
                                                END
                                      FROM      dbo.zipcl_claim_states st
                                      WHERE     st.id_claim_state = c.id_claim_state
                                    ) AS display_price_states ,
                                    ( SELECT    CASE WHEN st.sys_name IN (
                                                          'PRICEOK', 'ETORDER',
                                                          'ETDOCS', 'ETSHIP',
                                                          'ETPREP' ) THEN 1
                                                     ELSE 0
                                                END
                                      FROM      dbo.zipcl_claim_states st
                                      WHERE     st.id_claim_state = c.id_claim_state
                                    ) AS display_done_state ,
                                    ISNULL(( SELECT CASE WHEN st.order_num <= 1
                                                         THEN 1
                                                         ELSE 0
                                                    END
                                             FROM   dbo.zipcl_claim_states st
                                             WHERE  st.id_claim_state = c.id_claim_state
                                           ), 1) AS display_send_state ,
                                    ( SELECT    CASE WHEN st.order_num IN ( 2,
                                                              7 ) THEN 1
                                                     ELSE 0
                                                END
                                      FROM      dbo.zipcl_claim_states st
                                      WHERE     st.id_claim_state = c.id_claim_state
                                    ) AS display_price_set ,
                                    ( SELECT    CASE WHEN st.order_num NOT IN (
                                                          11 ) THEN 1
                                                     ELSE 0
                                                END
                                      FROM      dbo.zipcl_claim_states st
                                      WHERE     st.id_claim_state = c.id_claim_state
                                    ) AS display_cancel_state ,
                                    service_desk_num ,
                                    c.dattim1 AS date_create ,
                                    c.counter_colour ,
                                    c.cancel_comment ,
                                    c.[object_name] ,
                                    c.waybill_num ,
                                    c.contract_num ,
                                    c.contract_type ,
                                    ( SELECT    full_name
                                      FROM      users u
                                      WHERE     u.id_user = c.id_engeneer
                                    ) AS service_engeneer ,
                                    ( SELECT    full_name
                                      FROM      users u
                                      WHERE     u.id_user = c.id_manager
                                    ) AS manager ,
                                    ( SELECT    ec.name
                                      FROM      dbo.zipcl_engeneer_conclusions ec
                                      WHERE     ec.id_engeneer_conclusion = c.id_engeneer_conclusion
                                    ) AS engeneer_conclusion ,
                                    ( SELECT    mail
                                      FROM      users u
                                      WHERE     u.id_user = c.id_manager
                                    ) AS manager_mail ,
                                    c.contractor_sd_num ,
                                    ( CASE WHEN c.id_contractor IS NULL
                                                AND c.id_device IS NULL
                                           THEN NULL
                                           ELSE ( SELECT TOP 1
                                                            cc.id_contract
                                                  FROM      dbo.srvpl_contracts cc
                                                  WHERE     enabled = 1
                                                            AND cc.id_contractor = c.id_contractor
                                                            AND dbo.srvpl_fnc('checkContractIsActiveOnMonth',
                                                              NULL,
                                                              cc.id_contract,
                                                              c.dattim1, NULL) = '1'
                                                )
                                      END ) AS id_contract ,
                                    ( CASE WHEN EXISTS ( SELECT
                                                              1
                                                         FROM dbo.zipcl_claim_states st
                                                         WHERE
                                                              st.id_claim_state = c.id_claim_state
                                                              AND st.sys_name != 'NEW' )
                                           THEN 1
                                           ELSE 0
                                      END ) AS hide_top
                            FROM    dbo.zipcl_zip_claims c
                            WHERE   c.id_claim = @id_claim
                        END
                    ELSE
                        IF @action = 'saveClaim'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END
				
                                SET @var_str = 'insClaim'
								
                                IF EXISTS ( SELECT  1
                                            FROM    dbo.zipcl_zip_claims t
                                            WHERE   t.id_claim = @id_claim )
                                    BEGIN
                                        SET @var_str = 'updClaim'    
                                        IF @id_claim_state IS NULL
                                            AND @id_manager IS NOT NULL
                                            AND EXISTS ( SELECT
                                                              1
                                                         FROM dbo.zipcl_zip_claims cl
                                                              INNER JOIN dbo.zipcl_claim_states st ON cl.id_claim_state = st.id_claim_state
                                                         WHERE
                                                              id_claim = @id_claim
                                                              AND st.sys_name IN (
                                                              'SEND' ) )
                                            BEGIN
									--Когда устанавливаем менеджера то автоматом ставим статус Назначено
                                                SELECT  @id_claim_state = id_claim_state
                                                FROM    dbo.zipcl_claim_states cs
                                                WHERE   cs.enabled = 1
                                                        AND UPPER(cs.sys_name) = 'MANSEL'
                                            END
                                    END	
                            
                                IF @var_str = 'insClaim'
                                    BEGIN
                                    --IF @id_claim_state IS NULL
                                    --    BEGIN
									--При создании новой заявки присавиваем соответствующий статус NEW
                                        SELECT  @id_claim_state = id_claim_state
                                        FROM    dbo.zipcl_claim_states cs
                                        WHERE   cs.enabled = 1
                                                AND UPPER(cs.sys_name) = 'NEW'
                                        --END
                                        
                                        SELECT TOP ( 1 )
                                                @contractor = name_inn
                                        FROM    dbo.get_contractor(@id_contractor)
                                    END	
                                   
                                IF @id_claim_state = 0
                                    BEGIN
                                   
                                        SET @id_claim_state = NULL
                                    END 
                                
                                --Сохарняем факт изменения статуса
                                IF @id_claim_state IS NOT NULL
                                    BEGIN
                                        SELECT  @curr_id_claim_state = id_claim_state
                                        FROM    dbo.zipcl_zip_claims c
                                        WHERE   c.id_claim = @id_claim
                                    
                                        EXEC dbo.sk_zip_claims @action = 'insClaimStateChange',
                                            @id_claim = @id_claim,
                                            @id_claim_state = @id_claim_state,
                                            @date_change = @date_now,
                                            @id_creator = @id_creator,
                                            @id_claim_state_from = @curr_id_claim_state,
                                            @id_claim_state_to = @id_claim_state
                                    END      
									
                                EXEC @id_claim = dbo.sk_zip_claims @action = @var_str,
                                    @id_claim = @id_claim,
                                    @id_device = @id_device,
                                    @serial_num = @serial_num,
                                    @device_model = @device_model,
                                    @contractor = @contractor, @city = @city,
                                    @address = @address, @counter = @counter,
                                    @id_engeneer_conclusion = @id_engeneer_conclusion,
                                    @id_claim_state = @id_claim_state,
                                    @request_num = @request_num,
                                    @descr = @descr,
                                    @id_engeneer = @id_engeneer,
                                    @id_creator = @id_creator,
                                    @id_contractor = @id_contractor,
                                    @id_city = @id_city,
                                    @id_manager = @id_manager,
                                    @id_operator = @id_operator,
                                    @id_service_admin = @id_service_admin,
                                    @service_desk_num = @service_desk_num,
                                    @counter_colour = @counter_colour,
                                    @cancel_comment = @cancel_comment,
                                    @object_name = @object_name,
                                    @waybill_num = @waybill_num,
                                    @contract_num = @contract_num,
                                    @contract_type = @contract_type,
                                    @contractor_sd_num = @contractor_sd_num
                                
                                           
                            
                                IF @var_str = 'updClaim'
                                    BEGIN
										
										
                                        SELECT  @var_str = sys_name
                                        FROM    dbo.zipcl_claim_states
                                        WHERE   id_claim_state = @id_claim_state	
                                
                                        SELECT  @id_sended_mail_type = id_sended_mail_type
                                        FROM    dbo.sended_mail_types st
                                        WHERE   st.id_program = @id_program
                                                AND st.sys_name = 'sendMailStateSend'
                                
                                
                                --Если статус Передано
                                        IF @var_str = 'SEND'
                                            AND NOT EXISTS ( SELECT
                                                              1
                                                             FROM
                                                              dbo.sended_mails sm
                                                             WHERE
                                                              sm.id_sended_mail_type = @id_sended_mail_type
                                                              AND uid = @id_claim )
                                            BEGIN
                                            
                                            
												  --Если не передан id аппарата, но передан id заявки то вычисляем id аппарата
                                                IF @id_device IS NULL
                                                    AND @id_claim IS NOT NULL
                                                    BEGIN
                                                        SELECT
                                                              @id_device = id_device ,
                                                              @id_manager = CASE
                                                              WHEN @id_manager IS NULL
                                                              THEN cl.id_manager
                                                              ELSE @id_manager
                                                              END ,
                                                              @id_engeneer = CASE
                                                              WHEN @id_engeneer IS NULL
                                                              THEN cl.id_engeneer
                                                              ELSE @id_engeneer
                                                              END
                                                        FROM  dbo.zipcl_zip_claims cl
                                                        WHERE id_claim = @id_claim
                                                    END
                                                    
                                                --Если есть аппарат и он гарантийный, то добавляем уведомление
                                                IF @id_device IS NOT NULL
                                                    AND EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_contract2devices c2d
                                                              INNER JOIN dbo.srvpl_contracts c ON c2d.id_contract = c.id_contract
                                                              INNER JOIN dbo.srvpl_contract_types ct ON ct.id_contract_type = c.id_contract_type
                                                              INNER JOIN dbo.srvpl_devices d ON c2d.id_device = d.id_device
                                                              WHERE
                                                              c2d.enabled = 1
                                                              AND c.enabled = 1
                                                              AND d.enabled = 1
                                                              AND c2d.id_device = @id_device
                                                              AND dbo.srvpl_check_contract_is_active(c2d.id_contract,
                                                              GETDATE()) = 1
                                                              AND UPPER(ct.sys_name) = 'GUARANTEE' )
                                                    BEGIN
                                                        DECLARE @contractor_name NVARCHAR(500) ,
                                                            @device NVARCHAR(500) ,
                                                            @manager NVARCHAR(500) ,
                                                            @engeneer NVARCHAR(500)
                                                    
                                                        SELECT
                                                              @contractor_name = ctr.name_inn ,
                                                              @device = dbo.srvpl_get_device_name(c2d.id_device,
                                                              NULL) ,
                                                              @manager = ( SELECT
                                                              full_name
                                                              FROM
                                                              users u
                                                              WHERE
                                                              u.id_user = @id_manager
                                                              ) ,
                                                              @engeneer = ( SELECT
                                                              full_name
                                                              FROM
                                                              users u
                                                              WHERE
                                                              u.id_user = @id_engeneer
                                                              )
                                                        FROM  dbo.srvpl_contract2devices c2d
                                                              INNER JOIN dbo.srvpl_contracts c ON c2d.id_contract = c.id_contract
                                                              INNER JOIN dbo.get_contractor(NULL) ctr ON c.id_contractor = ctr.id
                                                              INNER JOIN dbo.srvpl_contract_types ct ON ct.id_contract_type = c.id_contract_type
                                                              INNER JOIN dbo.srvpl_devices d ON c2d.id_device = d.id_device
                                                        WHERE c2d.id_device = @id_device
														
                                                        SET @mail_subject = 'Заявка на ЗИП'
														
                                                        SET @mail_text = ISNULL(@mail_text,
                                                              '')
                                                            + '<span style="color:#a94442">'
                                                            + 'Внимание! Аппарат находится на гарантии, необходимо согласовать заказ ЗИП с сервисной службой!'
                                                            + '</span>'
                                                            + '<br />'
                                                            + 'Контрагент: '
                                                            + ISNULL(@contractor_name,
                                                              'не определено')
                                                            + '<br />'
                                                            + +'Аппарат: '
                                                            + ISNULL(@device,
                                                              'не определено')
                                                            + '<br />'
                                                            + +'Менеджер: '
                                                            + ISNULL(@manager,
                                                              'не определено')
                                                            + '<br />'
                                                            + +'Инженер: '
                                                            + ISNULL(@engeneer,
                                                              'не определено')
                                                            + '<br />'
                                                            + +'<a href="'
                                                            + ISNULL(@root_url,
                                                              '') + '?id='
                                                            + ISNULL(CONVERT(NVARCHAR(10), @id_claim),
                                                              '')
                                                            + '">заявка на ЗИП №'
                                                            + ISNULL(CONVERT(NVARCHAR(10), @id_claim),
                                                              '') + '</a>'
                                                            + '<br />'
                                                            
                                                            
                                                            
                                                            --Если аппарат на гарантии, то отправляем уведомление Главному инженеру
                                                
                                                        DECLARE @kobzarev NVARCHAR(150)
                                                        --DECLARE @rehov NVARCHAR(150)
													
                                                        --SELECT
                                                        --      @rehov = mail
                                                        --FROM  dbo.users u
                                                        --WHERE enabled = 1
                                                        --      AND sid = 'S-1-5-21-1970802976-3466419101-4042325969-2365'
													
                                                        --EXEC sk_send_message @action = 'send_email',
                                                        --    @id_program = @id_program,
                                                        --    @subject = @mail_subject,
                                                        --    @body = @mail_text,
                                                        --    @recipients = @rehov	
													
                                                        SELECT
                                                              @kobzarev = mail
                                                        FROM  dbo.users u
                                                        WHERE enabled = 1
                                                              AND sid = 'S-1-5-21-1970802976-3466419101-4042325969-1598'
                                                
                                                        EXEC sk_send_message @action = 'send_email',
                                                            @id_program = @id_program,
                                                            @subject = @mail_subject,
                                                            @body = @mail_text,
                                                            @recipients = @kobzarev	
												
                                                   
                                                    END  
                                            
                                            
                                                SELECT  @mail_address = mail
                                                FROM    users
                                                WHERE   id_user = ( SELECT
                                                              id_service_admin
                                                              FROM
                                                              dbo.zipcl_zip_claims
                                                              WHERE
                                                              id_claim = @id_claim
                                                              )
                                                
                                                
                                                
                                                SET @mail_text = 'Для вас передана <a href="'
                                                    + @root_url + '?id='
                                                    + CONVERT(NVARCHAR(10), @id_claim)
                                                    + '">заявка на ЗИП №'
                                                    + CONVERT(NVARCHAR(10), @id_claim)
                                                    + '</a>'
                                                    
                                                 
                                                    
                                                SET @mail_subject = 'Заявка на ЗИП'
									
                                                EXEC sk_send_message @action = 'send_email',
                                                    @id_program = @id_program,
                                                    @subject = @mail_subject,
                                                    @body = @mail_text,
                                                    @recipients = @mail_address	
												
                                                EXEC dbo.sk_sended_mails @id_program = @id_program,
                                                    @id_sended_mail_type = @id_sended_mail_type,
                                                    @uid = @id_claim
                                                
                                                
                                            --Если менеджер указан то устанавливаем статус Назначено              
                                                IF EXISTS ( SELECT
                                                              1
                                                            FROM
                                                              dbo.zipcl_zip_claims cl
                                                            WHERE
                                                              cl.id_claim = @id_claim
                                                              AND id_manager IS NOT NULL ) 
                                                              --Если статус передано установлен
                                                    AND EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.zipcl_zip_claims cl
                                                              INNER JOIN dbo.zipcl_claim_states css ON cl.id_claim_state = css.id_claim_state
                                                              WHERE
                                                              ( cl.id_claim = @id_claim
                                                              OR old_id_claim = @id_claim
                                                              )
                                                              AND css.sys_name = 'SEND' )
                                                    BEGIN
                                                        EXEC dbo.ui_zip_claims @action = N'setClaimManSelState',
                                                            @id_claim = @id_claim,
                                                            @id_creator = @id_creator
                                                    END
                                                    
                                                   
                                                    
                                            END
                                        
                                        SELECT  @id_sended_mail_type = id_sended_mail_type
                                        FROM    dbo.sended_mail_types st
                                        WHERE   st.id_program = @id_program
                                                AND st.sys_name = 'sendMailStateMansel'
                                        
                                        IF @var_str = 'MANSEL'
                                            AND NOT EXISTS ( SELECT
                                                              1
                                                             FROM
                                                              dbo.sended_mails sm
                                                             WHERE
                                                              sm.id_sended_mail_type = @id_sended_mail_type
                                                              AND uid = @id_claim )
                                            BEGIN
                                            
												--Если не передан id аппарата, но передан id заявки то вычисляем id аппарата
                                                IF @id_device IS NULL
                                                    AND @id_claim IS NOT NULL
                                                    BEGIN
                                                        SELECT
                                                              @id_device = id_device ,
                                                              @id_manager = CASE
                                                              WHEN @id_manager IS NULL
                                                              THEN cl.id_manager
                                                              ELSE @id_manager
                                                              END ,
                                                              @id_engeneer = CASE
                                                              WHEN @id_engeneer IS NULL
                                                              THEN cl.id_engeneer
                                                              ELSE @id_engeneer
                                                              END
                                                        FROM  dbo.zipcl_zip_claims cl
                                                        WHERE id_claim = @id_claim
                                                    END
                                                    
                                                --Если есть аппарат и он гарантийный, то добавляем уведомление
                                                IF @id_device IS NOT NULL
                                                    AND EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_contract2devices c2d
                                                              INNER JOIN dbo.srvpl_contracts c ON c2d.id_contract = c.id_contract
                                                              INNER JOIN dbo.srvpl_contract_types ct ON ct.id_contract_type = c.id_contract_type
                                                              INNER JOIN dbo.srvpl_devices d ON c2d.id_device = d.id_device
                                                              WHERE
                                                              c2d.enabled = 1
                                                              AND c.enabled = 1
                                                              AND d.enabled = 1
                                                              AND c2d.id_device = @id_device
                                                              AND dbo.srvpl_check_contract_is_active(c2d.id_contract,
                                                              GETDATE()) = 1
                                                              AND UPPER(ct.sys_name) = 'GUARANTEE' )
                                                    BEGIN
                                                                                                           
                                                        SELECT
                                                              @contractor_name = ctr.name_inn ,
                                                              @device = dbo.srvpl_get_device_name(c2d.id_device,
                                                              NULL) ,
                                                              @manager = ( SELECT
                                                              full_name
                                                              FROM
                                                              users u
                                                              WHERE
                                                              u.id_user = @id_manager
                                                              ) ,
                                                              @engeneer = ( SELECT
                                                              full_name
                                                              FROM
                                                              users u
                                                              WHERE
                                                              u.id_user = @id_engeneer
                                                              )
                                                        FROM  dbo.srvpl_contract2devices c2d
                                                              INNER JOIN dbo.srvpl_contracts c ON c2d.id_contract = c.id_contract
                                                              INNER JOIN dbo.get_contractor(NULL) ctr ON c.id_contractor = ctr.id
                                                              INNER JOIN dbo.srvpl_contract_types ct ON ct.id_contract_type = c.id_contract_type
                                                              INNER JOIN dbo.srvpl_devices d ON c2d.id_device = d.id_device
                                                        WHERE c2d.id_device = @id_device
														
                                                        SET @mail_text = ISNULL(@mail_text,
                                                              '')
                                                            + '<span style="color:#a94442">'
                                                            + 'Внимание! Аппарат находится на гарантии, необходимо согласовать заказ ЗИП с сервисной службой!'
                                                            + '</span>'
                                                            + '<br />'
                                                            + 'Контрагент: '
                                                            + ISNULL(@contractor_name,
                                                              'не определено')
                                                            + '<br />'
                                                            + +'Аппарат: '
                                                            + ISNULL(@device,
                                                              'не определено')
                                                            + '<br />'
                                                            + +'Менеджер: '
                                                            + ISNULL(@manager,
                                                              'не определено')
                                                            + '<br />'
                                                            + +'Инженер: '
                                                            + ISNULL(@engeneer,
                                                              'не определено')
                                                            + '<br />'
                                                            + +'<a href="'
                                                            + ISNULL(@root_url,
                                                              '') + '?id='
                                                            + ISNULL(CONVERT(NVARCHAR(10), @id_claim),
                                                              '')
                                                            + '">заявка на ЗИП №'
                                                            + ISNULL(CONVERT(NVARCHAR(10), @id_claim),
                                                              '') + '</a>'
                                                            + '<br />'                                    
                                                    END  
                                            
                                            
                                                SELECT  @mail_address = mail
                                                FROM    users
                                                WHERE   id_user = ( SELECT
                                                              id_manager
                                                              FROM
                                                              dbo.zipcl_zip_claims
                                                              WHERE
                                                              id_claim = @id_claim
                                                              )
                                                SET @mail_text = ISNULL(@mail_text,
                                                              '')
                                                    + 'Вас указали в качестве менеджера к <a href="'
                                                    + @root_url + '?id='
                                                    + CONVERT(NVARCHAR(10), @id_claim)
                                                    + '">заявке на ЗИП №'
                                                    + CONVERT(NVARCHAR(10), @id_claim)
                                                    + '</a>'
                                                SET @mail_subject = 'Заявка на ЗИП'
									
                                                EXEC sk_send_message @action = 'send_email',
                                                    @id_program = @id_program,
                                                    @subject = @mail_subject,
                                                    @body = @mail_text,
                                                    @recipients = @mail_address	
                                
                                                EXEC dbo.sk_sended_mails @id_program = @id_program,
                                                    @id_sended_mail_type = @id_sended_mail_type,
                                                    @uid = @id_claim
                                            
                                            
                                            END
                                        
                                        SELECT  @id_sended_mail_type = id_sended_mail_type
                                        FROM    dbo.sended_mail_types st
                                        WHERE   st.id_program = @id_program
                                                AND st.sys_name = 'sendMailStateOperatorSet'
                                        
                                        IF EXISTS ( SELECT  1
                                                    FROM    dbo.zipcl_zip_claims
                                                    WHERE   id_claim = @id_claim
                                                            AND id_operator IS NOT NULL )
                                            AND NOT EXISTS ( SELECT
                                                              1
                                                             FROM
                                                              dbo.sended_mails sm
                                                             WHERE
                                                              sm.id_sended_mail_type = @id_sended_mail_type
                                                              AND uid = @id_claim )
                                            BEGIN
                                                SELECT  @mail_address = mail
                                                FROM    users
                                                WHERE   id_user = ( SELECT
                                                              id_operator
                                                              FROM
                                                              dbo.zipcl_zip_claims
                                                              WHERE
                                                              id_claim = @id_claim
                                                              )
                                                SET @mail_text = 'Вас указали в качестве оператора к <a href="'
                                                    + @root_url + '?id='
                                                    + CONVERT(NVARCHAR(10), @id_claim)
                                                    + '">заявке на ЗИП №'
                                                    + CONVERT(NVARCHAR(10), @id_claim)
                                                    + '</a>'
                                                SET @mail_subject = 'Заявка на ЗИП'
									
                                                EXEC sk_send_message @action = 'send_email',
                                                    @id_program = @id_program,
                                                    @subject = @mail_subject,
                                                    @body = @mail_text,
                                                    @recipients = @mail_address	
                                
                                                EXEC dbo.sk_sended_mails @id_program = @id_program,
                                                    @id_sended_mail_type = @id_sended_mail_type,
                                                    @uid = @id_claim
                                                
                                                
                                            END
                                        
                                        SELECT  @id_sended_mail_type = id_sended_mail_type
                                        FROM    dbo.sended_mail_types st
                                        WHERE   st.id_program = @id_program
                                                AND st.sys_name = 'sendMailStatePrice'
                                        
                                        IF @var_str = 'PRICE'
                                            AND NOT EXISTS ( SELECT
                                                              1
                                                             FROM
                                                              dbo.sended_mails sm
                                                             WHERE
                                                              sm.id_sended_mail_type = @id_sended_mail_type
                                                              AND uid = @id_claim )
                                            BEGIN
                                                SELECT  @mail_address = mail
                                                FROM    users
                                                WHERE   id_user = ( SELECT
                                                              id_manager
                                                              FROM
                                                              dbo.zipcl_zip_claims
                                                              WHERE
                                                              id_claim = @id_claim
                                                              )
                                                SET @mail_text = 'К <a href="'
                                                    + @root_url + '?id='
                                                    + CONVERT(NVARCHAR(10), @id_claim)
                                                    + '">заявке на ЗИП №'
                                                    + CONVERT(NVARCHAR(10), @id_claim)
                                                    + '</a> проставлены цены.'
                                                SET @mail_subject = 'Заявка на ЗИП'
									
                                                EXEC sk_send_message @action = 'send_email',
                                                    @id_program = @id_program,
                                                    @subject = @mail_subject,
                                                    @body = @mail_text,
                                                    @recipients = @mail_address	
                                
                                                EXEC dbo.sk_sended_mails @id_program = @id_program,
                                                    @id_sended_mail_type = @id_sended_mail_type,
                                                    @uid = @id_claim
                                                
                                               
                                            END
                                        
                                        SELECT  @id_sended_mail_type = id_sended_mail_type
                                        FROM    dbo.sended_mail_types st
                                        WHERE   st.id_program = @id_program
                                                AND st.sys_name = 'sendMailStatePriceOk'
                                        
                                        IF @var_str = 'PRICEOK'
                                            AND NOT EXISTS ( SELECT
                                                              1
                                                             FROM
                                                              dbo.sended_mails sm
                                                             WHERE
                                                              sm.id_sended_mail_type = @id_sended_mail_type
                                                              AND uid = @id_claim )
                                            BEGIN
                                                SELECT  @mail_address = mail
                                                FROM    users
                                                WHERE   id_user = ( SELECT
                                                              id_operator
                                                              FROM
                                                              dbo.zipcl_zip_claims
                                                              WHERE
                                                              id_claim = @id_claim
                                                              )
                                                SET @mail_text = 'Согласованы цены к <a href="'
                                                    + @root_url + '?id='
                                                    + CONVERT(NVARCHAR(10), @id_claim)
                                                    + '">заявке на ЗИП №'
                                                    + CONVERT(NVARCHAR(10), @id_claim)
                                                    + '</a>'
                                                SET @mail_subject = 'Заявка на ЗИП'
									
                                                EXEC sk_send_message @action = 'send_email',
                                                    @id_program = @id_program,
                                                    @subject = @mail_subject,
                                                    @body = @mail_text,
                                                    @recipients = @mail_address	
                                
                                                EXEC dbo.sk_sended_mails @id_program = @id_program,
                                                    @id_sended_mail_type = @id_sended_mail_type,
                                                    @uid = @id_claim
                                                
                                                
                                            END
                                        
                                        SELECT  @id_sended_mail_type = id_sended_mail_type
                                        FROM    dbo.sended_mail_types st
                                        WHERE   st.id_program = @id_program
                                                AND st.sys_name = 'sendMailStatePriceFail'
                                        
                                        IF @var_str = 'PRICEFAIL'
                                            AND NOT EXISTS ( SELECT
                                                              1
                                                             FROM
                                                              dbo.sended_mails sm
                                                             WHERE
                                                              sm.id_sended_mail_type = @id_sended_mail_type
                                                              AND uid = @id_claim )
                                            BEGIN
                                                SELECT  @mail_address = mail
                                                FROM    users
                                                WHERE   id_user = ( SELECT
                                                              id_operator
                                                              FROM
                                                              dbo.zipcl_zip_claims
                                                              WHERE
                                                              id_claim = @id_claim
                                                              )
                                                SET @mail_text = 'Отклонены цены к <a href="'
                                                    + @root_url + '?id='
                                                    + CONVERT(NVARCHAR(10), @id_claim)
                                                    + '">заявке на ЗИП №'
                                                    + CONVERT(NVARCHAR(10), @id_claim)
                                                    + '</a>'
                                                SET @mail_subject = 'Заявка на ЗИП'
									
                                                EXEC sk_send_message @action = 'send_email',
                                                    @id_program = @id_program,
                                                    @subject = @mail_subject,
                                                    @body = @mail_text,
                                                    @recipients = @mail_address	
                                
                                                EXEC dbo.sk_sended_mails @id_program = @id_program,
                                                    @id_sended_mail_type = @id_sended_mail_type,
                                                    @uid = @id_claim
                                                
                                               
                                            END
                                        
                                        SELECT  @id_sended_mail_type = id_sended_mail_type
                                        FROM    dbo.sended_mail_types st
                                        WHERE   st.id_program = @id_program
                                                AND st.sys_name = 'sendMailStateDone'
                                        
                                        IF @var_str = 'DONE'
                                            AND NOT EXISTS ( SELECT
                                                              1
                                                             FROM
                                                              dbo.sended_mails sm
                                                             WHERE
                                                              sm.id_sended_mail_type = @id_sended_mail_type
                                                              AND uid = @id_claim )
                                            BEGIN
                                                SELECT  @mail_address = mail
                                                FROM    users
                                                WHERE   id_user = ( SELECT
                                                              id_operator
                                                              FROM
                                                              dbo.zipcl_zip_claims
                                                              WHERE
                                                              id_claim = @id_claim
                                                              )
                                                SET @mail_text = '<a href="'
                                                    + @root_url + '?id='
                                                    + CONVERT(NVARCHAR(10), @id_claim)
                                                    + '">Заявка на ЗИП №'
                                                    + CONVERT(NVARCHAR(10), @id_claim)
                                                    + '</a>' + ' закрыта.'
                                                SET @mail_subject = 'Заявка на ЗИП'
									
                                                EXEC sk_send_message @action = 'send_email',
                                                    @id_program = @id_program,
                                                    @subject = @mail_subject,
                                                    @body = @mail_text,
                                                    @recipients = @mail_address	                                
                                
									
                                                SELECT  @mail_address = mail
                                                FROM    users
                                                WHERE   id_user = ( SELECT
                                                              id_manager
                                                              FROM
                                                              dbo.zipcl_zip_claims
                                                              WHERE
                                                              id_claim = @id_claim
                                                              )
									
                                                EXEC sk_send_message @action = 'send_email',
                                                    @id_program = @id_program,
                                                    @subject = @mail_subject,
                                                    @body = @mail_text,
                                                    @recipients = @mail_address	
											
                                                EXEC dbo.sk_sended_mails @id_program = @id_program,
                                                    @id_sended_mail_type = @id_sended_mail_type,
                                                    @uid = @id_claim
                                                
                                               
                                            END
                                
                                        SELECT  @id_sended_mail_type = id_sended_mail_type
                                        FROM    dbo.sended_mail_types st
                                        WHERE   st.id_program = @id_program
                                                AND st.sys_name = 'sendMailStateRequestNum'
                                
                                        IF @request_num IS NOT NULL
                                            AND NOT EXISTS ( SELECT
                                                              1
                                                             FROM
                                                              dbo.sended_mails sm
                                                             WHERE
                                                              sm.id_sended_mail_type = @id_sended_mail_type
                                                              AND uid = @id_claim )
                                            BEGIN
                                                SELECT  @mail_address = mail
                                                FROM    users
                                                WHERE   id_user = ( SELECT
                                                              id_service_admin
                                                              FROM
                                                              dbo.zipcl_zip_claims
                                                              WHERE
                                                              id_claim = @id_claim
                                                              )
                                                SET @mail_text = 'Добавлен номер требования к <a href="'
                                                    + @root_url + '?id='
                                                    + CONVERT(NVARCHAR(10), @id_claim)
                                                    + '">заявке на ЗИП №'
                                                    + CONVERT(NVARCHAR(10), @id_claim)
                                                    + '</a>'
                                                SET @mail_subject = 'Заявка на ЗИП'
									
                                                EXEC sk_send_message @action = 'send_email',
                                                    @id_program = @id_program,
                                                    @subject = @mail_subject,
                                                    @body = @mail_text,
                                                    @recipients = @mail_address	
                                                
                                                EXEC dbo.sk_sended_mails @id_program = @id_program,
                                                    @id_sended_mail_type = @id_sended_mail_type,
                                                    @uid = @id_claim
                                                
                                                
                                            END
                                        
                                        --Отклонение заявки
                                        /*SELECT  @id_sended_mail_type = id_sended_mail_type
                                    FROM    dbo.sended_mail_types st
                                    WHERE   st.id_program = @id_program
                                            AND st.sys_name = 'sendMailStateCancel'
                                
                                    IF @var_str = 'CANCELED'
                                        AND NOT EXISTS ( SELECT
                                                              1
                                                         FROM dbo.sended_mails sm
                                                         WHERE
                                                              sm.id_sended_mail_type = @id_sended_mail_type
                                                              AND uid = @id_claim )
                                        BEGIN
                                            SELECT  @mail_address = mail
                                            FROM    users
                                            WHERE   id_user = ( SELECT
                                                              id_service_admin
                                                              FROM
                                                              dbo.zipcl_zip_claims
                                                              WHERE
                                                              id_claim = @id_claim
                                                              )
                                            SET @mail_text = 'Добавлен номер требования к <a href="'
                                                + @root_url + '?id='
                                                + CONVERT(NVARCHAR(10), @id_claim)
                                                + '">заявке на ЗИП №'
                                                + CONVERT(NVARCHAR(10), @id_claim)
                                                + '</a>'
                                            SET @mail_subject = 'Заявка на ЗИП'
									
                                            EXEC sk_send_message @action = 'send_email',
                                                @id_program = @id_program,
                                                @subject = @mail_subject,
                                                @body = @mail_text,
                                                @recipients = @mail_address	
                                                
                                            EXEC dbo.sk_sended_mails @id_program = @id_program,
                                                @id_sended_mail_type = @id_sended_mail_type,
                                                @uid = @id_claim
                                                
                                                
                                        END*/
                                        --</Отклонение заявки
                                        
                                        --Запрос цен
                                        IF @var_str = 'SUPPLY'
                                            BEGIN
											--Сохраняем переданные в Снабжение позиции для запроса цен
                                                DECLARE curs CURSOR
                                                FOR
                                                    SELECT  id_claim_unit
                                                    FROM    dbo.zipcl_claim_units cu
                                                    WHERE   cu.enabled = 1
                                                            AND cu.id_claim = @id_claim
                                                            AND ( cu.delivery_time IS NULL
                                                              OR LTRIM(RTRIM(cu.delivery_time)) = ''
                                                              )
                                                            AND ( cu.price_in IS NULL
                                                              OR LTRIM(RTRIM(cu.price_in)) = ''
                                                              )   
			
                                                OPEN curs
                                                FETCH NEXT
                        
                        FROM curs
				INTO @id_claim_unit
				
                                                WHILE @@FETCH_STATUS = 0
                                                    BEGIN
                                                
                                                        EXEC sk_zip_claims @action = 'updClaimUnit',
                                                            @id_claim_unit = @id_claim_unit,
                                                            @price_request = 1
              --                                              @id_claim_state = @id_claim_state,
              --                                              @id_creator = @id_creator
                                                
                                                        EXEC sk_zip_claims @action = 'insClaimUnitStateChange',
                                                            @id_claim_unit = @id_claim_unit,
                                                            @id_claim_state = @id_claim_state,
                                                            @id_creator = @id_creator
                                                
                                                        FETCH NEXT
					FROM curs
					INTO @id_claim_unit
                                                    END

                                                CLOSE curs

                                                DEALLOCATE curs
											                                
                                            END
                                    END
                                
                            --SET @mail_address = 'anton.rehov@unitgroup.ru'	
                                
                                SELECT  @id_claim AS id_claim
                            END
                        ELSE
                            IF @action = 'checkEtalonStateAndSendMessage'
                                BEGIN
                                    SELECT  @id_sended_mail_type = id_sended_mail_type
                                    FROM    dbo.sended_mail_types st
                                    WHERE   st.id_program = @id_program
                                            AND st.sys_name = 'sendMailStateEtalonDone'
                        
                                    DECLARE curs CURSOR
                                    FOR
                                        SELECT  c.id_claim
                                        FROM    dbo.zipcl_zip_claims c
                                                INNER JOIN dbo.zipcl_claim_states cs ON c.id_claim_state = cs.id_claim_state
                                        WHERE   c.old_id_claim IS NULL
                                                AND c.ENABLED = 1 /*AND cs.sys_name = 'REQUESTNUM'*/
                                                AND EXISTS ( SELECT
                                                              1
                                                             FROM
                                                              [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_ixvblg5apz51
                                                             WHERE
                                                              ixvblg5apz4e COLLATE Cyrillic_General_CI_AS = c.request_num
                                                              AND ixvblg5apxsh = 'Готово к отгрузке' )
                                                AND NOT EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.sended_mails sm
                                                              WHERE
                                                              sm.id_sended_mail_type = @id_sended_mail_type
                                                              AND uid = c.id_claim )
                                    OPEN curs
                                    FETCH NEXT                        
                        FROM curs
				INTO @id_claim
                                
                                    WHILE @@FETCH_STATUS = 0
                                        BEGIN
                                            SELECT  @mail_address = mail
                                            FROM    users
                                            WHERE   id_user = ( SELECT
                                                              id_manager
                                                              FROM
                                                              dbo.zipcl_zip_claims
                                                              WHERE
                                                              id_claim = @id_claim
                                                              )
                                            SET @mail_text = 'Статус требования - Готово к отгрузке по <a href="'
                                                + @root_url + '?id='
                                                + CONVERT(NVARCHAR(10), @id_claim)
                                                + '">заявке на ЗИП №'
                                                + CONVERT(NVARCHAR(10), @id_claim)
                                                + '</a>'
                                            SET @mail_subject = 'Заявка на ЗИП'
									
                                            EXEC sk_send_message @action = 'send_email',
                                                @id_program = @id_program,
                                                @subject = @mail_subject,
                                                @body = @mail_text,
                                                @recipients = @mail_address	
                                                
                                            EXEC dbo.sk_sended_mails @id_program = @id_program,
                                                @id_sended_mail_type = @id_sended_mail_type,
                                                @uid = @id_claim
                                        
                                            FETCH NEXT
					FROM curs
					INTO @id_claim
                                        END

                                    CLOSE curs

                                    DEALLOCATE curs 
                                    
							
							
                                END
                            ELSE
                                IF @action = 'checkEtalonWaybillStateAndSendMessage'
                                    BEGIN
                                        SELECT  @id_sended_mail_type = id_sended_mail_type
                                        FROM    dbo.sended_mail_types st
                                        WHERE   st.id_program = @id_program
                                                AND st.sys_name = 'sendMailStateEtalonWaybillDone'
                        
                                        DECLARE curs CURSOR
                                        FOR
                                            SELECT  c.id_claim
                                            FROM    dbo.zipcl_zip_claims c
                                                    INNER JOIN dbo.zipcl_claim_states cs ON c.id_claim_state = cs.id_claim_state
                                            WHERE   c.old_id_claim IS NULL
                                                    AND c.ENABLED = 1
                                                    AND EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_IXVBLG5ZO8B9
                                                              WHERE
                                                              IXVBLG5ZCSPK COLLATE Cyrillic_General_CI_AS = c.waybill_num
                                                              AND IXVBLG5ZD4K7 IN (
                                                              'Закрыто',
                                                              'Доставлено' ) )
                                                    AND NOT EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.sended_mails sm
                                                              WHERE
                                                              sm.id_sended_mail_type = @id_sended_mail_type
                                                              AND uid = c.id_claim )
                                        OPEN curs
                                        FETCH NEXT                        
                        FROM curs
				INTO @id_claim
                                
                                        WHILE @@FETCH_STATUS = 0
                                            BEGIN
                                                SELECT  @mail_address = mail
                                                FROM    users
                                                WHERE   id_user = ( SELECT
                                                              id_service_admin
                                                              FROM
                                                              dbo.zipcl_zip_claims
                                                              WHERE
                                                              id_claim = @id_claim
                                                              )
                                                SET @mail_text = 'Статус транспортной заявки - Доставлено по <a href="'
                                                    + @root_url + '?id='
                                                    + CONVERT(NVARCHAR(10), @id_claim)
                                                    + '">заявке на ЗИП №'
                                                    + CONVERT(NVARCHAR(10), @id_claim)
                                                    + '</a>'
                                                SET @mail_subject = 'Заявка на ЗИП'
									
                                                EXEC sk_send_message @action = 'send_email',
                                                    @id_program = @id_program,
                                                    @subject = @mail_subject,
                                                    @body = @mail_text,
                                                    @recipients = @mail_address	                                        
                                            
                                            --Так же отправляем письмо Менеджеру
                                                SELECT  @mail_address = mail
                                                FROM    users
                                                WHERE   id_user = ( SELECT
                                                              id_manager
                                                              FROM
                                                              dbo.zipcl_zip_claims
                                                              WHERE
                                                              id_claim = @id_claim
                                                              )
                                                EXEC sk_send_message @action = 'send_email',
                                                    @id_program = @id_program,
                                                    @subject = @mail_subject,
                                                    @body = @mail_text,
                                                    @recipients = @mail_address	
                                                
                                                EXEC dbo.sk_sended_mails @id_program = @id_program,
                                                    @id_sended_mail_type = @id_sended_mail_type,
                                                    @uid = @id_claim
                                        
                                                FETCH NEXT
					FROM curs
					INTO @id_claim
                                            END

                                        CLOSE curs

                                        DEALLOCATE curs 
                                    
							
							
                                    END
                                ELSE
                                    IF @action = 'closeClaim'
                                        BEGIN
                                            IF @sp_test IS NOT NULL
                                                BEGIN
                                                    RETURN
                                                END
                                            EXEC dbo.sk_zip_claims @action = N'closeClaim',
                                                @id_claim = @id_claim,
                                                @id_creator = @id_creator
                                        END
                                    ELSE
                                        IF @action = 'getClaimStateHistory'
                                            BEGIN
                                                IF @sp_test IS NOT NULL
                                                    BEGIN
                                                        RETURN
                                                    END
                                            
                                                SELECT  id_claim ,
                                                        claim_state ,
                                                        CONVERT(NVARCHAR, ttt.change_date, 104)
                                                        + ' '
                                                        + CONVERT(NVARCHAR, ttt.change_date, 108) AS change_date
                                                FROM    ( SELECT
                                                              tt.id_claim ,
                                                              tt.claim_state ,
                                                              change_date
                                                          FROM
                                                              ( SELECT
                                                              t.id_claim ,
                                                              ( CASE
                                                              WHEN cc.old_id_claim IS NULL
                                                              THEN ISNULL(( SELECT TOP 1
                                                              ccc.dattim1
                                                              FROM
                                                              dbo.zipcl_zip_claims ccc
                                                              WHERE
                                                              ccc.old_id_claim = cc.id_claim
                                                              AND ccc.id_claim_state = t.id_claim_state
                                                              ORDER BY ccc.id_claim
                                                              ),
                                                              ISNULL(( SELECT TOP 1
                                                              cc.dattim2
                                                              FROM
                                                              dbo.zipcl_zip_claims cc
                                                              WHERE
                                                              cc.old_id_claim = t.id_claim
                                                              ORDER BY cc.id_claim DESC
                                                              ), cc.dattim1))
                                                              ELSE cc.dattim1
                                                              END ) AS change_date ,
                                                              cs.name AS claim_state ,
                                                              cs.history_order
                                                              FROM
                                                              ( SELECT
                                                              MIN(c.id_claim) AS id_claim ,
                                                              c.id_claim_state
                                                              FROM
                                                              dbo.zipcl_zip_claims c
                                                              WHERE
                                                              c.id_claim = @id_claim
                                                              OR c.old_id_claim = @id_claim
                                                              GROUP BY id_claim_state
                                                              ) AS t
                                                              INNER JOIN dbo.zipcl_zip_claims cc ON t.id_claim = cc.id_claim
                                                              INNER JOIN dbo.zipcl_claim_states cs ON cc.id_claim_state = cs.id_claim_state
                                                              ) AS tt
                                                          UNION ALL
                                                          SELECT
                                                              tt.id_claim ,
                                                              tt.claim_state ,
                                                              change_date
                                                          FROM
                                                              ( SELECT
                                                              t.id_claim ,
                                                              ( CASE
                                                              WHEN cc.old_id_claim IS NULL
                                                              THEN ISNULL(( SELECT TOP 1
                                                              ccc.dattim1
                                                              FROM
                                                              dbo.zipcl_zip_claims ccc
                                                              WHERE
                                                              ccc.old_id_claim = cc.id_claim
                                                              AND ccc.id_et_way_claim_state = t.id_et_way_claim_state
                                                              ORDER BY ccc.id_claim
                                                              ),
                                                              ISNULL(( SELECT TOP 1
                                                              cc.dattim2
                                                              FROM
                                                              dbo.zipcl_zip_claims cc
                                                              WHERE
                                                              cc.old_id_claim = t.id_claim
                                                              ORDER BY cc.id_claim DESC
                                                              ), cc.dattim1))
                                                              ELSE cc.dattim1
                                                              END ) AS change_date ,
                                                              cs.name AS claim_state ,
                                                              cs.history_order
                                                              FROM
                                                              ( SELECT
                                                              MIN(c.id_claim) AS id_claim ,
                                                              c.id_et_way_claim_state
                                                              FROM
                                                              dbo.zipcl_zip_claims c
                                                              WHERE
                                                              c.id_claim = @id_claim
                                                              OR c.old_id_claim = @id_claim
                                                              GROUP BY id_et_way_claim_state
                                                              ) AS t
                                                              INNER JOIN dbo.zipcl_zip_claims cc ON t.id_claim = cc.id_claim
                                                              INNER JOIN dbo.zipcl_claim_states cs ON cc.id_et_way_claim_state = cs.id_claim_state
                                                              ) AS tt
                                                        ) AS ttt
                                                ORDER BY ttt.change_date
                                            END
                                        ELSE
                                            IF @action = 'setClaimManSelState'
                                                BEGIN
                                                    IF @sp_test IS NOT NULL
                                                        BEGIN
                                                            RETURN
                                                        END
                                    
                                                    SELECT  @id_claim_state = id_claim_state
                                                    FROM    dbo.zipcl_claim_states cs
                                                    WHERE   cs.enabled = 1
                                                            AND UPPER(cs.sys_name) = 'MANSEL'
                                    
                                                    EXEC dbo.ui_zip_claims @action = N'saveClaim',
                                                        @id_claim = @id_claim,
                                                        @id_claim_state = @id_claim_state,
                                                        @id_creator = @id_creator
                                                END
                                            ELSE
                                                IF @action = 'setClaimRequestPriceState'
                                                    BEGIN
                                                        IF @sp_test IS NOT NULL
                                                            BEGIN
                                                              RETURN
                                                            END
                                    
                                                        SELECT
                                                              @id_claim_state = id_claim_state
                                                        FROM  dbo.zipcl_claim_states cs
                                                        WHERE cs.enabled = 1
                                                              AND UPPER(cs.sys_name) = 'SUPPLY'
														
														--Меняем статус заявки
                                                        EXEC dbo.ui_zip_claims @action = N'saveClaim',
                                                            @id_claim = @id_claim,
                                                            @id_claim_state = @id_claim_state,
                                                            @id_creator = @id_creator
                                                        
                                                        --Ищем какой снабженец отвечает за эти позиции и проставляем его фамилию
                                                        EXEC dbo.ui_zip_claims @action = 'setClaimUnitRespSupply',
                                                            @id_claim = @id_claim
                                                            
                                                            --Отправляем уведомление снабженцам что необходимо проставить цены
                                                        EXEC ui_zip_claims @action = 'sendSupplyNewRequestNote',
                                                            @id_claim = @id_claim
                                                    END
                                                
        IF @action = 'setClaimUnitRespSupply'
            BEGIN
                DECLARE @supply_fio NVARCHAR(150) ,
                    @surname NVARCHAR(50) ,
                    @patron NVARCHAR(50) ,
                    @vidmc INT
	
                DECLARE curs CURSOR
                FOR
                    SELECT  cu.catalog_num ,
                            cu.id_claim_unit
                    FROM    dbo.zipcl_claim_units cu
                    WHERE   cu.enabled = 1
                            AND cu.id_claim = @id_claim

                OPEN curs

                FETCH NEXT                        
        FROM curs
		INTO @nomenclature_num, @id_claim_unit
			
			
                WHILE @@FETCH_STATUS = 0
                    BEGIN	
                          
                            
                        SELECT TOP 1
                                @vidmc = vidmc.recordid
                        FROM    --[ufs-db2].[UNIT_WORK].UNIT_WORK.et6_ixvblg5apz51 treb
                                --        INNER JOIN [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_Ixvblg5atilv spec ON spec.ixvblg5atosg = treb.recordid
                                        --INNER JOIN 
                                [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_ixsjty4t828z nom --ON spec.ixvblg5aq40v = nom.recordid
                                INNER JOIN [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_ixsjtw5s3zv4 vidmc ON nom.ixsjv7iitbok = vidmc.recordid
                        WHERE   --ixvblg5apz4e = @request_num AND 
                                        --nom.ixsjtkblfxyh like '%' +@catalog_num + '%' --каталожный номер
                                LTRIM(RTRIM(LOWER(nom.a1wwk3khbo8n))) = LTRIM(RTRIM(LOWER(@nomenclature_num))) --номенклатурный номер
				
                        SELECT  @surname = sotr.o2s5xclp2z3 ,
                                @name = sotr.o2s5xclp30e ,
                                @patron = sotr.o2s5xclp31q
                        FROM    [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_ixvblg5b88ws nom2sotr
                                INNER JOIN [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_o2s5xclwm77 sotr ON nom2sotr.ixvblg5b88ul = sotr.recordid
                        WHERE   nom2sotr.ixvblg5b88rb = @vidmc
				
                        SET @supply_fio = @surname + ' ' + LEFT(@name, 1)
                            + '.' + LEFT(@patron, 1) + '.'
				
                        SELECT TOP 1
                                @id_resp_supply = u.id_user
                        FROM    dbo.users u
                        WHERE   u.enabled = 1
                                AND display_name LIKE '%' + @supply_fio + '%'
				
                        EXEC ui_zip_claims @action = 'saveClaimUnit',
                            @id_claim_unit = @id_claim_unit,
                            @id_resp_supply = @id_resp_supply
				
                        FETCH NEXT                        
				FROM curs
				INTO @nomenclature_num, @id_claim_unit
        
                    END

                CLOSE curs

                DEALLOCATE curs
                    
            END
              
        IF @action = 'setClaimUnitSupplyReturn'
            BEGIN
            --Не отмечаем конкретную позицию, так как статус заявки меняем на предыдущий при первом возврате
            
                EXEC ui_zip_claims @action = 'saveClaimUnit',
                    @id_claim_unit = @id_Claim_unit, @is_return = 1,
                    @id_creator = @id_creator
                
                IF @id_claim IS NULL
                    BEGIN
                        SELECT  @id_claim = id_claim
                        FROM    dbo.zipcl_claim_units cu
                        WHERE   cu.id_claim_unit = @id_claim_unit	
                    END
                
                --Отправляем уведомление менеджеру что позиция возвращена
                EXEC ui_zip_claims @action = 'sendManagerClaimUnitReturnNote',
                    @id_claim_unit = @id_claim_unit, @id_claim = @id_claim,
                    @id_creator = @id_creator, @descr = @descr
            END
            
                 
        IF @action = 'sendManagerClaimUnitReturnNote'
            BEGIN
                
                SET @mail_text = 'Позиция возвращена снабжением для <a href="'
                    + @root_url + '?id=' + CONVERT(NVARCHAR(10), @id_claim)
                    + '">заявки на ЗИП №' + CONVERT(NVARCHAR(10), @id_claim)
                    + '</a>'
                
                SET @mail_text = ISNULL(@mail_text, '')
                    + '<br />Комментарий:<br />' + ISNULL(@descr, '')
	
                SET @mail_subject = 'Заявка на ЗИП'
					
                DECLARE @mail NVARCHAR(150)
					
                SELECT TOP 1
                        @mail = u.mail
                FROM    dbo.zipcl_zip_claims c
                        INNER JOIN dbo.users u ON c.id_manager = u.id_user
                WHERE   id_claim = @id_claim
                          
                          
                                                 			
              
                EXEC sk_send_message @action = 'send_email',
                    @id_program = @id_program, @subject = @mail_subject,
                    @body = @mail_text, @recipients = @mail	

                                     
                        
            END
                                                    
        IF @action = 'setClaimSupplyReturn'
            BEGIN
               
            ----------Если проставлены или возвращены не все позиции заявки то статус заявки не меняем
            --------    IF EXISTS ( SELECT  1
            --------                FROM    dbo.zipcl_claim_units cu
            --------                        INNER JOIN dbo.zipcl_zip_claims c ON cu.id_claim = c.id_claim
            --------                        INNER JOIN dbo.zipcl_claim_states cs ON c.id_claim_state = cs.id_claim_state
            --------                WHERE   cu.id_claim = @id_claim
            --------                        AND cu.enabled = 1
            --------                        AND cs.sys_name IN ( 'SUPPLY' )
            --------                        AND ( cu.price_in IS NULL
            --------                              OR LTRIM(RTRIM(cu.price_in)) = ''
            --------                            ) )
            --------        BEGIN
            --------            RETURN
            --------        END
                     
                     
                     
                                                              
                --Находим и устанавливаем предыдущий статус у заявки
                SELECT TOP 1
                        @id_claim_state = id_claim_state
                FROM    dbo.zipcl_claim_state_changes ch
                WHERE   enabled = 1
                        AND id_claim = @id_claim
                ORDER BY id_claim_state_change DESC
                       
                IF @id_claim_state IS NOT NULL
                    BEGIN
                                    
                        EXEC dbo.ui_zip_claims @action = N'saveClaim',
                            @id_claim = @id_claim,
                            @id_claim_state = @id_claim_state,
                            @id_creator = @id_creator
                    
                    END
            END                                            
                                                    
        IF @action = 'setClaimPriceSetState'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
                IF @if_set_price_done = 1
                    AND EXISTS ( SELECT 1
                                 FROM   dbo.zipcl_claim_units cu
                                        INNER JOIN dbo.zipcl_zip_claims c ON cu.id_claim = c.id_claim
                                        INNER JOIN dbo.zipcl_claim_states cs ON c.id_claim_state = cs.id_claim_state
                                 WHERE  cu.id_claim = @id_claim
                                        AND cu.enabled = 1
                                        AND cs.sys_name IN ( 'SUPPLY' )
                                        AND ( cu.price_in IS NULL
                                              OR LTRIM(RTRIM(cu.price_in)) = ''
                                            ) )
                    BEGIN
                        RETURN
                    END
                                                              
                                                              
                SELECT  @id_claim_state = id_claim_state
                FROM    dbo.zipcl_claim_states cs
                WHERE   cs.enabled = 1
                        AND UPPER(cs.sys_name) = 'PRICE'
                                    
                EXEC dbo.ui_zip_claims @action = N'saveClaim',
                    @id_claim = @id_claim, @id_claim_state = @id_claim_state,
                    @id_creator = @id_creator
            END
        ELSE
            IF @action = 'setClaimPriceOkState'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                                    
                    SELECT  @id_claim_state = id_claim_state
                    FROM    dbo.zipcl_claim_states cs
                    WHERE   cs.enabled = 1
                            AND UPPER(cs.sys_name) = 'PRICEOK'
                                    
                    EXEC dbo.ui_zip_claims @action = N'saveClaim',
                        @id_claim = @id_claim,
                        @id_claim_state = @id_claim_state,
                        @id_creator = @id_creator
                END
            ELSE
                IF @action = 'setClaimPriceFailState'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                                    
                        SELECT  @id_claim_state = id_claim_state
                        FROM    dbo.zipcl_claim_states cs
                        WHERE   cs.enabled = 1
                                AND UPPER(cs.sys_name) = 'PRICEFAIL'
                                    
                        EXEC dbo.ui_zip_claims @action = N'saveClaim',
                            @id_claim = @id_claim,
                            @id_claim_state = @id_claim_state,
                            @id_creator = @id_creator
                    END
                ELSE
                    IF @action = 'setClaimSendState'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END
                                    
                            SELECT  @id_claim_state = id_claim_state
                            FROM    dbo.zipcl_claim_states cs
                            WHERE   cs.enabled = 1
                                    AND UPPER(cs.sys_name) = 'SEND'
                                    
                            EXEC dbo.ui_zip_claims @action = N'saveClaim',
                                @id_claim = @id_claim,
                                @id_claim_state = @id_claim_state,
                                @id_creator = @id_creator
                        END
                    ELSE
                        IF @action = 'setClaimDoneState'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END
                                    
                                SELECT  @id_claim_state = id_claim_state
                                FROM    dbo.zipcl_claim_states cs
                                WHERE   cs.enabled = 1
                                        AND UPPER(cs.sys_name) = 'DONE'
                                    
                                EXEC dbo.ui_zip_claims @action = N'saveClaim',
                                    @id_claim = @id_claim,
                                    @id_claim_state = @id_claim_state,
                                    @id_creator = @id_creator
                            END
                        ELSE
                            IF @action = 'setClaimCancelState'
                                BEGIN
                                    IF @sp_test IS NOT NULL
                                        BEGIN
                                            RETURN
                                        END
                                    
                                    SELECT  @id_claim_state = id_claim_state
                                    FROM    dbo.zipcl_claim_states cs
                                    WHERE   cs.enabled = 1
                                            AND UPPER(cs.sys_name) = 'CANCELED'
                                    
                                    EXEC dbo.ui_zip_claims @action = N'saveClaim',
                                        @id_claim = @id_claim,
                                        @id_claim_state = @id_claim_state,
                                        @id_creator = @id_creator,
                                        @cancel_comment = @cancel_comment
                                END
                            ELSE
                                IF @action = 'setClaimRequestNumState'
                                    BEGIN
                                        IF @sp_test IS NOT NULL
                                            BEGIN
                                                RETURN
                                            END
													
                                        SELECT  @id_claim_state = id_claim_state
                                        FROM    dbo.zipcl_claim_states cs
                                        WHERE   cs.enabled = 1
                                                AND UPPER(cs.sys_name) = 'REQUESTNUM'
                                        IF NOT EXISTS ( SELECT
                                                              1
                                                        FROM  dbo.zipcl_zip_claims cl
                                                        WHERE ( cl.id_claim = @id_claim
                                                              OR cl.old_id_claim = @id_claim
                                                              )
                                                              AND id_claim_state = @id_claim_state )
                                            BEGIN
                                                EXEC dbo.ui_zip_claims @action = N'saveClaim',
                                                    @id_claim = @id_claim,
                                                    @id_claim_state = @id_claim_state,
                                                    @id_creator = @id_creator
                                            END
                                    END
	
	--=================================
	--ClaimUnits
	--=================================	
        IF @action = 'getClaimUnitList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                SELECT  ROW_NUMBER() OVER ( ORDER BY id_claim_unit ) AS row_num ,
                        cu.id_claim_unit ,
                        cu.id_claim ,
                        cu.catalog_num ,
                        cu.name ,
                        cu.count ,
                        cu.nomenclature_num ,
                        CONVERT(INT, ROUND(price_in, 0)) AS price_in ,
                        CONVERT(INT, ROUND(price_out, 0)) AS price_out ,
                        cu.id_creator ,
                        cu.delivery_time ,
                        --статус не Создано
                        CASE WHEN cs.sys_name != 'NEW' THEN 1
                             ELSE 0
                        END AS active_state ,
                        c.id_engeneer ,
                        ( cu.count * CONVERT(INT, ROUND(price_in, 0)) ) AS price_in_sum ,
                        ( cu.count * CONVERT(INT, ROUND(price_out, 0)) ) AS price_out_sum ,
                        ISNULL(no_nomenclature_num, 0) AS no_nomenclature_num ,
                        nomenclature_claim_num
                FROM    dbo.zipcl_claim_units cu
                        INNER JOIN dbo.zipcl_zip_claims c ON cu.id_claim = c.id_claim
                        INNER JOIN dbo.zipcl_claim_states cs ON c.id_claim_state = cs.id_claim_state
                        --INNER JOIN dbo.users u ON c.id_engeneer = u.id_user
                WHERE   cu.enabled = 1
				--Filters				
				/*********************  id_claim  ********************/
                        AND cu.id_claim = @id_claim
                                 
                 /*********************  SPEED  ********************/
                        --AND ( ( @speed IS NULL
                        --        OR @speed <= 0
                        --      )
                        --      OR ( @speed IS NOT NULL
                        --           AND cu.speed = @speed
                        --         )
                        --    )    
                            --</Filters>
                
                --для новых строк
                UNION ALL
                SELECT  NULL AS row_num ,
                        NULL AS id_claim_unit ,
                        NULL AS id_claim ,
                        NULL AS catalog_num ,
                        NULL AS name ,
                        NULL AS count ,
                        NULL AS nomenclature_num ,
                        NULL AS price_in ,
                        NULL AS price_out ,
                        NULL AS id_creator ,
                        NULL AS delivery_time ,
                        NULL AS active_state ,
                        NULL AS curr_engeneer ,
                        NULL AS price_in_sum ,
                        NULL AS price_out_sum ,
                        0 AS no_nomenclature_num ,
                        NULL AS nomenclature_claim_num
                ORDER BY id_claim_unit
            END  
        ELSE
            IF @action = 'getClaimUnitCommonList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
					
                    SELECT  * ,
                            ( SELECT    date_change
                              FROM      dbo.zipcl_claim_state_changes csc
                              WHERE     csc.id_claim_state_change = t.id_claim_supply_state_change
                            ) AS date_price_request 
                            --,( SELECT    display_name
                            --  FROM      dbo.zipcl_claim_state_changes csc
                            --            INNER JOIN users u ON csc.id_creator = u.id_user
                            --  WHERE     csc.id_claim_state_change = t.id_claim_supply_state_change
                            --) AS supply_man
                    FROM    ( SELECT    ROW_NUMBER() OVER ( ORDER BY id_claim_unit ) AS row_num ,
                                        cu.id_claim_unit ,
                                        cu.id_claim ,
                                        cu.catalog_num ,
                                        cu.name ,
                                        cu.count ,
                                        cu.nomenclature_num ,
                                        CONVERT(INT, ROUND(price_in, 0)) AS price_in ,
                                        CONVERT(INT, ROUND(price_out, 0)) AS price_out ,
                                        cu.id_creator ,
                                        cu.delivery_time ,
                                        c.id_engeneer ,
                                        ( cu.count
                                          * CONVERT(INT, ROUND(price_in, 0)) ) AS price_in_sum ,
                                        ( cu.count
                                          * CONVERT(INT, ROUND(price_out, 0)) ) AS price_out_sum ,
                                        ISNULL(dbo.srvpl_fnc(N'getDeviceShortCollectedNameNoSerialNoBr',
                                                             NULL, c.id_device,
                                                             NULL, NULL),
                                               ISNULL(c.device_model, '')) AS device ,
                                        ( SELECT    display_name
                                          FROM      users u
                                          WHERE     u.id_user = c.id_manager
                                        ) AS manager 
                                        --,cs.sys_name AS claim_state
                                        ,
                                        ( SELECT TOP 1
                                                    id_claim_state_change
                                          FROM      dbo.zipcl_claim_state_changes csc
                                                    INNER JOIN dbo.zipcl_claim_states css ON csc.id_claim_state = css.id_claim_state
                                          WHERE     csc.enabled = 1
                                                    AND csc.id_claim = cu.id_claim
                                                    AND css.sys_name IN (
                                                    'SUPPLY' )
                                                    AND cs.sys_name IN (
                                                    'SUPPLY' )
                                        ) AS id_claim_supply_state_change ,
                                        ISNULL(cu.no_nomenclature_num, 0) AS no_nomenclature_num ,
                                        nomenclature_claim_num
                              FROM      dbo.zipcl_claim_units cu
                                        INNER JOIN dbo.zipcl_zip_claims c ON cu.id_claim = c.id_claim
                                        INNER JOIN dbo.zipcl_claim_states cs ON c.id_claim_state = cs.id_claim_state
                              WHERE     cu.enabled = 1
                                        AND c.enabled = 1
				--Filters				
                                        AND ( ( @supply_list IS NULL
                                                OR @supply_list = 0
                                              )
                                              OR ( @supply_list = 1
                                                   AND cs.sys_name IN (
                                                   'SUPPLY' )
                                                   AND ( cu.price_in IS NULL
                                                         OR LTRIM(RTRIM(cu.price_in)) = ''
                                                       )
                                                   AND ( cu.is_return IS NULL
                                                         OR cu.is_return = 0
                                                       )
                                                 )
                                            )
                                        AND ( ( @id_resp_supply IS NULL
                                                OR @id_resp_supply <= 0
                                              )
                                              OR ( @id_resp_supply > 0
                                                   AND ( cu.id_resp_supply = @id_resp_supply
                                                         OR cu.id_resp_supply IS NULL
                                                       )
                                                 )
                                            )
				/*********************  id_claim  ********************/
                                        AND ( @id_claim IS NULL
                                              OR ( @id_claim IS NOT NULL
                                                   AND cu.id_claim = @id_claim
                                                 )
                                            )
                                 
                 /*********************  State  ********************/
                                        AND ( ( @lst_claim_states IS NULL
                                                OR @lst_claim_states = ''
                                              )
                                              OR ( ( @lst_claim_states IS NOT NULL
                                                     AND @lst_claim_states != ''
                                                   )
                                                   AND c.id_claim_state IN (
                                                   SELECT   CONVERT(INT, value)
                                                   FROM     dbo.Split(@lst_claim_states,
                                                              ',') )
                                                 )
                                            )    
                 /********************   date_begin   **********************/
                            --AND ( @date_begin IS NULL
                            --      OR ( @date_begin IS NOT NULL
                            --           AND CONVERT(DATE, c.dattim1) >= CONVERT(DATE, @date_begin)
                            --         )
                            --    )
                                         /********************   date_end   **********************/
                            --AND ( @date_end IS NULL
                            --      OR ( @date_end IS NOT NULL
                            --           AND CONVERT(DATE, c.dattim1) <= CONVERT(DATE, @date_end)
                            --         )
                            --    )
                                        AND ( ( @id_manager IS NULL
                                                OR @id_manager <= 0
                                              )
                                              OR ( @id_manager > 0
                                                   AND c.id_manager = @id_manager
                                                 )
                                            )
                                                 
                            --</Filters>
                            ) AS t
                    WHERE   /********************   rows_count   **********************/
                            ( ( @rows_count IS NULL
                                OR @rows_count <= 0
                              )
                              OR ( @rows_count > 0
                                   AND row_num <= @rows_count
                                 )
                            )
                    ORDER BY id_claim_unit
                END 
            ELSE
                IF @action = 'getClaimUnitHistoryList'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                    
                        IF @serial_num IS NULL
                            AND @id_claim IS NOT NULL
                            AND @id_device IS NULL
                            BEGIN
                                SELECT  @serial_num = serial_num
                                FROM    dbo.zipcl_zip_claims c
                                WHERE   c.id_claim = @id_claim
                            END
                         
                        IF @id_device IS NOT NULL
                            BEGIN
                                SELECT  @serial_num = serial_num
                                FROM    dbo.srvpl_devices d
                                WHERE   d.enabled = 1
                                        AND id_device = @id_device
                            END
                    
                        SELECT  t.row_num ,
                                t.id_claim_unit ,
                                t.id_claim ,
                                t.catalog_num ,
                                t.name ,
                                t.count ,
                                t.nomenclature_num ,
                                t.price_in ,
                                t.price_out ,
                                t.id_creator ,
                                CONVERT(NVARCHAR, t.date_create, 104) /*+ ' '
                            + CONVERT(NVARCHAR, t.date_create, 108)*/ AS date_create ,
                                t.counter ,
                                t.counter_colour ,
                                t.claim_state ,
                                t.service_engeneer ,
                                t.delivery_time ,
                                t.no_nomenclature_num ,
                                t.nomenclature_claim_num
                        FROM    ( SELECT    ROW_NUMBER() OVER ( ORDER BY id_claim_unit DESC ) AS row_num ,
                                            id_claim_unit ,
                                            cu.id_claim ,
                                            catalog_num ,
                                            name ,
                                            count ,
                                            nomenclature_num ,
                                            price_in ,
                                            price_out ,
                                            cu.id_creator ,
                                            c.dattim1 AS date_create ,
                                            c.counter ,
                                            c.counter_colour ,
                                            ( SELECT    name
                                              FROM      dbo.zipcl_claim_states cls
                                              WHERE     cls.id_claim_state = c.id_claim_state
                                            ) AS claim_state ,
                                            ( SELECT    display_name
                                              FROM      users u
                                              WHERE     u.id_user = c.id_engeneer
                                            ) AS service_engeneer ,
                                            delivery_time ,
                                            no_nomenclature_num ,
                                            nomenclature_claim_num
                                  FROM      dbo.zipcl_claim_units cu
                                            INNER JOIN dbo.zipcl_zip_claims c ON cu.id_claim = c.id_claim
                                  WHERE     cu.enabled = 1
                                            AND c.enabled = 1                              
				--Filters				
                                 
                 /*********************  Serial_num  ********************/
                                            AND c.serial_num = --'%' +
                                          @serial_num 
                                          --+ '%'
                            --</Filters>
                                ) AS t
                        WHERE   --Берем первые 50 строк
                                ( ( ( @get_all IS NULL
                                      OR @get_all = 0
                                    )
                                    AND t.row_num <= 50
                                  )
                                  OR @get_all = 1
                                )
                        ORDER BY t.row_num
                    END      
                ELSE
                    IF @action = 'getClaimUnitSelectionList'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END
				
                            SELECT  NULL
                        END
                    ELSE
                        IF @action = 'getClaimUnit'
                            BEGIN
                                SELECT  id_claim_unit ,
                                        id_claim ,
                                        catalog_num ,
                                        name ,
                                        count ,
                                        nomenclature_num ,
                                        price_in ,
                                        price_out ,
                                        id_creator ,
                                        delivery_time ,
                                        no_nomenclature_num ,
                                        nomenclature_claim_num
                                FROM    dbo.zipcl_claim_units cu
                                WHERE   id_claim_unit = @id_claim_unit
                            END
                        ELSE
                            IF @action = 'saveClaimUnit'
                                BEGIN
                                    IF @sp_test IS NOT NULL
                                        BEGIN
                                            RETURN
                                        END
									
                                    SELECT  @id_supply_man = ( CASE
                                                              WHEN @id_supply_man = 0
                                                              THEN NULL
                                                              ELSE @id_supply_man
                                                              END )
									
                                    SET @var_str = 'insClaimUnit'
				
                                    IF EXISTS ( SELECT  1
                                                FROM    dbo.zipcl_claim_units cu
                                                WHERE   id_claim_unit = @id_claim_unit )
                                        BEGIN
                                            SET @var_str = 'updClaimUnit'
                                        END
				
                                    SELECT  @pr_in = CONVERT(DECIMAL(10, 2), REPLACE(@price_in,
                                                              ',', '.'))
                                    SELECT  @pr_out = CONVERT(DECIMAL(10, 2), REPLACE(@price_out,
                                                              ',', '.'))
                                                              
                                    IF @from_top = 1
                                        AND @nomenclature_num IS NULL
                                        AND @catalog_num IS NOT NULL
                                        BEGIN
                                            SELECT TOP 1
                                                    @nomenclature_num = nomenclature_num
                                            FROM    dbo.zipcl_claim_units cu
                                            WHERE   cu.catalog_num = @catalog_num
                                            ORDER BY id_claim_unit DESC
                                        END
                                        
                                    SET @no_nomenclature_num = ISNULL(@no_nomenclature_num,
                                                              0)
                                        
                                        --Убираем факт отсутствия номенклатурного номера если он передан
                                    --IF @var_str = 'updClaimUnit'
                                    --    AND @nomenclature_num IS NOT NULL
                                    --    AND LTRIM(RTRIM(@nomenclature_num)) != ''
                                    --    BEGIN
                                    --        SET @no_nomenclature_num = 0
                                    --    END
                                    
                                    IF @no_nomenclature_num = 1
                                        BEGIN
                                    --Запоминаем номер заявки на заведение ЗИПа в Эталон
                                            SET @nomenclature_claim_num = @nomenclature_num
										--Удаляем номенклатурник
                                            SET @nomenclature_num = 'delete'
										
                                        END
									
                                    EXEC @id_claim_unit = dbo.sk_zip_claims @action = @var_str,
                                        @id_claim_unit = @id_claim_unit,
                                        @id_claim = @id_claim,
                                        @catalog_num = @catalog_num,
                                        @name = @name, @count = @count,
                                        @nomenclature_num = @nomenclature_num,
                                        @price_in = @pr_in,
                                        @price_out = @pr_out,
                                        @id_creator = @id_creator,
                                        @delivery_time = @delivery_time,
                                        @no_nomenclature_num = @no_nomenclature_num,
                                        @nomenclature_claim_num = @nomenclature_claim_num,
                                        @id_supply_man = @id_supply_man,
                                        @id_resp_supply = @id_resp_supply,
                                        @is_return = @is_return
									
                                    SELECT  @id_claim_state = id_claim_state
                                    FROM    dbo.zipcl_zip_claims c
                                    WHERE   id_claim = @id_claim
									
									----Если последний статус не такой же, то меняем статус позиции
         --                           IF NOT EXISTS ( SELECT  1
         --                                           FROM    dbo.zipcl_zip_claims c
         --                                           WHERE   c.id_claim = @id_claim
         --                                                   AND c.id_claim_state = @id_claim_state )
         --                               BEGIN
         --                                   EXEC sk_zip_claims @action = 'insClaimUnitStateChange',
         --                                       @id_claim_unit = @id_claim_unit,
         --                                       @id_claim_state = @id_claim_state,
         --                                       @id_creator = @id_creator
         --                               END
									
                                    SELECT  @id_claim_unit AS id_claim_unit
                                END
                            ELSE
                                IF @action = 'closeClaimUnit'
                                    BEGIN
                                        IF @sp_test IS NOT NULL
                                            BEGIN
                                                RETURN
                                            END
                            
                            --//TODO: Необходимо проверять не привязано ли устройство к договору иначе RAISERROR    
                            
                                        EXEC dbo.sk_zip_claims @action = N'closeClaimUnit',
                                            @id_claim_unit = @id_claim_unit,
                                            @id_creator = @id_creator                        
                                    END
                            
        IF @action = 'checkDeviceByNum'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
                    
                IF @serial_num IS NOT NULL
                    AND @serial_num != ''
                    BEGIN
                        SELECT  @id_device = d.id_device
                        FROM    dbo.srvpl_devices d
                        WHERE   d.enabled = 1
                                AND d.serial_num = @serial_num
                    END
                        
                            
                IF @inv_num IS NOT NULL
                    AND @inv_num != ''
                    BEGIN
                        SELECT  @id_device = d.id_device
                        FROM    dbo.srvpl_devices d
                        WHERE   d.enabled = 1
                                AND d.inv_num = @inv_num
                    END
                            
                SELECT TOP 1
                        c2d.id_device ,
                        dbo.srvpl_fnc('getDeviceModelCollectedName', NULL,
                                      d.id_device_model, NULL, NULL) AS model ,
                        c2d.address ,
                        c2d.id_city ,
                        ( SELECT    ISNULL(c.region
                                           + CASE WHEN c.locality IS NULL
                                                       AND c.name IS NULL
                                                       AND c.area IS NULL
                                                  THEN ''
                                                  ELSE ', '
                                             END, '') + ISNULL(c.area
                                                              + CASE
                                                              WHEN c.locality IS NULL
                                                              AND c.name IS NULL
                                                              THEN ''
                                                              ELSE ', '
                                                              END, '')
                                    + ISNULL(c.name
                                             + CASE WHEN c.locality IS NULL
                                                    THEN ''
                                                    ELSE ', '
                                               END, '') + ISNULL(c.locality,
                                                              '')
                          FROM      cities c
                          WHERE     c.id_city = c2d.id_city
                        ) AS city ,
                        ct.id_contractor ,
                        c2d.id_service_admin ,
                        ct.id_manager ,
                        ( SELECT    CASE WHEN sys_name = 'MOREZIP'
                                         THEN 'pnl-green-col'
                                         ELSE CASE WHEN sys_name = 'LESSZIP'
                                                   THEN 'pnl-red-col'
                                                   ELSE ''
                                              END
                                    END
                          FROM      srvpl_contract_zip_states zst
                          WHERE     zst.id_zip_state = ct.id_zip_state
                        ) AS zip_state ,
                        c2d.[object_name] ,
                        ct.number AS contract_number ,
                        ctt.name AS contract_type ,
                        d.serial_num ,
                        d.inv_num ,
                        ( SELECT TOP 1
                                    id_operator
                          FROM      zipcl_manager2operators m2o
                          WHERE     m2o.ENABLED = 1
                                    AND m2o.id_manager = ct.id_manager
                        ) AS id_operator
                FROM    dbo.srvpl_contract2devices c2d
                        INNER JOIN dbo.srvpl_devices d ON c2d.id_device = d.id_device
                        INNER JOIN dbo.srvpl_contracts ct ON c2d.id_contract = ct.id_contract
                        INNER JOIN dbo.srvpl_contract_types ctt ON ct.id_contract_type = ctt.id_contract_type
                WHERE   c2d.enabled = 1
                        AND d.enabled = 1
                        AND ct.enabled = 1
                        AND c2d.id_device = @id_device                       
            END
            
        IF @action = 'getClaimEtalonState'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
                    
                SELECT  ixvblg5apxsh AS et_state
                FROM    [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_ixvblg5apz51
                WHERE   ixvblg5apz4e = @request_num
            
            END
            
        IF @action = 'setClaimEtalonStates'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
                    
                DECLARE curs CURSOR
                FOR
                    --Выбираем все незакрытые заявки у которых есть номер требования или номер транс заяки
                                        SELECT  id_claim
                                        FROM    dbo.zipcl_zip_claims c
                                        WHERE   c.enabled = 1
                                                AND old_id_claim IS NULL
                                                AND c.id_claim_state NOT IN (
                                                SELECT  id_claim_state
                                                FROM    dbo.zipcl_claim_states st
                                                WHERE   st.enabled = 1
                                                        AND st.sys_name = 'DONE' )
                                                AND ( c.request_num IS NOT NULL
                                                      OR c.waybill_num IS NOT NULL
                                                    )
                OPEN curs
                FETCH NEXT
                        
                        FROM curs
				INTO @id_claim
							
                WHILE @@FETCH_STATUS = 0
                    BEGIN
                        SET @request_num = NULL
                        SET @waybill_num = NULL
                    
                        SELECT  @request_num = request_num ,
                                @waybill_num = waybill_num
                        FROM    dbo.zipcl_zip_claims c
                        WHERE   c.id_claim = @id_claim
                 
                        DECLARE @et_plan_came_date NVARCHAR(50)  
                                        --Обновляем статус требования                                                               
                        IF @request_num IS NOT NULL
                            BEGIN
                                SET @et_state = NULL
                                SET @et_plan_came_date = NULL
                            
                                ( SELECT    @et_state = ixvblg5apxsh COLLATE Cyrillic_General_CI_AS ,
                                            @et_plan_came_date = CONVERT(NVARCHAR(50), ixvblg5apy7k, 104)
                                  FROM      [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_ixvblg5apz51
                                  WHERE     ixvblg5apz4e COLLATE Cyrillic_General_CI_AS = @request_num
                                )
                         --<Сохраняем текущий статус в головную запись чтобы фильтровать по-старому
                                UPDATE  dbo.zipcl_zip_claims
                                SET     et_state = @et_state
                                WHERE   id_claim = @id_claim
                                --</Сохраняем текущий...
                                
                                SET @id_claim_state = NULL
                                
                                SELECT  @id_claim_state = id_claim_state
                                FROM    dbo.zipcl_claim_states cs
                                WHERE   cs.enabled = 1
                                        AND cs.name = @et_state
                                                                
                                IF @id_claim_state > 0
                                    AND EXISTS ( SELECT 1
                                                 FROM   dbo.zipcl_zip_claims c
                                                 WHERE  c.id_claim = @id_claim
                                                     --текущий статус = Согласованы цены
                                                        AND c.id_claim_state IN (
                                                        SELECT
                                                              id_claim_state
                                                        FROM  dbo.zipcl_claim_states cs
                                                        WHERE UPPER(cs.sys_name) IN (
                                                              'PRICEOK',
                                                              'ETORDER',
                                                              'ETDOCS',
                                                              'ETSHIP',
                                                              'ETPREP' ) )
                                                        AND c.id_claim_state <> @id_claim_state )
                                    BEGIN
                                        EXEC dbo.sk_zip_claims @action = N'updClaim',
                                            @id_claim = @id_claim,
                                            @id_claim_state = @id_claim_state
                                    END 
                                    
                                IF NOT EXISTS ( SELECT  1
                                                FROM    dbo.zipcl_zip_claims c
                                                WHERE   c.id_claim = @id_claim
                                                        AND c.et_plan_came_date = @et_plan_came_date )
                                    BEGIN
                                        EXEC dbo.sk_zip_claims @action = N'updClaim',
                                            @id_claim = @id_claim,
                                            @et_plan_came_date = @et_plan_came_date
                                                 
                                    END
                            END
                         
                         --Обновляем статус трансп заявки                                                               
                        IF @waybill_num IS NOT NULL
                            BEGIN
                                SET @et_waybill_state = NULL
								
                                ( SELECT    @et_waybill_state = IXVBLG5ZD4K7 COLLATE Cyrillic_General_CI_AS
                                  FROM      [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_IXVBLG5ZO8B9
                                  WHERE     IXVBLG5ZCSPK COLLATE Cyrillic_General_CI_AS = @waybill_num
                                )
                         
                         --<Сохраняем текущий статус в головную запись чтобы фильтровать по-старому
                                UPDATE  dbo.zipcl_zip_claims
                                SET     et_waybill_state = @et_waybill_state
                                WHERE   id_claim = @id_claim
                                --</Сохраняем текущий...
                                
                                SET @id_et_way_claim_state = NULL
                                
                                SELECT  @id_et_way_claim_state = id_claim_state
                                FROM    dbo.zipcl_claim_states cs
                                WHERE   cs.enabled = 1
                                        AND cs.name = @et_waybill_state
                                
                                --Статус транспортной сохраняем в отдельную колонку чтобы не путать со статусов транспортной
                                
                                IF @id_et_way_claim_state > 0
                                    AND NOT EXISTS ( SELECT 1
                                                     FROM   dbo.zipcl_zip_claims c
                                                     WHERE  c.id_claim = @id_claim
                                                            AND c.id_et_way_claim_state = @id_et_way_claim_state )
                                    BEGIN								
                                    
                                        EXEC dbo.sk_zip_claims @action = N'updClaim',
                                            @id_claim = @id_claim,
                                            @id_et_way_claim_state = @id_et_way_claim_state
                                    END 
                            END
                                            
                        FETCH NEXT
					FROM curs
					INTO @id_claim
                    END

                CLOSE curs

                DEALLOCATE curs
            END
            
            
            
        IF @action = 'getClaimUnitLastClaimDaysCount'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
                    
                SELECT TOP 1
                        DATEDIFF(day, c.dattim1, GETDATE()) AS days_count ,
                        CONVERT(DATE, c.dattim1, 104) AS claim_date ,
                        ( SELECT    name
                          FROM      dbo.zipcl_claim_states cs
                          WHERE     cs.id_claim_state = c.id_claim_state
                        ) AS claim_state ,
                        c.et_state ,
                        c.et_waybill_state
                FROM    dbo.zipcl_zip_claims c
                        INNER JOIN dbo.zipcl_claim_units cu ON c.id_claim = cu.id_claim
                WHERE   c.enabled = 1
                        AND cu.enabled = 1
                        AND
                --( ( ( @id_device IS NULL
                --              OR @id_device <= 0
                --            )
                --            AND ( c.serial_num = @serial_num )
                --          )
                --          OR ( @id_device IS NOT NULL
                --               AND c.id_device = @id_device
                --             )
                --        )
                        LOWER(c.serial_num) = LOWER(@serial_num)
                        AND LOWER(cu.catalog_num) = LOWER(@catalog_num)
                ORDER BY c.id_claim DESC
            
            END
            
        IF @action = 'getClaimCommentHistory'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END                    

                SELECT  MIN(t.id_claim) ,
                        t.descr ,
                        ( SELECT    cc.dattim2
                          FROM      dbo.zipcl_zip_claims cc
                          WHERE     cc.id_claim = MIN(t.id_claim)
                        ) AS date_create ,
                        ( SELECT    u.display_name
                          FROM      dbo.zipcl_zip_claims cc
                                    INNER JOIN users u ON cc.id_creator = u.id_user
                          WHERE     cc.id_claim = MIN(t.id_claim)
                        ) AS creator
                FROM    ( SELECT    c.id_claim ,
                                    c.descr
                          FROM      dbo.zipcl_zip_claims c
                          WHERE     c.old_id_claim = @id_claim
                                    AND LTRIM(RTRIM(c.descr)) <> ''
--ORDER BY c.id_claim DESC
                        ) AS T
                GROUP BY t.descr
                ORDER BY MIN(t.id_claim)
                
            END
                            
	--=================================
	--EngeneerConclusion
	--=================================	
        IF @action = 'getEngeneerConclusionSelectionList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
				
                SELECT  t.id_engeneer_conclusion AS id ,
                        t.name AS name
                FROM    dbo.zipcl_engeneer_conclusions t
                WHERE   t.enabled = 1
                ORDER BY t.order_num        
            END
                
    --=================================
	--ClaimState
	--=================================	

        IF @action = 'getClaimStateSelectionList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
				
                SELECT  t.id_claim_state AS id ,
                        t.name AS name
                FROM    dbo.zipcl_claim_states t
                WHERE   t.enabled = 1
                        AND ( t.note IS NULL
                              OR t.note = 'ET'
                            )
                ORDER BY t.order_num        
            END
        ELSE
            IF @action = 'getEtClaimStateSelectionList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
				
                    SELECT  t.id_claim_state AS id ,
                            t.name AS name
                    FROM    dbo.zipcl_claim_states t
                    WHERE   t.enabled = 1
                            AND t.note = 'ET'
                    ORDER BY t.order_num        
                END
            ELSE
                IF @action = 'getWaybillClaimStateSelectionList'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
				
                        SELECT  t.id_claim_state AS id ,
                                t.name AS name
                        FROM    dbo.zipcl_claim_states t
                        WHERE   t.enabled = 1
                                AND t.note = 'WAY'
                        ORDER BY t.order_num        
                    END
            
            --=================================
	--FilterSelectionLists
	--=================================	

        IF @action = 'getContractorFilterSelectionList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                SELECT  t.id_contractor AS id ,
                        ct.name_inn AS name
                FROM    ( SELECT    c.id_contractor
                          FROM      dbo.zipcl_zip_claims c
                          GROUP BY  c.id_contractor
                        ) AS t
                        INNER JOIN dbo.get_contractor(NULL) ct ON t.id_contractor = ct.id
                ORDER BY ct.inn ,
                        ct.full_name       
            END
            
            --=================================
	--OftenSelected
	--=================================	
            
        IF @action = 'getOftenSelectedList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
				
				--Удаляем характеристики которые в скобках
                SET @var_int = CHARINDEX('(', @device_model)
                SELECT  @var_int = CASE WHEN @var_int > 0 THEN @var_int - 1
                                        ELSE 0
                                   END
                IF @var_int > 0
                    BEGIN
                        SET @device_model = LTRIM(RTRIM(LEFT(@device_model,
                                                             @var_int)))
                    END
                SELECT  tttt.*
                FROM    ( SELECT    ttt.* ,
                                    ROW_NUMBER() OVER ( ORDER BY ttt.zip_group_order_num , ttt.id_zip_group , ttt.cnt DESC ) AS row_num ,
                                    CASE WHEN ttt.id_zip_group2cat_num IS NOT NULL
                                              AND ttt.id_zip_group = @id_zip_group
                                         THEN 1
                                         ELSE 0
                                    END AS show_delete ,
                                    CASE WHEN ttt.id_zip_group2cat_num IS NOT NULL
                                         THEN 1
                                         ELSE 0
                                    END AS show_selected ,
                                    CASE WHEN ttt.id_zip_group2cat_num IS NULL
                                         THEN 1
                                         ELSE 0
                                    END AS show_add ,
                                    ( SELECT    descr
                                      FROM      zipcl_claim_unit_infos i
                                      WHERE     i.ENABLED = 1
                                                AND i.catalog_num = ttt.catalog_num
                                    ) AS comment
                          FROM      ( SELECT    r_num ,
                                                tt.catalog_num ,
                                                ( SELECT TOP 1
                                                            name
                                                  FROM      dbo.zipcl_claim_units cuu
                                                            INNER JOIN dbo.zipcl_zip_claims cc ON cuu.id_claim = cc.id_claim
                                                  WHERE     cuu.enabled = 1
                                                            AND cc.enabled = 1
                                                            AND ( CONVERT(DATE, cuu.dattim1) >= CONVERT(DATE, '27.06.2014', 104) )
                                                            AND cuu.catalog_num = tt.catalog_num
                                                            AND ( @get_all = 1
                                                              OR ( ( @get_all IS NULL
                                                              OR @get_all = 0
                                                              )
                                                              AND cc.device_model LIKE @device_model
                                                              + '%'
                                                              )
                                                              )
                                                  GROUP BY  name
                                                ) AS NAME ,
                                                1 AS [count] ,
                                                cnt ,
                                                ISNULL(id_zip_group, 999999999) AS id_zip_group ,
                                                ISNULL(( SELECT
                                                              order_num
                                                         FROM zipcl_zip_groups zg
                                                         WHERE
                                                              zg.ENABLED = 1
                                                              AND zg.id_zip_group = tt.id_zip_group
                                                       ), 999999999) AS zip_group_order_num ,
                                                ( SELECT    name
                                                  FROM      zipcl_zip_groups zg
                                                  WHERE     zg.ENABLED = 1
                                                            AND zg.id_zip_group = tt.id_zip_group
                                                ) AS zip_group ,
                                                ( SELECT    colour
                                                  FROM      zipcl_zip_groups zg
                                                  WHERE     zg.ENABLED = 1
                                                            AND zg.id_zip_group = tt.id_zip_group
                                                ) AS zip_group_color ,
                                                ( SELECT TOP 1
                                                            id_zip_group2cat_num
                                                  FROM      zipcl_zip_group2cat_nums z2c
                                                  WHERE     z2c.ENABLED = 1
                                                            AND z2c.id_zip_group = tt.id_zip_group
                                                            AND z2c.catalog_num = tt.catalog_num
                                                ) AS id_zip_group2cat_num
                                      FROM      ( SELECT    ROW_NUMBER() OVER ( ORDER BY t.cnt DESC ) AS r_num ,
                                                            t.catalog_num ,
                                                            cnt ,
                                                            ( SELECT TOP 1
                                                              zg.id_zip_group
                                                              FROM
                                                              zipcl_zip_group2cat_nums z2c
                                                              INNER JOIN zipcl_zip_groups zg ON z2c.id_zip_group = zg.id_zip_group
                                                              WHERE
                                                              z2c.ENABLED = 1
                                                              AND zg.ENABLED = 1
                                                              AND z2c.catalog_num = t.catalog_num
                                                            ) AS id_zip_group
                                                  FROM      ( SELECT
                                                              cu.catalog_num ,
                                                              COUNT(1) AS cnt
                                                              FROM
                                                              dbo.zipcl_claim_units cu
                                                              INNER JOIN dbo.zipcl_zip_claims c ON cu.id_claim = c.id_claim
                                                              WHERE
                                                              cu.enabled = 1
                                                              AND c.enabled = 1
                                                              AND ( CONVERT(DATE, c.dattim1) >= CONVERT(DATE, '27.06.2014', 104) )
                                      --Выводим только имеющиеся в базе
                                                              AND c.id_device IS NOT NULL
                                                              AND LTRIM(RTRIM(cu.catalog_num)) NOT IN (
                                                              '', '-' )
                                                              AND ( @get_all = 1
                                                              OR ( ( @get_all IS NULL
                                                              OR @get_all = 0
                                                              )
                                                              AND c.device_model LIKE @device_model
                                                              + '%'
                                                              )
                                                              )
                                                              GROUP BY cu.catalog_num
                                                            ) AS t
                                                ) AS tt
                                      WHERE     ( ( @is_top IS NULL
                                                    OR @is_top = 0
                                                  )
                                                  OR ( @is_top = 1
                                                       AND r_num <= 30
                                                     )
                                                )
                                                AND ( ( @in_group IS NULL
                                                        OR @in_group = 0
                                                      )
                                                      OR ( @in_group = 1
                                                           AND id_zip_group = @id_zip_group
                                                         )
                                                    )
                                                AND ( ( @no_group IS NULL
                                                        OR @no_group = 0
                                                      )
                                                      OR ( @no_group = 1
                                                           AND id_zip_group IS NULL
                                                         )
                                                    )
                                    ) AS ttt
                        ) AS tttt
                WHERE   ( @start_row IS NULL
                          OR ( @start_row IS NOT NULL
                               AND row_num >= @start_row
                             )
                        )
                        AND ( @end_row IS NULL
                              OR ( @end_row IS NOT NULL
                                   AND row_num <= @end_row
                                 )
                            )
                ORDER BY 
                --tttt.zip_group_order_num, tttt.id_zip_group, tttt.cnt DESC 
                        CASE WHEN @is_top = 1 THEN tttt.zip_group_order_num
                             ELSE NULL
                        END ,
                        CASE WHEN @is_top = 1 THEN tttt.id_zip_group
                             ELSE NULL
                        END ,
                        tttt.cnt DESC  
            END
            
            
    --=================================
	--UserFilter
	--=================================	

        IF @action = 'getUserFilter'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
				
				--выбираем последний активный фильтр
                SELECT TOP 1
                        @id_user_filter = id_user_filter
                FROM    zipcl_user_filters uf
                WHERE   uf.enabled = 1
                        AND uf.id_user = @id_user
                ORDER BY uf.id_user_filter DESC
				
                SELECT  filter
                FROM    zipcl_user_filters uf
                WHERE   uf.id_user_filter = @id_user_filter  
            END
        ELSE
            IF @action = 'saveUserFilter'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                    
                    --выбираем последний активный фильтр
                    SELECT TOP 1
                            @id_user_filter = id_user_filter
                    FROM    zipcl_user_filters uf
                    WHERE   uf.enabled = 1
                            AND uf.id_user = @id_user
                    ORDER BY uf.id_user_filter DESC                  
                    
                    SET @var_str = 'insUserFilter'
				
                    IF EXISTS ( SELECT  1
                                FROM    dbo.zipcl_user_filters t
                                WHERE   t.id_user_filter = @id_user_filter )
                        BEGIN
                            SET @var_str = 'updUserFilter'
                        END
				
                    EXEC dbo.sk_zip_claims @action = @var_str,
                        @id_user_filter = @id_user_filter, @id_user = @id_user,
                        @filter = @filter            
                    
                END
            ELSE
                IF @action = 'closeUserFilter'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                        EXEC dbo.sk_zip_claims @action = N'closeUserFilter',
                            @id_user_filter = @id_user_filter,
                            @id_creator = @id_creator
                    END
    --=================================
	--NewStateNote
	--=================================	

        IF @action = 'sendNewStateNote'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
                --////////////////////////////////
                --DESCRIPTION ОПИСАНИЕ
                --Необходимо отправлять каждые 3 часа
                --////////////////////////////////
                    
                    
                DECLARE @engeneer_mail NVARCHAR(150) ,
                    @serv_admin_mail NVARCHAR(150)
                    
                SELECT  @id_sended_mail_type = id_sended_mail_type
                FROM    dbo.sended_mail_types mt
                WHERE   mt.sys_name = 'sendNewStateNote'
                    
                DECLARE curs CURSOR
                FOR
                    SELECT  c.id_claim ,
                            u_eng.mail ,
                            u_adm.mail
                    FROM    dbo.zipcl_zip_claims c
                            INNER JOIN dbo.zipcl_claim_states cs ON c.id_claim_state = cs.id_claim_state
                            INNER JOIN dbo.users u_eng ON c.id_engeneer = u_eng.id_user
                            INNER JOIN dbo.users u_adm ON c.id_service_admin = u_adm.id_user
                    WHERE   c.enabled = 1
                            AND c.old_id_claim IS NULL
                            AND UPPER(cs.sys_name) = 'NEW'
--AND  CONVERT(DATE, c.dattim1) >= CONVERT(DATE, '27.06.2014', 104)
                            AND DATEDIFF(day, c.dattim1, GETDATE()) >= 1
                            --Проверяем было ли отправлено уже письмо с таким уведомлением
                            --AND NOT EXISTS ( SELECT 1
                            --                 FROM   dbo.sended_mails sm
                            --                 WHERE  sm.id_sended_mail_type = @id_sended_mail_type
                            --                        AND uid = c.id_claim )
                    
                OPEN curs
                FETCH NEXT
                        
                        FROM curs
				INTO @id_claim, @engeneer_mail, @serv_admin_mail
							
                WHILE @@FETCH_STATUS = 0
                    BEGIN
                        SET @mail_text = '<a href="' + @root_url + '?id='
                            + CONVERT(NVARCHAR(10), @id_claim)
                            + '">Заявка на ЗИП №'
                            + CONVERT(NVARCHAR(10), @id_claim)
                            + '</a> находится в статусе Создано более суток'
                        SET @mail_subject = 'Заявка на ЗИП'
									
                        EXEC sk_send_message @action = 'send_email',
                            @id_program = @id_program,
                            @subject = @mail_subject, @body = @mail_text,
                            @recipients = @engeneer_mail	
                                                
                        EXEC sk_send_message @action = 'send_email',
                            @id_program = @id_program,
                            @subject = @mail_subject, @body = @mail_text,
                            @recipients = @serv_admin_mail	
                                
                        EXEC dbo.sk_sended_mails @id_program = @id_program,
                            @id_sended_mail_type = @id_sended_mail_type,
                            @uid = @id_claim
                        
				
                        FETCH NEXT
					FROM curs
					INTO @id_claim, @engeneer_mail, @serv_admin_mail
                    END

                CLOSE curs

                DEALLOCATE curs
            END
            
        IF @action = 'sendSendStateNote'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
                --////////////////////////////////
                --DESCRIPTION ОПИСАНИЕ
                --Необходимо отправлять каждые 3 часа
                --////////////////////////////////
                    
                SELECT  @id_sended_mail_type = id_sended_mail_type
                FROM    dbo.sended_mail_types mt
                WHERE   mt.sys_name = 'sendSendtateNote'
                    
                DECLARE curs CURSOR
                FOR
                    SELECT  c.id_claim ,
                            u_eng.mail ,
                            u_adm.mail
                    FROM    dbo.zipcl_zip_claims c
                            INNER JOIN dbo.zipcl_claim_states cs ON c.id_claim_state = cs.id_claim_state
                            INNER JOIN dbo.users u_eng ON c.id_engeneer = u_eng.id_user
                            INNER JOIN dbo.users u_adm ON c.id_service_admin = u_adm.id_user
                    WHERE   c.enabled = 1
                            AND c.old_id_claim IS NULL
                            AND UPPER(cs.sys_name) = 'SEND'
--AND  CONVERT(DATE, c.dattim1) >= CONVERT(DATE, '27.06.2014', 104)
                            AND DATEDIFF(hour, c.dattim1, GETDATE()) >= 24
                            --Проверяем было ли отправлено уже письмо с таким уведомлением
                            --AND NOT EXISTS ( SELECT 1
                            --                 FROM   dbo.sended_mails sm
                            --                 WHERE  sm.id_sended_mail_type = @id_sended_mail_type
                            --                        AND uid = c.id_claim )
                    
                OPEN curs
                FETCH NEXT
                        
                        FROM curs
				INTO @id_claim, @engeneer_mail, @serv_admin_mail
							
                WHILE @@FETCH_STATUS = 0
                    BEGIN
                        SET @mail_text = '<a href="' + @root_url + '?id='
                            + CONVERT(NVARCHAR(10), @id_claim)
                            + '">Заявка на ЗИП №'
                            + CONVERT(NVARCHAR(10), @id_claim)
                            + '</a> находится в статусе Передано более суток'
                        SET @mail_subject = 'Заявка на ЗИП'
									
                        EXEC sk_send_message @action = 'send_email',
                            @id_program = @id_program,
                            @subject = @mail_subject, @body = @mail_text,
                            @recipients = @engeneer_mail	
                                                
                        EXEC sk_send_message @action = 'send_email',
                            @id_program = @id_program,
                            @subject = @mail_subject, @body = @mail_text,
                            @recipients = @serv_admin_mail	
                                
                        EXEC dbo.sk_sended_mails @id_program = @id_program,
                            @id_sended_mail_type = @id_sended_mail_type,
                            @uid = @id_claim
                        
				
                        FETCH NEXT
					FROM curs
					INTO @id_claim, @engeneer_mail, @serv_admin_mail
                    END

                CLOSE curs

                DEALLOCATE curs
            END
            
        IF @action = 'sendSupplyNewRequestNote'
            BEGIN
                
                DECLARE @vostrecov NVARCHAR(50) ,
                    @lyscov NVARCHAR(50) ,
                    @losminskaya NVARCHAR(50) ,
                    @latisheva NVARCHAR(50)
                
                SET @mail_text = 'Поступил запрос на ввод цены и срока поставки для заявки на ЗИП №'
                    + CONVERT(NVARCHAR(10), @id_claim)
	
                SET @mail_subject = 'Заявка на ЗИП'
							
                SELECT  @id_sended_mail_type = id_sended_mail_type
                FROM    dbo.sended_mail_types mt
                WHERE   mt.sys_name = 'sendSupplyNewRequestNote'
	

	
                DECLARE curs CURSOR
                FOR
                    SELECT  cu.id_resp_supply
                    FROM    dbo.zipcl_claim_units cu
                    WHERE   cu.enabled = 1
                            AND cu.id_claim = @id_claim
                            AND cu.price_request = 1
                    GROUP BY id_resp_supply

                OPEN curs

                FETCH NEXT                        
        FROM curs
		INTO @id_resp_supply
			
                WHILE @@FETCH_STATUS = 0
                    BEGIN	
                        IF @id_resp_supply IS NOT NULL
                            BEGIN
                                SELECT  @mail = mail
                                FROM    dbo.users u
                                WHERE   u.id_user = @id_resp_supply
                
                                EXEC sk_send_message @action = 'send_email',
                                    @id_program = @id_program,
                                    @subject = @mail_subject,
                                    @body = @mail_text, @recipients = @mail
                            END          
                        ELSE
                            BEGIN
                                SET @vostrecov = ( SELECT   mail
                                                   FROM     dbo.users u
                                                   WHERE    u.old_id_user IS NULL
                                                            --AND LOWER(u.login) = LOWER('Evgeniy.Vostrecov')
                                                            AND sid = 'S-1-5-21-1970802976-3466419101-4042325969-1676'
                                                            AND mail IS NOT NULL
                                                 )
                                SET @lyscov = ( SELECT  mail
                                                FROM    dbo.users u
                                                WHERE   u.old_id_user IS NULL
                                                        --AND LOWER(u.login) = LOWER('Alexandr.Lystsov')
                                                        AND sid = 'S-1-5-21-1970802976-3466419101-4042325969-2220'
                                                        AND mail IS NOT NULL
                                              )	
                                              
                                SET @losminskaya = ( SELECT mail
                                                     FROM   dbo.users u
                                                     WHERE  u.old_id_user IS NULL
                                                            --AND LOWER(u.login) = LOWER('anna.losminskaya')
                                                            AND sid = 'S-1-5-21-1970802976-3466419101-4042325969-2342'
                                                            AND mail IS NOT NULL
                                                   )		
                                              
                                SET @latisheva = ( SELECT   mail
                                                   FROM     dbo.users u
                                                   WHERE    u.old_id_user IS NULL
                                                            --AND LOWER(u.login) = LOWER('tatyana.latisheva')
                                                            AND sid = 'S-1-5-21-1970802976-3466419101-4042325969-3965'
                                                            AND mail IS NOT NULL
                                                 )				
              
                                EXEC sk_send_message @action = 'send_email',
                                    @id_program = @id_program,
                                    @subject = @mail_subject,
                                    @body = @mail_text,
                                    @recipients = @vostrecov	
                                                
                                EXEC sk_send_message @action = 'send_email',
                                    @id_program = @id_program,
                                    @subject = @mail_subject,
                                    @body = @mail_text, @recipients = @lyscov	
                                    
                                EXEC sk_send_message @action = 'send_email',
                                    @id_program = @id_program,
                                    @subject = @mail_subject,
                                    @body = @mail_text,
                                    @recipients = @losminskaya	
                                    
                                EXEC sk_send_message @action = 'send_email',
                                    @id_program = @id_program,
                                    @subject = @mail_subject,
                                    @body = @mail_text,
                                    @recipients = @latisheva	        
                            END                                
				
                        FETCH NEXT                        
				FROM curs
				INTO @id_resp_supply
        
                    END

                EXEC dbo.sk_sended_mails @id_program = @id_program,
                    @id_sended_mail_type = @id_sended_mail_type,
                    @uid = @id_claim

                CLOSE curs

                DEALLOCATE curs
                
                --SET @mail_text = 'Поступил запрос на ввод цены и срока поставки для заявки на ЗИП №'
                --    + CONVERT(NVARCHAR(10), @id_claim)
                --SET @mail_subject = 'Заявка на ЗИП'
							
                --SELECT  @id_sended_mail_type = id_sended_mail_type
                --FROM    dbo.sended_mail_types mt
                --WHERE   mt.sys_name = 'sendSupplyNewRequestNote'
								
                --DECLARE @vostrecov NVARCHAR(50) ,
                --    @lyscov NVARCHAR(50)
                --SET @vostrecov = ( SELECT   mail
                --                   FROM     dbo.users u
                --                   WHERE    u.old_id_user IS NULL
                --                            AND LOWER(u.login) = LOWER('Evgeniy.Vostrecov')
                --                            AND mail IS NOT NULL
                --                 )
                --SET @lyscov = ( SELECT  mail
                --                FROM    dbo.users u
                --                WHERE   u.old_id_user IS NULL
                --                        AND LOWER(u.login) = LOWER('Alexandr.Lystsov')
                --                        AND mail IS NOT NULL
                --              )				
									
                --EXEC sk_send_message @action = 'send_email',
                --    @id_program = @id_program, @subject = @mail_subject,
                --    @body = @mail_text, @recipients = @vostrecov	
                                                
                --EXEC sk_send_message @action = 'send_email',
                --    @id_program = @id_program, @subject = @mail_subject,
                --    @body = @mail_text, @recipients = @lyscov	
                                
                --EXEC dbo.sk_sended_mails @id_program = @id_program,
                --    @id_sended_mail_type = @id_sended_mail_type,
                --    @uid = @id_claim
            END
            
        IF @action = 'getNomenclatureDataByNumber'
            BEGIN
                SELECT  ttt.nom_name ,
                        CASE WHEN CONVERT(INT, ttt.COUNT) = 0
                                  OR ttt.COUNT IS NULL THEN '-'
                             ELSE CONVERT(NVARCHAR(50), CONVERT(INT, ttt.COUNT))
                        END AS [COUNT] ,
                        CASE WHEN ttt.[count] = 0
                                  OR ttt.[count] IS NULL THEN '-'
                             ELSE CONVERT(NVARCHAR(50), CONVERT(DECIMAL(18, 2), ttt.cost
                                  / ttt.[count]))
                        END AS price
                FROM    ( SELECT    tt.nom_name ,
                                    SUM(tt.count) AS COUNT ,
                                    SUM(tt.cost) * 1.02 AS cost
                          FROM      ( SELECT    t.nom_name ,
                                                t.post_date ,
                                                t.[count] ,
                                                t.cost
                                      FROM      ( SELECT    n.o2s5xclou7k AS nom_name ,
                                                            wh.ixvblg72woge AS post_date ,
                                                            wh.ixvblg6o94ty AS [count] ,
                                                            wh.ixvblg6o94uh AS cost
                                                  FROM      [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_ixvblg6o95d0
                                                            AS wh --Склад
                                                            INNER JOIN [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_ixsjty4t828z
                                                            AS n ON wh.ixvblg6o9522 = n.recordid--Номенклатура МЦ 
                                                            INNER JOIN [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_o2s5xd0xhi7 mol ON wh.ixvblg6o950r = mol.recordid--МОЛ
                                                            INNER JOIN [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_o2s5xcqw0yw pl ON mol.o2s5xd0xhll = pl.recordid--Места хранения
                                                            INNER JOIN [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_a1wwk3keebw1 app ON pl.a1wwk3keed1r = app.recordid--Целевое назначение
                                                  WHERE     app.a1wwk3khbo8n = '0001'
                                                            AND n.a1wwk3khbo8n = LTRIM(RTRIM(@nomenclature_num))
                                                ) AS t
                                    ) AS tt
                          GROUP BY  nom_name
                        ) AS ttt
            
            END
    
    --=================================
	--ZipGroups
	--=================================	
        IF @action = 'getZipGroupList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                SELECT  ROW_NUMBER() OVER ( ORDER BY zg.order_num , zg.name ) AS row_num ,
                        zg.id_zip_group ,
                        zg.NAME ,
                        zg.colour ,
                        zg.order_num
                FROM    dbo.zipcl_zip_groups zg
                WHERE   zg.enabled = 1
                ORDER BY zg.order_num ,
                        zg.name
            END
        ELSE
            IF @action = 'getZipGroupSelectionList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
		
                    SELECT  t.id_zip_group AS id ,
                            t.name
                    FROM    dbo.zipcl_zip_groups t
                    WHERE   t.enabled = 1
                    ORDER BY t.order_num ,
                            t.name
                END
            ELSE
                IF @action = 'getZipGroup'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                    
                        SELECT  id_zip_group ,
                                name ,
                                order_num ,
                                colour
                        FROM    zipcl_zip_groups t
                        WHERE   t.id_zip_group = @id_zip_group                   
                    
                    END
                ELSE
                    IF @action = 'saveZipGroup'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END
                    
                            SET @var_str = 'insZipGroup'
				
                            IF EXISTS ( SELECT  1
                                        FROM    dbo.zipcl_zip_groups t
                                        WHERE   t.id_zip_group = @id_zip_group )
                                BEGIN
                                    SET @var_str = 'updZipGroup'
                                END
							
                            IF @order_num = 0
                                BEGIN
                                    SET @order_num = NULL
                                END
							
                            EXEC dbo.sk_zip_claims @action = @var_str,
                                @id_zip_group = @id_zip_group, @name = @name,
                                @order_num = @order_num, @colour = @colour,
                                @id_creator = @id_creator                        
                    
                        END
                    ELSE
                        IF @action = 'closeZipGroup'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END
                                EXEC dbo.sk_zip_claims @action = N'closeZipGroup',
                                    @id_zip_group = @id_zip_group,
                                    @id_creator = @id_creator    
                            END
                            
    --=================================
	--ZipGroup2catNums
	--=================================	
        IF @action = 'getZipGroup2CatNumsList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                SELECT  ROW_NUMBER() OVER ( ORDER BY z2c.order_num , z2c.catalog_num ) AS row_num ,
                        z2c.id_zip_group2cat_num ,
                        z2c.id_zip_group ,
                        z2c.catalog_num
                FROM    dbo.zipcl_zip_group2cat_nums z2c
                WHERE   z2c.enabled = 1
                ORDER BY z2c.order_num ,
                        z2c.catalog_num
            END
        ELSE
            IF @action = 'getZipGroup2CatNumsSelectionList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
		
                    SELECT  t.id_zip_group2cat_num AS id ,
                            t.catalog_num
                    FROM    dbo.zipcl_zip_group2cat_nums t
                    WHERE   t.enabled = 1
                    ORDER BY t.order_num ,
                            t.catalog_num
                END
            ELSE
                IF @action = 'getZipGroup2CatNum'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                    
                        SELECT  id_zip_group ,
                                catalog_num ,
                                order_num
                        FROM    zipcl_zip_group2cat_nums t
                        WHERE   t.id_zip_group2cat_num = @id_zip_group2cat_num                  
                    
                    END
                ELSE
                    IF @action = 'saveZipGroup2CatNum'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END
                    
                            SET @var_str = 'insZipGroup2CatNum'
				
                            IF EXISTS ( SELECT  1
                                        FROM    dbo.zipcl_zip_group2cat_nums t
                                        WHERE   t.id_zip_group2cat_num = @id_zip_group2cat_num )
                                BEGIN
                                    SET @var_str = 'updZipGroup2CatNum'
                                END
				
                            IF @order_num = 0
                                BEGIN
                                    SET @order_num = NULL
                                END
				
                            EXEC dbo.sk_zip_claims @action = @var_str,
                                @id_zip_group = @id_zip_group,
                                @catalog_num = @catalog_num,
                                @order_num = @order_num,
                                @id_creator = @id_creator                        
                    
                        END
                        
                    ELSE
                        IF @action = 'closeZipGroup2CatNum'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END
                                EXEC dbo.sk_zip_claims @action = N'closeZipGroup2CatNum',
                                    @id_zip_group2cat_num = @id_zip_group2cat_num,
                                    @id_creator = @id_creator    
                            END
        
        
        --=================================
	--ClaimUnitInfo
	--=================================	
        IF @action = 'saveClaimUnitInfo'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
                    
                SET @var_str = 'insClaimUnitInfo'
				
                IF EXISTS ( SELECT  1
                            FROM    dbo.zipcl_claim_unit_infos t
                            WHERE   --t.id_claim_unit_info = @id_claim_unit_info 
                                    t.ENABLED = 1
                                    AND t.catalog_num = @catalog_num )
                    BEGIN
                        SET @var_str = 'updClaimUnitInfo'
                                    
                        SELECT  @id_claim_unit_info = t.id_claim_unit_info
                        FROM    dbo.zipcl_claim_unit_infos t
                        WHERE   t.ENABLED = 1
                                AND t.catalog_num = @catalog_num
                    END
				
                            				
                EXEC dbo.sk_zip_claims @action = @var_str,
                    @catalog_num = @catalog_num,
                    @id_claim_unit_info = @id_claim_unit_info, @descr = @descr,
                    @id_creator = @id_creator                        
                    
            END   
            
    --=================================
	--Counter
	--=================================	
        IF @action = 'saveCounter'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                EXEC dbo.sk_counter @action = 'insCounter',
                    @id_program = @id_program, @id_user = @id_user,
                    @descr = @descr, @ip_address = @ip_address,
                    @user_login = @user_login
            END  
            
     --=================================
	--NomenclaturePrice
	--=================================	
        IF @action = 'getNomenclaturePrice'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
                
                SELECT  * ,
                        CONVERT(DECIMAL(10, 2), price) AS price_in ,
                        CONVERT(DECIMAL(10, 2), price) AS price_out
                FROM    ( SELECT    load_num ,
                                    name ,
                                    catalog_num ,
                                    nomenclature_num ,
                                    price_usd ,
                                    price_eur ,
                                    dattim1 AS load_date ,
                                    CASE WHEN price_usd IS NOT NULL
                                              OR price_eur IS NOT NULL
                                         THEN CASE WHEN price_usd IS NOT NULL
                                                   THEN price_usd
                                                        * dbo.get_currency_price('USD',
                                                              NULL)
                                                   ELSE CASE WHEN price_eur IS NOT NULL
                                                             THEN price_eur
                                                              * dbo.get_currency_price('EUR',
                                                              NULL)
                                                             ELSE price_rur
                                                        END
                                              END
                                         ELSE price_rur
                                    END AS price
                          FROM      dbo.zipcl_nomenclature_price np
                          WHERE     ENABLED = 1
                --CATALOG_NUM
                                    AND ( @catalog_num IS NULL
                                          OR ( @catalog_num IS NOT NULL
                                               AND np.catalog_num LIKE '%'
                                               + @catalog_num + '%'
                                             )
                                        )
                        ) AS t
                ORDER BY t.catalog_num
            END
        ELSE
            IF @action = 'saveNomenclaturePrice'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                    EXEC dbo.sk_zip_claims @action = 'insNomenclaturePrice',
                        @load_num = @load_num, @name = @name,
                        @catalog_num = @catalog_num,
                        @nomenclature_num = @nomenclature_num,
                        @price_rur = @price_rur, @price_usd = @price_usd,
                        @price_eur = @price_eur
                
                END
            ELSE
                IF @action = 'closeNomenclaturePriceList'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
		
                        EXEC dbo.sk_zip_claims @action = 'closeNomenclaturePriceList',
                            @load_num = @load_num
                    END  
                ELSE
                    IF @action = 'getNomenclaturePriceNewLoadNum'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END
                            SELECT  @load_num = ISNULL(MAX(load_num), 0) + 1
                            FROM    zipcl_nomenclature_price np
                            GROUP BY load_num	
		
                            SELECT  ISNULL(@load_num, 1) AS load_num
                        END   
                        
    --=================================
	--SrvplContractSpecPrice
	--=================================	
        IF @action = 'getSrvplContractSpecPriceList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
                
                SELECT  id_srvpl_contract ,
                        id_nomenclature ,
                        catalog_num ,
                        price
                FROM    zipcl_srvpl_contract_spec_prices sp
                WHERE   sp.ENABLED = 1
                        AND sp.id_srvpl_contract = @id_srvpl_contract
            END
        ELSE
            IF @action = 'getSrvplContractSpecPrice'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                
                    SELECT  id_srvpl_contract ,
                            id_nomenclature ,
                            nomenclature_name ,
                            catalog_num ,
                            price ,
                            id_creator
                    FROM    zipcl_srvpl_contract_spec_prices sp
                    WHERE   sp.id_contract_spec_price = @id_contract_spec_price
                END
            ELSE
                IF @action = 'saveSrvplContractSpecPrice'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                        SET @var_str = 'insSrvplContractSpecPrice'
				
                        IF EXISTS ( SELECT  1
                                    FROM    dbo.zipcl_srvpl_contract_spec_prices t
                                    WHERE   t.id_contract_spec_price = @id_contract_spec_price )
                            BEGIN
                                SET @var_str = 'updSrvplContractSpecPrice'
                            END
				
                        IF @order_num = 0
                            BEGIN
                                SET @order_num = NULL
                            END
				
                        EXEC dbo.sk_zip_claims @action = @var_str,
                            @id_contract_spec_price = @id_contract_spec_price,
                            @id_srvpl_contract = @id_srvpl_contract,
                            @id_nomenclature = @id_nomenclature,
                            @nomenclature_name = @nomenclature_name,
                            @catalog_num = @catalog_num, @price = @price,
                            @id_creator = @id_creator 
                
                    END
                ELSE
                    IF @action = 'closeSrvplContractSpecPrice'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END
		
                            EXEC dbo.sk_zip_claims @action = 'closeSrvplContractSpecPrice',
                                @id_contract_spec_price = @id_contract_spec_price,
                                @id_creator = @id_creator 
                        END  
                    ELSE
                        IF @action = 'getSrvplContractSpecPriceNomenclatureName'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END
		
                                SELECT  sp.id_nomenclature ,
                                        sp.nomenclature_name
                                FROM    zipcl_srvpl_contract_spec_prices sp
                                WHERE   sp.ENABLED = 1
                                        AND sp.catalog_num = @catalog_num
                            END  
      --=================================
	--Manager2Operator
	--=================================	
        IF @action = 'getManager2OperatorList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
                
                SELECT  id_manager2operator ,
                        id_manager ,
                        id_operator
                FROM    zipcl_manager2operators
                WHERE   ENABLED = 1
            END
        ELSE
            IF @action = 'getManager2Operator'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
		
                    SELECT  id_manager2operator ,
                            id_manager ,
                            id_operator ,
                            dattim1 ,
                            dattim2 ,
                            enabled ,
                            id_creator
                    FROM    dbo.zipcl_manager2operators
                    WHERE   id_manager2operator = @id_manager2operator
                        
                END
            ELSE
                IF @action = 'saveManager2Operator'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                        
                        IF @id_manager2operator IS NULL
                            AND @id_manager IS NOT NULL
                            BEGIN
                                EXEC ui_zip_claims @action = 'closeManager2Operator',
                                    @id_manager = @id_manager
                            END
                        
                        EXEC dbo.sk_zip_claims @action = 'insManager2Operator',
                            @id_manager2operator = @id_manager2operator,
                            @id_manager = @id_manager,
                            @id_operator = @id_operator,
                            @id_creator = @id_creator
					
                    END
                ELSE
                    IF @action = 'closeManager2Operator'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END
		
                            EXEC dbo.sk_zip_claims @action = 'closeManager2Operator',
                                @id_manager2operator = @id_manager2operator,
                                @id_manager = @id_manager
                            --,
                            --@id_operator = @id_operator
                        END                        
    
            
    --=================================
	--
	--=================================	
        /*IF @action = 'get'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                
            END  */ 
            
           
    
    /********TEMPLATE*******/
    
    /*
    
    --=================================
	--
	--=================================	
		IF @action = 'getList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                SELECT  *
                FROM    dbo.srvpl_ 
                WHERE   .enabled = 1
            END
        ELSE
        IF @action = 'getSelectionList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
		
                SELECT  t.id_ AS id ,
                        t.name ,
                        t.nickname
                FROM    dbo.srvpl_ t
                WHERE   t.enabled = 1
                ORDER BY t.order_num ,
                        t.name
            END
            ELSE
            IF @action = 'save'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
                    
                    SET @var_str = 'ins'
				
                    IF EXISTS ( SELECT  1
                                FROM    dbo.srvpl_ t
                                WHERE   t.id = @id )
                        BEGIN
                            SET @var_str = 'upd'
                        END
				
                    EXEC dbo.sk_service_planing @action = @var_str,
                       
                        @id_creator = @id_creator                        
                    
                END
            ELSE
                IF @action = 'close'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                        EXEC dbo.sk_service_planing @action = N'close',
							@id_ = @id_,
                            @id_creator = @id_creator    
                    END
    */
    
    END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ui_zip_claims] TO [sqlUnit_prog]
    AS [dbo];

