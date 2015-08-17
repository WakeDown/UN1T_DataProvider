
-- =============================================
-- Author:		Anton Rekhov
-- Create date: 10.03.2014
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[ui_service_planing]
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
        SET NOCOUNT ON;

	--<Variables>
        DECLARE @error_text NVARCHAR(MAX) ,
            @mail_text NVARCHAR(MAX) ,
            @id_program INT ,
            @var_int INT ,
            @log_params NVARCHAR(MAX) ,
            @log_descr NVARCHAR(MAX) ,
            @var_str NVARCHAR(MAX) ,
            @def_page_size INT ,
            @def_page_index INT ,
            @row_begin INT ,
            @row_end INT ,
            @id_is_null BIT ,
            @per_manth INT ,
            @cur_date DATETIME

        SET @def_page_index = 0
        SET @def_page_size = 10

	--</Variables>
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
                                                + CONVERT(NVARCHAR(100), @action)
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
                                END + CASE WHEN @page_index IS NULL THEN ''
                                           ELSE ' @page_index='
                                                + CONVERT(NVARCHAR, @page_index)
                                      END
                        + CASE WHEN @page_size IS NULL THEN ''
                               ELSE ' @page_size='
                                    + CONVERT(NVARCHAR, @page_size)
                          END + CASE WHEN @id_device_model IS NULL THEN ''
                                     ELSE ' @id_device_model='
                                          + CONVERT(NVARCHAR, @id_device_model)
                                END + CASE WHEN @lst_id_device IS NULL THEN ''
                                           ELSE ' @lst_id_device='
                                                + CONVERT(NVARCHAR(MAX), @lst_id_device)
                                      END
                        + CASE WHEN @is_linked IS NULL THEN ''
                               ELSE ' @is_linked='
                                    + CONVERT(NVARCHAR(MAX), @is_linked)
                          END + CASE WHEN @planing_date IS NULL THEN ''
                                     ELSE ' @planing_date='
                                          + CONVERT(NVARCHAR(MAX), @planing_date)
                                END
                        + CASE WHEN @id_service_claim IS NULL THEN ''
                               ELSE ' @id_service_claim='
                                    + CONVERT(NVARCHAR(MAX), @id_service_claim)
                          END
                        + CASE WHEN @id_service_claim_status IS NULL THEN ''
                               ELSE ' @id_service_claim_status='
                                    + CONVERT(NVARCHAR(MAX), @id_service_claim_status)
                          END + CASE WHEN @id_device_type IS NULL THEN ''
                                     ELSE ' @id_device_type='
                                          + CONVERT(NVARCHAR(MAX), @id_device_type)
                                END + CASE WHEN @is_active IS NULL THEN ''
                                           ELSE ' @is_active='
                                                + CONVERT(NVARCHAR(MAX), @is_active)
                                      END + CASE WHEN @vendor IS NULL THEN ''
                                                 ELSE ' @vendor='
                                                      + CONVERT(NVARCHAR(MAX), @vendor)
                                            END
                        + CASE WHEN @id_service_interval_plan_group IS NULL
                               THEN ''
                               ELSE ' @id_service_interval_plan_group='
                                    + CONVERT(NVARCHAR(MAX), @id_service_interval_plan_group)
                          END
                        + CASE WHEN @lst_id_contract2devices IS NULL THEN ''
                               ELSE ' @lst_id_contract2devices='
                                    + CONVERT(NVARCHAR(MAX), @lst_id_contract2devices)
                          END + CASE WHEN @not_in_plan_list IS NULL THEN ''
                                     ELSE ' @not_in_plan_list='
                                          + CONVERT(NVARCHAR(MAX), @not_in_plan_list)
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
                        + CASE WHEN @no_device_linked IS NULL THEN ''
                               ELSE ' @no_device_linked='
                                    + CONVERT(NVARCHAR(MAX), @no_device_linked)
                          END + CASE WHEN @id_zip_state IS NULL THEN ''
                                     ELSE ' @id_zip_state='
                                          + CONVERT(NVARCHAR(MAX), @id_zip_state)
                                END + CASE WHEN @note IS NULL THEN ''
                                           ELSE ' @note='
                                                + CONVERT(NVARCHAR(MAX), @note)
                                      END
                        + CASE WHEN @rows_count IS NULL THEN ''
                               ELSE ' @rows_count='
                                    + CONVERT(NVARCHAR(MAX), @rows_count)
                          END + CASE WHEN @counter_colour IS NULL THEN ''
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
                                      END + CASE WHEN @all IS NULL THEN ''
                                                 ELSE ' @all='
                                                      + CONVERT(NVARCHAR(MAX), @all)
                                            END
                        + CASE WHEN @date_month IS NULL THEN ''
                               ELSE ' @date_month='
                                    + CONVERT(NVARCHAR(MAX), @date_month)
                          END + CASE WHEN @lst_schedule_dates IS NULL THEN ''
                                     ELSE ' @lst_schedule_dates='
                                          + CONVERT(NVARCHAR(MAX), @lst_schedule_dates)
                                END
                        + CASE WHEN @add_scheduled_dates2service_plan IS NULL
                               THEN ''
                               ELSE ' @add_scheduled_dates2service_plan='
                                    + CONVERT(NVARCHAR(MAX), @add_scheduled_dates2service_plan)
                          END + CASE WHEN @inv_num IS NULL THEN ''
                                     ELSE ' @inv_num='
                                          + CONVERT(NVARCHAR(MAX), @inv_num)
                                END + CASE WHEN @no_set IS NULL THEN ''
                                           ELSE ' @no_set='
                                                + CONVERT(NVARCHAR(MAX), @no_set)
                                      END
                        + CASE WHEN @filter_text IS NULL THEN ''
                               ELSE ' @filter_text='
                                    + CONVERT(NVARCHAR(MAX), @filter_text)
                          END + CASE WHEN @id_contract_prolong IS NULL THEN ''
                                     ELSE ' @id_contract_prolong='
                                          + CONVERT(NVARCHAR(MAX), @id_contract_prolong)
                                END
                        + CASE WHEN @id_price_discount IS NULL THEN ''
                               ELSE ' @id_price_discount='
                                    + CONVERT(NVARCHAR(MAX), @id_price_discount)
                          END + CASE WHEN @no_came IS NULL THEN ''
                                     ELSE ' @no_came='
                                          + CONVERT(NVARCHAR(MAX), @no_came)
                                END + CASE WHEN @is_done IS NULL THEN ''
                                           ELSE ' @is_done='
                                                + CONVERT(NVARCHAR(MAX), @is_done)
                                      END
                        + CASE WHEN @id_srvpl_address IS NULL THEN ''
                               ELSE ' @id_srvpl_address='
                                    + CONVERT(NVARCHAR(MAX), @id_srvpl_address)
                          END + CASE WHEN @id_payment_tariff IS NULL THEN ''
                                     ELSE ' @id_payment_tariff='
                                          + CONVERT(NVARCHAR(MAX), @id_payment_tariff)
                                END + CASE WHEN @id_user_role IS NULL THEN ''
                                           ELSE ' @id_user_role='
                                                + CONVERT(NVARCHAR(MAX), @id_user_role)
                                      END
                        + CASE WHEN @id_user2user_role IS NULL THEN ''
                               ELSE ' @id_user2user_role='
                                    + CONVERT(NVARCHAR(MAX), @id_user2user_role)
                          END + CASE WHEN @show_no_graphicks IS NULL THEN ''
                                     ELSE ' @show_no_graphicks='
                                          + CONVERT(NVARCHAR(MAX), @show_no_graphicks)
                                END
                        + CASE WHEN @lst_id_service_claim IS NULL THEN ''
                               ELSE ' @lst_id_service_claim='
                                    + CONVERT(NVARCHAR(MAX), @lst_id_service_claim)
                          END + CASE WHEN @id_akt_scan IS NULL THEN ''
                                     ELSE ' @id_akt_scan='
                                          + CONVERT(NVARCHAR(MAX), @id_akt_scan)
                                END + CASE WHEN @id_adder IS NULL THEN ''
                                           ELSE ' @id_adder='
                                                + CONVERT(NVARCHAR(MAX), @id_adder)
                                      END
                        + CASE WHEN @date_cames_add IS NULL THEN ''
                               ELSE ' @date_cames_add='
                                    + CONVERT(NVARCHAR(MAX), @date_cames_add)
                          END + CASE WHEN @file_name IS NULL THEN ''
                                     ELSE ' @file_name='
                                          + CONVERT(NVARCHAR(MAX), @file_name)
                                END + CASE WHEN @full_path IS NULL THEN ''
                                           ELSE ' @full_path='
                                                + CONVERT(NVARCHAR(MAX), @full_path)
                                      END
                        + CASE WHEN @cames_add IS NULL THEN ''
                               ELSE ' @cames_add='
                                    + CONVERT(NVARCHAR(MAX), @cames_add)
                          END + CASE WHEN @date_day IS NULL THEN ''
                                     ELSE ' @date_day='
                                          + CONVERT(NVARCHAR(MAX), @date_day)
                                END + CASE WHEN @already_exec IS NULL THEN ''
                                           ELSE ' @already_exec='
                                                + CONVERT(NVARCHAR(MAX), @already_exec)
                                      END
                        + CASE WHEN @claim_count IS NULL THEN ''
                               ELSE ' @claim_count='
                                    + CONVERT(NVARCHAR(MAX), @claim_count)
                          END + CASE WHEN @norm_order IS NULL THEN ''
                                     ELSE ' @norm_order='
                                          + CONVERT(NVARCHAR(MAX), @norm_order)
                                END
                        + CASE WHEN @add_plan_when_deactive IS NULL THEN ''
                               ELSE ' @add_plan_when_deactive='
                                    + CONVERT(NVARCHAR(MAX), @add_plan_when_deactive)
                          END + CASE WHEN @data_source IS NULL THEN ''
                                     ELSE ' @data_source='
                                          + CONVERT(NVARCHAR(MAX), @data_source)
                                END
                        + CASE WHEN @id_device_data IS NULL THEN ''
                               ELSE ' @@id_device_data='
                                    + CONVERT(NVARCHAR(MAX), @id_device_data)
                          END + CASE WHEN @date_came IS NULL THEN ''
                                     ELSE ' @date_came='
                                          + CONVERT(NVARCHAR(MAX), @date_came)
                                END + CASE WHEN @is_manual IS NULL THEN ''
                                           ELSE ' @is_manual='
                                                + CONVERT(NVARCHAR(MAX), @is_manual)
                                      END
                        + CASE WHEN @is_sys_admin IS NULL THEN ''
                               ELSE ' @is_sys_admin='
                                    + CONVERT(NVARCHAR(MAX), @is_sys_admin)
                          END + CASE WHEN @handling_devices IS NULL THEN ''
                                     ELSE ' @handling_devices='
                                          + CONVERT(NVARCHAR(MAX), @handling_devices)
                                END
                        + CASE WHEN @is_handling_devices_contract IS NULL
                               THEN ''
                               ELSE ' @is_handling_devices_contract='
                                    + CONVERT(NVARCHAR(MAX), @is_handling_devices_contract)
                          END + CASE WHEN @max_volume IS NULL THEN ''
                                     ELSE ' @max_volume='
                                          + CONVERT(NVARCHAR(MAX), @max_volume)
                                END + CASE WHEN @period_begin IS NULL THEN ''
                                           ELSE ' @period_begin='
                                                + CONVERT(NVARCHAR(MAX), @period_begin)
                                      END
                        + CASE WHEN @period_end IS NULL THEN ''
                               ELSE ' @period_end='
                                    + CONVERT(NVARCHAR(MAX), @period_end)
                          END + CASE WHEN @wear_begin IS NULL THEN ''
                                     ELSE ' @wear_begin='
                                          + CONVERT(NVARCHAR(MAX), @wear_begin)
                                END + CASE WHEN @wear_end IS NULL THEN ''
                                           ELSE ' @wear_end='
                                                + CONVERT(NVARCHAR(MAX), @wear_end)
                                      END
                        + CASE WHEN @loading_begin IS NULL THEN ''
                               ELSE ' @loading_begin='
                                    + CONVERT(NVARCHAR(MAX), @loading_begin)
                          END + CASE WHEN @loading_end IS NULL THEN ''
                                     ELSE ' @loading_end='
                                          + CONVERT(NVARCHAR(MAX), @loading_end)
                                END + CASE WHEN @lst_vendor IS NULL THEN ''
                                           ELSE ' @lst_vendor='
                                                + CONVERT(NVARCHAR(MAX), @lst_vendor)
                                      END
                        + CASE WHEN @has_cames IS NULL THEN ''
                               ELSE ' @has_cames='
                                    + CONVERT(NVARCHAR(MAX), @has_cames)
                          END + CASE WHEN @not_null_volume IS NULL THEN ''
                                     ELSE ' @not_null_volume='
                                          + CONVERT(NVARCHAR(MAX), @not_null_volume)
                                END
                          

                EXEC sk_log @action = 'insLog',
                    @proc_name = 'ui_service_planing',
                    @id_program = @id_program, @params = @log_params,
                    @descr = @log_descr
			--/>
            END

	--=================================
	--Contracts
	--=================================	
        IF @action = 'getContractList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

		--Paging options
		--SET @page_index = ISNULL(@page_index, @def_page_index)
		--SET @page_size = ISNULL(@page_size, @def_page_size)
		--SET @row_begin = ( @page_index * @page_size ) + 1
		--SET @row_end = ( @row_begin + @page_size ) - 1
                SELECT  *
                FROM    ( SELECT    ROW_NUMBER() OVER ( ORDER BY id_contract DESC ) AS row_num ,
                                    tt.id_contract ,
                                    tt.id_contract AS id ,
                                    tt.number AS NAME ,
                                    tt.number ,
				--tt.service_type ,
                                    tt.contract_type ,
                                    tt.contract_status ,
                                    tt.manager ,
                                    tt.date_begin ,
                                    tt.date_end ,
                                    tt.price ,
                                    tt.contractor ,
                                    tt.residue ,
                                    tt.sys_name ,
                                    tt.is_active ,
                                    tt.collected_name ,
                                    tt.device_count ,
                                    tt.note ,
                                    tt.mark
                          FROM      ( SELECT    t.id_contract ,
                                                t.number ,
					--t.service_type ,
                                                t.contract_type ,
                                                t.contract_status ,
                                                t.manager ,
                                                t.date_begin ,
                                                t.date_end ,
                                                t.price ,
                                                t.contractor ,
					--остаток дней
                                                DATEDIFF(DAY, GETDATE(),
                                                         t.date_end) AS residue ,
                                                t.sys_name ,
                                                t.is_active ,
                                                t.collected_name ,
                                                ( SELECT    COUNT(1)
                                                  FROM      dbo.srvpl_contract2devices c2d
                                                            INNER JOIN dbo.srvpl_devices d ON c2d.id_device = d.id_device
                                                  WHERE     c2d.enabled = 1
                                                            AND d.enabled = 1
                                                            AND c2d.id_contract = t.id_contract
                                                ) AS device_count ,
                                                t.note ,
                                                t.mark
                                      FROM      ( SELECT    c.id_contract ,
                                                            c.number ,
						--st.name AS service_type ,
                                                            ct.NAME AS contract_type ,
                                                            cs.NAME AS contract_status ,
                                                            u.display_name AS manager ,
						--CONVERT(NVARCHAR, c.date_begin, 104) AS date_begin ,
						--CONVERT(NVARCHAR, c.date_end, 104) AS date_end ,
                                                            c.date_begin ,
                                                            c.date_end ,
                                                            c.price ,
						/*( SELECT TOP 1
                                                              name_inn
                                                              FROM
                                                              dbo.get_contractor(c.id_contractor)
                                                            ) */
                                                            c.contractor_name
                                                            + ' (ИНН '
                                                            + c.contractor_inn
                                                            + ')' AS contractor ,
                                                            dbo.srvpl_fnc('checkContractIsActiveNow',
                                                              NULL,
                                                              c.id_contract,
                                                              NULL, NULL) AS is_active ,
                                                            dbo.srvpl_fnc('getContractCollectedName',
                                                              NULL,
                                                              c.id_contract,
                                                              NULL, NULL) AS collected_name ,
                                                            cs.sys_name ,
                                                            c.note ,
                                                            CASE
                                                              WHEN cs.MARK = 1
                                                              THEN 1
                                                              ELSE 0
                                                            END AS mark
                                                  FROM      dbo.srvpl_contracts c
                                                            INNER JOIN dbo.srvpl_contract_types ct ON c.id_contract_type = ct.id_contract_type
					--INNER JOIN dbo.srvpl_service_types st ON c.id_service_type = st.id_service_type
                                                            INNER JOIN dbo.srvpl_contract_statuses cs ON c.id_contract_status = cs.id_contract_status
                                                            INNER JOIN dbo.users u ON c.id_manager = u.id_user
                                                  WHERE     c.old_id_contract IS NULL
                                                            AND c.enabled = 1
						--<Filters>
						/********************   ID_CONTRACT   **********************/
						--AND ( (@id_contract IS NULL OR @id_contract <= 0)
						--      OR ( @id_contract > 0
						--           AND c.id_contract = @id_contract
						--         )
						--    ) 
						/********************   NUMBER   **********************/
                                                            AND ( @number IS NULL
                                                              OR ( @number IS NOT NULL
                                                              AND c.number LIKE '%'
                                                              + @number + '%'
                                                              )
                                                              )
						/********************   PRICE   **********************/
                                                            AND ( @price IS NULL
                                                              OR ( @price IS NOT NULL
                                                              AND c.price = @price
                                                              )
                                                              )
						/********************   CONTRACT_TYPE   **********************/
                                                            AND ( ( @id_contract_type IS NULL
                                                              OR @id_contract_type <= 0
                                                              )
                                                              OR ( @id_contract_type IS NOT NULL
                                                              AND c.id_contract_type = @id_contract_type
                                                              )
                                                              )
						/********************   SERVICE_TYPE   **********************/
                                                            AND ( ( @id_service_type IS NULL
                                                              OR @id_service_type <= 0
                                                              )
                                                              OR ( @id_service_type IS NOT NULL
                                                              AND c.id_service_type = @id_service_type
                                                              )
                                                              )
						/********************   CONTRACTOR   **********************/
                                                            AND ( ( @id_contractor IS NULL
                                                              OR ( @id_contractor <= 0
                                                              AND @id_contractor != -999
                                                              )
                                                              )
                                                              OR ( @id_contractor IS NOT NULL
                                                              AND c.id_contractor = @id_contractor
                                                              )
                                                              --чтобы не выводить список если в кабинете клинета зашел хакер)
                                                              OR ( @id_contractor = -999
                                                              AND c.id_contractor = @id_contractor
                                                              )
                                                              )
						/********************   CONTRACT_STATUS   **********************/
                                                            AND ( ( @id_contract_status IS NULL
                                                              OR @id_contract_status <= 0
                                                              )
                                                              OR ( @id_contract_status IS NOT NULL
                                                              AND c.id_contract_status = @id_contract_status
                                                              )
                                                              )
						/********************   MANAGER   **********************/
                                                            AND ( ( @id_manager IS NULL
                                                              OR @id_manager <= 0
                                                              )
                                                              OR ( @id_manager IS NOT NULL
                                                              AND c.id_manager = @id_manager
                                                              )
                                                              )
						/********************   DATE_BEGIN   **********************/
                                                            AND ( @date_begin IS NULL
                                                              OR ( @date_begin IS NOT NULL
                                                              AND CONVERT(DATE, c.date_begin) >= CONVERT(DATE, @date_begin)
                                                              )
                                                              )
						/********************   DATE_END   **********************/
                                                            AND ( @date_end IS NULL
                                                              OR ( @date_end IS NOT NULL
                                                              AND CONVERT(DATE, c.date_end) <= CONVERT(DATE, @date_end)
                                                              )
                                                              )
						/********************   DEVICE SERIAL_NUM   **********************/
                                                            AND ( @serial_num IS NULL
                                                              OR ( @serial_num IS NOT NULL
                                                              AND EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_contract2devices c2d
                                                              WHERE
                                                              c2d.enabled = 1
                                                              AND c2d.id_contract = c.id_contract
                                                              AND c2d.id_device IN (
                                                              SELECT
                                                              id_device
                                                              FROM
                                                              dbo.srvpl_devices
                                                              WHERE
                                                              enabled = 1
                                                              AND serial_num LIKE '%'
                                                              + @serial_num
                                                              + '%' ) /*AND CONVERT(DATE, GETDATE()) BETWEEN CONVERT(DATE, c2d.dattim1)
                                                              AND
                                                              CONVERT(DATE, c2d.dattim2)*/
									)
                                                              )
                                                              )
						--</Filters>
                                                ) AS T
                                      WHERE     --<Paging>
                                                1 = 1
					--row_num BETWEEN @row_begin AND @row_end
					--</Paging>
					/********************   DATE_END   **********************/
                                                AND ( @is_active IS NULL
                                                      OR ( @is_active IS NOT NULL
                                                           AND @is_active = is_active
                                                         )
                                                    )
                                    ) AS tt
                          WHERE     /********************   NO_DEVICE_LINKED   **********************/
                                    ( @no_device_linked IS NULL
                                      OR ( @no_device_linked IS NOT NULL
                                           AND ( ( @no_device_linked = 1
                                                   AND tt.device_count = 0
                                                 )
                                                 OR ( @no_device_linked = 0
                                                      AND tt.device_count > 0
                                                    )
                                               )
                                         )
                                    )
                        ) AS TTT
                WHERE   ( ( @rows_count IS NULL
                            OR @rows_count <= 0
                          )
                          OR ( @rows_count > 0
                               AND row_num <= @rows_count
                             )
                        )
                ORDER BY ttt.id_contract DESC
            END
        ELSE
		--=================================
		--Сгруппированый список менеджеров по договору из списка Договоров
		--=================================	
            IF @action = 'getContractsManagerFilterSelectionList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    SELECT  t.id_manager AS id ,
                            u.display_name AS NAME
                    FROM    ( SELECT    c.id_manager
                              FROM      dbo.srvpl_contracts c
                              GROUP BY  c.id_manager
                            ) AS t
                            INNER JOIN dbo.users u ON t.id_manager = u.id_user
                    ORDER BY u.display_name
                END
            ELSE
			--=================================
			--Сгруппированый список контрагентов по договору из списка Договоров
			--=================================	
                IF @action = 'getContractContractorFilterSelectionList'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END

				/*SELECT  t.id_contractor AS id ,
                                ct.name_inn AS name
                        FROM    ( SELECT    c.id_contractor
                                  FROM      dbo.srvpl_contracts c
                                  GROUP BY  c.id_contractor
                                ) AS t
                                INNER JOIN dbo.get_contractor(NULL) ct ON t.id_contractor = ct.id
                        ORDER BY ct.full_name ,
                                ct.inn*/
				/*SELECT  t.id_contractor AS id ,
                                (SELECT TOP 1 cc.contractor_name + '(ИНН ' + cc.contractor_inn + ')' FROM dbo.srvpl_contracts cc WHERE cc.id_contractor = t.id_contractor) AS NAME
                        FROM    ( */
                        SELECT  c.id_contractor AS id ,
                                c.contractor_name + '(ИНН ' + c.contractor_inn
                                + ')' AS NAME
                        FROM    dbo.srvpl_contracts c
                        GROUP BY c.id_contractor ,
                                c.contractor_name ,
                                c.contractor_inn
					/*) AS t 
                                ORDER BY name, */
                    END
                ELSE
                    IF @action = 'getContractSelectionList'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END
						
                            SELECT  *
                            FROM    ( SELECT    c.id_contract AS id ,
                                                c.number + ' '
                                                + c.contractor_name + '(ИНН '
                                                + c.contractor_inn + ')' /*( SELECT  name_inn
                                        FROM    dbo.get_contractor(c.id_contractor)
                                      ) */
						AS NAME
                                      FROM      dbo.srvpl_contracts c
                                      WHERE     c.old_id_contract IS NULL
                                                AND c.enabled = 1
                                                AND ( dbo.srvpl_fnc('checkContractNotEndedNow',
                                                              NULL,
                                                              c.id_contract,
                                                              NULL, NULL) = '1'
                                                      OR c.add_plan_when_deactive = 1
                                                    )
						--Filters						 
                                                AND ( ( @id_contract IS NULL
                                                        OR @id_contract <= 0
                                                      )
                                                      OR ( @id_contract IS NOT NULL
                                                           AND c.id_contract = @id_contract
                                                         )
                                                    )
					--/Filters
                                    ) AS t
                            WHERE   ( ( @name IS NULL
                                        OR LTRIM(RTRIM(@name)) = ''
                                      )
                                      OR ( ( @name IS NOT NULL
                                             AND LTRIM(RTRIM(@name)) != ''
                                           )
                                           AND name LIKE '%' + @name + '%'
                                         )
                                    )
                            ORDER BY NAME
                        END
                    ELSE
                        IF @action = 'getContract'
                            BEGIN
                                SELECT  c.id_contract ,
                                        c.number ,
                                        c.price ,
                                        c.id_service_type ,
                                        c.id_contract_type ,
                                        c.id_contractor ,
                                        c.id_contract_status ,
                                        c.id_manager ,
                                        c.date_begin ,
                                        c.date_end ,
                                        c.id_creator ,
                                        c.id_zip_state ,
                                        c.note ,
                                        c.id_contract_prolong ,
                                        c.id_price_discount ,
                                        period_reduction ,
                                        handling_devices
                                FROM    dbo.srvpl_contracts c
                                WHERE   c.id_contract = @id_contract
                            END
                        ELSE
                            IF @action = 'saveContract'
                                BEGIN
                                    IF @sp_test IS NOT NULL
                                        BEGIN
                                            RETURN
                                        END

                                    SET @var_str = 'insContract'

                                    IF EXISTS ( SELECT  1
                                                FROM    dbo.srvpl_contracts t
                                                WHERE   t.id_contract = @id_contract )
                                        BEGIN
                                            SET @var_str = 'updContract'
                                        END

                                    IF @number IS NULL
                                        OR LTRIM(RTRIM(@number)) = ''
                                        BEGIN
                                            SET @number = CONVERT(NVARCHAR(50), @id_contract)
                                        END

                                    SELECT  @contractor_name = NAME ,
                                            @contractor_inn = inn
                                    FROM    dbo.get_contractor(@id_contractor)
									
                                    BEGIN TRY
                                        BEGIN TRANSACTION t1
									
									--Если изменилось количество минимального оборудования для обслуживания
                                        IF @var_str = 'updContract'
                                            AND EXISTS ( SELECT
                                                              1
                                                         FROM dbo.srvpl_contracts t
                                                         WHERE
                                                              t.id_contract = @id_contract
                                                              AND t.handling_devices <> @handling_devices )
                                            BEGIN
										--Пробегаемся циклом по всем аппаратам на договоре и пересоздаем выезды
                                                DECLARE curs CURSOR LOCAL
                                                FOR
                                                    SELECT  id_contract2devices ,
                                                            id_device
                                                    FROM    dbo.srvpl_contract2devices c2d
                                                    WHERE   c2d.enabled = 1
                                                            AND id_contract = @id_contract
										
                                                OPEN curs
										
                                                FETCH NEXT
											FROM curs
											INTO @id_contract2devices,
                                                    @id_device
										
                                                WHILE @@FETCH_STATUS = 0
                                                    BEGIN
												
                                                        SET @lst_schedule_dates = ( SELECT
                                                              CAST(dt + ',' AS VARCHAR(MAX))
                                                              FROM
                                                              ( SELECT
                                                              CONVERT(VARCHAR(10), planing_date, 104) AS dt
                                                              FROM
                                                              dbo.srvpl_service_claims cl
                                                              WHERE
                                                              cl.enabled = 1
                                                              AND id_contract = @id_contract
                                                              AND id_device = @id_device
                                                              GROUP BY planing_date
                                                              ) AS t
                                                              FOR
                                                              XML
                                                              PATH('')
                                                              )

                                                        SET @lst_schedule_dates = LEFT(@lst_schedule_dates,
                                                              LEN(@lst_schedule_dates)
                                                              - 1)

										
										--Удаляем ранее заведенные плановые выезды для данного контракта и устройства
                                                        EXEC dbo.sk_service_planing @action = N'closeServiceClaimList',
                                                            @id_contract = @id_contract,
                                                            @id_device = @id_device,
                                                            @id_creator = @id_creator

														--Сохраняем плановые выезды на даты
                                                        EXEC dbo.ui_service_planing @action = 'saveServiceClaim',
                                                            @id_contract2devices = @id_contract2devices,
                                                            @id_contract = @id_contract,
                                                            @id_device = @id_device,
                                                            @lst_schedule_dates = @lst_schedule_dates,
                                                            @id_creator = @id_creator
                                                              
                                                        FETCH NEXT
												FROM curs
												INTO @id_contract2devices,
                                                            @id_device
                                                    END
										
                                                CLOSE curs
										
                                                DEALLOCATE curs
                                            END
									
                                        EXEC @id_contract = dbo.sk_service_planing @action = @var_str,
                                            @id_contract = @id_contract,
                                            @number = @number,
                                            @id_service_type = @id_service_type,
                                            @id_contract_type = @id_contract_type,
                                            @id_contractor = @id_contractor,
                                            @id_contract_status = @id_contract_status,
                                            @id_manager = @id_manager,
                                            @date_begin = @date_begin,
                                            @date_end = @date_end,
                                            @price = @price,
                                            @id_creator = @id_creator,
                                            @id_zip_state = @id_zip_state,
                                            @note = @note,
                                            @contractor_name = @contractor_name,
                                            @contractor_inn = @contractor_inn,
                                            @id_contract_prolong = @id_contract_prolong,
                                            @id_price_discount = @id_price_discount,
                                            @handling_devices = @handling_devices

                                    
                                    
                                        COMMIT TRANSACTION t1
                                    END TRY
									
                                    BEGIN CATCH
                                        IF @@TRANCOUNT > 0
                                            ROLLBACK TRANSACTION t1
									
                                        SELECT  @error_text = ERROR_MESSAGE()
                                                + ' Изменения не были сохранены!'
									
                                        RAISERROR (
																	@error_text
																	,16
																	,1
																	)
                                    END CATCH
									
                                    SELECT  @id_contract AS id_contract
                                END
                            ELSE
                                IF @action = 'closeContract'
                                    BEGIN
                                        IF @sp_test IS NOT NULL
                                            BEGIN
                                                RETURN
                                            END

                                        EXEC dbo.sk_service_planing @action = N'closeContract',
                                            @id_contract = @id_contract,
                                            @id_creator = @id_creator
                                    END
                                ELSE
                                    IF @action = 'setPeriodReduction'
                                        BEGIN
                                            IF @sp_test IS NOT NULL
                                                BEGIN
                                                    RETURN
                                                END
											
                                            SELECT  @date_end = DATEADD(day,
                                                              -1, date_end)
                                            FROM    dbo.srvpl_contracts
                                            WHERE   id_contract = @id_contract
											
                                            EXEC @id_contract = dbo.sk_service_planing @action = 'updContract',
                                                @id_contract = @id_contract,
                                                @date_end = @date_end,
                                                @id_creator = @id_creator,
                                                @period_reduction = 1

                                            SELECT  @id_contract AS id_contract
                                        END
                                    ELSE
                                        IF @action = 'setContractsContractor'
                                            BEGIN
                                                IF @sp_test IS NOT NULL
                                                    BEGIN
                                                        RETURN
                                                    END

                                                DECLARE curs CURSOR LOCAL LOCAL
                                                FOR
                                                    SELECT  id_contract ,
                                                            id_contractor
                                                    FROM    dbo.srvpl_contracts c
                                                    WHERE   c.enabled = 1
                                                            AND c.old_id_contract IS NULL

                                                OPEN curs

                                                FETCH NEXT
										FROM curs
										INTO @id_contract, @id_contractor

                                                WHILE @@FETCH_STATUS = 0
                                                    BEGIN
                                                        SELECT
                                                              @contractor_name = NAME ,
                                                              @contractor_inn = inn
                                                        FROM  dbo.get_contractor(@id_contractor)

                                                        EXEC @id_contract = dbo.sk_service_planing @action = 'updContract',
                                                            @id_contract = @id_contract,
                                                            @contractor_name = @contractor_name,
                                                            @contractor_inn = @contractor_inn

                                                        FETCH NEXT
											FROM curs
											INTO @id_contract, @id_contractor
                                                    END

                                                CLOSE curs

                                                DEALLOCATE curs
                                            END
                                        ELSE
                                            IF @action = 'enableContract'
                                                BEGIN
                                                    IF @sp_test IS NOT NULL
                                                        BEGIN
                                                            RETURN
                                                        END
								
                                                    SELECT  @id_contract_status = id_contract_status
                                                    FROM    dbo.srvpl_contract_statuses st
                                                    WHERE   st.enabled = 1
                                                            AND UPPER(st.sys_name) = 'ACTIVE'
													
													--Если договор НЕ расторгнут то восстанавливаем
                                                    IF NOT EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_contracts c
                                                              INNER JOIN dbo.srvpl_contract_statuses st ON st.id_contract_status = c.id_contract_status
                                                              WHERE
                                                              st.enabled = 1
                                                              AND c.id_contract = @id_contract
                                                              AND st.sys_name IN (
                                                              'DEACTIVE' ) )
                                                        BEGIN
                                                            EXEC dbo.sk_service_planing @action = N'updContract',
                                                              @id_contract_status = @id_contract_status,
                                                              @id_contract = @id_contract,
                                                              @id_creator = @id_creator
                                                        END
                                                    ELSE
                                                        BEGIN
                                                        
                                                            SET @error_text = 'Договор расторгнут. Нет возможности возобновить договор!'  
                                                            RAISERROR (
								@error_text
								,16
								,1
								)
                                                        END
                                                END                                            
                                            ELSE
                                                IF @action = 'pauseContract'
                                                    BEGIN
                                                        IF @sp_test IS NOT NULL
                                                            BEGIN
                                                              RETURN
                                                            END
								
                                                        SELECT
                                                              @id_contract_status = id_contract_status
                                                        FROM  dbo.srvpl_contract_statuses st
                                                        WHERE st.enabled = 1
                                                              AND UPPER(st.sys_name) = 'PAUSED'
								
                                                        EXEC dbo.sk_service_planing @action = N'updContract',
                                                            @id_contract_status = @id_contract_status,
                                                            @id_contract = @id_contract,
                                                            @id_creator = @id_creator
                                                    END
                                                ELSE
                                                    IF @action = 'deactivateContract'
                                                        BEGIN
                                                            IF @sp_test IS NOT NULL
                                                              BEGIN
                                                              RETURN
                                                              END
								
                                                            SELECT
                                                              @id_contract_status = id_contract_status
                                                            FROM
                                                              dbo.srvpl_contract_statuses st
                                                            WHERE
                                                              st.enabled = 1
                                                              AND UPPER(st.sys_name) = 'DEACTIVE'
								
                                                            EXEC dbo.sk_service_planing @action = N'updContract',
                                                              @id_contract_status = @id_contract_status,
                                                              @id_contract = @id_contract,
                                                              @id_creator = @id_creator
                                                              
                                                            --Скрываем созданные на будующие даты выезды и текущий месяц если не закрыт актами
                                                            UPDATE
                                                              cl
                                                            SET
                                                              enabled = 0
                                                            FROM
                                                              dbo.srvpl_service_claims cl
                                                            WHERE
                                                              cl.ENABLED = 1
                                                              AND cl.id_contract = @id_contract
                                                              --ткущий месяц и будущие
                                                              AND ( ( ( YEAR(cl.planing_date) = YEAR(GETDATE())
                                                              AND MONTH(cl.planing_date) = MONTH(GETDATE())
                                                              )
                                                              OR cl.planing_date >= GETDATE()
                                                              )
                                                            --и нет закрытого акта обслуживания
                                                              AND NOT EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames cam
                                                              WHERE
                                                              cam.enabled = 1
                                                              AND cam.id_service_claim = cl.id_service_claim )
                                                              )
                                                        END

        IF @action = 'getSerialNumList'
            BEGIN
                SELECT  d.serial_num AS id,d.serial_num AS name
                FROM    dbo.srvpl_contract2devices c2d
                        INNER JOIN dbo.srvpl_devices d ON c2d.id_device = d.id_device
                        INNER JOIN dbo.srvpl_contracts c ON c.id_contract = c2d.id_contract
                WHERE   c2d.enabled = 1
                        AND d.enabled = 1
                        AND c.enabled = 1
                        AND c.handling_devices IS NOT NULL
                        AND d.serial_num LIKE '%' + @filter_text + '%'

            END

	--=================================
	--Devices
	--=================================	
        IF @action = 'getDeviceList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

------SELECT  *
------                    FROM    ( SELECT    * ,
------                                        CASE WHEN age_count > 5 THEN 5
------                                             ELSE age_count
------                                        END AS age ,
------                                        CASE WHEN DATEDIFF(DAY,
------                                                           device_date_create,
------                                                           GETDATE()) = 0
------                                             THEN 0
------                                             ELSE 1
------                                        END AS is_new
------                              FROM      ( SELECT    ROW_NUMBER() OVER ( ORDER BY id_device DESC ) AS row_num ,
------                                                    [id_device] ,
------                                                    dbo.srvpl_fnc('getDeviceModelShortCollectedName',
------                                                              NULL,
------                                                              d.id_device_model,
------                                                              NULL, NULL) AS model ,
------                                                    [serial_num] ,
------                                                    [speed] ,
------				/*di.name AS device_imprint ,
------                        pt.name AS print_type ,
------                        ct.name AS cartridge_type ,*/
------                                                    [counter] ,
------                                                    CASE WHEN instalation_date IS NOT NULL
------                                                         THEN ABS(DATEDIFF(month,
------                                                              instalation_date,
------                                                              GETDATE())) / 12
------                                                         ELSE age
------                                                    END AS age_count ,
------                                                    [instalation_date] ,
------                                                    dbo.srvpl_fnc('checkDeviceIsLinkedNow',
------                                                              NULL,
------                                                              d.id_device,
------                                                              NULL, NULL) AS linked_now ,
------                                                    ( SELECT TOP 1
------                                                              number
------                                                      FROM    dbo.srvpl_contract2devices c2d
------                                                              INNER JOIN srvpl_contracts c ON c2d.id_contract = c.id_contract
------                                                      WHERE   c2d.enabled = 1
------                                                              AND c2d.id_device = d.id_device
------                                                              AND dbo.srvpl_fnc('checkContractIsActiveNow',
------                                                              NULL,
------                                                              c2d.id_contract,
------                                                              NULL, NULL) = '1'
------                                                      ORDER BY c2d.id_contract2devices DESC
------                                                    ) AS contract_num ,
------                                                    ( SELECT TOP 1
------                                                              c2d.id_contract
------                                                      FROM    dbo.srvpl_contract2devices c2d
------                                                              INNER JOIN srvpl_contracts c ON c2d.id_contract = c.id_contract
------                                                      WHERE   c2d.enabled = 1
------                                                              AND c2d.id_device = d.id_device
------                                                              AND dbo.srvpl_fnc('checkContractIsActiveNow',
------                                                              NULL,
------                                                              c2d.id_contract,
------                                                              NULL, NULL) = '1'
------                                                      ORDER BY c2d.id_contract2devices DESC
------                                                    ) AS id_contract ,
------                                                    d.dattim1 AS device_date_create ,
------                                                    dbo.srvpl_fnc('getDeviceShortCollectedNameNoBr',
------                                                              NULL,
------                                                              d.id_device,
------                                                              NULL, NULL) AS NAME
------                                          FROM      dbo.srvpl_devices d
------                                                    INNER JOIN srvpl_device_models dm ON d.id_device_model = dm.id_device_model
------			--INNER JOIN dbo.srvpl_device_imprints di ON d.id_device_imprint = di.id_device_imprint
------			--INNER JOIN dbo.srvpl_print_types pt ON d.id_print_type = pt.id_print_type
------			--INNER JOIN dbo.srvpl_cartridge_types ct ON d.id_cartridge_type = ct.id_cartridge_type
------                                          WHERE     d.old_id_device IS NULL
------                                                    AND d.enabled = 1
------				--Filters
------				/*********************  на договоре  ********************/
------                                                    AND ( @is_linked IS NULL
------                                                          OR ( @is_linked IS NOT NULL
------                                                              AND ( ( @is_linked = 1
------                                                              AND dbo.srvpl_fnc('checkDeviceIsLinkedNow',
------                                                              NULL,
------                                                              d.id_device,
------                                                              NULL, NULL) = '1'
------                                                              )
------                                                              OR ( @is_linked = 0
------                                                              AND dbo.srvpl_fnc('checkDeviceIsLinkedNow',
------                                                              NULL,
------                                                              d.id_device,
------                                                              NULL, NULL) = '0'
------                                                              )
------                                                              )
------                                                             )
------                                                        )
------				/*********************  DEVICE_MODEL  ********************/
------                                                    AND ( @id_device_model IS NULL
------                                                          OR ( @id_device_model IS NOT NULL
------                                                              AND d.id_device_model = @id_device_model
------                                                             )
------                                                        )
------				--AND ( @model IS NULL
------				--      OR ( @model IS NOT NULL
------				--           AND d.model LIKE '%' + @model + '%'
------				--         )
------				--    )
------				/*********************  SERIAL_NUM  ********************/
------                                                    AND ( @serial_num IS NULL
------                                                          OR ( @serial_num IS NOT NULL
------                                                              AND d.serial_num LIKE '%'
------                                                              + @serial_num
------                                                              + '%'
------                                                             )
------                                                        )
------				/*********************  SPEED  ********************/
------				/*AND ( ( @speed IS NULL
------                                OR @speed <= 0
------                              )
------                              OR ( @speed IS NOT NULL
------                                   AND d.speed = @speed
------                                 )
------                            ) */
------				/*********************  DEVICE_IMPRINT  ********************/
------				/* AND ( ( @id_device_imprint IS NULL
------                                OR @id_device_imprint <= 0
------                              )
------                              OR ( @id_device_imprint IS NOT NULL
------                                   AND d.id_device_imprint = @id_device_imprint
------                                 )
------                            )     */
------				/*********************  PRINT_TYPE  ********************/
------				/*AND ( ( @id_print_type IS NULL
------                                OR @id_print_type <= 0
------                              )
------                              OR ( @id_print_type IS NOT NULL
------                                   AND d.id_print_type = @id_print_type
------                                 )
------                            )*/
------				/*********************  CARTRIDGE_TYPE  ********************/
------				/*AND ( ( @id_cartridge_type IS NULL
------                                OR @id_cartridge_type <= 0
------                              )
------                              OR ( @id_cartridge_type IS NOT NULL
------                                   AND d.id_cartridge_type = @id_cartridge_type
------                                 )
------                            ) */
------				/*********************  COUNTER  ********************/
------                                                    AND ( ( @counter IS NULL
------                                                            OR @counter < 0
------                                                          )
------                                                          OR ( @counter IS NOT NULL
------                                                              AND d.counter = @counter
------                                                             )
------                                                        )
------				/*********************  AGE  ********************/
------                                                    AND ( ( @age IS NULL
------                                                            OR @age < 0
------                                                          )
------                                                          OR ( @age IS NOT NULL
------                                                              AND d.age = @age
------                                                             )
------                                                        )
------				/*********************  INSTALATION_DATE  ********************/
------                                                    AND ( @instalation_date IS NULL
------                                                          OR ( @instalation_date IS NOT NULL
------                                                              AND d.instalation_date = @instalation_date
------                                                             )
------                                                        )
------				--</Filters>
------                                        ) AS T
------                              WHERE     ( ( @rows_count IS NULL
------                                            OR @rows_count <= 0
------                                          )
------                                          OR ( @rows_count > 0
------                                               AND row_num <= @rows_count
------                                             )
------                                        )
------                            ) AS T
------                    ORDER BY is_new ,
------                            name


                SELECT  * ,
                        CASE WHEN age_count > 5 THEN 5
                             ELSE age_count
                        END AS age
                FROM    ( SELECT    ROW_NUMBER() OVER ( ORDER BY id_device DESC ) AS row_num ,
                                    [id_device] ,
                                    dbo.srvpl_fnc('getDeviceModelShortCollectedName',
                                                  NULL, d.id_device_model,
                                                  NULL, NULL) AS model ,
                                    [serial_num] ,
                                    [speed] ,
				/*di.name AS device_imprint ,
                        pt.name AS print_type ,
                        ct.name AS cartridge_type ,*/
                                    [counter] ,
                                    CASE WHEN instalation_date IS NOT NULL
                                         THEN ABS(DATEDIFF(month,
                                                           instalation_date,
                                                           GETDATE())) / 12
                                         ELSE age
                                    END AS age_count ,
                                    [instalation_date] ,
                                    dbo.srvpl_fnc('checkDeviceIsLinkedNow',
                                                  NULL, d.id_device, NULL,
                                                  NULL) AS linked_now ,
                                    ( SELECT TOP 1
                                                number
                                      FROM      dbo.srvpl_contract2devices c2d
                                                INNER JOIN srvpl_contracts c ON c2d.id_contract = c.id_contract
                                      WHERE     c2d.enabled = 1
                                                AND c2d.id_device = d.id_device
                                                AND dbo.srvpl_fnc('checkContractIsActiveNow',
                                                              NULL,
                                                              c2d.id_contract,
                                                              NULL, NULL) = '1'
                                      ORDER BY  c2d.id_contract2devices DESC
                                    ) AS contract_num ,
                                    ( SELECT TOP 1
                                                c2d.id_contract
                                      FROM      dbo.srvpl_contract2devices c2d
                                                INNER JOIN srvpl_contracts c ON c2d.id_contract = c.id_contract
                                      WHERE     c2d.enabled = 1
                                                AND c2d.id_device = d.id_device
                                                AND dbo.srvpl_fnc('checkContractIsActiveNow',
                                                              NULL,
                                                              c2d.id_contract,
                                                              NULL, NULL) = '1'
                                      ORDER BY  c2d.id_contract2devices DESC
                                    ) AS id_contract
                          FROM      dbo.srvpl_devices d
                                    INNER JOIN srvpl_device_models dm ON d.id_device_model = dm.id_device_model
			--INNER JOIN dbo.srvpl_device_imprints di ON d.id_device_imprint = di.id_device_imprint
			--INNER JOIN dbo.srvpl_print_types pt ON d.id_print_type = pt.id_print_type
			--INNER JOIN dbo.srvpl_cartridge_types ct ON d.id_cartridge_type = ct.id_cartridge_type
                          WHERE     d.old_id_device IS NULL
                                    AND d.enabled = 1
				--Filters
				/*********************  на договоре  ********************/
                                    AND ( @is_linked IS NULL
                                          OR ( @is_linked IS NOT NULL
                                               AND ( ( @is_linked = 1
                                                       AND dbo.srvpl_fnc('checkDeviceIsLinkedNow',
                                                              NULL,
                                                              d.id_device,
                                                              NULL, NULL) = '1'
                                                     )
                                                     OR ( @is_linked = 0
                                                          AND dbo.srvpl_fnc('checkDeviceIsLinkedNow',
                                                              NULL,
                                                              d.id_device,
                                                              NULL, NULL) = '0'
                                                        )
                                                   )
                                             )
                                        )
				/*********************  DEVICE_MODEL  ********************/
                                    AND ( @id_device_model IS NULL
                                          OR ( @id_device_model IS NOT NULL
                                               AND d.id_device_model = @id_device_model
                                             )
                                        )
				--AND ( @model IS NULL
				--      OR ( @model IS NOT NULL
				--           AND d.model LIKE '%' + @model + '%'
				--         )
				--    )
				/*********************  SERIAL_NUM  ********************/
                                    AND ( @serial_num IS NULL
                                          OR ( @serial_num IS NOT NULL
                                               AND d.serial_num LIKE '%'
                                               + @serial_num + '%'
                                             )
                                        )
				/*********************  SPEED  ********************/
				/*AND ( ( @speed IS NULL
                                OR @speed <= 0
                              )
                              OR ( @speed IS NOT NULL
                                   AND d.speed = @speed
                                 )
                            ) */
				/*********************  DEVICE_IMPRINT  ********************/
				/* AND ( ( @id_device_imprint IS NULL
                                OR @id_device_imprint <= 0
                              )
                              OR ( @id_device_imprint IS NOT NULL
                                   AND d.id_device_imprint = @id_device_imprint
                                 )
                            )     */
				/*********************  PRINT_TYPE  ********************/
				/*AND ( ( @id_print_type IS NULL
                                OR @id_print_type <= 0
                              )
                              OR ( @id_print_type IS NOT NULL
                                   AND d.id_print_type = @id_print_type
                                 )
                            )*/
				/*********************  CARTRIDGE_TYPE  ********************/
				/*AND ( ( @id_cartridge_type IS NULL
                                OR @id_cartridge_type <= 0
                              )
                              OR ( @id_cartridge_type IS NOT NULL
                                   AND d.id_cartridge_type = @id_cartridge_type
                                 )
                            ) */
				/*********************  COUNTER  ********************/
                                    AND ( ( @counter IS NULL
                                            OR @counter < 0
                                          )
                                          OR ( @counter IS NOT NULL
                                               AND d.counter = @counter
                                             )
                                        )
				/*********************  AGE  ********************/
                                    AND ( ( @age IS NULL
                                            OR @age < 0
                                          )
                                          OR ( @age IS NOT NULL
                                               AND d.age = @age
                                             )
                                        )
				/*********************  INSTALATION_DATE  ********************/
                                    AND ( @instalation_date IS NULL
                                          OR ( @instalation_date IS NOT NULL
                                               AND d.instalation_date = @instalation_date
                                             )
                                        )
				--</Filters>
                        ) AS T
                WHERE   ( ( @rows_count IS NULL
                            OR @rows_count <= 0
                          )
                          OR ( @rows_count > 0
                               AND row_num <= @rows_count
                             )
                        )
                ORDER BY id_device DESC
            END
        ELSE
            IF @action = 'getDeviceSelectionList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    
                    SELECT  id ,
                            name ,
                            is_new
                    FROM    ( SELECT    d.id_device AS id ,
                                        dbo.srvpl_fnc('getDeviceShortCollectedNameNoBr',
                                                      NULL, d.id_device, NULL,
                                                      NULL) AS NAME ,
                                        CASE WHEN CONVERT(DATE, d.dattim1) = CONVERT(DATE, GETDATE())
                                             THEN 0
                                             ELSE 1
                                        END AS is_new ,
                                        d.dattim1
                              FROM      dbo.srvpl_devices d
                                        INNER JOIN srvpl_device_models dm ON d.id_device_model = dm.id_device_model
                              WHERE     d.old_id_device IS NULL
                                        AND d.enabled = 1
				--Filters	
				--выбранное оборудование
                                        AND ( @lst_id_device IS NULL
                                              OR ( @lst_id_device IS NOT NULL
                                                   AND id_device IN (
                                                   SELECT   value
                                                   FROM     dbo.Split(@lst_id_device,
                                                              ',') )
                                                 )
                                            )
				--Без уже добавленых//////--отсекаем уже добавленные на данный период при сохранении привязки, так как нужно дать возможность добавлять на разные договоры в разные периоды действия
				/*AND ( ( @id_contract IS NULL
                                    OR @id_contract <= 0
                                  )
                                  OR ( @id_contract > 0
                                       AND NOT EXISTS ( SELECT
                                                              1
                                                        FROM  dbo.srvpl_contract2devices c2d
                                                        WHERE c2d.enabled = 1
                                                              AND --c2d.id_contract = @id_contract AND 
                                                              c2d.id_device = d.id_device )
                                     )
                                )*/
				--Модель
                                        AND ( @model IS NULL
                                              OR ( @model IS NOT NULL
                                                   AND dm.NAME LIKE '%'
                                                   + @model + '%'
                                                 )
                                            )
                            ) AS t
                    ORDER BY is_new ,
                            CASE is_new
                              WHEN 0 THEN dattim1
                            END DESC ,
                            CASE is_new
                              WHEN 1 THEN name
                            END
                END
            ELSE
                IF @action = 'getDevice'
                    BEGIN
                        SELECT  [id_device] ,
                                d.[id_device_model] ,
                                [serial_num] ,
                                [inv_num] ,
                                [speed] ,
					--[id_device_imprint] ,
					--[id_print_type] ,
					--[id_cartridge_type] ,
                                [counter] ,
                                [counter_colour] ,
                                [age] ,
                                [instalation_date] ,
                                d.[id_creator] ,
                                dbo.srvpl_fnc('getDeviceModelShortCollectedName',
                                              NULL, d.id_device_model, NULL,
                                              NULL) AS model
                        FROM    dbo.srvpl_devices d
                                INNER JOIN srvpl_device_models dm ON d.id_device_model = dm.id_device_model
                        WHERE   id_device = @id_device
                    END
                ELSE
                    IF @action = 'saveDevice'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END

                            SET @var_str = 'insDevice'

                            IF EXISTS ( SELECT  1
                                        FROM    dbo.srvpl_devices t
                                        WHERE   t.id_device = @id_device )
                                BEGIN
                                    SET @var_str = 'updDevice'
                                END

					--Проверяем не существует ли такой серийный номер в системе, так как они уникальны
                            IF @var_str = 'insDevice'
                                AND EXISTS ( SELECT 1
                                             FROM   dbo.srvpl_devices d
                                             WHERE  d.enabled = 1
                                                    AND @serial_num IS NOT NULL
                                                    AND d.serial_num = @serial_num )
                                BEGIN
                                    SELECT TOP 1
                                            @error_text = 'Серийный номер '
                                            + d.serial_num
                                            + ' уже существует в системе. Аппарат - '
                                            + dbo.srvpl_fnc('getDeviceCollectedName',
                                                            NULL, d.id_device,
                                                            NULL, NULL)
                                    FROM    dbo.srvpl_devices d
                                    WHERE   d.enabled = 1
                                            AND @serial_num IS NOT NULL
                                            AND d.serial_num = @serial_num

                                    RAISERROR (
								@error_text
								,16
								,1
								)

                                    RETURN;
                                END

                            IF @instalation_date IS NOT NULL
						--AND @age IS NULL
                                BEGIN
                                    SELECT  @age = ABS(DATEDIFF(month,
                                                              @instalation_date,
                                                              GETDATE())) / 12

                                    SELECT  @age = CASE WHEN @age > 5 THEN 5
                                                        ELSE @age
                                                   END
                                END

					--<Сохраняем факт нулевого серийника чтобы подставить потом фиктивный для отличения от других
                            IF @serial_num IS NULL
                                BEGIN
                                    SET @id_is_null = 1
                                    SET @serial_num = CONVERT(NVARCHAR(15), @id_device)
                                END
                            ELSE
                                BEGIN
                                    SET @id_is_null = 0
                                END
					--</Сохраняем факт нулевого серийника					
                            EXEC @id_device = dbo.sk_service_planing @action = @var_str,
                                @id_device = @id_device,
                                @id_device_model = @id_device_model,
                                @serial_num = @serial_num, @inv_num = @inv_num,
                                @counter = @counter,
                                @counter_colour = @counter_colour, @age = @age,
                                @instalation_date = @instalation_date,
                                @id_creator = @id_creator
					
					--Устанавливаем тариф для аппарата
					--IF @var_str = 'insDevice'
					--    BEGIN
                            EXEC dbo.ui_service_planing @action = 'setDeviceTariff',
                                @id_device = @id_device,
                                @id_creator = @id_creator

					-- END
					--SELECT  @id_device AS id_device
					--Если ID неизвестен то добавляем ID и надпись неизвестно чтобы отличать от других таких же
                            IF @id_is_null = 1
                                OR LTRIM(RTRIM(@serial_num)) = ''
                                BEGIN
                                    SELECT  @serial_num = 'неизвестно ID '
                                            + CONVERT(NVARCHAR(10), @id_device)

                                    EXEC @id_device = dbo.sk_service_planing @action = 'updDevice',
                                        @id_device = @id_device,
                                        @serial_num = @serial_num
                                END

                            SELECT  @id_device AS id_device
                        END
                   
                    ELSE
                        IF @action = 'setDevicesAge'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END

                                DECLARE curs CURSOR LOCAL
                                FOR
                                    SELECT  id_device ,
                                            instalation_date
                                    FROM    dbo.srvpl_devices d
                                    WHERE   d.enabled = 1

                                OPEN curs

                                FETCH NEXT
						FROM curs
						INTO @id_device, @instalation_date

                                WHILE @@FETCH_STATUS = 0
                                    BEGIN
                                        SELECT  @age = ABS(DATEDIFF(month,
                                                              @instalation_date,
                                                              GETDATE())) / 12

                                        SELECT  @age = CASE WHEN @age > 5
                                                            THEN 5
                                                            ELSE @age
                                                       END

                                        EXEC dbo.sk_service_planing @action = 'updDevice',
                                            @id_device = @id_device,
                                            @age = @age,
                                            @instalation_date = @instalation_date,
                                            @id_creator = -1

                                        FETCH NEXT
							FROM curs
							INTO @id_device, @instalation_date
                                    END

                                CLOSE curs

                                DEALLOCATE curs
                            END
                        ELSE
                            IF @action = 'closeDevice'
                                BEGIN
                                    IF @sp_test IS NOT NULL
                                        BEGIN
                                            RETURN
                                        END

							--//TODO: Необходимо проверять не привязано ли устройство к договору иначе RAISERROR    
                                    EXEC dbo.sk_service_planing @action = N'closeDevice',
                                        @id_device = @id_device,
                                        @id_creator = @id_creator
                                END
                            ELSE
                                IF @action = 'getDeviceCounterList'
                                    BEGIN
                                        SELECT  YEAR(dd.date_month) AS year ,
                                                MONTH(dd.date_month) AS [month] ,
                                                dd.id_device ,
                                                dd.id_contract ,
                                                dd.counter ,
                                                dd.counter_colour ,
                                                ISNULL(dd.counter, 0)
                                                + ISNULL(dd.counter_colour, 0) AS total_counter ,
                                                volume_counter ,
                                                volume_counter_colour ,
                                                ISNULL(dd.volume_counter, 0)
                                                + ISNULL(dd.volume_counter_colour,
                                                         0) AS volume_total_counter
                                        FROM    srvpl_device_data dd
                                                INNER JOIN dbo.srvpl_devices d ON dd.id_device = d.id_device
                                                INNER JOIN dbo.srvpl_contracts c ON dd.id_contract = c.id_contract
                                        WHERE   dd.enabled = 1
                                                AND c.enabled = 1
                                                AND d.enabled = 1
                                                AND EXISTS ( SELECT
                                                              1
                                                             FROM
                                                              dbo.srvpl_contract2devices c2d
                                                             WHERE
                                                              c2d.enabled = 1
                                                              AND c2d.id_device = dd.id_device
                                                              AND c2d.id_contract = dd.id_contract )
                                                AND c.id_contractor = @id_contractor
                                                    --Только активные
                                                AND dbo.srvpl_fnc('checkContractIsActiveNow',
                                                              NULL,
                                                              c.id_contract,
                                                              NULL, NULL) = '1'
                                                AND dd.date_month BETWEEN @date_begin AND @date_end
                                    END
                                ELSE
                                    IF @action = 'getDeviceCounterByDate'
                                        BEGIN
                                            IF @sp_test IS NOT NULL
                                                BEGIN
                                                    RETURN
                                                END
									
                                            SELECT  tt.[counter] ,
                                                    tt.counter_colour ,
                                                    tt.last_counter ,
                                                    volume
                                            FROM    ( SELECT  t.[counter] ,
                                                              t.counter_colour ,
                                                              t.last_counter ,
                                                              CASE
                                                              WHEN t.last_counter IS NULL
                                                              THEN NULL
                                                              ELSE ( t.[counter]
                                                              - t.last_counter )
                                                              END AS volume
                                                      FROM    ( SELECT
                                                              cam.id_service_came ,
                                                              cam.[counter] ,
                                                              cam.counter_colour ,
                                                              ( SELECT
                                                              MAX(counter)
                                                              FROM
                                                              ( SELECT
                                                              MAX(cam2.[counter]) AS [counter]
                                                              FROM
                                                              dbo.srvpl_service_cames cam2
                                                              INNER JOIN dbo.srvpl_service_claims sc2 ON cam2.id_service_claim = sc2.id_service_claim
                                                              INNER JOIN dbo.srvpl_contract2devices c2d2 ON sc2.id_contract2devices = c2d2.id_contract2devices
                                                              INNER JOIN dbo.srvpl_contracts c2 ON c2d2.id_contract = c2.id_contract
                                                              INNER JOIN dbo.srvpl_devices d2 ON c2d2.id_device = d2.id_device
                                                              WHERE
                                                              cam2.enabled = 1
                                                              AND sc2.enabled = 1
                                                              AND c2d2.enabled = 1
                                                              AND c2.enabled = 1
                                                              AND d2.enabled = 1
                                                              AND sc2.id_contract = @id_contract
                                                              AND sc2.id_device = @id_device
                                                              AND cam2.id_service_came < cam.id_service_came
                                                              AND YEAR(sc2.planing_date) <= YEAR(DATEADD(month,
                                                              -1,
                                                              sc.planing_date))
                                                              AND MONTH(sc2.planing_date) < MONTH(DATEADD(month,
                                                              -1,
                                                              sc.planing_date))
                                                              UNION ALL
                                                              SELECT
                                                              MAX(counter) AS [COUNTER]
                                                              FROM
                                                              dbo.snmp_requests r
                                                              WHERE
                                                              id_device = @id_device
                                                              AND r.counter IS NOT NULL
                                                              AND YEAR(r.date_request) <= YEAR(DATEADD(month,
                                                              -1,
                                                              sc.planing_date))
                                                              AND MONTH(r.date_request) < MONTH(DATEADD(month,
                                                              -1,
                                                              sc.planing_date))
                                                              ) AS t
                                                              ) AS last_counter
                                                              FROM
                                                              dbo.srvpl_service_cames cam
                                                              INNER JOIN dbo.srvpl_service_claims sc ON cam.id_service_claim = sc.id_service_claim
                                                              INNER JOIN dbo.srvpl_contract2devices c2d ON sc.id_contract2devices = c2d.id_contract2devices
                                                              INNER JOIN dbo.srvpl_contracts c ON c2d.id_contract = c.id_contract
                                                              INNER JOIN dbo.srvpl_devices d ON c2d.id_device = d.id_device
                                                              WHERE
                                                              cam.enabled = 1
                                                              AND sc.enabled = 1
                                                              AND c2d.enabled = 1
                                                              AND c.enabled = 1
                                                              AND d.enabled = 1
                                                              AND dbo.srvpl_fnc('checkContractIsActiveNow',
                                                              NULL,
                                                              c2d.id_contract,
                                                              NULL, NULL) = '1'
                                                              AND ( @id_contractor IS NULL
                                                              OR ( @id_contractor IS NOT NULL
                                                              AND c.id_contractor = @id_contractor
                                                              )
                                                              )
                                                              AND ( @id_contract IS NULL
                                                              OR ( @id_contract IS NOT NULL
                                                              AND sc.id_contract = @id_contract
                                                              )
                                                              )
                                                              AND ( @id_device IS NULL
                                                              OR ( @id_device IS NOT NULL
                                                              AND sc.id_device = @id_device
                                                              )
                                                              )
                                                              AND YEAR(sc.planing_date) = YEAR(@planing_date)
                                                              AND MONTH(sc.planing_date) = MONTH(@planing_date)
                                                              ) AS T
                                                    ) AS tt
                                        END
                                    ELSE
                                        IF @action = 'getVolumeSumByDate'
                                            BEGIN
                                                IF @sp_test IS NOT NULL
                                                    BEGIN
                                                        RETURN
                                                    END
                                                DECLARE @volume INT
                                                SET @volume = 0

                                                DECLARE curs CURSOR
                                                FOR
                                                    SELECT  c2d.id_device ,
                                                            c2d.id_contract
                                                    FROM    dbo.srvpl_contract2devices c2d
                                                            INNER JOIN dbo.srvpl_contracts c ON c2d.id_contract = c.id_contract
                                                            INNER JOIN dbo.srvpl_devices d ON c2d.id_device = d.id_device
                                                    WHERE   c2d.enabled = 1
                                                            AND d.enabled = 1
                                                            AND c.enabled = 1
                                                            AND ( ( @id_contract IS NULL
                                                              OR @id_contract <= 0
                                                              )
                                                              OR ( @id_contract IS NOT NULL
                                                              AND c.id_contract = @id_contract
                                                              )
                                                              )
                                                            AND ( ( @id_contractor IS NULL
                                                              OR @id_contractor <= 0
                                                              )
                                                              OR ( @id_contractor IS NOT NULL
                                                              AND c.id_contractor = @id_contractor
                                                              )
                                                              )
                                                OPEN curs

                                                FETCH NEXT
													FROM curs
													INTO @id_device,
                                                    @id_contract

                                                WHILE @@FETCH_STATUS = 0
                                                    BEGIN
                                                        SELECT
                                                              @volume = @volume
                                                              + ISNULL(volume,
                                                              0)
                                                        FROM  ( SELECT
                                                              t.[counter] ,
                                                              t.counter_colour ,
                                                              t.last_counter ,
                                                              CASE
                                                              WHEN t.last_counter IS NULL
                                                              THEN NULL
                                                              ELSE ( t.[counter]
                                                              - t.last_counter )
                                                              END AS volume
                                                              FROM
                                                              ( SELECT
                                                              cam.id_service_came ,
                                                              cam.[counter] ,
                                                              cam.counter_colour ,
                                                              ( SELECT
                                                              MAX(cam2.[counter])
                                                              FROM
                                                              dbo.srvpl_service_cames cam2
                                                              INNER JOIN dbo.srvpl_service_claims sc2 ON cam2.id_service_claim = sc2.id_service_claim
                                                              INNER JOIN dbo.srvpl_contract2devices c2d2 ON sc2.id_contract2devices = c2d2.id_contract2devices
                                                              INNER JOIN dbo.srvpl_contracts c2 ON c2d2.id_contract = c2.id_contract
                                                              INNER JOIN dbo.srvpl_devices d2 ON c2d2.id_device = d2.id_device
                                                              WHERE
                                                              cam2.enabled = 1
                                                              AND sc2.enabled = 1
                                                              AND c2d2.enabled = 1
                                                              AND c2.enabled = 1
                                                              AND d2.enabled = 1
                                                              AND sc2.id_contract = @id_contract
                                                              AND sc2.id_device = @id_device
                                                              AND cam2.id_service_came < cam.id_service_came
                                                              AND YEAR(sc2.planing_date) <= YEAR(sc.planing_date)
                                                              AND MONTH(sc2.planing_date) < MONTH(sc.planing_date)
                                                              GROUP BY sc2.id_device
                                                              ) AS last_counter
                                                              FROM
                                                              dbo.srvpl_service_cames cam
                                                              INNER JOIN dbo.srvpl_service_claims sc ON cam.id_service_claim = sc.id_service_claim
                                                              INNER JOIN dbo.srvpl_contract2devices c2d ON sc.id_contract2devices = c2d.id_contract2devices
                                                              INNER JOIN dbo.srvpl_contracts c ON c2d.id_contract = c.id_contract
                                                              INNER JOIN dbo.srvpl_devices d ON c2d.id_device = d.id_device
                                                              WHERE
                                                              cam.enabled = 1
                                                              AND sc.enabled = 1
                                                              AND c2d.enabled = 1
                                                              AND c.enabled = 1
                                                              AND d.enabled = 1
                                                              AND sc.id_contract = @id_contract
                                                              AND sc.id_device = @id_device
                                                              AND YEAR(sc.planing_date) = YEAR(@planing_date)
                                                              AND MONTH(sc.planing_date) = MONTH(@planing_date)
                                                              ) AS T
                                                              ) AS tt
                                                
                                                        FETCH NEXT
													FROM curs
													INTO @id_device,
                                                            @id_contract
													
                                                    END
                                                
                                                CLOSE curs

                                                DEALLOCATE curs
                                                
                                                SELECT  CASE WHEN @volume = 0
                                                             THEN '-'
                                                             ELSE @volume
                                                        END AS volume_sum
                                            END
                                        ELSE
                                            IF @action = 'getDeviceCounterHistory'
                                                BEGIN
                                                    IF @sp_test IS NOT NULL
                                                        BEGIN
                                                            RETURN
                                                        END
                                                    
                                                    SELECT  *
                                                    FROM    ( SELECT
                                                              t.* ,
                                                              CONVERT(DATETIME, [date]) AS date_counter ,
                                                              ROW_NUMBER() OVER ( ORDER BY [date] DESC, [counter] DESC ) AS row_num
                                                              FROM
                                                              ( SELECT
                                                              CONVERT(NVARCHAR, date_came, 102) AS [date] ,
                                                              cam.[counter] AS [counter] ,
                                                              ( SELECT
                                                              u.display_name
                                                              FROM
                                                              users u
                                                              WHERE
                                                              u.id_user = cam.id_service_engeneer
                                                              ) AS name ,
                                                              cam.id_akt_scan ,
                                                              ( SELECT
                                                              full_path
                                                              FROM
                                                              dbo.srvpl_akt_scans sk
                                                              WHERE
                                                              sk.enabled = 1
                                                              AND sk.id_akt_scan = cam.id_akt_scan
                                                              ) AS full_path
                                                              FROM
                                                              dbo.srvpl_service_cames cam
                                                              INNER JOIN dbo.srvpl_service_claims sc ON cam.id_service_claim = sc.id_service_claim
                                                              INNER JOIN dbo.srvpl_contract2devices c2d ON sc.id_contract2devices = c2d.id_contract2devices
                                                              INNER JOIN dbo.srvpl_contracts c ON c2d.id_contract = c.id_contract
                                                              INNER JOIN dbo.srvpl_devices d ON c2d.id_device = d.id_device
                                                              WHERE
                                                              cam.enabled = 1
                                                              AND sc.enabled = 1
                                                              AND c2d.enabled = 1
                                                              AND c.enabled = 1
                                                              AND d.enabled = 1
                                                              AND sc.id_contract = @id_contract
                                                              AND sc.id_device = @id_device
                                                              AND @data_source IN (
                                                              'all', 'eng' )
                                                              UNION ALL
                                                              SELECT
                                                              CONVERT(NVARCHAR, date_request, 102) AS [date] ,
                                                              MAX(counter) AS [counter] ,
                                                              'UN1T Счетчик' AS NAME ,
                                                              NULL AS id_akt_scan ,
                                                              NULL AS full_path
                                                              FROM
                                                              dbo.snmp_requests r
                                                              WHERE
                                                              id_device = @id_device
                                                              AND r.counter IS NOT NULL
                                                              AND @data_source IN (
                                                              'all',
                                                              'un1t_cnt' )
                                                              GROUP BY CONVERT(NVARCHAR, date_request, 102)
                                                              ) AS t
                                                            ) AS tt
                                                    WHERE   ( ( @rows_count IS NULL
                                                              OR @rows_count <= 0
                                                              )
                                                              OR ( @rows_count > 0
                                                              AND row_num <= @rows_count
                                                              )
                                                            )
                                                    ORDER BY [date] DESC ,
                                                            [counter] DESC
                                                
                                            
                                            
                                                END
     
        IF @action = 'getDeviceCounterDetail'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
                    
                    --Стало сильно тормозить 
                SELECT  NULL                                   
                  
                  /*                                 
               DECLARE @new_id UNIQUEIDENTIFIER
SET @new_id = NEWID()

CREATE TABLE #tmp_device_counter_detail
    (
      id UNIQUEIDENTIFIER NOT NULL ,
      id_contract INT NOT NULL ,
      id_device INT NOT NULL ,
      date_counter DATETIME NOT NULL ,
      COUNTER INT ,
      counter_color INT ,
      counter_total INT ,
      place NVARCHAR(50) NOT NULL ,
      creator NVARCHAR(150) ,
      date_create DATETIME NOT NULL ,
      link_id INT ,
      NAME NVARCHAR(150) ,
      SOURCE NVARCHAR(10) ,
      id_akt_scan INT ,
      akt_scan_full_path NVARCHAR(500) ,
      has_akt_scan BIT ,
      row_num INT NOT NULL
    )

INSERT  INTO #tmp_device_counter_detail
        SELECT  @new_id ,
                id_contract ,
                id_device ,
                date_counter ,
                counter ,
                counter_color ,
                counter_total ,
                place ,
                creator ,
                date_create ,
                link_id ,
                name ,
                source ,
                id_akt_scan ,
                akt_scan_full_path ,
                has_akt_scan ,
                row_num
        FROM    ( SELECT    id_contract ,
                            id_device ,
                            date_counter ,
                            counter ,
                            counter_color ,
                            counter_total ,
                            place ,
                            creator ,
                            date_create ,
                            link_id ,
                            name ,
                            source ,
                            id_akt_scan ,
                            akt_scan_full_path ,
                            has_akt_scan ,
                            ROW_NUMBER() OVER ( ORDER BY [date_counter] DESC, counter_total DESC ) AS row_num
                  FROM      ( SELECT 
        --c.number ,
        --dbo.srvpl_get_device_name(t.id_device, NULL) AS device ,
        --ctr.name_inn AS contractor ,
                                        t.id_contract ,
                                        t.id_device ,
                                        t.planing_date AS date_counter ,
                                        t.counter ,
                                        t.counter_colour AS counter_color ,
                                        ISNULL(t.COUNTER, 0)
                                        + ISNULL(t.counter_colour, 0) AS counter_total ,
                                        t.place ,
                                        ( SELECT    display_name
                                          FROM      dbo.users AS u
                                          WHERE     ( enabled = 1 )
                                                    AND ( id_user = t.id_creator )
                                        ) AS creator ,
                                        t.dattim1 AS date_create ,
                                        link_id ,
                                        name ,
                                        source ,
                                        id_akt_scan ,
                                        akt_scan_full_path ,
                                        CASE WHEN id_akt_scan IS NOT NULL
                                             THEN 1
                                             ELSE 0
                                        END AS has_akt_scan
                              FROM      ( SELECT    c2d.id_contract ,
                                                    c2d.id_device ,
                                                    d.dattim1 AS planing_date ,
                                                    d.counter ,
                                                    d.counter_colour ,
                                                    'srvpl_contract2devices' AS place ,
                                                    c2d.id_creator ,
                                                    c2d.dattim1 ,
                                                    c2d.id_contract2devices AS link_id ,
                                                    'Первоначальные показания' AS name ,
                                                    'eng' AS SOURCE ,
                                                    NULL AS id_akt_scan ,
                                                    NULL AS akt_scan_full_path
                                          FROM      dbo.srvpl_contract2devices
                                                    AS c2d
                                                    INNER JOIN dbo.srvpl_devices
                                                    AS d ON d.id_device = c2d.id_device
                                                    INNER JOIN dbo.srvpl_contracts
                                                    AS c ON c2d.id_contract = c.id_contract
                                          WHERE     ( d.enabled = 1 )
                                                    AND ( c.enabled = 1 )
                                                    AND ( c2d.enabled = 1 )
                                                    AND ( d.counter IS NOT NULL )
                                                    OR ( d.enabled = 1 )
                                                    AND ( c.enabled = 1 )
                                                    AND ( c2d.enabled = 1 )
                                                    AND ( d.counter_colour IS NOT NULL )
                                          UNION ALL
                                          SELECT    c2d.id_contract ,
                                                    c2d.id_device ,
                                                    cam.date_came AS planing_date ,
                                                    cam.counter ,
                                                    cam.counter_colour ,
                                                    'srvpl_service_claims' AS place ,
                                                    cam.id_creator ,
                                                    cam.dattim1 ,
                                                    cl.id_service_claim AS link_id ,
                                                    ( SELECT  display_name
                                                      FROM    dbo.users AS u
                                                      WHERE   ( enabled = 1 )
                                                              AND ( id_user = cam.id_service_engeneer )
                                                    ) AS name ,
                                                    'eng' AS SOURCE ,
                                                    cam.id_akt_scan ,
                                                    ( SELECT  full_path
                                                      FROM    dbo.srvpl_akt_scans sk
                                                      WHERE   sk.enabled = 1
                                                              AND sk.id_akt_scan = cam.id_akt_scan
                                                    ) AS akt_scan_full_path
                                          FROM      dbo.srvpl_service_claims
                                                    AS cl
                                                    INNER JOIN dbo.srvpl_service_cames
                                                    AS cam ON cl.id_service_claim = cam.id_service_claim
                                                    INNER JOIN dbo.srvpl_contract2devices
                                                    AS c2d ON c2d.id_contract2devices = cl.id_contract2devices
                                                    INNER JOIN dbo.srvpl_devices
                                                    AS d ON d.id_device = c2d.id_device
                                                    INNER JOIN dbo.srvpl_contracts
                                                    AS c ON c2d.id_contract = c.id_contract
                                          WHERE     ( d.enabled = 1 )
                                                    AND ( c.enabled = 1 )
                                                    AND ( c2d.enabled = 1 )
                                                    AND ( cl.enabled = 1 )
                                                    AND ( cam.enabled = 1 )
                                          UNION ALL
                                          SELECT    ( SELECT TOP ( 1 )
                                                              id_contract
                                                      FROM    dbo.srvpl_contracts
                                                      WHERE   ( enabled = 1 )
                                                              AND ( id_contractor = r.id_contractor )
                                                              AND ( dbo.srvpl_fnc(N'checkContractIsActiveOnMonth',
                                                              NULL,
                                                              id_contract,
                                                              r.date_request,
                                                              NULL) = '1' )
                                                    ) AS id_contract ,
                                                    id_device ,
                                                    date_request AS planing_date ,
                                                    counter ,
                                                    counter_color ,
                                                    'snmp_requests' AS place ,
                                                    NULL AS id_creator ,
                                                    dattim1 ,
                                                    r.id_requset AS link_id ,
                                                    'UN1T Счетчик' AS name ,
                                                    'un1t_cnt' AS source ,
                                                    NULL AS id_akt_scan ,
                                                    NULL AS akt_scan_full_path
                                          FROM      dbo.snmp_requests AS r
                                        ) AS t
        --INNER JOIN dbo.srvpl_contracts AS c ON t.id_contract = c.id_contract
        --INNER JOIN dbo.srvpl_devices AS d ON t.id_device = d.id_device
        --INNER JOIN dbo.get_contractor(NULL) AS ctr ON c.id_contractor = ctr.id
                            ) AS t2
                  WHERE     id_contract = @id_contract
                            AND id_device = @id_device
                            AND ( ( @data_source IS NULL
                                    OR @data_source = 'all'
                                  )
                                  OR ( @data_source IS NOT NULL
                                       AND @data_source != 'all'
                                       AND source = @data_source
                                     )
                                )
                ) AS t3
        ORDER BY row_num
                        --[date_counter] DESC, [counter] DESC
        
        --SELECT * FROM #tmp_device_counter_detail
        
        
        --CREATE TABLE #tmp_device_counter_detail2(
        
        --id UNIQUEIDENTIFIER NOT NULL ,
        --              id_contract INT NOT NULL ,
        --              id_device INT NOT NULL ,
        --              date_counter DATETIME NOT NULL ,
        --              COUNTER INT ,
        --              counter_prev INT,
        --              volume_counter INT,
        --              counter_color INT ,
        --              counter_color_prev INT,
        --              volume_counter_color INT,
        --              counter_total INT ,
        --              counter_total_prev INT,
        --              volume_counter_total INT,
        --              place NVARCHAR(50) NOT NULL ,
        --              creator NVARCHAR(150) ,
        --              date_create DATETIME NOT NULL ,
        --              link_id INT ,
        --              NAME NVARCHAR(150) ,
        --              SOURCE NVARCHAR(10) ,
        --              id_akt_scan INT ,
        --              akt_scan_full_path NVARCHAR(500) ,
        --              has_akt_scan BIT 
        --              ,
        --              row_num INT NOT NULL
                        
        --)
        
        --INSERT INTO #tmp_device_counter_detail2

SELECT  *
FROM    ( SELECT    * ,
                    ROW_NUMBER() OVER ( ORDER BY [date_counter] DESC, [counter_total] DESC ) AS row_num
          FROM      ( SELECT    date_counter ,
                    --CASE WHEN @group_by_date = 1 THEN MAX(counter) ELSE counter end AS counter ,
                    --CASE WHEN @group_by_date = 1 THEN MAX(volume_counter) ELSE volume_counter end AS volume_counter ,
                    --CASE WHEN @group_by_date = 1 THEN MAX(counter_color) ELSE counter_color end AS counter_color ,
                    --CASE WHEN @group_by_date = 1 THEN MAX(volume_counter_color) ELSE volume_counter_color end AS volume_counter_color ,
                    --CASE WHEN @group_by_date = 1 THEN MAX(counter_total) ELSE counter_total end AS counter_total ,
                    --CASE WHEN @group_by_date = 1 THEN MAX(volume_counter_total) ELSE volume_counter_total end AS volume_counter_total ,
                                MAX(counter) AS counter ,
                                MAX(volume_counter) AS volume_counter ,
                                MAX(counter_color) AS counter_color ,
                                MAX(volume_counter_color) AS volume_counter_color ,
                                MAX(counter_total) AS counter_total ,
                                MAX(volume_counter_total) AS volume_counter_total ,
                                name ,
                                source ,
                                id_akt_scan ,
                                akt_scan_full_path ,
                                has_akt_scan
                      FROM      ( SELECT    t4.id_contract ,
                                            t4.id_device ,
                                            CONVERT(DATE, t4.date_counter) AS date_counter ,
                                            t4.counter ,
                                            t4.counter_prev ,
                                            t4.volume_counter ,
                                            t4.counter_color ,
                                            t4.counter_color_prev ,
                                            t4.volume_counter_color ,
                                            t4.counter_total ,
                                            t4.counter_total_prev ,
                                            t4.volume_counter_total ,
                                            t4.place ,
                                            t4.creator ,
                                            t4.date_create ,
                                            t4.link_id ,
                                            t4.name ,
                                            t4.source ,
                                            t4.id_akt_scan ,
                                            t4.akt_scan_full_path ,
                                            t4.has_akt_scan 
                        --,
                        --t4.row_num
                                  FROM      ( SELECT    t3.id_contract ,
                                                        t3.id_device ,
                                                        t3.date_counter ,
                                                        t3.counter ,
                                                        t3.counter_prev ,
                                                        CASE WHEN t3.counter_prev IS NOT NULL
                                                              AND t3.COUNTER IS NOT NULL
                                                             THEN t3.counter
                                                              - t3.counter_prev
                                                             ELSE NULL
                                                        END AS volume_counter ,
                                                        t3.counter_color ,
                                                        t3.counter_color_prev ,
                                                        CASE WHEN t3.counter_color_prev IS NOT NULL
                                                              AND t3.counter_color IS NOT NULL
                                                             THEN t3.counter_color
                                                              - t3.counter_color_prev
                                                             ELSE NULL
                                                        END AS volume_counter_color ,
                                                        t3.counter_total ,
                                                        t3.counter_total_prev ,
                                                        CASE WHEN t3.counter_total_prev IS NOT NULL
                                                              AND t3.counter_total IS NOT NULL
                                                             THEN t3.counter_total
                                                              - t3.counter_total_prev
                                                             ELSE NULL
                                                        END AS volume_counter_total ,
                                                        t3.place ,
                                                        t3.creator ,
                                                        t3.date_create ,
                                                        t3.link_id ,
                                                        t3.name ,
                                                        t3.source ,
                                                        t3.id_akt_scan ,
                                                        t3.akt_scan_full_path ,
                                                        t3.has_akt_scan 
                                    --,
                                    --t3.row_num
                                              FROM      ( SELECT
                                                              t1.id_contract ,
                                                              t1.id_device ,
                                                              t1.date_counter ,
                                                              t1.counter ,
                                                              t2.counter AS counter_prev ,
                                                              t1.counter_color ,
                                                              t2.counter_color AS counter_color_prev ,
                                                              t1.counter_total ,
                                                              t2.counter_total AS counter_total_prev ,
                                                              t1.place ,
                                                              t1.creator ,
                                                              t1.date_create ,
                                                              t1.link_id ,
                                                              t1.name ,
                                                              t1.source ,
                                                              t1.id_akt_scan ,
                                                              t1.akt_scan_full_path ,
                                                              t1.has_akt_scan 
                                                --,
                                                --t1.row_num
                                                          FROM
                                                              #tmp_device_counter_detail t1
                                                              LEFT OUTER JOIN #tmp_device_counter_detail t2 ON t1.row_num = ( t2.row_num
                                                              - 1 )
                                                          WHERE
                                                              t1.id = @new_id
                                                        ) AS t3
                                            ) AS t4
                                  WHERE     ( ( @not_null_volume IS NULL
                                                OR @not_null_volume < 0
                                              )
                                              OR ( @not_null_volume IS NOT NULL
                                                   AND @not_null_volume = 1
                                                   AND ( volume_counter_total IS NULL
                                                         OR volume_counter_total != 0
                                                       )
                                                 )
                                              OR ( @not_null_volume IS NOT NULL
                                                   AND @not_null_volume = 0
                                                   AND volume_counter_total = 0
                                                 )
                                            )
                                ) AS t5
                      GROUP BY  date_counter ,
                                name ,
                                SOURCE ,
                                id_akt_scan ,
                                akt_scan_full_path ,
                                has_akt_scan
        --CASE WHEN @group_by_date = 1 THEN date_counter end,
        --            --counter ,
        --            --volume_counter ,
        --            --counter_color ,
        --            --volume_counter_color ,
        --            --counter_total ,
        --            --volume_counter_total ,
        --            CASE WHEN @group_by_date = 1 THEN name  end,
        --            CASE WHEN @group_by_date = 1 THEN source  end,
        --            CASE WHEN @group_by_date = 1 THEN id_akt_scan  end,
        --            CASE WHEN @group_by_date = 1 THEN akt_scan_full_path  end,
        --            CASE WHEN @group_by_date = 1 THEN has_akt_scan  end
                    ) AS t6
        ) AS tbl
WHERE   ( ( @rows_count IS NULL
            OR @rows_count <= 0
          )
          OR ( @rows_count > 0
               AND row_num <= @rows_count
             )
        )
       
        
                
                --SELECT * FROM #tmp_device_counter_detail
                
DROP TABLE #tmp_device_counter_detail
                
                ------Пересчитываем объем печати        
                ----SELECT id_contract , id_device, CONVERT(date, date_counter, 102) AS date_counter, counter, counter_prev, volume_counter, counter_color, 
                ----counter_color_prev, volume_counter_color, counter_total, counter_total_prev, volume_counter_total, place, creator, date_create, link_id, 
                ----name, SOURCE, id_akt_scan, akt_scan_full_path, has_akt_scan
                ----FROM (        
                --SELECT    t3.id_contract ,
                --                    t3.id_device ,
                --                    t3.date_counter ,
                --                    t3.counter ,
                --                    t3.counter_prev ,
                --                    CASE WHEN t3.counter_prev IS NOT NULL AND t3.COUNTER IS NOT NULL
                --                         THEN t3.counter
                --                              - t3.counter_prev
                --                         ELSE NULL
                --                    END AS volume_counter ,
                --                    t3.counter_color ,
                --                    t3.counter_color_prev ,
                --                    CASE WHEN t3.counter_color_prev IS NOT NULL AND t3.counter_color IS NOT NULL
                --                         THEN t3.counter_color
                --                              - t3.counter_color_prev
                --                         ELSE NULL
                --                    END AS volume_counter_color ,
                --                    t3.counter_total ,
                --                    t3.counter_total_prev ,
                --                    CASE WHEN t3.counter_total_prev IS NOT NULL AND t3.counter_total IS NOT NULL
                --                         THEN t3.counter_total
                --                              - t3.counter_total_prev
                --                         ELSE NULL
                --                    END AS volume_counter_total ,
                --                    t3.place ,
                --                    t3.creator ,
                --                    t3.date_create ,
                --                    t3.link_id ,
                --                    t3.name ,
                --                    t3.source ,
                --                    t3.id_akt_scan ,
                --                    t3.akt_scan_full_path ,
                --                    t3.has_akt_scan,
                --                    t3.row_num                                                
                --          FROM      ( SELECT    t1.id_contract ,
                --                                t1.id_device ,
                --                                t1.date_counter ,
                --                                t1.counter ,
                --                                t2.counter AS counter_prev ,
                --                                t1.counter_color ,
                --                                t2.counter_color AS counter_color_prev ,
                --                                t1.counter_total ,
                --                                t2.counter_total AS counter_total_prev ,
                --                                t1.place ,
                --                                t1.creator ,
                --                                t1.date_create ,
                --                                t1.link_id ,
                --                                t1.name ,
                --                                t1.source ,
                --                                t1.id_akt_scan ,
                --                                t1.akt_scan_full_path ,
                --                                t1.has_akt_scan,
                --                                ROW_NUMBER() OVER ( ORDER BY t1.date_counter DESC, t1.counter_total DESC ) AS row_num 
                --                      FROM      #tmp_device_counter_detail2 t1
                --                                LEFT OUTER JOIN #tmp_device_counter_detail2 t2 ON t1.row_num = ( t2.row_num
                --                                              - 1 )
                --                      WHERE     t1.id = @new_id
                --                    ) AS t3
                                    
                                    
                --                    ) AS t4
                ----                    GROUP BY 
                ----                    id_contract , id_device, CONVERT(date, date_counter, 102), counter, counter_prev, volume_counter, counter_color, 
                ----counter_color_prev, volume_counter_color, counter_total, counter_total_prev, volume_counter_total, place, creator, date_create, link_id, 
                ----name, SOURCE, id_akt_scan, akt_scan_full_path, has_akt_scan
                ----ORDER BY CONVERT(date, date_counter, 102) DESC, counter_total desc
                                    
                --                --    WHERE   ( ( @rows_count IS NULL
                --                --    OR @rows_count <= 0
                --                --  )
                --                --  OR ( @rows_count > 0
                --                --       AND row_num <= @rows_count
                --                --     )
                --                --) 
                --        --        AND ( (@not_null_volume IS NULL or @not_null_volume < 0)
                --        --  OR ( @not_null_volume IS NOT NULL
                --        --       AND @not_null_volume = 1
                --        --       AND volume_counter_total IS NOT NULL
                --        --       AND volume_counter_total != 0
                --        --     )
                --        --  OR ( @not_null_volume IS NOT NULL
                --        --       AND @not_null_volume = 0
                --        --       AND ( volume_counter_total IS  NULL or volume_counter_total = 0
                --        --           )
                --        --     )
                --        --)
                        
                
                ----SELECT * FROM #tmp_device_counter_detail2
                
                --DROP TABLE #tmp_device_counter_detail2
                                            
                    */                      
            END
     
        IF @action = 'setDeviceData'
            BEGIN
                            
                            --Вычисляем id договора если его не передали
                IF @id_contract IS NULL
                    AND @id_contractor IS NOT NULL
                    BEGIN
                        SELECT TOP 1
                                @id_contract = id_contract
                        FROM    dbo.srvpl_contracts
                        WHERE   enabled = 1
                                AND id_contractor = @id_contractor
                                AND dbo.srvpl_fnc('checkContractIsActiveOnMonth',
                                                  NULL, id_contract,
                                                  @planing_date, NULL) = '1'
                    END
								
								--IF @id_contract IS not NULL AND @id_contractor IS NULL
								--begin
								--	SELECT @id_contractor = id_contractor FROM dbo.srvpl_contracts
								--	WHERE id_contract = @id_contract
								--end
                            
                IF @id_device IS NULL
                    OR ( @id_contract IS NULL
                         AND @id_contractor IS NULL
                       )
                    OR @planing_date IS NULL
                    OR ( @counter IS NULL
                         AND @counter_colour IS NULL
                       )
                    BEGIN
                        RETURN
                    END
								
                SET @var_str = 'insDeviceData'
                DECLARE @volume_counter INT ,
                    @volume_counter_colour INT

                IF EXISTS ( SELECT  id_device_data
                            FROM    dbo.srvpl_device_data t
                            WHERE   t.ENABLED = 1
                                    AND t.id_device = @id_device
                                    AND t.id_contract = @id_contract
                                    AND YEAR(t.date_month) = YEAR(@planing_date)
                                    AND MONTH(t.date_month) = MONTH(@planing_date) )
                    BEGIN
                        SET @var_str = 'updDeviceData'
                                        
                        SELECT TOP 1
                                @id_device_data = id_device_data
                        FROM    dbo.srvpl_device_data t
                        WHERE   t.ENABLED = 1
                                AND t.id_device = @id_device
                                AND t.id_contract = @id_contract
                                AND YEAR(t.date_month) = YEAR(@planing_date)
                                AND MONTH(t.date_month) = MONTH(@planing_date)
                                                
                                                --Если это админ системы то сохраняем то значение которое он сохраняет, иначе не даем сохранить значение которое меньше
                        IF @is_sys_admin <> 1
                            BEGIN    
                                                
                                SELECT  @counter = CASE WHEN counter IS NULL
                                                             OR counter < @counter
                                                        THEN @counter
                                                        ELSE counter
                                                   END ,
                                        @counter_colour = CASE
                                                              WHEN counter_colour IS NULL
                                                              OR counter_colour < @counter_colour
                                                              THEN @counter_colour
                                                              ELSE counter_colour
                                                          END
                                FROM    dbo.srvpl_device_data
                                WHERE   id_device_data = @id_device_data
                            END
                    END
								
		--Рассчитываем объем печати для ЧерноБелого счетчика
                DECLARE @last_counter INT ,
                    @is_first_counter BIT
		
		
		--если в предыдущем месяце или ранее есть значения
                IF EXISTS ( SELECT  1
                            FROM    dbo.srvpl_device_data dd
                            WHERE   dd.enabled = 1
                                    AND dd.id_device = @id_device
                                    AND dd.id_contract = @id_contract
                                    AND dd.COUNTER IS NOT NULL
                                    AND dd.date_month <= @planing_date
                                    AND ( ( YEAR(dd.date_month) = YEAR(DATEADD(month,
                                                              -1,
                                                              @planing_date))
                                            AND ( MONTH(dd.date_month) = MONTH(DATEADD(month,
                                                              -1,
                                                              @planing_date)) )
                                          )
                                          OR ( YEAR(dd.date_month) < YEAR(DATEADD(month,
                                                              -1,
                                                              @planing_date))
                                               OR ( YEAR(dd.date_month) = YEAR(DATEADD(month,
                                                              -1,
                                                              @planing_date))
                                                    AND MONTH(dd.date_month) < MONTH(DATEADD(month,
                                                              -1,
                                                              @planing_date))
                                                  )
                                             )
                                        ) )
                    BEGIN
-- берем максимальное значение среди предыдущих месяцев
                        SELECT  @last_counter = MAX([counter])
                        FROM    dbo.srvpl_device_data dd
                        WHERE   dd.enabled = 1
                                AND dd.id_device = @id_device
                                AND dd.id_contract = @id_contract
                                AND dd.COUNTER IS NOT NULL
                                AND dd.date_month <= @planing_date
                                AND ( ( YEAR(dd.date_month) = YEAR(DATEADD(month,
                                                              -1,
                                                              @planing_date))
                                        AND ( MONTH(dd.date_month) = MONTH(DATEADD(month,
                                                              -1,
                                                              @planing_date)) )
                                      )
                                      OR ( YEAR(dd.date_month) < YEAR(DATEADD(month,
                                                              -1,
                                                              @planing_date))
                                           OR ( YEAR(dd.date_month) = YEAR(DATEADD(month,
                                                              -1,
                                                              @planing_date))
                                                AND MONTH(dd.date_month) < MONTH(DATEADD(month,
                                                              -1,
                                                              @planing_date))
                                              )
                                         )
                                    )	
                    END
		
                ELSE
 --иначе если в текущем месяце есть значение
                    IF EXISTS ( SELECT  1
                                FROM    dbo.srvpl_device_data dd
                                WHERE   dd.enabled = 1
                                        AND dd.id_device = @id_device
                                        AND dd.id_contract = @id_contract
                                        AND dd.COUNTER IS NOT NULL
                                        AND dd.date_month <= @planing_date
                                        AND YEAR(dd.date_month) = YEAR(@planing_date)
                                        AND MONTH(dd.date_month) = MONTH(@planing_date) )
                        BEGIN
                                                        --берем минимальное значение в текущем месяце меньше текущей даты или не текущую дату значение
                                                        
                                                        
                                                        
                            SELECT  @last_counter = MIN([counter])
                            FROM    dbo.srvpl_device_data dd
                            WHERE   dd.enabled = 1
                                    AND dd.id_device = @id_device
                                    AND dd.id_contract = @id_contract
                                    AND dd.COUNTER IS NOT NULL
                                    AND dd.date_month <= @planing_date
                                    AND YEAR(dd.date_month) = YEAR(@planing_date)
                                    AND MONTH(dd.date_month) = MONTH(@planing_date)
                                                        
                        END
                                        --если значений совсем нет
                    ELSE
                        IF NOT EXISTS ( SELECT  1
                                        FROM    dbo.srvpl_device_data dd
                                        WHERE   dd.enabled = 1
                                                AND dd.id_device = @id_device
                                                AND dd.id_contract = @id_contract
                                                AND dd.COUNTER IS NOT NULL
                                                AND dd.date_month < @planing_date )
                            BEGIN
                                        --Устанавливаем метку чтобы потом исключить объем
                                SET @is_first_counter = 1
                            END
								
								--Если значение не единственное, то высчитываем объем
                IF @is_first_counter IS NULL
                    OR @is_first_counter = 0
                    BEGIN
                        SET @volume_counter = ISNULL(@counter, 0)
                            - ISNULL(@last_counter, 0)
                        SELECT  @volume_counter = CASE WHEN @volume_counter < 0
                                                            OR @volume_counter IS NULL
                                                       THEN 0
                                                       ELSE @volume_counter
                                                  END
                    END
                ELSE
                    BEGIN
                        SET @volume_counter = 0
                    END
   
   --Рассчитываем объем печати для Цветного счетчика
                DECLARE @last_counter_colour INT ,
                    @is_first_counter_colour BIT
   
    
-- если в предыдущем месяце или ранее есть значения
                IF EXISTS ( SELECT  1
                            FROM    dbo.srvpl_device_data dd
                            WHERE   dd.enabled = 1
                                    AND dd.id_device = @id_device
                                    AND dd.id_contract = @id_contract
                                    AND dd.counter_colour IS NOT NULL
                                    AND dd.date_month <= @planing_date
                                    AND ( ( YEAR(dd.date_month) = YEAR(DATEADD(month,
                                                              -1,
                                                              @planing_date))
                                            AND ( MONTH(dd.date_month) = MONTH(DATEADD(month,
                                                              -1,
                                                              @planing_date)) )
                                          )
                                          OR ( YEAR(dd.date_month) < YEAR(DATEADD(month,
                                                              -1,
                                                              @planing_date))
                                               OR ( YEAR(dd.date_month) = YEAR(DATEADD(month,
                                                              -1,
                                                              @planing_date))
                                                    AND MONTH(dd.date_month) < MONTH(DATEADD(month,
                                                              -1,
                                                              @planing_date))
                                                  )
                                             )
                                        ) )
                    BEGIN
-- берем максимальное значение среди предыдущих месяцев
                        SELECT  @last_counter_colour = MAX([counter_colour])
                        FROM    dbo.srvpl_device_data dd
                        WHERE   dd.enabled = 1
                                AND dd.id_device = @id_device
                                AND dd.id_contract = @id_contract
                                AND dd.counter_colour IS NOT NULL
                                AND dd.date_month <= @planing_date
                                AND ( ( YEAR(dd.date_month) = YEAR(DATEADD(month,
                                                              -1,
                                                              @planing_date))
                                        AND ( MONTH(dd.date_month) = MONTH(DATEADD(month,
                                                              -1,
                                                              @planing_date)) )
                                      )
                                      OR ( YEAR(dd.date_month) < YEAR(DATEADD(month,
                                                              -1,
                                                              @planing_date))
                                           OR ( YEAR(dd.date_month) = YEAR(DATEADD(month,
                                                              -1,
                                                              @planing_date))
                                                AND MONTH(dd.date_month) < MONTH(DATEADD(month,
                                                              -1,
                                                              @planing_date))
                                              )
                                         )
                                    )	

                    END
                                       
                ELSE
                                     --если в текущем месяце есть значение
                    IF EXISTS ( SELECT  1
                                FROM    dbo.srvpl_device_data dd
                                WHERE   dd.enabled = 1
                                        AND dd.id_device = @id_device
                                        AND dd.id_contract = @id_contract
                                        AND dd.counter_colour IS NOT NULL
                                        AND dd.date_month <= @planing_date
                                        AND YEAR(dd.date_month) = YEAR(@planing_date)
                                        AND MONTH(dd.date_month) = MONTH(@planing_date) )
                        BEGIN
                                                        --берем минимальное значение в текущем месяце меньше текущей даты или не текущую дату значение
                                                        
                                                        
                                                        
                            SELECT  @last_counter_colour = MIN([counter_colour])
                            FROM    dbo.srvpl_device_data dd
                            WHERE   dd.enabled = 1
                                    AND dd.id_device = @id_device
                                    AND dd.id_contract = @id_contract
                                    AND dd.counter_colour IS NOT NULL
                                    AND dd.date_month <= @planing_date
                                    AND YEAR(dd.date_month) = YEAR(@planing_date)
                                    AND MONTH(dd.date_month) = MONTH(@planing_date)
                                                        
                        END
                                     --если значений совсем нет
                    ELSE
                        IF NOT EXISTS ( SELECT  1
                                        FROM    dbo.srvpl_device_data dd
                                        WHERE   dd.enabled = 1
                                                AND dd.id_device = @id_device
                                                AND dd.id_contract = @id_contract
                                                AND dd.counter_colour IS NOT NULL
                                                AND dd.date_month < @planing_date )
                            BEGIN
                                        --Устанавливаем метку чтобы потом исключить объем
                                SET @is_first_counter_colour = 1
                            END
   
                IF @is_first_counter_colour IS NULL
                    OR @is_first_counter_colour = 0
                    BEGIN
                        SET @volume_counter_colour = ISNULL(@counter_colour, 0)
                            - ISNULL(@last_counter_colour, 0)
                                    
                        SELECT  @volume_counter_colour = CASE WHEN @volume_counter_colour < 0
                                                              OR @volume_counter_colour IS NULL
                                                              THEN 0
                                                              ELSE @volume_counter_colour
                                                         END
                    END
                ELSE
                    BEGIN
                        SET @volume_counter_colour = 0
                    END
  
  --Если показаний за текущий и предыдущий месяц не было, но показания были ранее, то высчитываем средний объем печати
                IF NOT EXISTS ( SELECT  1
                                FROM    dbo.srvpl_device_data dd
                                WHERE   dd.enabled = 1
                                        AND dd.id_device = @id_device
                                        AND dd.id_contract = @id_contract
                                        AND YEAR(dd.date_month) = YEAR(DATEADD(month,
                                                              -1,
                                                              @planing_date))
                                        AND ( MONTH(dd.date_month) = MONTH(DATEADD(month,
                                                              -1,
                                                              @planing_date))
                                              OR MONTH(dd.date_month) = MONTH(@planing_date)
                                            ) )
                    AND EXISTS ( SELECT 1
                                 FROM   dbo.srvpl_device_data dd
                                 WHERE  dd.enabled = 1
                                        AND dd.id_device = @id_device
                                        AND dd.id_contract = @id_contract
                                        AND ( YEAR(dd.date_month) < YEAR(DATEADD(month,
                                                              -1,
                                                              @planing_date))
                                              OR ( YEAR(dd.date_month) = YEAR(DATEADD(month,
                                                              -1,
                                                              @planing_date))
                                                   AND MONTH(dd.date_month) < MONTH(DATEADD(month,
                                                              -1,
                                                              @planing_date))
                                                 )
                                            ) )
                    BEGIN
    
                        DECLARE @avg_month_days_count DECIMAL(8, 1) ,
                            @days_diff DECIMAL(8, 1) ,
                            @days_index DECIMAL(8, 1) ,
                            @counter_avg INT ,
                            @counter_colour_avg INT ,
                            @is_average BIT
                                            
                        SET @avg_month_days_count = 30--среднее число дней в месяце
	    
		--Вычисляем сколько дней прошло с момента сохранения последнего акта
                        SELECT TOP 1
                                @days_diff = DATEDIFF(DAY, date_month,
                                                      @planing_date)
                        FROM    dbo.srvpl_device_data dd
                        WHERE   dd.enabled = 1
                                AND dd.id_device = @id_device
                                AND dd.id_contract = @id_contract
                        ORDER BY date_month DESC
                        
                        SET @days_index = @days_diff / @avg_month_days_count
        
                        IF @days_index > 0
                            BEGIN
                                            
                                SET @counter_avg = ISNULL(@volume_counter, 0)
                                    / @days_index
                                SET @counter_colour_avg = ISNULL(@volume_counter_colour,
                                                              0) / @days_index
                            END
			
                        SET @volume_counter = ISNULL(@counter_avg,
                                                     @volume_counter)
                        SET @volume_counter_colour = ISNULL(@counter_colour_avg,
                                                            @volume_counter_colour)
										
                        SET @is_average = 1
                    END
                                
                EXEC @id_device = dbo.sk_service_planing @action = @var_str,
                    @id_device = @id_device, @id_device_data = @id_device_data,
                    @counter = @counter, @counter_colour = @counter_colour,
                    @date_month = @planing_date, @id_contract = @id_contract,
                    @volume_counter = @volume_counter,
                    @volume_counter_colour = @volume_counter_colour,
                    @is_average = @is_average
            END      
        ELSE
            IF @action = 'refillDaviceData'
                BEGIN
                --Пересчитываем значения объемов счетчиков для аппарата
                
                --Если недостаточно данных то ничего не делаем
                    IF @id_contract IS NULL
                        OR @id_device IS NULL
                        BEGIN
                            SET @error_text = 'Недостаточно данных. Отсутствует либо id договора либо id аппарата!'
						
                            RAISERROR (
																@error_text
																,16
																,1
																)
                            RETURN
                        END
                    BEGIN TRY
                        BEGIN TRANSACTION
				--Удаляем записи этого устройства
                        DELETE  dbo.srvpl_device_data
                        WHERE   id_device = @id_device
                                AND id_contract = @id_contract
--Формируем список показаний для договора и устройства
                        DECLARE curs CURSOR
                        FOR
                            SELECT  p.id_contract ,
                                    p.id_device ,
                                    p.date ,
                                    [COUNTER] ,
                                    counter_color
                            FROM    srvpl_devices_data_pivot p
                            WHERE   p.id_contract = @id_contract
                                    AND p.id_device = @id_device
                            ORDER BY p.id_contract ,
                                    p.id_device ,
                                    p.date
                            
                        OPEN curs

                        FETCH NEXT
	FROM curs
	INTO @id_contract, @id_device, @planing_date, @counter, @counter_colour
	
	--Сохраняем значения в таблицу объема печати которые будут пересчитаны
                        WHILE @@FETCH_STATUS = 0
                            BEGIN
                                EXEC dbo.ui_service_planing @action = 'setDeviceData',
                                    @id_contract = @id_contract,
                                    @id_device = @id_device,
                                    @counter = @counter,
                                    @counter_colour = @counter_colour,
                                    @planing_date = @planing_date,
                                    @id_creator = @id_creator
    
    
                                FETCH NEXT
	FROM curs
	INTO @id_contract, @id_device, @planing_date, @counter, @counter_colour
    
                            END

                        CLOSE curs

                        DEALLOCATE curs
            
                        COMMIT TRANSACTION
                    END TRY

                    BEGIN CATCH
                        IF @@TRANCOUNT > 0
                            ROLLBACK TRANSACTION

                        SELECT  @error_text = ERROR_MESSAGE()
                                + ' Изменения не были сохранены!'

                        RAISERROR (
								@error_text
								,16
								,1
								)
                    END CATCH
            
                END                     
                                

	--=================================
	--Contract2Devices
	--=================================	
        IF @action = 'getContract2DevicesList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
				
                SELECT  * ,
                        ( SELECT TOP 1
                                    ISNULL(counter, 0) + ISNULL(counter_colour,
                                                              0)
                          FROM      dbo.srvpl_device_data dd
                          WHERE     dd.enabled = 1
                                    AND dd.id_device = tt.id_device
                                    AND dd.id_contract = tt.id_contract
                          ORDER BY  date_month DESC
                        ) AS last_counter ,
                        ( SELECT TOP 1
                                    date_month
                          FROM      dbo.srvpl_device_data dd
                          WHERE     dd.enabled = 1
                                    AND dd.id_device = tt.id_device
                                    AND dd.id_contract = tt.id_contract
                          ORDER BY  date_month DESC
                        ) AS last_counter_date ,
                        ( SELECT TOP 1
                                    MAX(snm.date_request)
                          FROM      dbo.snmp_requests snm
                          WHERE     snm.id_device = tt.id_device
                        ) AS unit_counter_last_date
                        
                --,
                --        ( SELECT    ISNULL(MAX(counter), 0)
                --                    + ISNULL(MAX(counter_colour), 0)
                --          FROM      dbo.srvpl_device_data dd
                --          WHERE     dd.enabled = 1
                --                    AND dd.id_device = tt.id_device
                --                    AND dd.id_contract = tt.id_contract
                --        --------( SELECT    MAX(counter)
                --        --------  FROM      ( SELECT    MAX(cam.[counter]) AS [COUNTER]
                --        --------              FROM      dbo.srvpl_service_cames cam
                --        --------                        INNER JOIN dbo.srvpl_service_claims cl ON cam.id_service_claim = cl.id_service_claim
                --        --------              WHERE     cam.enabled = 1
                --        --------                        AND cl.enabled = 1
                --        --------                        AND cl.id_device = tt.id_device
                --        --------                        AND cl.id_contract = tt.id_contract
                --        --------              UNION ALL
                --        --------              SELECT    MAX(counter) AS [COUNTER]
                --        --------              FROM      dbo.snmp_requests r
                --        --------              WHERE     id_device = tt.id_device
                --        --------                        AND r.counter IS NOT NULL
                --        --------            ) AS t
                        
                --        --------SELECT TOP 1
                --        --------            t2.[counter]
                --        --------  FROM      ( SELECT    cam.[counter] ,
                --        --------                        ROW_NUMBER() OVER ( PARTITION BY cam.id_service_came ORDER BY cam.date_came DESC ) AS rn
                --        --------              FROM      dbo.srvpl_service_cames cam
                --        --------                        INNER JOIN dbo.srvpl_service_claims cl ON cam.id_service_claim = cl.id_service_claim
                --        --------              WHERE     cam.enabled = 1
                --        --------                        AND cl.enabled = 1
                --        --------                        AND cl.id_device = tt.id_device
                --        --------                        AND cl.id_contract = tt.id_contract
                --        --------            ) AS t2
                --        --------  WHERE     t2.rn = 1
                --        ) AS last_counter,
                --        (SELECT    ISNULL(MAX(counter), 0)
                --                    + ISNULL(MAX(counter_colour), 0)
                --          FROM      dbo.srvpl_device_data dd
                --          WHERE     dd.enabled = 1
                --                    AND dd.id_device = tt.id_device
                --                    AND dd.id_contract = tt.id_contract) AS last_counter_date
                FROM    ( SELECT    ROW_NUMBER() OVER ( ORDER BY contract_num, device DESC ) AS row_num ,
                                    t.id_contract2devices ,
                                    t.id_device ,
                                    t.model ,
                                    t.serial_num ,
                                    t.service_admin ,
                                    t.id_service_admin ,
                                    t.city ,
                                    t.[address] ,
                                    t.[object_name] ,
                                    t.service_interval ,
                                    t.contact_name ,
                                    ISNULL(t.model, '-') + '; '
                                    + ISNULL(t.city, '') + ' '
                                    + ISNULL(t.ADDRESS, '') + ' '
                                    + ISNULL(t.OBJECT_NAME, '') + '; '
                                    + ISNULL(t.service_interval, '-') + '; '
                                    + ISNULL(t.contact_name, '-') AS collected_name ,
                                    t.device ,
                                    t.id_contract ,
                                    t.id_contractor ,
                                    t.contract_num
                                    --,
                                    --last_counter,
                                    --last_counter_date
                          FROM      ( SELECT    c2d.id_contract2devices ,
                                                d.id_device ,
                                                dbo.srvpl_fnc('getDeviceShortCollectedNameNoBr',
                                                              NULL,
                                                              d.id_device,
                                                              NULL, NULL) AS device ,
                                                dm.NAME AS model ,
                                                d.serial_num ,
                                                ( SELECT    display_name
                                                  FROM      users u
                                                  WHERE     u.id_user = c2d.id_service_admin
                                                ) AS service_admin ,
                                                id_service_admin ,
                                                ( SELECT    c.NAME
                                                  FROM      dbo.cities c
                                                  WHERE     c2d.id_city = c.id_city
                                                ) AS city ,
                                                c2d.address ,
                                                c2d.object_name ,
                                                ( SELECT    NAME
                                                  FROM      dbo.srvpl_service_intervals si
                                                  WHERE     c2d.id_service_interval = si.id_service_interval
                                                ) AS service_interval ,
                                                c2d.contact_name ,
                                                c2d.id_contract ,
                                                c.id_contractor ,
                                                c.number AS contract_num
                                                --, (ISNULL(dd.counter, 0) + ISNULL(dd.counter_colour, 0)) 
                                                -- as  last_counter,
                                                --dd.date_month as last_counter_date
                                      FROM      dbo.srvpl_contract2devices c2d
                                                INNER JOIN dbo.srvpl_devices d ON c2d.id_device = d.id_device
                                                INNER JOIN dbo.srvpl_contracts c ON c2d.id_contract = c.id_contract
                                                INNER JOIN srvpl_device_models dm ON d.id_device_model = dm.id_device_model
                                                --INNER JOIN srvpl_device_data dd ON  dd.id_device = c2d.id_device AND dd.id_contract = c2d.id_contract
                                      WHERE     c2d.enabled = 1
                                                AND c.enabled = 1
                                                AND d.enabled = 1
                                                --AND dd.enabled = 1
                                                AND
				--//<Filter>
				--id_contractor
                                                ( ( @id_contractor IS NULL
                                                    OR @id_contractor <= 0
                                                  )
                                                  OR ( @id_contractor > 0
                                                       AND c.id_contractor = @id_contractor
                                                       --Только активные
                                                       AND dbo.srvpl_fnc('checkContractIsActiveNow',
                                                              NULL,
                                                              c2d.id_contract,
                                                              NULL, NULL) = '1'
                                                     )
                                                )
                                                AND
				--id_contract
                                                ( ( @id_contract IS NULL
                                                    OR @id_contract <= 0
                                                  )
                                                  OR ( @id_contract > 0
                                                       AND c2d.id_contract = @id_contract
                                                     )
                                                )
				--OR @id_contract <= 0
				--MODEL
                                                AND ( ( @id_device_model IS NULL
                                                        OR @id_device_model <= 0
                                                      )
                                                      OR ( @id_device_model IS NOT NULL
                                                           AND d.id_device_model LIKE @id_device_model
                                                         )
                                                    )
				--SERIAL NUM
                                                AND ( @serial_num IS NULL
                                                      OR ( @serial_num IS NOT NULL
                                                           AND d.serial_num LIKE '%'
                                                           + @serial_num + '%'
                                                         )
                                                    )
				--SERVICE INTERVAL
                                                AND ( ( @id_service_interval IS NULL
                                                        OR @id_service_interval <= 0
                                                      )
                                                      OR ( @id_service_interval IS NOT NULL
                                                           AND c2d.id_service_interval = @id_service_interval
                                                         )
                                                    )
				--CITY
                                                AND ( ( @id_city IS NULL
                                                        OR @id_city <= 0
                                                      )
                                                      OR ( @id_city IS NOT NULL
                                                           AND c2d.id_city = @id_city
                                                         )
                                                    )
				--ADDRESS
                                                AND ( @address IS NULL
                                                      OR ( @address IS NOT NULL
                                                           AND c2d.address LIKE '%'
                                                           + @address + '%'
                                                         )
                                                    )
				--CONTACT NAME
                                                AND ( @contact_name IS NULL
                                                      OR ( @contact_name IS NOT NULL
                                                           AND c2d.contact_name LIKE '%'
                                                           + @contact_name
                                                           + '%'
                                                         )
                                                    )
				--ID_SERVICE_ADMIN
                                                AND ( ( @id_service_admin IS NULL
                                                        OR @id_service_admin <= 0
                                                      )
                                                      OR ( @id_service_admin IS NOT NULL
                                                           AND c2d.id_service_admin = @id_service_admin
                                                         )
                                                    )
				--OBJECT NAME
                                                AND ( @object_name IS NULL
                                                      OR ( @object_name IS NOT NULL
                                                           AND c2d.object_name LIKE '%'
                                                           + @object_name
                                                           + '%'
                                                         )
                                                    )
				--</Filter>
                                    ) AS T
                        ) AS tt
                WHERE   ( ( @rows_count IS NULL
                            OR @rows_count <= 0
                          )
                          OR ( @rows_count > 0
                               AND row_num <= @rows_count
                             )
                        )
                ORDER BY tt.row_num
                --ORDER BY t.id_contract2devices DESC
            END
        ELSE
            IF @action = 'getContract2DevicesTotalCount'
                BEGIN
				
                    SELECT  COUNT(1) AS device_count
                    FROM    dbo.srvpl_contract2devices c2d
                            INNER JOIN dbo.srvpl_devices d ON c2d.id_device = d.id_device
                            INNER JOIN dbo.srvpl_contracts c ON c2d.id_contract = c.id_contract
                            INNER JOIN srvpl_device_models dm ON d.id_device_model = dm.id_device_model
                    WHERE   c2d.enabled = 1
                            AND c.enabled = 1
                            AND d.enabled = 1
                            AND
				--//<Filter>
				--id_contractor
                            ( ( @id_contractor IS NULL
                                OR @id_contractor <= 0
                              )
                              OR ( @id_contractor > 0
                                   AND c.id_contractor = @id_contractor
                                 )
                            )
                            AND
				--id_contract
                            ( ( @id_contract IS NULL
                                OR @id_contract <= 0
                              )
                              OR ( @id_contract > 0
                                   AND c2d.id_contract = @id_contract
                                 )
                            )
				--OR @id_contract <= 0
				--MODEL
                            AND ( ( @id_device_model IS NULL
                                    OR @id_device_model <= 0
                                  )
                                  OR ( @id_device_model IS NOT NULL
                                       AND d.id_device_model LIKE @id_device_model
                                     )
                                )
				--SERIAL NUM
                            AND ( @serial_num IS NULL
                                  OR ( @serial_num IS NOT NULL
                                       AND d.serial_num LIKE '%' + @serial_num
                                       + '%'
                                     )
                                )
				--SERVICE INTERVAL
                            AND ( ( @id_service_interval IS NULL
                                    OR @id_service_interval <= 0
                                  )
                                  OR ( @id_service_interval IS NOT NULL
                                       AND c2d.id_service_interval = @id_service_interval
                                     )
                                )
				--CITY
                            AND ( ( @id_city IS NULL
                                    OR @id_city <= 0
                                  )
                                  OR ( @id_city IS NOT NULL
                                       AND c2d.id_city = @id_city
                                     )
                                )
				--ADDRESS
                            AND ( @address IS NULL
                                  OR ( @address IS NOT NULL
                                       AND c2d.address LIKE '%' + @address
                                       + '%'
                                     )
                                )
				--CONTACT NAME
                            AND ( @contact_name IS NULL
                                  OR ( @contact_name IS NOT NULL
                                       AND c2d.contact_name LIKE '%'
                                       + @contact_name + '%'
                                     )
                                )
				--ID_SERVICE_ADMIN
                            AND ( ( @id_service_admin IS NULL
                                    OR @id_service_admin <= 0
                                  )
                                  OR ( @id_service_admin IS NOT NULL
                                       AND c2d.id_service_admin = @id_service_admin
                                     )
                                )
				--OBJECT NAME
                            AND ( @object_name IS NULL
                                  OR ( @object_name IS NOT NULL
                                       AND c2d.object_name LIKE '%'
                                       + @object_name + '%'
                                     )
                                )
				

				
                END
            ELSE
                IF @action = 'getContract2DevicesSelectionList'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END



                        SELECT  c2d.id_contract2devices AS id ,
                                dbo.srvpl_fnc('getDeviceShortCollectedNameNoBr',
                                              NULL, c2d.id_device, NULL, NULL) AS NAME ,
                                dbo.get_city_full_name(c2d.id_city) AS city ,
                                ( SELECT    CASE WHEN locality IS NULL
                                                 THEN name
                                                 ELSE locality
                                            END
                                  FROM      dbo.cities c
                                  WHERE     c.id_city = c2d.id_city
                                ) AS short_city ,
                                c2d.address ,
                                c2d.object_name ,
                                CASE WHEN CONVERT(DATE, c2d.dattim1) = CONVERT(DATE, GETDATE())
                                     THEN 1
                                     ELSE 0
                                END AS is_new
                        FROM    dbo.srvpl_contract2devices c2d
                                INNER JOIN dbo.srvpl_contracts c ON c2d.id_contract = c.id_contract
                                INNER JOIN dbo.srvpl_devices d ON c2d.id_device = d.id_device
                        WHERE   c2d.enabled = 1
                                AND c.enabled = 1
                                AND d.enabled = 1
                                AND
				--id_contract
                                ( ( @id_contract > 0
                                    AND c2d.id_contract = @id_contract
                                  )
                                  OR @id_contract IS NULL
                                )
				--id_device
                                AND ( ( @id_device > 0
                                        AND c2d.id_device = @id_device
                                      )
                                      OR @id_device IS NULL
                                    )
                                --id_city
                                AND ( ( @id_city > 0
                                        AND c2d.id_City = @id_city
                                      )
                                      OR ( @id_city IS NULL
                                           OR @id_city <= 0
                                         )
                                    )
                                 --address
                                AND ( ( @address IS NOT NULL
                                        AND c2d.address = @address
                                      )
                                      OR @address IS NULL
                                    )
				--SERVICE INTERVAL
                                AND ( ( @id_service_interval IS NULL
                                        OR @id_service_interval <= 0
                                      )
                                      OR ( @id_service_interval IS NOT NULL
                                           AND c2d.id_service_interval = @id_service_interval
                                         )
                                    )
                        ORDER BY c2d.dattim1 DESC ,
                                NAME
                    END
                ELSE
                    IF @action = 'getContract2DevicesAddressSelectionList'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END

                            SELECT  c2d.address AS id ,
                                    c2d.address AS NAME
                            FROM    dbo.srvpl_contract2devices c2d
                                    INNER JOIN dbo.srvpl_contracts c ON c.id_contract = c2d.id_contract
                                    INNER JOIN dbo.srvpl_devices d ON d.id_device = c2d.id_device
                            WHERE   c2d.enabled = 1
                                    AND c.enabled = 1
                                    AND d.enabled = 1
                                    AND dbo.srvpl_fnc('checkContractIsActiveNow',
                                                      NULL, c.id_contract,
                                                      NULL, NULL) = '1'
                                    AND ( ( @address IS NULL
                                            OR LTRIM(RTRIM(@address)) = ''
                                          )
                                          OR ( @address IS NOT NULL
                                               AND c2d.ADDRESS LIKE '%'
                                               + @address + '%'
                                             )
                                        )
                                    AND ( ( @id_city IS NULL
                                            OR @id_city <= 0
                                          )
                                          OR ( @id_city > 0
                                               AND c2d.id_city = @id_city
                                             )
                                        )
                                    AND ( ( @id_contractor IS NULL
                                            OR @id_contractor <= 0
                                          )
                                          OR ( @id_contractor > 0
                                               AND c.id_contractor = @id_contractor
                                             )
                                        )
                            GROUP BY c2d.address
                            ORDER BY NAME
                        END
                    ELSE
                        IF @action = 'getContract2DevicesCitiesSelectionList'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END

                                SELECT  id ,
                                        NAME
                                FROM    ( SELECT    c2d.id_city AS id ,
                                                    dbo.get_city_full_name(c2d.id_city) AS NAME
                                          FROM      dbo.srvpl_contract2devices c2d
                                                    INNER JOIN dbo.srvpl_contracts c ON c.id_contract = c2d.id_contract
                                                    INNER JOIN dbo.srvpl_devices d ON d.id_device = c2d.id_device
                                          WHERE     c2d.enabled = 1
                                                    AND c.enabled = 1
                                                    AND d.enabled = 1
                                                    AND dbo.srvpl_fnc('checkContractIsActiveNow',
                                                              NULL,
                                                              c.id_contract,
                                                              NULL, NULL) = '1'
                                                    AND ( ( @address IS NULL
                                                            OR LTRIM(RTRIM(@address)) = ''
                                                          )
                                                          OR ( @address IS NOT NULL
                                                              AND c2d.address LIKE '%'
                                                              + @address + '%'
                                                             )
                                                        )
                                                    AND ( ( @id_contractor IS NULL
                                                            OR @id_contractor <= 0
                                                          )
                                                          OR ( @id_contractor > 0
                                                              AND c.id_contractor = @id_contractor
                                                             )
                                                        )
                                        ) AS t
                                WHERE   --c.enabled = 1 AND 
                                        ( ( @name IS NULL
                                            OR LTRIM(RTRIM(@name)) = ''
                                          )
                                          OR ( @name IS NOT NULL
                                               AND t.NAME LIKE '%' + @name
                                               + '%'
                                             )
                                        )
                                GROUP BY t.id ,
                                        t.NAME
                                ORDER BY t.NAME
                            END
                        ELSE
                            IF @action = 'getContract2DevicesPlanSelectionList'
                                BEGIN
                                    IF @sp_test IS NOT NULL
                                        BEGIN
                                            RETURN
                                        END

                                    SELECT  tt.id_contract2devices ,
                                            tt.id_device ,
                                            tt.id_contract ,
                                            tt.NAME ,
                                            tt.CONTRACT ,
							--ISNULL(RIGHT(CONVERT(VARCHAR, tt.last_claim_date, 106), 8), 'пусто') AS last_claim_date ,
                                            tt.last_claim_date ,
							--ISNULL(CONVERT(NVARCHAR, tt.last_came_date, 104), 'пусто') AS last_came_date ,
                                            tt.last_came_date ,
                                            ISNULL(( DATEDIFF(MONTH,
                                                              tt.last_came_date,
                                                              @planing_date) ),
                                                   0) AS no_service_month_count ,
                                            tt.id_service_interval_plan_group
                                    FROM    ( SELECT    t.id_contract2devices ,
                                                        t.id_device ,
                                                        t.id_contract ,
                                                        t.NAME ,
                                                        t.CONTRACT ,
                                                        ( SELECT
                                                              sc.planing_date
                                                          FROM
                                                              dbo.srvpl_service_claims sc
                                                          WHERE
                                                              sc.id_service_claim = last_claim_id
                                                        ) AS last_claim_date ,
                                                        ( SELECT TOP 1
                                                              sc.date_came
                                                          FROM
                                                              dbo.srvpl_service_cames sc
                                                          WHERE
                                                              sc.enabled = 1
                                                              AND sc.id_service_claim = last_claim_id
                                                        ) AS last_came_date ,
                                                        t.id_service_interval_plan_group
                                              FROM      ( SELECT
                                                              c2d.id_contract2devices ,
                                                              c2d.id_device ,
                                                              c2d.id_contract ,
                                                              dbo.srvpl_fnc('getContract2DevicesShortCollectedName',
                                                              NULL,
                                                              c2d.id_contract2devices,
                                                              NULL, NULL) AS NAME ,
                                                              dbo.srvpl_fnc('getContractCollectedNameNoAmount',
                                                              NULL,
                                                              c2d.id_contract,
                                                              NULL, NULL) AS contract ,
                                                              ( SELECT TOP 1
                                                              scl.id_service_claim
                                                              FROM
                                                              dbo.srvpl_service_claims scl
                                                              WHERE
                                                              scl.enabled = 1
                                                              AND scl.id_device = c2d.id_device
                                                              ORDER BY scl.planing_date DESC ,
                                                              id_service_claim DESC
                                                              ) AS last_claim_id ,
                                                              si.id_service_interval_plan_group
								--,(SELECT si.name FROM dbo.srvpl_service_intervals si WHERE si.id_service_interval = c2d.id_service_interval) AS service_interval
                                                          FROM
                                                              dbo.srvpl_contract2devices c2d
                                                              INNER JOIN dbo.srvpl_devices d ON c2d.id_device = d.id_device
                                                              INNER JOIN dbo.srvpl_contracts c ON c2d.id_contract = c.id_contract
                                                              INNER JOIN dbo.srvpl_service_intervals si ON c2d.id_service_interval = si.id_service_interval
                                                          WHERE
                                                              c2d.enabled = 1
                                                              AND old_id_contract2devices IS NULL
									--id_contract
                                                              AND ( ( @id_contract > 0
                                                              AND c2d.id_contract = @id_contract
                                                              )
                                                              OR @id_contract IS NULL
                                                              )
									--SERVICE INTERVAL
                                                              AND ( ( @id_service_interval IS NULL
                                                              OR @id_service_interval <= 0
                                                              )
                                                              OR ( @id_service_interval IS NOT NULL
                                                              AND c2d.id_service_interval = @id_service_interval
                                                              )
                                                              )
									--SERVICE INTERVAL PLAN GROUP
                                                              AND ( ( @id_service_interval_plan_group IS NULL
                                                              OR @id_service_interval_plan_group <= 0
                                                              )
                                                              OR ( @id_service_interval_plan_group IS NOT NULL
                                                              AND si.id_service_interval_plan_group = @id_service_interval_plan_group
                                                              )
                                                              )
									/********************   NUMBER   **********************/
                                                              AND ( @number IS NULL
                                                              OR ( @number IS NOT NULL
                                                              AND c.number LIKE '%'
                                                              + @number + '%'
                                                              )
                                                              )
									/********************   CONTRACTOR   **********************/
                                                              AND ( ( @id_contractor IS NULL
                                                              OR @id_contractor <= 0
                                                              )
                                                              OR ( @id_contractor IS NOT NULL
                                                              AND c.id_contractor = @id_contractor
                                                              )
                                                              )
									/********************   not_in_plan_list   **********************/
                                                              AND ( ( @not_in_plan_list IS NULL
                                                              OR @not_in_plan_list <= 0
                                                              )
                                                              OR ( @not_in_plan_list = 0 )
                                                              OR ( @not_in_plan_list = 1
                                                              AND NOT EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              srvpl_service_claims scl
                                                              WHERE
                                                              scl.enabled = 1
                                                              AND scl.id_device = c2d.id_device
                                                              AND scl.id_contract = c2d.id_contract
                                                              AND scl.planing_date = @planing_date )
                                                              )
                                                              )
									/********************   ID_SERVICE_ADMIN   **********************/
                                                              AND ( ( @id_service_admin IS NULL
                                                              OR @id_service_admin <= 0
                                                              )
                                                              OR ( @id_service_admin IS NOT NULL
                                                              AND c2d.id_service_admin = @id_service_admin
                                                              )
                                                              )
									--PLANING DATE
									--Выводим активные договоры на это месяц (даже если один день попадает в месяц то договор считается активным
									/*AND (  @planing_date IS NULL
                              OR ( @planing_date IS NOT NULL*/
                                                              AND dbo.srvpl_fnc('checkContractIsActiveOnMonth',
                                                              NULL,
                                                              c2d.id_contract,
                                                              @planing_date,
                                                              NULL) = '1'
									/*)
                            )*/
                                                        ) AS T
                                            ) AS tt
                                    ORDER BY contract ,
                                            no_service_month_count DESC ,
                                            NAME
                                END
                            ELSE
                                IF @action = 'getContract2DevicesIntervalGroupList'
                                    BEGIN
                                        IF @sp_test IS NOT NULL
                                            BEGIN
                                                RETURN
                                            END

                                        SELECT  t.id_contract ,
                                                si.NAME AS service_interval ,
                                                t.COUNT AS [count]
                                        FROM    ( SELECT    c2d.id_contract ,
                                                            c2d.id_service_interval ,
                                                            COUNT(1) AS [COUNT]
                                                  FROM      dbo.srvpl_contract2devices c2d
                                                  WHERE     c2d.enabled = 1
                                                            AND old_id_contract2devices IS NULL
                                                            AND
									--id_contract
                                                            ( @id_contract > 0
                                                              AND c2d.id_contract = @id_contract
                                                            )
                                                            OR @id_contract IS NULL
                                                  GROUP BY  c2d.id_contract ,
                                                            c2d.id_service_interval
                                                ) AS t
                                                INNER JOIN dbo.srvpl_service_intervals si ON t.id_service_interval = si.id_service_interval
                                        ORDER BY [COUNT] DESC
                                    END
                                ELSE
                                    IF @action = 'getContract2DevicesScheduleDates'
                                        BEGIN
                                            IF @sp_test IS NOT NULL
                                                BEGIN
                                                    RETURN
                                                END

                                            SELECT  @id_contract = id_contract ,
                                                    @id_device = id_device
                                            FROM    dbo.srvpl_contract2devices c2d
                                            WHERE   c2d.id_contract2devices = @id_contract2devices

                                            SELECT  planing_date
                                            FROM    dbo.srvpl_service_claims sc
                                            WHERE   sc.enabled = 1
                                                    AND planing_date IS NOT NULL
                                                    AND sc.id_contract = @id_contract
                                                    AND sc.id_device = @id_device
                                            GROUP BY planing_date
                                        END
                                    ELSE
                                        IF @action = 'getContract2DevicesClaimDates'
                                            BEGIN
                                                IF @sp_test IS NOT NULL
                                                    BEGIN
                                                        RETURN
                                                    END

                                                SELECT  @id_contract = id_contract ,
                                                        @id_device = id_device
                                                FROM    dbo.srvpl_contract2devices c2d
                                                WHERE   c2d.id_contract2devices = @id_contract2devices

                                                SELECT  planing_date
                                                FROM    dbo.srvpl_service_claims sc
                                                        INNER JOIN dbo.srvpl_service_cames scam ON sc.id_service_claim = scam.id_service_claim
                                                WHERE   sc.enabled = 1
                                                        AND scam.enabled = 1
                                                        AND planing_date IS NOT NULL
                                                        AND sc.id_contract = @id_contract
                                                        AND sc.id_device = @id_device
                                                GROUP BY planing_date
                                            END
                                        ELSE
                                            IF @action = 'getContract2Devices'
                                                BEGIN
                                                    IF @sp_test IS NOT NULL
                                                        BEGIN
                                                            RETURN
                                                        END
													
                                                    IF @id_contract2devices IS NULL
                                                        AND @id_device IS NOT NULL
                                                        AND @id_contract IS NOT NULL
                                                        BEGIN
                                                            SELECT TOP 1
                                                              @id_contract2devices = id_contract2devices
                                                            FROM
                                                              srvpl_contract2devices c2d
														--INNER join dbo.srvpl_contracts c ON c2d.id_contract = c.id_contract
                                                            WHERE
                                                              c2d.enabled = 1 
														--AND c.enabled = 1
                                                              AND c2d.id_device = @id_device
                                                              AND c2d.id_contract = @id_contract
                                                        END
													
                                                    SELECT  [id_contract2devices] ,
                                                            [id_contract] ,
                                                            [id_device] ,
                                                            [id_service_interval] ,
                                                            [id_city] ,
                                                            [address] ,
                                                            [contact_name] ,
                                                            [comment] ,
                                                            [id_creator] ,
                                                            id_service_admin ,
                                                            object_name ,
                                                            coord ,
                                                            ( SELECT
                                                              c.NAME
                                                              FROM
                                                              dbo.cities c
                                                              WHERE
                                                              c2d.id_city = c.id_city
                                                            ) AS city
                                                    FROM    dbo.srvpl_contract2devices c2d
                                                    WHERE   c2d.id_contract2devices = @id_contract2devices
                                                END
                                            ELSE
                                                IF @action = 'saveContract2Devices'
                                                    BEGIN
                                                        IF @sp_test IS NOT NULL
                                                            BEGIN
                                                              RETURN
                                                            END

                                                        BEGIN TRY
                                                            BEGIN TRANSACTION

                                                            SET @var_str = 'insContract2Devices'

                                                            IF EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_contract2devices t
                                                              WHERE
                                                              t.id_contract2devices = @id_contract2devices )
                                                              BEGIN
                                                              SET @var_str = 'updContract2Devices'
                                                              END

                                                            DECLARE curs
                                                              CURSOR LOCAL
                                                            FOR
                                                              SELECT
                                                              value
                                                              FROM
                                                              dbo.Split(@lst_id_device,
                                                              ',')

                                                            OPEN curs

                                                            FETCH NEXT
												FROM curs
												INTO @id_device

                                                            WHILE @@FETCH_STATUS = 0
                                                              BEGIN
													--Проверяем привязано ли устройство на заданный период
                                                              SELECT
                                                              @date_begin = c.date_begin ,
                                                              @date_end = c.date_end
                                                              FROM
                                                              dbo.srvpl_contracts c
                                                              WHERE
                                                              c.id_contract = @id_contract

                                                              IF EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_contract2devices c2d
                                                              INNER JOIN dbo.srvpl_contracts c ON c2d.id_contract = c.id_contract
                                                              INNER JOIN dbo.srvpl_contract_statuses st ON c.id_contract_status = st.id_contract_status
                                                              WHERE
                                                              c2d.enabled = 1
                                                              AND c.enabled = 1
                                                              AND st.enabled = 1
                                                              AND UPPER(st.sys_name) NOT IN (
                                                              'DEACTIVE' )
                                                              AND c.add_plan_when_deactive = 0
                                                              AND ( c2d.id_device = @id_device
																	--устройство не на текущем договоре попадает в период действия договора
                                                              AND c2d.id_contract != @id_contract
                                                              AND ( CONVERT(DATE, @date_begin) BETWEEN CONVERT(DATE, c.date_begin)
                                                              AND
                                                              CONVERT(DATE, c.date_end)
                                                              OR CONVERT(DATE, @date_end) BETWEEN CONVERT(DATE, c.date_begin)
                                                              AND
                                                              CONVERT(DATE, c.date_end)
                                                              )
																	--добавляют тот же аппарат на тот же договор
                                                              OR ( c2d.id_device = @id_device
                                                              AND c2d.id_contract = @id_contract
                                                              AND ( @id_contract2devices IS NULL
                                                              OR @id_contract2devices <= 0
                                                              )
                                                              )
                                                              ) )
                                                              BEGIN
                                                              IF @@TRANCOUNT > 0
                                                              ROLLBACK TRANSACTION

                                                              SELECT
                                                              @error_text = 'Утсройство ID '
                                                              + CONVERT(NVARCHAR, @id_device)
                                                              + ' уже числится на договоре в заданный период.'

                                                              RAISERROR (
																@error_text
																,16
																,1
																)
                                                              END

                                                              EXEC @id_contract2devices = dbo.sk_service_planing @action = @var_str,
                                                              @id_contract2devices = @id_contract2devices,
                                                              @id_contract = @id_contract,
                                                              @id_device = @id_device,
														--@lst_id_device = @lst_id_device,
                                                              @id_service_interval = @id_service_interval,
                                                              @id_city = @id_city,
                                                              @address = @address,
                                                              @contact_name = @contact_name,
                                                              @comment = @comment,
                                                              @id_creator = @id_creator,
                                                              @id_service_admin = @id_service_admin,
                                                              @object_name = @object_name,
                                                              @coord = @coord
                                                              
                                                              IF @var_str = 'insContract2Devices'
                                                              BEGIN
                                                              SELECT
                                                              @counter = counter ,
                                                              @counter_colour = counter_colour ,
                                                              @cur_date = dattim1 ,
                                                              @id_creator = id_creator
                                                              FROM
                                                              dbo.srvpl_devices
                                                              WHERE
                                                              id_device = @id_device
																
                                                              EXEC dbo.ui_service_planing @action = 'setDeviceData',
                                                              @id_device = @id_device,
                                                              @counter = @counter,
                                                              @counter_colour = @counter_colour,
                                                              @planing_date = @cur_date,
                                                              @id_contract = @id_contract,
                                                              @id_creator = @id_creator,
                                                              @is_sys_admin = @is_sys_admin
                                                              END




                                                              IF @add_scheduled_dates2service_plan = 1
                                                              BEGIN
                                                              
                                                              
                                                              
														--Удаляем ранее заведенные плановые выезды для данного контракта и устройства
                                                              EXEC dbo.sk_service_planing @action = N'closeServiceClaimList',
                                                              @id_contract = @id_contract,
                                                              @id_device = @id_device,
                                                              @id_creator = @id_creator

														--Сохраняем плановые выезды на даты
                                                              EXEC dbo.ui_service_planing @action = 'saveServiceClaim',
                                                              @id_contract2devices = @id_contract2devices,
                                                              @id_contract = @id_contract,
                                                              @id_device = @id_device,
                                                              @lst_schedule_dates = @lst_schedule_dates,
                                                              @id_creator = @id_creator
                                                              END

                                                              FETCH NEXT
													FROM curs
													INTO @id_device
                                                              END

                                                            CLOSE curs

                                                            DEALLOCATE curs

                                                            COMMIT TRANSACTION
                                                        END TRY

                                                        BEGIN CATCH
                                                            IF @@TRANCOUNT > 0
                                                              ROLLBACK TRANSACTION

                                                            SELECT
                                                              @error_text = ERROR_MESSAGE()
                                                              + ' Изменения не были сохранены!'

                                                            RAISERROR (
														@error_text
														,16
														,1
														)
                                                        END CATCH
                                                    END
                                                ELSE
                                                    IF @action = 'closeContract2Devices'
                                                        BEGIN
                                                            IF @sp_test IS NOT NULL
                                                              BEGIN
                                                              RETURN
                                                              END

                                                            EXEC dbo.sk_service_planing @action = N'closeContract2Devices',
                                                              @id_contract2devices = @id_contract2devices,
                                                              @id_creator = @id_creator
                                                        END
                                                    ELSE
                                                        IF @action = 'copyContract2Devices'
                                                            BEGIN
                                                              IF @sp_test IS NOT NULL
                                                              BEGIN
                                                              RETURN
                                                              END

                                                              SELECT
                                                              @id_contract_prolong = id_contract_prolong
                                                              FROM
                                                              dbo.srvpl_contracts c
                                                              WHERE
                                                              id_contract = @id_contract

                                                              DECLARE curs
                                                              CURSOR LOCAL
                                                              FOR
                                                              SELECT
                                                              c2d.id_device
                                                              FROM
                                                              dbo.srvpl_contract2devices c2d
                                                              INNER JOIN dbo.srvpl_devices d ON c2d.id_device = d.id_device
                                                              WHERE
                                                              c2d.enabled = 1
                                                              AND d.enabled = 1
                                                              AND c2d.id_contract = @id_contract_prolong

                                                              OPEN curs

                                                              FETCH NEXT
													FROM curs
													INTO @id_device

                                                              WHILE @@FETCH_STATUS = 0
                                                              BEGIN
                                                              SET @lst_schedule_dates = NULL
                                                              SET @var_str = CONVERT(NVARCHAR, @id_device)

                                                              SELECT TOP 1
                                                              @id_service_interval = id_service_interval ,
                                                              @id_city = id_city ,
                                                              @address = address ,
                                                              @contact_name = contact_name ,
                                                              @comment = comment ,
                                                              @id_service_admin = id_service_admin ,
                                                              @object_name = [object_name] ,
                                                              @coord = coord
                                                              FROM
                                                              dbo.srvpl_contract2devices c2d
                                                              WHERE
                                                              enabled = 1
                                                              AND c2d.id_contract = @id_contract_prolong
                                                              AND c2d.id_device = @id_device

                                                              SELECT
                                                              @per_manth = per_month
                                                              FROM
                                                              dbo.srvpl_service_intervals si
                                                              WHERE
                                                              si.id_service_interval = @id_service_interval

                                                              IF @per_manth > 0
                                                              BEGIN
															--Формируем график обслуживания для данного аппарата
                                                              SELECT
                                                              @date_begin = c.date_begin ,
                                                              @date_end = c.date_end
                                                              FROM
                                                              dbo.srvpl_contracts c
                                                              WHERE
                                                              c.id_contract = @id_contract

                                                              SET @cur_date = @date_begin

                                                              WHILE YEAR(@cur_date) < YEAR(@date_end)
                                                              OR ( YEAR(@cur_date) = YEAR(@date_end)
                                                              AND MONTH(@cur_date) <= MONTH(@date_end)
                                                              )
                                                              BEGIN
                                                              IF NOT EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_contract2devices c2d
                                                              INNER JOIN dbo.srvpl_service_claims sc ON c2d.id_contract2devices = sc.id_contract2devices
                                                              WHERE
                                                              c2d.enabled = 1
                                                              AND c2d.id_contract = @id_contract_prolong
                                                              AND c2d.id_device = @id_device
                                                              AND YEAR(sc.planing_date) = YEAR(@cur_date)
                                                              AND MONTH(sc.planing_date) = MONTH(@cur_date) )
                                                              BEGIN
                                                              SET @lst_schedule_dates = ISNULL(@lst_schedule_dates,
                                                              '') + ','
                                                              + CONVERT(NVARCHAR, @cur_date, 104)
                                                              END

                                                              SET @cur_date = DATEADD(MONTH,
                                                              @per_manth,
                                                              @cur_date)
                                                              END

                                                              SET @lst_schedule_dates = RIGHT(@lst_schedule_dates,
                                                              LEN(@lst_schedule_dates)
                                                              - 1)
                                                              END

														--ELSE
														--  BEGIN
														--  SET @error_text = 'Неверный график обслуживания для аппарата ID'
														--  + CONVERT(NVARCHAR, @id_device) 
														--  RAISERROR (@error_text, 16, 1)	
														--  END 
                                                              EXEC dbo.ui_service_planing @action = N'saveContract2Devices',
                                                              @id_contract = @id_contract,
                                                              @id_creator = @id_creator,
                                                              @lst_id_device = @var_str,
                                                              @id_service_interval = @id_service_interval,
                                                              @id_city = @id_city,
                                                              @address = @address,
                                                              @contact_name = @contact_name,
                                                              @comment = @comment,
                                                              @id_service_admin = @id_service_admin,
                                                              @object_name = @object_name,
                                                              @coord = @coord,
                                                              @add_scheduled_dates2service_plan = 1,
                                                              @lst_schedule_dates = @lst_schedule_dates

                                                              FETCH NEXT
														FROM curs
														INTO @id_device
                                                              END

                                                              CLOSE curs

                                                              DEALLOCATE curs
                                                            END

        

	--=================================
	--DeviceModels
	--=================================	
        IF @action = 'getDeviceModelList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  tt.row_num ,
                        tt.id_device_model ,
                        tt.NAME ,
			--t.name ,
                        tt.nickname ,
                        tt.speed ,
                        tt.id_device_type ,
                        tt.id_device_imprint ,
                        tt.id_cartridge_type ,
                        tt.id_print_type ,
                        tt.dattim1 ,
                        tt.dattim2 ,
                        tt.using_device_count ,
                        tt.max_volume
                FROM    ( SELECT    ROW_NUMBER() OVER ( ORDER BY NAME ) AS row_num ,
                                    t.id_device_model ,
                                    dbo.srvpl_fnc('getDeviceModelCollectedName',
                                                  NULL, t.id_device_model,
                                                  NULL, NULL) AS NAME ,
				--t.name ,
                                    t.nickname ,
                                    speed ,
                                    id_device_type ,
                                    id_device_imprint ,
                                    id_cartridge_type ,
                                    id_print_type ,
                                    t.dattim1 ,
                                    t.dattim2 ,
                                    ( SELECT    COUNT(1)
                                      FROM      dbo.srvpl_contract2devices c2d
                                                INNER JOIN srvpl_devices d ON d.id_device = c2d.id_device
                                      WHERE     c2d.enabled = 1
                                                AND d.id_device_model = t.id_device_model
                                    ) AS using_device_count ,
                                    max_volume
                          FROM      dbo.srvpl_device_models t
                          WHERE     t.enabled = 1
                        ) AS tt
                WHERE   --<Filter
			--Name
                        ( @name IS NULL
                          OR ( @name IS NOT NULL
                               AND tt.NAME LIKE '%' + @name + '%'
                             )
                        )
		--</Filter>
                ORDER BY tt.NAME
            END
        ELSE
            IF @action = 'getDeviceModelSelectionList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    SELECT  t.id ,
                            t.NAME
                    FROM    ( SELECT    dm.id_device_model AS id ,
                                        dbo.srvpl_fnc('getDeviceModelCollectedName',
                                                      NULL, dm.id_device_model,
                                                      NULL, NULL) AS NAME
                              FROM      dbo.srvpl_device_models dm
                              WHERE     dm.enabled = 1
                            ) AS t
                    ORDER BY t.NAME
                END
            ELSE
                IF @action = 'getDeviceModel'
                    BEGIN
                        SELECT  [id_device_model] ,
                                vendor ,
                                [name] ,
                                [nickname] ,
                                speed ,
                                id_device_type ,
                                id_device_imprint ,
                                id_cartridge_type ,
                                id_print_type ,
                                max_volume
                        FROM    dbo.srvpl_device_models dm
                        WHERE   dm.id_device_model = @id_device_model
                    END
                ELSE
                    IF @action = 'saveDeviceModel'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END

                            SET @var_str = 'insDeviceModel'

                            IF EXISTS ( SELECT  1
                                        FROM    dbo.srvpl_device_models t
                                        WHERE   t.id_device_model = @id_device_model )
                                BEGIN
                                    SET @var_str = 'updDeviceModel'
                                END

					--Проверка подобного названия
                            IF EXISTS ( SELECT  1
                                        FROM    srvpl_device_models dm
                                        WHERE   dm.enabled = 1
                                                AND @name IS NOT NULL
                                                AND LEN(@name) > 0
                                                AND
								--Ниже условие отбора имени модели
                                                ( dm.NAME = @name ) )
                                BEGIN
                                    SET @error_text = 'Название модели "'
                                        + @name
                                        + '" не прошло проверку! Попробуйте сохранить другое название.'

                                    RAISERROR (
								@error_text
								,16
								,1
								)

                                    RETURN;
                                END

					--/Проверка
                            EXEC dbo.sk_service_planing @action = @var_str,
                                @id_device_model = @id_device_model,
                                @vendor = @vendor, @name = @name,
                                @nickname = @nickname,
                                @id_creator = @id_creator, @speed = @speed,
                                @id_device_type = @id_device_type,
                                @id_device_imprint = @id_device_imprint,
                                @id_cartridge_type = @id_cartridge_type,
                                @id_print_type = @id_print_type,
                                @max_volume = @max_volume
                        END
                    ELSE
                        IF @action = 'closeDeviceModel'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END

                                EXEC dbo.sk_service_planing @action = N'closeDeviceModel',
                                    @id_device_model = @id_device_model,
                                    @id_creator = @id_creator
                            END

        IF @action = 'getVendorSelectionList'
            BEGIN
                SELECT  dm.vendor AS id ,
                        dm.vendor AS name
                FROM    dbo.srvpl_device_models dm
                WHERE   enabled = 1
                GROUP BY dm.vendor
                ORDER BY dm.vendor
            END


	--=================================
	--DeviceTypes
	--=================================	
        IF @action = 'getDeviceTypeSelectionList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  t.id_device_type AS id ,
                        t.NAME ,
                        t.nickname
                FROM    dbo.srvpl_device_types t
                WHERE   t.enabled = 1
                ORDER BY t.NAME
            END

	--=================================
	--CartridgeTypes
	--=================================	
        IF @action = 'getCartridgeTypeList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  t.NAME ,
                        t.nickname ,
                        t.descr ,
                        t.order_num ,
                        t.dattim1 ,
                        t.dattim2
                FROM    dbo.srvpl_cartridge_types t
                WHERE   t.enabled = 1
            END
        ELSE
            IF @action = 'getCartridgeTypeSelectionList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    SELECT  t.id_cartridge_type AS id ,
                            t.NAME ,
                            t.nickname
                    FROM    dbo.srvpl_cartridge_types t
                    WHERE   t.enabled = 1
                    ORDER BY t.order_num ,
                            t.NAME
                END
            ELSE
                IF @action = 'getCartridgeType'
                    BEGIN
                        SELECT  [id_cartridge_type] ,
                                [name] ,
                                [nickname] ,
                                [descr] ,
                                [order_num]
                        FROM    dbo.srvpl_cartridge_types ct
                        WHERE   ct.id_cartridge_type = @id_cartridge_type
                    END
                ELSE
                    IF @action = 'saveCartridgeType'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END

                            SET @var_str = 'insCartridgeType'

                            IF EXISTS ( SELECT  1
                                        FROM    dbo.srvpl_cartridge_types t
                                        WHERE   t.id_cartridge_type = @id_cartridge_type )
                                BEGIN
                                    SET @var_str = 'updCartridgeType'
                                END

                            EXEC dbo.sk_service_planing @action = @var_str,
                                @id_cartridge_type = @id_cartridge_type,
                                @name = @name, @nickname = @nickname,
                                @descr = @descr, @order_num = @order_num,
                                @id_creator = @id_creator
                        END
                    ELSE
                        IF @action = 'closeCartridgeType'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END

                                EXEC dbo.sk_service_planing @action = N'closeCartridgeType',
                                    @id_cartridge_type = @id_cartridge_type,
                                    @id_creator = @id_creator
                            END

	--=================================
	--ContractStatuses
	--=================================	
        IF @action = 'getContractStatusList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  t.NAME ,
                        t.nickname ,
                        t.descr ,
                        t.order_num ,
                        t.dattim1 ,
                        t.dattim2 ,
                        t.visible
                FROM    dbo.srvpl_contract_statuses t
                WHERE   t.enabled = 1
            END
        ELSE
            IF @action = 'getContractStatusSelectionList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    SELECT  t.id_contract_status AS id ,
                            t.NAME ,
                            t.nickname ,
                            t.visible
                    FROM    dbo.srvpl_contract_statuses t
                    WHERE   t.enabled = 1
                    ORDER BY t.order_num ,
                            t.NAME
                END
            ELSE
                IF @action = 'getContractStatus'
                    BEGIN
                        SELECT  [id_contract_status] ,
                                [name] ,
                                [nickname] ,
                                [descr] ,
                                [order_num] ,
                                cs.visible
                        FROM    dbo.srvpl_contract_statuses cs
                        WHERE   cs.id_contract_status = @id_contract_status
                    END
                ELSE
                    IF @action = 'saveContractStatus'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END

                            SET @var_str = 'insContractStatus'

                            IF EXISTS ( SELECT  1
                                        FROM    dbo.srvpl_contract_statuses t
                                        WHERE   t.id_contract_status = @id_contract_status )
                                BEGIN
                                    SET @var_str = 'updContractStatus'
                                END

                            EXEC dbo.sk_service_planing @action = @var_str,
                                @id_contract_status = @id_contract_status,
                                @name = @name, @nickname = @nickname,
                                @descr = @descr, @order_num = @order_num,
                                @id_creator = @id_creator
                        END
                    ELSE
                        IF @action = 'closeContractStatus'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END

                                EXEC dbo.sk_service_planing @action = N'closeContractStatus',
                                    @id_contract_status = @id_contract_status,
                                    @id_creator = @id_creator
                            END                            

	--=================================
	--ContractTypes
	--=================================	
        IF @action = 'getContractTypeList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  t.NAME ,
                        t.nickname ,
                        t.descr ,
                        t.order_num ,
                        t.dattim1 ,
                        t.dattim2
                FROM    dbo.srvpl_contract_types t
                WHERE   t.enabled = 1
            END
        ELSE
            IF @action = 'getContractTypeSelectionList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    SELECT  t.id_contract_type AS id ,
                            t.NAME ,
                            t.nickname
                    FROM    dbo.srvpl_contract_types t
                    WHERE   t.enabled = 1
                    ORDER BY t.order_num ,
                            t.NAME
                END
            ELSE
                IF @action = 'getContractType'
                    BEGIN
                        SELECT  [id_contract_type] ,
                                [name] ,
                                [nickname] ,
                                [descr] ,
                                [order_num]
                        FROM    dbo.srvpl_contract_types ct
                        WHERE   ct.id_contract_type = @id_contract_type
                    END
                ELSE
                    IF @action = 'saveContractType'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END

                            SET @var_str = 'insContractType'

                            IF EXISTS ( SELECT  1
                                        FROM    dbo.srvpl_contract_types t
                                        WHERE   t.id_contract_type = @id_contract_type )
                                BEGIN
                                    SET @var_str = 'updContractType'
                                END

                            EXEC dbo.sk_service_planing @action = @var_str,
                                @id_contract_type = @id_contract_type,
                                @name = @name, @nickname = @nickname,
                                @descr = @descr, @order_num = @order_num,
                                @id_creator = @id_creator
                        END
                    ELSE
                        IF @action = 'closeContractType'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END

                                EXEC dbo.sk_service_planing @action = N'closeContractType',
                                    @id_contract_type = @id_contract_type,
                                    @id_creator = @id_creator
                            END

	--=================================
	--DeviceImprints
	--=================================	
        IF @action = 'getDeviceImprintList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  t.NAME ,
                        t.nickname ,
                        t.descr ,
                        t.order_num ,
                        t.dattim1 ,
                        t.dattim2
                FROM    dbo.srvpl_device_imprints t
                WHERE   t.enabled = 1
            END
        ELSE
            IF @action = 'getDeviceImprintSelectionList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    SELECT  t.id_device_imprint AS id ,
                            t.NAME ,
                            t.nickname
                    FROM    dbo.srvpl_device_imprints t
                    WHERE   t.enabled = 1
                    ORDER BY t.order_num ,
                            t.NAME
                END
            ELSE
                IF @action = 'getDeviceImprint'
                    BEGIN
                        SELECT  [id_device_imprint] ,
                                [name] ,
                                [nickname] ,
                                [descr] ,
                                [order_num]
                        FROM    dbo.srvpl_device_imprints di
                        WHERE   di.id_device_imprint = @id_device_imprint
                    END
                ELSE
                    IF @action = 'saveDeviceImprint'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END

                            SET @var_str = 'insDeviceImprint'

                            IF EXISTS ( SELECT  1
                                        FROM    dbo.srvpl_device_imprints t
                                        WHERE   t.id_device_imprint = @id_device_imprint )
                                BEGIN
                                    SET @var_str = 'updDeviceImprint'
                                END

                            EXEC dbo.sk_service_planing @action = @var_str,
                                @id_device_imprint = @id_device_imprint,
                                @name = @name, @nickname = @nickname,
                                @descr = @descr, @order_num = @order_num,
                                @id_creator = @id_creator
                        END
                    ELSE
                        IF @action = 'closeDeviceImprint'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END

                                EXEC dbo.sk_service_planing @action = N'closeDeviceImprint',
                                    @id_device_imprint = @id_device_imprint,
                                    @id_creator = @id_creator
                            END

	--=================================
	--DeviceOptions
	--=================================	
        IF @action = 'getDeviceOptionList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  t.NAME ,
                        t.nickname ,
                        t.descr ,
                        t.order_num ,
                        t.dattim1 ,
                        t.dattim2
                FROM    dbo.srvpl_device_options t
                WHERE   t.enabled = 1
            END
        ELSE
            IF @action = 'getDeviceOptionSelectionList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    SELECT  t.id_device_option AS id ,
                            t.NAME ,
                            t.nickname
                    FROM    dbo.srvpl_device_options t
                    WHERE   t.enabled = 1
                    ORDER BY t.order_num ,
                            t.NAME
                END
            ELSE
                IF @action = 'getDeviceOption'
                    BEGIN
                        SELECT  [id_device_option] ,
                                [name] ,
                                [nickname] ,
                                [descr] ,
                                [order_num]
                        FROM    dbo.srvpl_device_options do
                        WHERE   do.id_device_option = @id_device_option
                    END
                ELSE
                    IF @action = 'saveDeviceOption'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END

                            SET @var_str = 'insDeviceOption'

                            IF EXISTS ( SELECT  1
                                        FROM    dbo.srvpl_device_options t
                                        WHERE   t.id_device_option = @id_device_option )
                                BEGIN
                                    SET @var_str = 'updDeviceOption'
                                END

                            EXEC dbo.sk_service_planing @action = @var_str,
                                @id_device_option = @id_device_option,
                                @name = @name, @nickname = @nickname,
                                @descr = @descr, @order_num = @order_num,
                                @id_creator = @id_creator
                        END
                    ELSE
                        IF @action = 'closeDeviceOption'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END

                                EXEC dbo.sk_service_planing @action = N'closeDeviceOption',
                                    @id_device_option = @id_device_option,
                                    @id_creator = @id_creator
                            END

	--=================================
	--Device2Options
	--=================================	
        IF @action = 'getDevice2OptionsList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  t.id_device2option ,
                        t.id_device ,
                        t.id_device_option
                FROM    dbo.srvpl_device2options t
                WHERE   t.enabled = 1
			--ID DEVICE
                        AND ( ( @id_device IS NULL
                                OR @id_device <= 0
                              )
                              OR ( @id_device IS NOT NULL
                                   AND t.id_device = @id_device
                                 )
                            )
            END
        ELSE
            IF @action = 'getDevice2OptionsSelectionList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    SELECT  t.id_device2option AS id ,
                            t.id_device AS NAME
                    FROM    dbo.srvpl_device2options t
                    WHERE   t.enabled = 1
                END
            ELSE
                IF @action = 'getDevice2Options'
                    BEGIN
                        SELECT  [id_device2option] ,
                                [id_device] ,
                                [id_device_option]
                        FROM    dbo.srvpl_device2options d2o
                        WHERE   d2o.id_device2option = @id_device2option
                    END
                ELSE
                    IF @action = 'saveDevice2Options'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END

                            SET @var_str = 'insDevice2Options'

                            IF EXISTS ( SELECT  1
                                        FROM    dbo.srvpl_device2options t
                                        WHERE   t.id_device2option = @id_device2option )
                                BEGIN
                                    SET @var_str = 'updDevice2Options'
                                END

                            EXEC dbo.sk_service_planing @action = @var_str,
                                @id_device2option = @id_device2option,
                                @id_device = @id_device,
                                @id_device_option = @id_device_option,
                                @id_creator = @id_creator
                        END
                    ELSE
                        IF @action = 'closeDevice2Options'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END

                                EXEC dbo.sk_service_planing @action = N'closeDevice2Options',
                                    @id_device2option = @id_device2option,
                                    @id_creator = @id_creator
                            END
                        ELSE
                            IF @action = 'closeAllOptions4Device'
                                BEGIN
                                    IF @sp_test IS NOT NULL
                                        BEGIN
                                            RETURN
                                        END

                                    EXEC dbo.sk_service_planing @action = 'closeDevice2Options4Device',
                                        @id_device = @id_device,
                                        @id_creator = @id_creator
                                END

	--=================================
	--PrintTypes
	--=================================	
        IF @action = 'getPrintTypeList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  t.NAME ,
                        t.nickname ,
                        t.descr ,
                        t.order_num ,
                        t.dattim1 ,
                        t.dattim2
                FROM    dbo.srvpl_print_types t
                WHERE   t.enabled = 1
            END
        ELSE
            IF @action = 'getPrintTypeSelectionList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    SELECT  t.id_print_type AS id ,
                            t.NAME ,
                            t.nickname
                    FROM    dbo.srvpl_print_types t
                    WHERE   t.enabled = 1
                    ORDER BY t.order_num ,
                            t.NAME
                END
            ELSE
                IF @action = 'getPrintType'
                    BEGIN
                        SELECT  [id_print_type] ,
                                [name] ,
                                [nickname] ,
                                [descr] ,
                                [order_num]
                        FROM    dbo.srvpl_print_types pt
                        WHERE   pt.id_print_type = @id_print_type
                    END
                ELSE
                    IF @action = 'savePrintType'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END

                            SET @var_str = 'insPrintType'

                            IF EXISTS ( SELECT  1
                                        FROM    dbo.srvpl_print_types t
                                        WHERE   t.id_print_type = @id_print_type )
                                BEGIN
                                    SET @var_str = 'updPrintType'
                                END

                            EXEC dbo.sk_service_planing @action = @var_str,
                                @id_print_type = @id_print_type, @name = @name,
                                @nickname = @nickname, @descr = @descr,
                                @order_num = @order_num,
                                @id_creator = @id_creator
                        END
                    ELSE
                        IF @action = 'closePrintType'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END

                                EXEC dbo.sk_service_planing @action = N'closePrintType',
                                    @id_print_type = @id_print_type,
                                    @id_creator = @id_creator
                            END

	--=================================
	--ServiceActionTypes
	--=================================	
        IF @action = 'getServiceActionTypeList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  t.NAME ,
                        t.nickname ,
                        t.descr ,
                        t.order_num ,
                        t.dattim1 ,
                        t.dattim2
                FROM    dbo.srvpl_service_action_types t
                WHERE   t.enabled = 1
            END
        ELSE
            IF @action = 'getServiceActionTypeSelectionList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    SELECT  t.id_service_action_type AS id ,
                            t.NAME ,
                            t.nickname
                    FROM    dbo.srvpl_service_action_types t
                    WHERE   t.enabled = 1
                    ORDER BY t.order_num ,
                            t.NAME
                END
            ELSE
                IF @action = 'getServiceActionType'
                    BEGIN
                        SELECT  [id_service_action_type] ,
                                [name] ,
                                [nickname] ,
                                [descr] ,
                                [order_num]
                        FROM    dbo.srvpl_service_action_types sat
                        WHERE   sat.id_service_action_type = @id_service_action_type
                    END
                ELSE
                    IF @action = 'saveServiceActionType'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END

                            SET @var_str = 'insServiceActionType'

                            IF EXISTS ( SELECT  1
                                        FROM    dbo.srvpl_service_action_types t
                                        WHERE   t.id_service_action_type = @id_service_action_type )
                                BEGIN
                                    SET @var_str = 'updServiceActionType'
                                END

                            EXEC dbo.sk_service_planing @action = @var_str,
                                @id_service_action_type = @id_service_action_type,
                                @name = @name, @nickname = @nickname,
                                @descr = @descr, @order_num = @order_num,
                                @id_creator = @id_creator
                        END
                    ELSE
                        IF @action = 'closeServiceActionType'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END

                                EXEC dbo.sk_service_planing @action = N'closeServiceActionType',
                                    @id_service_action_type = @id_service_action_type,
                                    @id_creator = @id_creator
                            END

	--=================================
	--ServiceCames
	--=================================	
        IF @action = 'getServiceCameList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT /*id_service_came ,
                sc.id_contract,
                sc.id_device,
                        c.number AS contract_num ,
                --d.NAME AS device,
                        --date_came ,
                        --date_claim,
                        st.name AS service_type ,
                --sat.name AS service_action_type,
                        claim_num ,
                        sc.descr ,
                        u.display_name AS service_engeneer ,
                        uu.display_name AS creator
                        ,(SELECT name_inn FROM dbo.get_contractor(c.id_contractor)) as contractor*/
                        sc.id_service_came
                FROM    dbo.srvpl_service_cames sc
                        INNER JOIN srvpl_service_claims cl ON sc.id_service_claim = cl.id_service_claim
                WHERE   sc.enabled = 1
			/*****************  FILTERS  ****************/
			--ID_CONTRACTOR
			/*AND ( ( @id_contractor IS NULL
                                            OR @id_contractor <= 0
                                          )
                                          OR ( @id_contractor IS NOT NULL
                                               AND c.id_contractor = @id_contractor
                                             )
                                        )   
                --ID_DEVICE
                AND ( ( @id_device IS NULL
                                            OR @id_device <= 0
                                          )
                                          OR ( @id_device IS NOT NULL
                                               AND sc.id_device = @id_device
                                             )
                                        )                          
                --claim_num
                AND ( @claim_num IS NULL
                                          OR ( @claim_num IS NOT NULL
                                               AND sc.claim_num like '%' + @claim_num + '%'
                                             )
                                        )  
                --number
                AND ( @number IS NULL
                                          OR ( @number IS NOT NULL
                                               AND c.number like '%' + @number + '%'
                                             )
                                        )                          
                --id_service_type
                AND ( ( @id_service_type IS NULL
                                            OR @id_service_type <= 0
                                          )
                                          OR ( @id_service_type IS NOT NULL
                                               AND sc.id_service_type = @id_service_type
                                             )
                                        )    
                --id_service_action_type
                AND ( ( @id_service_action_type IS NULL
                                            OR @id_service_action_type <= 0
                                          )
                                          OR ( @id_service_action_type IS NOT NULL
                                               AND sc.id_service_action_type = @id_service_action_type
                                             )
                                        )                           
                 --id_service_engeneer
                AND ( ( @id_service_engeneer IS NULL
                                            OR @id_service_engeneer <= 0
                                          )
                                          OR ( @id_service_engeneer IS NOT NULL
                                               AND sc.id_service_engeneer = @id_service_engeneer
                                             )
                                        )                         
                 --id_creator
                AND ( ( @id_creator IS NULL
                                            OR @id_creator <= 0
                                          )
                                          OR ( @id_creator IS NOT NULL
                                               AND sc.id_creator = @id_creator
                                             )
                                        )                                               
                --date_claim_begin
                                    AND ( @date_claim_begin IS NULL
                                          OR ( @date_claim_begin IS NOT NULL
                                               AND CONVERT(DATE, sc.date_claim) >= CONVERT(DATE, @date_claim_begin)
                                             )
                                        )   
                --date_claim_end
                                    AND ( @date_claim_end IS NULL
                                          OR ( @date_claim_end IS NOT NULL
                                               AND CONVERT(DATE, sc.date_claim) <= CONVERT(DATE, @date_claim_end)
                                             )
                                        )     
                --date_came_begin
                                    AND ( @date_came_begin IS NULL
                                          OR ( @date_came_begin IS NOT NULL
                                               AND CONVERT(DATE, sc.date_came) >= CONVERT(DATE, @date_came_begin)
                                             )
                                        )   
                --date_came_end
                                    AND ( @date_came_end IS NULL
                                          OR ( @date_came_end IS NOT NULL
                                               AND CONVERT(DATE, sc.date_came) <= CONVERT(DATE, @date_came_end)
                                             )
                                        )   
                /***************** /FILTERS  ****************/
               
                
                */
            END
        ELSE
            IF @action = 'getServiceCameSelectionList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    SELECT  t.id_service_came AS id ,
                            t.id_service_claim AS NAME
                    FROM    dbo.srvpl_service_cames t
                    WHERE   t.enabled = 1
                END
            ELSE
                IF @action = 'getServiceCame'
                    BEGIN
                        SELECT  id_service_came ,
                                id_service_claim ,
                                date_came ,
                                descr ,
                                counter ,
                                id_service_engeneer ,
                                id_service_action_type ,
                                id_creator ,
                                counter_colour ,
                                id_akt_scan
                        FROM    dbo.srvpl_service_cames sc
                        WHERE   sc.id_service_came = @id_service_came
                    END
                ELSE
                    IF @action = 'saveServiceCame'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END

                            SET @var_str = 'insServiceCame'

                            IF EXISTS ( SELECT  1
                                        FROM    dbo.srvpl_service_cames t
                                        WHERE   t.id_service_came = @id_service_came )
                                BEGIN
                                    SET @var_str = 'updServiceCame'
                                END
							
                            DECLARE @prev_counter INT ,
                                @prev_counter_colour INT ,
                                @prev_total_counter INT ,
                                @prev_date DATETIME ,
                                @cur_total_counter INT
                            
                            SELECT  @id_device = id_device ,
                                    @id_contract = id_contract
                            FROM    dbo.srvpl_service_claims cl
                            WHERE   cl.id_service_claim = @id_service_claim    
                            		
                            --Если сохраняем акт для договора у которого ограничение (минимум) по количеству обслуживаний в месяц, то проверяем введен ли полный серийный номер аппарата или нет
                            IF @serial_num IS NOT NULL
                                AND LTRIM(RTRIM(@serial_num)) <> ''
                                AND NOT EXISTS ( SELECT 1
                                                 FROM dbo.srvpl_contract2devices c2d INNER JOIN dbo.srvpl_devices d ON c2d.id_device = d.id_device
                                                 WHERE  d.enabled = 1 AND c2d.enabled=1 AND c2d.id_contract=@id_contract
                                                        AND d.serial_num = LTRIM(RTRIM(@serial_num)) )
                                AND EXISTS ( SELECT 1
                                             FROM   dbo.srvpl_contract2devices c2d
                                                    INNER JOIN dbo.srvpl_contracts c ON c2d.id_contract = c.id_contract
                                                    INNER JOIN dbo.srvpl_devices d ON c2d.id_device = d.id_device
                                             WHERE  c2d.enabled = 1
                                                    AND c.enabled = 1
                                                    AND d.enabled = 1
                                                    AND c.id_contract = @id_contract
                                                    AND c.handling_devices IS NOT NULL
                                                    AND c.handling_devices > 0
                                                    AND d.serial_num = LTRIM(RTRIM(@serial_num)) )
                                BEGIN
                                    SELECT  @error_text = 'Изменения не были сохранены! Указанный Вами серийный номер не полный'

                                    RAISERROR (
								@error_text
								,16
								,1
								)
								
                                    RETURN
                                END
                                --Если ввели полный серийник, то 
                            ELSE
                                IF @serial_num IS NOT NULL
                                    AND LTRIM(RTRIM(@serial_num)) <> ''
                                    AND EXISTS ( SELECT 1
                                                 FROM   dbo.srvpl_contract2devices c2d
                                                        INNER JOIN dbo.srvpl_contracts c ON c2d.id_contract = c.id_contract
                                                        INNER JOIN dbo.srvpl_devices d ON c2d.id_device = d.id_device
                                                 WHERE  c2d.enabled = 1
                                                        AND c.enabled = 1
                                                        AND d.enabled = 1
                                                        AND c.id_contract = @id_contract
                                                        AND c.handling_devices IS NOT NULL
                                                        AND c.handling_devices > 0
                                                        AND d.serial_num = @serial_num )
                                    BEGIN
                                --переназначаем выезд на этот серийник и сохраняем к нему акт
                                        SELECT  @id_device = id_device
                                        FROM    dbo.srvpl_devices d
                                        WHERE   d.enabled = 1
                                                AND d.serial_num = @serial_num
                                                
                                        EXEC sk_service_planing @action = 'updServiceCameDevice',
                                            @id_service_claim = @id_service_claim,
                                            @id_device = @id_device 
                                    END
                                
                            					
							--Если переданный счетчик меньше старого то выдаем ошибку
                            SELECT TOP 1
                                    @prev_date = [date] ,
                                    @prev_counter = [counter] ,
                                    @prev_counter_colour = counter_colour ,
                                    @prev_total_counter = ISNULL([counter], 0)
                                    + ISNULL(counter_colour, 0)
                            FROM    ( SELECT    date_came AS [date] ,
                                                counter ,
                                                counter_colour
                                      FROM      dbo.srvpl_service_cames c
                                                INNER JOIN dbo.srvpl_service_claims cl ON c.id_service_claim = cl.id_service_claim
                                      WHERE     c.enabled = 1
                                                AND cl.enabled = 1
                                                AND cl.id_device = @id_device
                                                AND c.date_came <= @date_came
                                      UNION ALL
                                      SELECT    r.date_request ,
                                                counter ,
                                                counter_color
                                      FROM      dbo.snmp_requests r
                                      WHERE     r.id_device = @id_device
                                                AND r.date_request <= @date_came
                                    ) AS t
                            ORDER BY [date] DESC
							
                            SET @cur_total_counter = ( ISNULL(@counter, 0)
                                                       + ISNULL(@counter_colour,
                                                              0) )
							--Админ системы может менять покзания счетчика (т.к. операторы совершают ошибки)
                            IF @is_sys_admin <> 1
                                AND @cur_total_counter < ISNULL(@prev_total_counter,
                                                              0)
                                BEGIN
                                    SELECT  @error_text = 'Изменения не были сохранены! Указанный Вами счетчик ('
                                            + CONVERT(NVARCHAR, @cur_total_counter)
                                            + ' от '
                                            + CONVERT(NVARCHAR, @date_came, 104)
                                            + ') меньше предыдущих данных ('
                                            + CONVERT(NVARCHAR, @prev_total_counter)
                                            + ' от '
                                            + CONVERT(NVARCHAR, @prev_date, 104)
                                            + ')'

                                    RAISERROR (
								@error_text
								,16
								,1
								)
								
                                    RETURN
                                END	
                                
                            DECLARE @last_tot_counter INT ,
                                @id_service_came_for_delete INT
                                
                                --Если переданный счетчик меньше старого то выдаем ошибку
                            SELECT TOP 1
                                    @last_tot_counter = ISNULL([counter], 0)
                                    + ISNULL(counter_colour, 0) ,
                                    @id_service_came_for_delete = id_service_came
                            FROM    ( SELECT    date_came AS [date] ,
                                                counter ,
                                                counter_colour ,
                                                c.id_service_came
                                      FROM      dbo.srvpl_service_cames c
                                                INNER JOIN dbo.srvpl_service_claims cl ON c.id_service_claim = cl.id_service_claim
                                      WHERE     c.enabled = 1
                                                AND cl.enabled = 1
                                                AND cl.id_device = @id_device
                                                AND c.date_came <= @date_came
                                      UNION ALL
                                      SELECT    r.date_request ,
                                                counter ,
                                                counter_color ,
                                                NULL AS id_service_came
                                      FROM      dbo.snmp_requests r
                                      WHERE     r.id_device = @id_device
                                                AND r.date_request <= @date_came
                                    ) AS t
                            ORDER BY [date] DESC
                                
                                --Если админ меняеn счетчик на меньший, то больший удаляем
                            IF @is_sys_admin = 1
                                AND @cur_total_counter < ISNULL(@last_tot_counter,
                                                              0)
                                BEGIN
									
									
                                    IF @id_service_came_for_delete IS NOT NULL
                                        BEGIN
                                            EXEC dbo.ui_service_planing @action = N'closeServiceCame',
                                                @id_service_came = @id_service_came_for_delete,
                                                @id_creator = @id_creator
                                        END
                                END			
								
                            BEGIN TRY
                                BEGIN TRANSACTION
								
                                EXEC dbo.sk_service_planing @action = @var_str,
                                    @id_service_came = @id_service_came,
                                    @id_service_claim = @id_service_claim,
                                    @date_came = @date_came, @descr = @descr,
                                    @counter = @counter,
                                    @id_service_engeneer = @id_service_engeneer,
                                    @id_service_action_type = @id_service_action_type,
                                    @id_creator = @id_creator,
                                    @counter_colour = @counter_colour,
                                    @id_akt_scan = @id_akt_scan
								
                                IF NOT EXISTS ( SELECT  1
                                                FROM    dbo.srvpl_akt_scans
                                                WHERE   id_akt_scan = @id_akt_scan
                                                        AND cames_add = 1 )
                                    BEGIN						
                                        DECLARE @curr_date DATETIME = GETDATE()
		
                                        EXEC dbo.sk_service_planing @action = 'updAktScan',
                                            @id_akt_scan = @id_akt_scan,
                                            @cames_add = 1,
                                            @date_cames_add = @curr_date,
                                            @id_adder = @id_creator
                                    END
								
						--Меняем статус заявки на "Обслужено"
                                SELECT  @id_service_claim_status = id_service_claim_status
                                FROM    dbo.srvpl_service_claim_statuses scs
                                WHERE   scs.enabled = 1
                                        AND LOWER(scs.SYSNAME) = LOWER('DONE')

                                EXEC dbo.sk_service_planing @action = 'updServiceClaim',
                                    @id_service_claim = @id_service_claim,
                                    --Меняем инженера в плане на того кто обслужил фактически
                                    @id_service_engeneer = @id_service_engeneer,
                                    @id_service_claim_status = @id_service_claim_status,
                                    @id_creator = @id_creator

						--Меняем показания счетчика у устройства
                                SELECT  @id_device = id_device
                                FROM    dbo.srvpl_service_claims sc
                                WHERE   sc.id_service_claim = @id_service_claim

                                EXEC dbo.sk_service_planing @action = 'updDevice',
                                    @id_device = @id_device,
                                    @counter = @counter,
                                    @counter_colour = @counter_colour
                                
                                --Находим текущий договор
                                SELECT  @id_contract = sc.id_contract
                                FROM    dbo.srvpl_service_claims sc
                                        --INNER JOIN dbo.srvpl_service_cames cam ON sc.id_service_claim = cam.id_service_claim
                                WHERE   sc.id_service_claim = @id_service_claim
                                
                                EXEC dbo.ui_service_planing @action = 'setDeviceData',
                                    @id_device = @id_device,
                                    @counter = @counter,
                                    @counter_colour = @counter_colour,
                                    @planing_date = @date_came,
                                    @id_creator = @id_creator,
                                    @id_contract = @id_contract,
                                    @is_sys_admin = @is_sys_admin

                                COMMIT TRANSACTION
                            END TRY

                            BEGIN CATCH
                                IF @@TRANCOUNT > 0
                                    ROLLBACK TRANSACTION

                                SELECT  @error_text = ERROR_MESSAGE()
                                        + ' Изменения не были сохранены!'

                                RAISERROR (
								@error_text
								,16
								,1
								)
                            END CATCH
                        END
                    ELSE
                        IF @action = 'closeServiceCame'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END
                                BEGIN TRY
                                    BEGIN TRANSACTION

                                    EXEC dbo.sk_service_planing @action = N'closeServiceCame',
                                        @id_service_came = @id_service_came,
                                        @id_creator = @id_creator
                                    
                                    SELECT  @id_contract = id_contract ,
                                            @id_device = id_device
                                    FROM    dbo.srvpl_service_claims cl
                                            INNER JOIN dbo.srvpl_service_cames cam ON cl.id_service_claim = cam.id_service_claim
                                    WHERE   cam.id_service_came = @id_service_came
                                    
                                
                                    EXEC ui_service_planing @action = 'refillDaviceData',
                                        @id_contract = @id_contract,
                                        @id_device = @id_device,
                                        @id_creator = -1
                                    COMMIT TRANSACTION
                                END TRY

                                BEGIN CATCH
                                    IF @@TRANCOUNT > 0
                                        ROLLBACK TRANSACTION

                                    SELECT  @error_text = ERROR_MESSAGE()
                                            + ' Изменения не были сохранены!'

                                    RAISERROR (
								@error_text
								,16
								,1
								)
                                END CATCH
                                
                            END

	--=================================
	--ServiceClaims
	--=================================	
        IF @action = 'getServiceClaimList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  *
                FROM    ( SELECT    ROW_NUMBER() OVER ( ORDER BY t.id_service_claim DESC ) AS row_num ,
                                    t.id_service_claim ,
                                    t.id_contract ,
                                    t.id_device ,
                                    t.contract_number ,
                                    t.model ,
                                    t.planing_date ,
                                    t.descr ,
                                    t.creator ,
                                    t.claim_status ,
                                    t.id_service_claim_status ,
                                    t.contractor ,
                                    ( CASE WHEN service_engeneer_fact IS NULL
                                           THEN ISNULL(service_engeneer_plan,
                                                       'не указано')
                                           ELSE service_engeneer_fact
                                      END ) AS service_engeneer ,
                                    t.device ,
                                    t.id_service_engeneer_plan ,
                                    id_contract2devices ,
                                    t.id_service_came ,
                                    ( SELECT TOP 1
                                                date_came
                                      FROM      dbo.srvpl_service_cames scam
                                      WHERE     scam.id_service_came = t.id_service_came
                                    ) AS date_came ,
                                    ( CASE WHEN id_service_came > 0 THEN 1
                                           ELSE 0
                                      END ) AS has_came ,
                                    t.ADDRESS ,
                                    city ,
                                    contract_date_end ,
                                    show_date_end ,
                                    serial_num ,
                                    inv_num ,
                                    [object_name]
			--,per_month
                          FROM      ( SELECT    id_service_claim ,
                                                sc.id_contract ,
                                                sc.id_device ,
                                                c.number AS contract_number ,
                                                dbo.srvpl_fnc('getDeviceModelShortCollectedName',
                                                              NULL,
                                                              d.id_device_model,
                                                              NULL, NULL) AS model ,
                                                sc.planing_date ,
                                                sc.descr ,
                                                ( SELECT    u.display_name
                                                  FROM      users u
                                                  WHERE     u.id_user = sc.id_service_engeneer
                                                ) AS service_engeneer_plan ,
                                                sc.id_service_engeneer AS id_service_engeneer_plan ,
                                                ( SELECT    u.display_name
                                                  FROM      users u
                                                  WHERE     u.id_user = ( SELECT TOP 1
                                                              id_service_engeneer
                                                              FROM
                                                              srvpl_service_cames scc
                                                              WHERE
                                                              scc.enabled = 1
                                                              AND scc.id_service_claim = sc.id_service_claim
                                                              )
                                                ) AS service_engeneer_fact ,
                                                ( SELECT    u.display_name
                                                  FROM      users u
                                                  WHERE     sc.id_creator = u.id_user
                                                ) AS creator ,
                                                CASE WHEN @show_inn = 1
                                                     THEN c.contractor_name
                                                          + '(ИНН '
                                                          + c.contractor_inn
                                                          + ')'
                                                     ELSE c.contractor_name
                                                END AS contractor ,
                                                scs.SYSNAME AS claim_status ,
                                                sc.id_service_claim_status ,
                                                sc.id_contract2devices ,
                                                dbo.srvpl_fnc('getContract2DevicesShortCollectedName',
                                                              NULL,
                                                              sc.id_contract2devices,
                                                              NULL, NULL) AS device ,
                                                ( SELECT TOP 1
                                                            id_service_came
                                                  FROM      dbo.srvpl_service_cames scam
                                                  WHERE     scam.enabled = 1
                                                            AND scam.id_service_claim = sc.id_service_claim
                                                  ORDER BY  dattim1 DESC
                                                ) AS id_service_came ,
                                                c2d.address ,
                                                dbo.get_city_full_name(c2d.id_city) AS city ,
                                                c.date_end AS contract_date_end ,
                                                CASE WHEN DATEDIFF(MONTH,
                                                              GETDATE(),
                                                              c.date_end) < 1
                                                     THEN 1
                                                     ELSE 0
                                                END AS show_date_end ,
                                                d.serial_num ,
                                                d.inv_num ,
                                                c2d.[object_name]
				--,si.per_month
                                      FROM      dbo.srvpl_service_claims sc
                                                INNER JOIN dbo.srvpl_service_claim_statuses scs ON sc.id_service_claim_status = scs.id_service_claim_status
                                                INNER JOIN dbo.srvpl_contracts c ON sc.id_contract = c.id_contract
                                                INNER JOIN dbo.srvpl_devices d ON sc.id_device = d.id_device
                                                INNER JOIN dbo.srvpl_device_models dm ON d.id_device_model = dm.id_device_model
                                                INNER JOIN dbo.srvpl_contract2devices c2d ON c2d.id_contract2devices = sc.id_contract2devices
                                                --INNER JOIN dbo.users u ON sc.id_creator = u.id_user
				--INNER JOIN dbo.srvpl_service_intervals si ON c2d.id_service_interval = si.id_service_interval
                                      WHERE     sc.enabled = 1
                                                AND c2d.enabled = 1
                                                AND c.enabled = 1
                                                AND d.enabled = 1
					/*****************  FILTERS  ****************/
					--Id_claim
                                                AND ( @lst_id_service_claim IS NULL
                                                      OR ( @lst_id_service_claim IS NOT NULL
                                                           AND sc.id_service_claim IN (
                                                           SELECT
                                                              value
                                                           FROM
                                                              dbo.Split(@lst_id_service_claim,
                                                              ',') )
                                                         )
                                                    )
					--ID_CONTRACTOR
                                                AND ( ( @id_contractor IS NULL
                                                        OR @id_contractor <= 0
                                                      )
                                                      OR ( @id_contractor IS NOT NULL
                                                           AND c.id_contractor = @id_contractor
                                                         )
                                                    )
					--ID_CITY
                                                AND ( ( @id_city IS NULL
                                                        OR @id_city <= 0
                                                      )
                                                      OR ( @id_city IS NOT NULL
                                                           AND c2d.id_city = @id_city
                                                         )
                                                    )
					--ADDRESS
                                                AND ( ( @address IS NULL
                                                        OR LTRIM(RTRIM(@address)) = ''
                                                      )
                                                      OR ( @address IS NOT NULL
                                                           AND c2d.address = @address
                                                         )
                                                    )
					--ID_DEVICE
                                                AND ( ( @id_device IS NULL
                                                        OR @id_device <= 0
                                                      )
                                                      OR ( @id_device IS NOT NULL
                                                           AND sc.id_device = @id_device
                                                         )
                                                    )
					--claim_num
                                                AND ( @claim_num IS NULL
                                                      OR ( @claim_num IS NOT NULL
                                                           AND sc.number LIKE '%'
                                                           + @claim_num + '%'
                                                         )
                                                    )
					--number
                                                AND ( @number IS NULL
                                                      OR ( @number IS NOT NULL
                                                           AND c.number LIKE '%'
                                                           + @number + '%'
                                                         )
                                                    )
					--id_service_type
                                                AND ( ( @id_service_type IS NULL
                                                        OR @id_service_type <= 0
                                                      )
                                                      OR ( @id_service_type IS NOT NULL
                                                           AND sc.id_service_type = @id_service_type
                                                         )
                                                    )
					--id_service_engeneer
                                                AND ( ( @id_service_engeneer IS NULL
                                                        OR @id_service_engeneer <= 0
                                                      )
                                                      OR ( @id_service_engeneer IS NOT NULL
                                                           AND sc.id_service_engeneer = @id_service_engeneer
                                                         )
                                                    )
					--id_creator
                                                AND ( ( @id_creator IS NULL
                                                        OR @id_creator <= 0
                                                      )
                                                      OR ( @id_creator IS NOT NULL
                                                           AND sc.id_creator = @id_creator
                                                         )
                                                    )
					--id_service_claim_statuses
                                                AND ( ( @id_service_claim_status IS NULL
                                                        OR @id_service_claim_status <= 0
                                                      )
                                                      OR ( @id_service_claim_status IS NOT NULL
                                                           AND sc.id_service_claim_status = @id_service_claim_status
                                                         )
                                                    )
					--ID_SERVICE_ADMIN
                                                AND ( ( @id_service_admin IS NULL
                                                        OR @id_service_admin <= 0
                                                      )
                                                      OR ( @id_service_admin IS NOT NULL
                                                           AND c2d.id_service_admin = @id_service_admin
                                                         )
                                                    )
					--No Set Service Engeneer
                                                AND ( ( @no_set IS NULL
                                                        OR @no_set < 0
                                                      )
                                                      OR ( @no_set = 1
                                                           AND sc.id_service_engeneer IS NOT NULL
                                                         )
                                                      OR ( @no_set = 0
                                                           AND sc.id_service_engeneer IS NULL
                                                         )
                                                    )
					--Без обслуженных
                                                AND ( ( @no_came IS NULL
                                                        OR @no_came = 0
                                                      )
                                                      OR ( @no_came = 1
                                                           AND NOT EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scam
                                                              WHERE
                                                              scam.enabled = 1
                                                              AND scam.id_service_claim = sc.id_service_claim )
                                                         )
                                                    )
                                                AND ( ( @is_done IS NULL
                                                        OR @is_done < 0
                                                      )
                                                      OR ( @is_done = 1
                                                           AND EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.id_service_claim = sc.id_service_claim
                                                              AND scm.enabled = 1 )
                                                         )
                                                      OR ( @is_done = 0
                                                           AND NOT EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.id_service_claim = sc.id_service_claim
                                                              AND scm.enabled = 1 )
                                                         )
                                                    )
					/***************** /FILTERS  ****************/
                                    ) AS T
                          WHERE     --date_claim_begin
                                    ( @date_claim_begin IS NULL
                                      OR ( @date_claim_begin IS NOT NULL
                                           AND CONVERT(DATE, t.planing_date) >= CONVERT(DATE, @date_claim_begin)
                                         )
                                    )
				--date_claim_end
                                    AND ( @date_claim_end IS NULL
                                          OR ( @date_claim_end IS NOT NULL
						--AND ((@show_no_graphicks IS NULL OR @show_no_graphicks = 0) OR (@show_no_graphicks = 1 AND t.per_month IS NOT NULL))
                                               AND CONVERT(DATE, t.planing_date) <= CONVERT(DATE, @date_claim_end)
                                             )
                                        )
                                    AND ( @date_month IS NULL
                                          OR ( @date_month IS NOT NULL
						--AND ((@show_no_graphicks IS NULL OR @show_no_graphicks = 0) OR (@show_no_graphicks = 1 AND t.per_month IS NOT NULL))
                                               AND MONTH(t.planing_date) = MONTH(@date_month)
                                               AND YEAR(t.planing_date) = YEAR(@date_month)
                                             )
                                        )
                        ) AS tt
                WHERE   --date_came_begin
                        ( @date_came_begin IS NULL
                          OR ( @date_came_begin IS NOT NULL
                               AND CONVERT(DATE, tt.date_came) >= CONVERT(DATE, @date_came_begin)
                             )
                        )
			--date_came_end
                        AND ( @date_came_end IS NULL
                              OR ( @date_came_end IS NOT NULL
                                   AND CONVERT(DATE, tt.date_came) <= CONVERT(DATE, @date_came_end)
                                 )
                            )
                        AND ( ( @rows_count IS NULL
                                OR @rows_count <= 0
                              )
                              OR ( @rows_count > 0
                                   AND row_num <= @rows_count
                                 )
                            )
                ORDER BY tt.row_num
            END
        ELSE
            IF @action = 'getServiceClaimSelectionList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    SELECT  t.id_service_claim AS id ,
                            t.id_service_claim AS NAME
                    FROM    dbo.srvpl_service_claims t
                    WHERE   t.enabled = 1
				/**************** FILTERS *****************/
				--ID_SERVICE_CLAIM 
                            AND ( ( @id_service_claim IS NULL
                                    OR @id_service_claim <= 0
                                  )
                                  OR ( @id_service_claim IS NOT NULL
                                       AND id_service_claim = @id_service_claim
                                     )
                                )
				--ID_SERVICE_CLAIM_STATUS    
                            AND ( ( @id_service_claim_status IS NULL
                                    OR @id_service_claim_status < = 0
                                  )
                                  OR ( @id_service_claim_status IS NOT NULL
                                       AND id_service_claim_status = @id_service_claim_status
                                     )
                                )
                END
            ELSE
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
                                                              dbo.srvpl_service_claims cl2 INNER JOIN dbo.srvpl_service_cames cam2 ON cl2.id_service_claim = cam2.id_service_claim
                                                              WHERE
                                                              cl2.enabled = 1
                                                              AND cl2.id_contract2devices = c2d2.id_contract2devices )
                                                              AND ( c.handling_devices IS NOT NULL
                                                              AND c.handling_devices > 0
                                                              )
                                                              AND d2.id_device=c2d.id_device
                                                              --AND d2.serial_num LIKE '%'
                                                              --+ @serial_num
                                                              --+ '%' 
                                                              )
                                                              --AND NOT EXISTS (select 1 from dbo.srvpl_service_cames cam2 WHERE cam2.id_service_claim = )
                                                      )
                                                )
                                ) AS T                                
                    END
                ELSE
                    IF @action = 'getServiceClaim'
                        BEGIN
                            SELECT  id_service_claim ,
                                    id_contract2devices ,
                                    id_contract ,
                                    id_device ,
                                    planing_date ,
                                    id_service_type ,
                                    ( CASE WHEN number IS NULL
                                                OR number = ''
                                           THEN id_service_claim
                                           ELSE number
                                      END ) AS number ,
                                    id_service_engeneer ,
                                    descr ,
                                    dattim1 ,
                                    dattim2 ,
                                    enabled ,
                                    id_creator ,
                                    order_num ,
                                    id_service_claim_status ,
                                    id_service_claim_type ,
                                    id_service_admin
                            FROM    dbo.srvpl_service_claims sc
                            WHERE   sc.id_service_claim = @id_service_claim
                        END
                    ELSE
                        IF @action = 'saveServiceClaim'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END

                                SET @var_str = 'insServiceClaim'
								
								--Берем статус заявки - Новая
                                SELECT  @id_service_claim_status = id_service_claim_status
                                FROM    dbo.srvpl_service_claim_statuses scs
                                WHERE   scs.enabled = 1
                                        AND LOWER(scs.SYSNAME) = LOWER('NEW')
								
								--Берем тип заявки - Плановая
                                SELECT  @id_service_claim_type = ISNULL(@id_service_claim_type,
                                                              ( SELECT
                                                              id_service_claim_type
                                                              FROM
                                                              dbo.srvpl_service_claim_types ct
                                                              WHERE
                                                              ct.enabled = 1
                                                              AND UPPER(ct.sys_name) = 'PLAN'
                                                              ))
								
								--
                                IF EXISTS ( SELECT  1
                                            FROM    dbo.srvpl_service_claims t
                                            WHERE   t.id_service_claim = @id_service_claim )
                                    BEGIN
                                        SET @var_str = 'updServiceClaim'
                                    END
								
								
								
                                IF @lst_id_contract2devices IS NOT NULL--Если передается список устройств, то парсим
                                    AND RTRIM(LTRIM(@lst_id_contract2devices)) != ''
                                    BEGIN
                                        DECLARE curs_sc CURSOR LOCAL
                                        FOR
                                            SELECT  value
                                            FROM    dbo.Split(@lst_id_contract2devices,
                                                              ',')                                   
                                    END
                                ELSE
                                    BEGIN
                                        DECLARE curs_sc CURSOR LOCAL
                                        FOR
                                            SELECT  @id_contract2devices
                                    END

                                OPEN curs_sc

                                FETCH NEXT
						FROM curs_sc
						INTO @id_contract2devices
						
						
						
						--Цикл по связке устройство/контракт
                                WHILE @@FETCH_STATUS = 0
                                    BEGIN
										
                                    
                                        SELECT  @id_contract = c2d.id_contract ,
                                                @id_device = c2d.id_device ,
                                                @id_service_admin = id_service_admin
                                        FROM    dbo.srvpl_contract2devices c2d
                                        WHERE   c2d.enabled = 1
                                                AND c2d.id_contract2devices = @id_contract2devices
										
										--Вычисляем было ли продление договора
										--Проверяем есть ли у договора ограничения на количесто заявок в месяц
                                        SELECT  @id_contract_prolong = id_contract_prolong ,
                                                @handling_devices = c.handling_devices
                                        FROM    dbo.srvpl_contracts c
                                        WHERE   c.id_contract = @id_contract

                                        IF @lst_schedule_dates IS NOT NULL
                                            AND LTRIM(RTRIM(@lst_schedule_dates)) != ''
                                            BEGIN
                                                DECLARE curs_dates CURSOR LOCAL
                                                FOR
                                                    SELECT  CONVERT(DATETIME, value, 104)
                                                    FROM    dbo.Split(@lst_schedule_dates,
                                                              ',')
                                            END
                                        ELSE
                                            BEGIN
                                                DECLARE curs_dates CURSOR LOCAL
                                                FOR
                                                    SELECT  @planing_date
                                            END

                                        OPEN curs_dates

                                        FETCH NEXT
							FROM curs_dates
							INTO @planing_date

							--Цикл по датам
                                        WHILE @@FETCH_STATUS = 0
                                            BEGIN
                                            --Если не было продления договора или продление было и не существует выезда на предыдущем договоре на этот месяц и этот договор не расторгнут и это не ручное добавление выезда
                                                IF ( @is_manual = 1
                                                     OR @planing_date IS NULL or ( ( @id_contract_prolong IS NULL
                                                            OR ( @id_contract_prolong IS NOT NULL
                                                              AND NOT EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_contract2devices c2d
                                                              INNER JOIN dbo.srvpl_service_claims sc ON c2d.id_contract2devices = sc.id_contract2devices
                                                              INNER JOIN dbo.srvpl_contracts c ON c2d.id_contract = c.id_contract
                                                              INNER JOIN dbo.srvpl_devices d ON c2d.id_device = d.id_device
                                                              INNER JOIN dbo.srvpl_contract_statuses st ON c.id_contract_status = st.id_contract_status
                                                              WHERE
                                                              c2d.enabled = 1
                                                              AND c.enabled = 1
                                                              AND d.enabled = 1
                                                              AND sc.enabled = 1
                                                              AND st.enabled = 1
                                                              AND UPPER(st.sys_name) NOT IN (
                                                              'DEACTIVE' )
                                                              AND c2d.id_contract = @id_contract_prolong
                                                              AND c2d.id_device = @id_device
                                                              AND YEAR(sc.planing_date) = YEAR(@planing_date)
                                                              AND MONTH(sc.planing_date) = MONTH(@planing_date)
                                                              AND c.add_plan_when_deactive = 0 )
                                                              )
                                                          )
                                                       --И не превышено допустимое количество выездов на этот месяц
                                                          AND ( ( @handling_devices IS NULL
                                                              OR @handling_devices <= 0
                                                              )
                                                              OR ( @handling_devices IS NOT NULL
                                                              AND ( ( SELECT
                                                              COUNT(1)
                                                              FROM
                                                              dbo.srvpl_service_claims sc
                                                              INNER JOIN dbo.srvpl_contracts c ON sc.id_contract = c.id_contract
                                                              INNER JOIN dbo.srvpl_devices d ON sc.id_device = d.id_device
                                                              WHERE
                                                              c.enabled = 1
                                                              AND d.enabled = 1
                                                              AND sc.enabled = 1
                                                              AND sc.id_contract = @id_contract
                                                              AND YEAR(sc.planing_date) = YEAR(@planing_date)
                                                              AND MONTH(sc.planing_date) = MONTH(@planing_date)
                                                              ) < @handling_devices )
                                                              )
                                                              )
                                                        )
                                                   )
                                                    --AND @planing_date IS NOT NULL
                                                    BEGIN
                                                        EXEC dbo.sk_service_planing @action = @var_str,
                                                            @id_service_claim = @id_service_claim,
                                                            @id_contract2devices = @id_contract2devices,
                                                            @id_contract = @id_contract,
                                                            @id_device = @id_device,
                                                            @planing_date = @planing_date,
                                                            @id_service_claim_type = @id_service_claim_type,
                                                            @number = @number,
                                                            @id_service_engeneer = @id_service_engeneer,
                                                            @descr = @descr,
                                                            @order_num = @order_num,
                                                            @id_service_claim_status = @id_service_claim_status,
                                                            @id_creator = @id_creator,
                                                            @id_service_admin = @id_service_admin
                                                    END
                                                FETCH NEXT
								FROM curs_dates
								INTO @planing_date
                                            END

                                        CLOSE curs_dates

                                        DEALLOCATE curs_dates

                                        FETCH NEXT
							FROM curs_sc
							INTO @id_contract2devices
                                    END

                                CLOSE curs_sc

                                DEALLOCATE curs_sc
                            END
                        ELSE
                            IF @action = 'closeServiceClaim'
                                BEGIN
                                    IF @sp_test IS NOT NULL
                                        BEGIN
                                            RETURN
                                        END
                                    BEGIN TRY
                                        BEGIN TRANSACTION
                                        --скрываем акт обслуживания
                                        EXEC dbo.sk_service_planing @action = N'closeServiceClaim',
                                            @id_service_claim = @id_service_claim,
                                            @id_creator = @id_creator
                                        
                                        --Если у заявки на выезд есть акты, то закрываем эти акты
                                        DECLARE curs CURSOR local
                                        FOR
                                            SELECT  id_service_came
                                            FROM    dbo.srvpl_service_cames cam
                                            WHERE   enabled = 1
                                                    AND cam.id_service_claim = @id_service_claim

                                        OPEN curs

                                        FETCH NEXT
	FROM curs
	INTO @id_service_came

                                        WHILE @@FETCH_STATUS = 0
                                            BEGIN
                                                EXEC dbo.ui_service_planing @action = N'closeServiceCame',
                                                    @id_service_came = @id_service_came,
                                                    @id_creator = @id_creator

                                                FETCH NEXT
		FROM curs
		INTO @id_service_came
                                            END

                                        CLOSE curs

                                        DEALLOCATE curs
                                        
                                        
                                        COMMIT TRANSACTION
                                    END TRY

                                    BEGIN CATCH
                                        IF @@TRANCOUNT > 0
                                            ROLLBACK TRANSACTION

                                        SELECT  @error_text = ERROR_MESSAGE()
                                                + ' Изменения не были сохранены!'

                                        RAISERROR (
														@error_text
														,16
														,1
														)
                                    END CATCH
                                END

        IF @action = 'checkDeviceTotalCounterIsNotTooBig'
            BEGIN
                DECLARE @counter_must_be INT
            
                SELECT  @id_device = id_device
                FROM    dbo.srvpl_service_claims cl
                WHERE   id_service_claim = @id_service_claim

                IF @id_device IS NOT NULL
                    AND @date_came IS NOT NULL
                    BEGIN 
	
                        SELECT  @counter_must_be = ISNULL(total_counter
                                                          + ( total_volume
                                                              * moths_diff_count ),
                                                          0)
                        FROM    ( SELECT TOP 1
                                            ISNULL(counter, 0)
                                            + ISNULL(counter_colour, 0) AS total_counter ,
                                            ISNULL(volume_counter, 0)
                                            + ISNULL(volume_counter_colour, 0) AS total_volume ,
                                            date_month ,
                                            DATEDIFF(day, date_month,
                                                     @date_came) / 30
                                            + CASE WHEN DATEDIFF(day,
                                                              date_month,
                                                              @date_came) % 30 > 25
                                                   THEN 1
                                                   ELSE 0
                                              END AS moths_diff_count
                                  FROM      dbo.srvpl_device_data dd
                                  WHERE     id_device = @id_device
                                            AND ( date_month < @date_came
                                                  OR ( YEAR(@date_came) = YEAR(date_month)
                                                       AND MONTH(@date_came) = MONTH(date_month)
                                                     )
                                                )
                                  ORDER BY  date_month DESC
                                ) AS t
						
						--Если различие больше чем на 50 % 
                        IF ( @counter_must_be * 1.5 ) < @counter
                            BEGIN
                                SELECT  1 AS result ,
                                        @counter_must_be AS counter_must_be 
                            END 
                        ELSE
                            BEGIN 
                                SELECT  0 AS result ,
                                        @counter_must_be AS counter_must_be 
                            END
	
                    END
	
            END

	--=================================
	--ServiceClaimStatuses
	--=================================	
        IF @action = 'getServiceClaimStatusList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  t.NAME ,
                        t.nickname ,
                        t.descr ,
                        t.order_num ,
                        t.dattim1 ,
                        t.dattim2
                FROM    dbo.srvpl_service_claim_statuses t
                WHERE   t.enabled = 1
            END
        ELSE
            IF @action = 'getServiceClaimStatusSelectionList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    SELECT  t.id_service_claim_status AS id ,
                            t.NAME ,
                            t.nickname
                    FROM    dbo.srvpl_service_claim_statuses t
                    WHERE   t.enabled = 1
                    ORDER BY t.order_num ,
                            t.NAME
                END
            ELSE
                IF @action = 'getServiceClaimStatus'
                    BEGIN
                        SELECT  id_service_claim_status ,
                                [name] ,
                                [nickname] ,
                                [descr] ,
                                [order_num]
                        FROM    dbo.srvpl_service_claim_statuses scs
                        WHERE   scs.id_service_claim_status = @id_service_claim_status
                    END
                ELSE
                    IF @action = 'saveServiceClaimStatus'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END

                            SET @var_str = 'insServiceClaimStatus'

                            IF EXISTS ( SELECT  1
                                        FROM    dbo.srvpl_service_claim_statuses t
                                        WHERE   t.id_service_claim_status = @id_service_claim_status )
                                BEGIN
                                    SET @var_str = 'updServiceClaimStatus'
                                END

                            EXEC dbo.sk_service_planing @action = @var_str,
                                @id_service_claim_status = @id_service_claim_status,
                                @name = @name, @nickname = @nickname,
                                @descr = @descr, @order_num = @order_num,
                                @id_creator = @id_creator
                        END
                    ELSE
                        IF @action = 'closeServiceClaimStatus'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END

                                EXEC dbo.sk_service_planing @action = N'closeServiceClaimStatus',
                                    @id_service_claim_status = @id_service_claim_status,
                                    @id_creator = @id_creator
                            END

	--=================================
	--ServiceIntervals
	--=================================	
        IF @action = 'getServiceIntervalList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  t.id_service_interval ,
                        t.NAME ,
                        t.nickname ,
                        t.descr ,
                        t.order_num ,
                        t.dattim1 ,
                        t.dattim2
                FROM    dbo.srvpl_service_intervals t
                WHERE   t.enabled = 1
            END
        ELSE
            IF @action = 'getServiceIntervalPlanGroupList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    SELECT  t.id_service_interval_plan_group ,
                            t.NAME ,
                            t.order_num ,
                            t.dattim1 ,
                            t.dattim2 ,
                            color
                    FROM    dbo.srvpl_service_interval_plan_groups t
                    WHERE   t.enabled = 1
                    ORDER BY order_num
                END
            ELSE
                IF @action = 'getServiceIntervalSelectionList'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END

                        SELECT  t.id_service_interval AS id ,
                                t.NAME ,
                                t.nickname
                        FROM    dbo.srvpl_service_intervals t
                        WHERE   t.enabled = 1
                        ORDER BY t.order_num ,
                                t.NAME
                    END
                ELSE
                    IF @action = 'getServiceInterval'
                        BEGIN
                            SELECT  [id_service_interval] ,
                                    [name] ,
                                    [nickname] ,
                                    [descr] ,
                                    [order_num] ,
                                    per_month ,
                                    CASE WHEN per_month IS NOT NULL THEN 1
                                         ELSE 0
                                    END AS needs_graphick_list
                            FROM    dbo.srvpl_service_intervals si
                            WHERE   si.id_service_interval = @id_service_interval
                        END
                    ELSE
                        IF @action = 'saveServiceInterval'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END

                                SET @var_str = 'insServiceInterval'

                                IF EXISTS ( SELECT  1
                                            FROM    dbo.srvpl_service_intervals t
                                            WHERE   t.id_service_interval = @id_service_interval )
                                    BEGIN
                                        SET @var_str = 'updServiceInterval'
                                    END

                                EXEC dbo.sk_service_planing @action = @var_str,
                                    @id_service_interval = @id_service_interval,
                                    @name = @name, @nickname = @nickname,
                                    @descr = @descr, @order_num = @order_num,
                                    @id_creator = @id_creator
                            END
                        ELSE
                            IF @action = 'closeServiceInterval'
                                BEGIN
                                    IF @sp_test IS NOT NULL
                                        BEGIN
                                            RETURN
                                        END

                                    EXEC dbo.sk_service_planing @action = N'closeServiceInterval',
                                        @id_service_interval = @id_service_interval,
                                        @id_creator = @id_creator
                                END

	--=================================
	--ServiceTypes
	--=================================	
        IF @action = 'getServiceTypeList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  t.NAME ,
                        t.nickname ,
                        t.descr ,
                        t.order_num ,
                        t.dattim1 ,
                        t.dattim2
                FROM    dbo.srvpl_service_types t
                WHERE   t.enabled = 1
            END
        ELSE
            IF @action = 'getServiceTypeSelectionList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    SELECT  t.id_service_type AS id ,
                            t.NAME ,
                            t.nickname
                    FROM    dbo.srvpl_service_types t
                    WHERE   t.enabled = 1
                    ORDER BY t.order_num ,
                            t.NAME
                END
            ELSE
                IF @action = 'getServiceType'
                    BEGIN
                        SELECT  [id_service_type] ,
                                [name] ,
                                [nickname] ,
                                [descr] ,
                                [order_num]
                        FROM    dbo.srvpl_service_types st
                        WHERE   st.id_service_type = @id_service_type
                    END
                ELSE
                    IF @action = 'saveServiceType'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END

                            SET @var_str = 'insServiceType'

                            IF EXISTS ( SELECT  1
                                        FROM    dbo.srvpl_service_types t
                                        WHERE   t.id_service_type = @id_service_type )
                                BEGIN
                                    SET @var_str = 'updServiceType'
                                END

                            EXEC dbo.sk_service_planing @action = @var_str,
                                @id_service_type = @id_service_type,
                                @name = @name, @nickname = @nickname,
                                @descr = @descr, @order_num = @order_num,
                                @id_creator = @id_creator
                        END
                    ELSE
                        IF @action = 'closeServiceType'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END

                                EXEC dbo.sk_service_planing @action = N'closeServiceType',
                                    @id_service_type = @id_service_type,
                                    @id_creator = @id_creator
                            END

	--=================================
	--ServiceZones
	--=================================	
        IF @action = 'getServiceZoneList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  t.NAME ,
                        t.nickname ,
                        t.descr ,
                        t.order_num ,
                        t.dattim1 ,
                        t.dattim2
                FROM    dbo.srvpl_service_zones t
                WHERE   t.enabled = 1
            END
        ELSE
            IF @action = 'getServiceZoneSelectionList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    SELECT  t.id_service_zone AS id ,
                            t.NAME ,
                            t.nickname
                    FROM    dbo.srvpl_service_zones t
                    WHERE   t.enabled = 1
                    ORDER BY t.order_num ,
                            t.NAME
                END
            ELSE
                IF @action = 'getServiceZone'
                    BEGIN
                        SELECT  [id_service_zone] ,
                                [name] ,
                                [nickname] ,
                                [descr] ,
                                [order_num]
                        FROM    dbo.srvpl_service_zones sz
                        WHERE   sz.id_service_zone = @id_service_zone
                    END
                ELSE
                    IF @action = 'saveServiceZone'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END

                            SET @var_str = 'insServiceZone'

                            IF EXISTS ( SELECT  1
                                        FROM    dbo.srvpl_service_zones t
                                        WHERE   t.id_service_zone = @id_service_zone )
                                BEGIN
                                    SET @var_str = 'updServiceZone'
                                END

                            EXEC dbo.sk_service_planing @action = @var_str,
                                @id_service_zone = @id_service_zone,
                                @name = @name, @nickname = @nickname,
                                @descr = @descr, @order_num = @order_num,
                                @id_creator = @id_creator
                        END
                    ELSE
                        IF @action = 'closeServiceZone'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END

                                EXEC dbo.sk_service_planing @action = N'closeServiceZone',
                                    @id_service_zone = @id_service_zone,
                                    @id_creator = @id_creator
                            END

	--=================================
	--ServiceZone2Devices
	--=================================	
        IF @action = 'getServiceZone2DevicesList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  *
                FROM    dbo.srvpl_service_zone2devices t
                WHERE   t.enabled = 1
            END
        ELSE
            IF @action = 'getServiceZone2DevicesSelectionList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    SELECT  t.id_service_zone2devices AS id ,
                            t.id_device AS NAME
                    FROM    dbo.srvpl_service_zone2devices t
                    WHERE   t.enabled = 1
                END
            ELSE
                IF @action = 'getServiceZone2Devices'
                    BEGIN
                        SELECT  [id_service_zone2devices] ,
                                [id_service_zone] ,
                                [id_device]
                        FROM    dbo.srvpl_service_zone2devices sz2d
                        WHERE   sz2d.id_service_zone2devices = @id_service_zone2devices
                    END
                ELSE
                    IF @action = 'saveServiceZone2Devices'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END

                            SET @var_str = 'insServiceZone2Devices'

                            IF EXISTS ( SELECT  1
                                        FROM    dbo.srvpl_service_zone2devices t
                                        WHERE   t.id_service_zone2devices = @id_service_zone2devices )
                                BEGIN
                                    SET @var_str = 'updServiceZone2Devices'
                                END

                            EXEC dbo.sk_service_planing @action = @var_str,
                                @id_service_zone2devices = @id_service_zone2devices,
                                @id_service_zone = @id_service_zone,
                                @id_device = @id_device,
                                @id_creator = @id_creator
                        END
                    ELSE
                        IF @action = 'closeServiceZone2Devices'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END

                                EXEC dbo.sk_service_planing @action = N'closeServiceZone2Devices',
                                    @id_service_zone2devices = @id_service_zone2devices,
                                    @id_creator = @id_creator
                            END

	--=================================
	--SrvplAddress
	--=================================	
        IF @action = 'getSrvplAddressList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  *
                FROM    ( SELECT    ROW_NUMBER() OVER ( ORDER BY a.NAME
						, a.order_num ) AS row_num ,
                                    a.id_srvpl_address ,
                                    a.NAME ,
                                    a.order_num ,
                                    ISNULL(( SELECT COUNT(1)
                                             FROM   dbo.srvpl_contract2devices c2d
                                                    INNER JOIN srvpl_contracts c ON c2d.id_contract = c.id_contract
                                                    INNER JOIN srvpl_devices d ON c2d.id_device = d.id_device
                                             WHERE  c2d.enabled = 1
                                                    AND c.enabled = 1
                                                    AND d.ENABLED = 1
                                                    AND c2d.address = a.NAME
                                             GROUP BY c2d.address
                                           ), 0) AS [count]
                          FROM      dbo.srvpl_addresses a
                          WHERE     a.enabled = 1
                                    AND ( ( @name IS NULL
                                            OR LTRIM(RTRIM(@name)) = ''
                                          )
                                          OR ( @name IS NOT NULL
                                               AND a.NAME LIKE '%' + @name
                                               + '%'
                                             )
                                        )
                        ) AS T
                WHERE   ( ( @rows_count IS NULL
                            OR @rows_count <= 0
                          )
                          OR ( @rows_count > 0
                               AND row_num <= @rows_count
                             )
                        )
                ORDER BY t.NAME ,
                        t.order_num
            END
        ELSE
            IF @action = 'getSrvplAddressSelectionList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    SELECT  t.id_srvpl_address AS id ,
                            t.NAME AS NAME
                    FROM    dbo.srvpl_addresses t
                    WHERE   t.enabled = 1
                    ORDER BY t.NAME ,
                            t.order_num
                END
            ELSE
                IF @action = 'getSrvplAddress'
                    BEGIN
                        SELECT  id_srvpl_address ,
                                NAME ,
                                order_num
                        FROM    dbo.srvpl_addresses a
                        WHERE   a.id_srvpl_address = @id_srvpl_address
                    END
                ELSE
                    IF @action = 'saveSrvplAddress'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END

                            SET @var_str = 'insSrvplAddress'

                            IF EXISTS ( SELECT  1
                                        FROM    dbo.srvpl_addresses t
                                        WHERE   t.id_srvpl_address = @id_srvpl_address )
                                BEGIN
                                    SET @var_str = 'updSrvplAddress'
                                END

                            EXEC dbo.sk_service_planing @action = @var_str,
                                @id_srvpl_address = @id_srvpl_address,
                                @name = @name, @order_num = @order_num,
                                @id_creator = @id_creator
                        END
                    ELSE
                        IF @action = 'closeSrvplAddress'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END

                                EXEC dbo.sk_service_planing @action = N'closeSrvplAddress',
                                    @id_srvpl_address = @id_srvpl_address,
                                    @id_creator = @id_creator
                            END

	--=================================
	--ServiceZone2Users
	--=================================	
        IF @action = 'getServiceZone2UsersList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  *
                FROM    dbo.srvpl_service_zone2users t
                WHERE   t.enabled = 1
            END
        ELSE
            IF @action = 'getServiceZone2UsersSelectionList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    SELECT  t.id_service_zone2user AS id ,
                            t.id_user AS NAME
                    FROM    dbo.srvpl_service_zone2users t
                    WHERE   t.enabled = 1
                END
            ELSE
                IF @action = 'getServiceZone2Users'
                    BEGIN
                        SELECT  [id_service_zone2user] ,
                                [id_service_zone] ,
                                [id_user]
                        FROM    dbo.srvpl_service_zone2users sz2u
                        WHERE   sz2u.id_service_zone2user = @id_service_zone2user
                    END
                ELSE
                    IF @action = 'saveServiceZone2Users'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END

                            SET @var_str = 'insServiceZone2Users'

                            IF EXISTS ( SELECT  1
                                        FROM    dbo.srvpl_service_zone2users t
                                        WHERE   t.id_service_zone2user = @id_service_zone2user )
                                BEGIN
                                    SET @var_str = 'updServiceZone2Users'
                                END

                            EXEC dbo.sk_service_planing @action = @var_str,
                                @id_service_zone2user = @id_service_zone2user,
                                @id_service_zone = @id_service_zone,
                                @id_user = @id_user, @id_creator = @id_creator
                        END
                    ELSE
                        IF @action = 'closeServiceZone2Users'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END

                                EXEC dbo.sk_service_planing @action = N'closeServiceZone2Users',
                                    @id_service_zone2user = @id_service_zone2user,
                                    @id_creator = @id_creator
                            END

        IF @action = 'getContractZipStateSelectionList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  t.id_zip_state AS id ,
                        t.NAME AS NAME
                FROM    dbo.srvpl_contract_zip_states t
                WHERE   t.enabled = 1
            END

	--=================================
	--ServiceClaimTypes
	--=================================	
        IF @action = 'getServiceClaimTypeSelectionList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  t.id_service_claim_type AS id ,
                        t.NAME AS NAME
                FROM    dbo.srvpl_service_claim_types t
                WHERE   t.enabled = 1
                ORDER BY t.order_num
            END

	--=================================
	--Reports
	--=================================	
        IF @action = 'getPaymentList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  id_device ,
                        dbo.srvpl_fnc('getDeviceShortCollectedNameNoBr', NULL,
                                      id_device, NULL, NULL) AS device ,
                        planing_date ,
                        date_came ,
                        CONVERT(DECIMAL(10, 2), ROUND(tariff / came_count, 2)) AS payment ,
                        id_service_engeneer ,
                        tariff ,
                        service_engeneer
                FROM    ( SELECT    sc.id_device ,
                                    CONVERT(DATE, sc.planing_date) AS planing_date ,
                                    CONVERT(DATE, scm.date_came) AS date_came ,
                                    d.tariff ,
                                    scm.id_service_engeneer ,
                                    ( SELECT    COUNT(1)
                                      FROM      srvpl_service_cames scm2
                                      WHERE     scm2.id_service_claim = sc.id_service_claim
                                      GROUP BY  scm2.id_service_claim
                                    ) AS came_count ,
                                    ( SELECT    display_name
                                      FROM      users u
                                      WHERE     u.id_user = scm.id_service_engeneer
                                    ) AS service_engeneer
                          FROM      dbo.srvpl_service_cames scm
                                    INNER JOIN dbo.srvpl_service_claims sc ON sc.id_service_claim = scm.id_service_claim
                                    INNER JOIN srvpl_contract2devices c2d ON sc.id_contract2devices = c2d.id_contract2devices
                                    INNER JOIN dbo.srvpl_devices d ON sc.id_device = d.id_device
                                    INNER JOIN dbo.srvpl_contracts c ON sc.id_contract = c.id_contract
                          WHERE     scm.enabled = 1
                                    AND sc.enabled = 1
                                    AND d.enabled = 1
                                    AND c.enabled = 1
                                    AND c2d.enabled = 1
                                    AND ( @id_service_claim IS NULL
                                          OR ( @id_service_claim IS NOT NULL
                                               AND scm.id_service_claim = @id_service_claim
                                             )
                                        )
                                    AND ( @id_service_engeneer IS NULL
                                          OR ( @id_service_engeneer IS NOT NULL
                                               AND scm.id_service_engeneer = @id_service_engeneer
                                             )
                                        )
                                    AND ( @id_device IS NULL
                                          OR ( @id_device IS NOT NULL
                                               AND sc.id_device = @id_device
                                             )
                                        )
                                    AND ( @date_begin IS NULL
                                          OR ( @date_begin IS NOT NULL
                                               AND CONVERT(DATE, scm.date_came) >= CONVERT(DATE, @date_begin)
                                             )
                                        )
                                    AND ( @date_end IS NULL
                                          OR ( @date_end IS NOT NULL
                                               AND CONVERT(DATE, scm.date_came) <= CONVERT(DATE, @date_end)
                                             )
                                        )
                                    AND ( @date_month IS NULL
                                          OR ( @date_month IS NOT NULL
                                               AND MONTH(scm.date_came) = MONTH(@date_month)
                                               AND YEAR(scm.date_came) = YEAR(@date_month)
                                             )
                                        )
                                    AND ( ( @is_done IS NULL
                                            OR @is_done < 0
                                          )
                                          OR ( @is_done = 1
                                               AND EXISTS ( SELECT
                                                              1
                                                            FROM
                                                              dbo.srvpl_service_cames scm
                                                            WHERE
                                                              scm.id_service_claim = sc.id_service_claim
                                                              AND scm.enabled = 1 )
                                             )
                                          OR ( @is_done = 0
                                               AND NOT EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.id_service_claim = sc.id_service_claim
                                                              AND scm.enabled = 1 )
                                             )
                                        )
				--No Set Service Engeneer
                                    AND ( ( @no_set IS NULL
                                            OR @no_set < 0
                                          )
                                          OR ( @no_set = 1
                                               AND sc.id_service_engeneer IS NOT NULL
                                             )
                                          OR ( @no_set = 0
                                               AND sc.id_service_engeneer IS NULL
                                             )
                                        )
                        ) AS t
                ORDER BY date_came DESC
            END
        ELSE
            IF @action = 'getPlanExecuteServAdminList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    IF YEAR(@date_month) = YEAR(GETDATE())
                        AND MONTH(@date_month) = MONTH(GETDATE())
                        AND @date_begin IS NULL
                        AND @date_end IS NULL
                        AND ( @is_done IS NULL
                              OR @is_done < 0
                            )
                        AND ( @no_set = 1 )
                        BEGIN
                            SELECT  *
                            FROM    srvpl_getPlanExecuteServAdminList_curr_month t
                            WHERE   ( @id_service_admin IS NULL
                                      OR ( @id_service_admin IS NOT NULL
                                           AND t.id_service_admin = @id_service_admin
                                         )
                                    )
                        END
                    ELSE
                        BEGIN
                            SELECT  tt.display_name AS service_admin ,
                                    tt.id_service_admin ,
                                    tt.plan_cnt ,
                                    tt.done_cnt ,
                                    tt.plan_cnt - tt.done_cnt AS residue ,
                                    CONVERT(DECIMAL(10, 0), ( CONVERT(DECIMAL(10,
                                                              2), tt.done_cnt)
                                                              / CONVERT(DECIMAL(10,
                                                              2), tt.plan_cnt) )
                                    * 100) AS done_percent
                            FROM    ( SELECT    t.display_name ,
                                                t.id_service_admin ,
                                                SUM(t.[plan]) AS plan_cnt ,
                                                SUM(t.done) AS done_cnt
                                      FROM      ( SELECT    u.display_name ,
                                                            c2d.id_service_admin ,
                                                            1 AS [plan] ,
                                                            CASE
                                                              WHEN EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.id_service_claim = sc.id_service_claim
                                                              AND scm.enabled = 1 )
                                                              THEN 1
                                                              ELSE 0
                                                            END AS done
                                                  FROM      dbo.srvpl_service_claims sc
                                                            INNER JOIN dbo.srvpl_contract2devices c2d ON sc.id_contract2devices = c2d.id_contract2devices
                                                            INNER JOIN dbo.srvpl_devices d ON c2d.id_device = d.id_device
                                                            INNER JOIN dbo.srvpl_contracts c ON c2d.id_contract = c.id_contract
                                                            INNER JOIN dbo.users u ON u.id_user = c2d.id_service_admin
                                                  WHERE     sc.enabled = 1
                                                            AND c2d.enabled = 1
                                                            AND d.enabled = 1
                                                            AND c.enabled = 1
                                                            AND ( @id_service_claim IS NULL
                                                              OR ( @id_service_claim IS NOT NULL
                                                              AND sc.id_service_claim = @id_service_claim
                                                              )
                                                              )
                                                            AND ( @id_service_engeneer IS NULL
                                                              OR ( @id_service_engeneer IS NOT NULL
                                                              AND sc.id_service_engeneer = @id_service_engeneer
                                                              )
                                                              )
                                                            AND ( @id_service_admin IS NULL
                                                              OR ( @id_service_admin IS NOT NULL
                                                              AND c2d.id_service_admin = @id_service_admin
                                                              )
                                                              )
                                                            AND ( @id_manager IS NULL
                                                              OR ( @id_manager IS NOT NULL
                                                              AND c.id_manager = @id_manager
                                                              )
                                                              )
                                                            AND ( @date_begin IS NULL
                                                              OR ( @date_begin IS NOT NULL
                                                              AND CONVERT(DATE, sc.planing_date) >= CONVERT(DATE, @date_begin)
                                                              )
                                                              )
                                                            AND ( @date_end IS NULL
                                                              OR ( @date_end IS NOT NULL
                                                              AND CONVERT(DATE, sc.planing_date) <= CONVERT(DATE, @date_end)
                                                              )
                                                              )
                                                            AND ( @date_month IS NULL
                                                              OR ( @date_month IS NOT NULL
                                                              AND MONTH(sc.planing_date) = MONTH(@date_month)
                                                              AND YEAR(sc.planing_date) = YEAR(@date_month)
                                                              )
                                                              )
                                                            AND ( ( @is_done IS NULL
                                                              OR @is_done < 0
                                                              )
                                                              OR ( @is_done = 1
                                                              AND EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.id_service_claim = sc.id_service_claim
                                                              AND scm.enabled = 1 )
                                                              )
                                                              OR ( @is_done = 0
                                                              AND NOT EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.id_service_claim = sc.id_service_claim
                                                              AND scm.enabled = 1 )
                                                              )
                                                              )
						--No Set Service Engeneer
                                                            AND ( ( @no_set IS NULL
                                                              OR @no_set < 0
                                                              )
                                                              OR ( @no_set = 1
                                                              AND sc.id_service_engeneer IS NOT NULL
                                                              )
                                                              OR ( @no_set = 0
                                                              AND sc.id_service_engeneer IS NULL
                                                              )
                                                              )
                                                ) AS t
                                      GROUP BY  t.display_name ,
                                                t.id_service_admin
                                    ) AS tt
                            ORDER BY tt.display_name
                        END
                END
            ELSE
                IF @action = 'getPlanExecuteServAdminContractorList'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END

                        IF YEAR(@date_month) = YEAR(GETDATE())
                            AND MONTH(@date_month) = MONTH(GETDATE())
                            AND @date_begin IS NULL
                            AND @date_end IS NULL
                            AND ( @is_done IS NULL
                                  OR @is_done < 0
                                )
                            AND ( @no_set = 1 )
                            BEGIN
                                SELECT  *
                                FROM    srvpl_getPlanExecuteServAdminContractorList_curr_month_cache t
                                WHERE   id_service_admin = @id_service_admin
                            END
                        ELSE
                            BEGIN

                                SELECT  tt.NAME AS contractor ,
                                        tt.id_contractor ,
                                        tt.id_service_admin ,
                                        tt.plan_cnt ,
                                        tt.done_cnt ,
                                        tt.plan_cnt - tt.done_cnt AS residue ,
                                        CONVERT(DECIMAL(10, 0), ( CONVERT(DECIMAL(10,
                                                              2), tt.done_cnt)
                                                              / CONVERT(DECIMAL(10,
                                                              2), tt.plan_cnt) )
                                        * 100) AS done_percent
                                FROM    ( SELECT    t.NAME ,
                                                    t.id_contractor ,
                                                    t.id_service_admin ,
                                                    SUM(t.[plan]) AS plan_cnt ,
                                                    SUM(t.done) AS done_cnt
                                          FROM      ( SELECT  ctr.NAME ,
                                                              ctr.id AS id_contractor ,
                                                              c2d.id_service_admin ,
                                                              1 AS [plan] ,
                                                              CASE
                                                              WHEN EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.id_service_claim = sc.id_service_claim
                                                              AND scm.enabled = 1 )
                                                              THEN 1
                                                              ELSE 0
                                                              END AS done
                                                      FROM    dbo.srvpl_service_claims sc
                                                              INNER JOIN dbo.srvpl_contract2devices c2d ON sc.id_contract2devices = c2d.id_contract2devices
                                                              INNER JOIN dbo.srvpl_devices d ON sc.id_device = d.id_device
                                                              INNER JOIN dbo.srvpl_contracts c ON sc.id_contract = c.id_contract
                                                              INNER JOIN dbo.get_contractor(NULL)
                                                              AS ctr ON c.id_contractor = ctr.id
                                                      WHERE   sc.enabled = 1
                                                              AND d.enabled = 1
                                                              AND c.enabled = 1
                                                              AND c2d.enabled = 1
                                                              AND ( @id_service_claim IS NULL
                                                              OR ( @id_service_claim IS NOT NULL
                                                              AND sc.id_service_claim = @id_service_claim
                                                              )
                                                              )
                                                              AND ( @id_service_engeneer IS NULL
                                                              OR ( @id_service_engeneer IS NOT NULL
                                                              AND sc.id_service_engeneer = @id_service_engeneer
                                                              )
                                                              )
                                                              AND ( @id_service_admin IS NULL
                                                              OR ( @id_service_admin IS NOT NULL
                                                              AND c2d.id_service_admin = @id_service_admin
                                                              )
                                                              )
                                                              AND ( @id_manager IS NULL
                                                              OR ( @id_manager IS NOT NULL
                                                              AND c.id_manager = @id_manager
                                                              )
                                                              )
                                                              AND ( @id_contractor IS NULL
                                                              OR ( @id_contractor IS NOT NULL
                                                              AND c.id_contractor = @id_contractor
                                                              )
                                                              )
                                                              AND ( @date_begin IS NULL
                                                              OR ( @date_begin IS NOT NULL
                                                              AND CONVERT(DATE, sc.planing_date) >= CONVERT(DATE, @date_begin)
                                                              )
                                                              )
                                                              AND ( @date_end IS NULL
                                                              OR ( @date_end IS NOT NULL
                                                              AND CONVERT(DATE, sc.planing_date) <= CONVERT(DATE, @date_end)
                                                              )
                                                              )
                                                              AND ( @date_month IS NULL
                                                              OR ( @date_month IS NOT NULL
                                                              AND MONTH(sc.planing_date) = MONTH(@date_month)
                                                              AND YEAR(sc.planing_date) = YEAR(@date_month)
                                                              )
                                                              )
                                                              AND ( ( @is_done IS NULL
                                                              OR @is_done < 0
                                                              )
                                                              OR ( @is_done = 1
                                                              AND EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.id_service_claim = sc.id_service_claim
                                                              AND scm.enabled = 1 )
                                                              )
                                                              OR ( @is_done = 0
                                                              AND NOT EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.id_service_claim = sc.id_service_claim
                                                              AND scm.enabled = 1 )
                                                              )
                                                              )
							--No Set Service Engeneer
                                                              AND ( ( @no_set IS NULL
                                                              OR @no_set < 0
                                                              )
                                                              OR ( @no_set = 1
                                                              AND sc.id_service_engeneer IS NOT NULL
                                                              )
                                                              OR ( @no_set = 0
                                                              AND sc.id_service_engeneer IS NULL
                                                              )
                                                              )
                                                    ) AS t
                                          GROUP BY  t.NAME ,
                                                    t.id_contractor ,
                                                    t.id_service_admin
                                        ) AS tt
                                ORDER BY tt.NAME
                        
                            END
                    END
                ELSE
                    IF @action = 'getPlanExecuteServManagerList'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END
							
							
							
                            SELECT  tt.display_name AS manager ,
                                    tt.id_manager ,
                                    tt.plan_cnt ,
                                    tt.done_cnt ,
                                    tt.plan_cnt - tt.done_cnt AS residue ,
                                    CONVERT(DECIMAL(10, 0), ( CONVERT(DECIMAL(10,
                                                              2), tt.done_cnt)
                                                              / CONVERT(DECIMAL(10,
                                                              2), tt.plan_cnt) )
                                    * 100) AS done_percent
                            FROM    ( SELECT    t.display_name ,
                                                t.id_manager ,
                                                SUM(t.[plan]) AS plan_cnt ,
                                                SUM(t.done) AS done_cnt
                                      FROM      ( SELECT    u.display_name ,
                                                            c.id_manager ,
                                                            1 AS [plan] ,
                                                            CASE
                                                              WHEN EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.id_service_claim = sc.id_service_claim
                                                              AND scm.enabled = 1 )
                                                              THEN 1
                                                              ELSE 0
                                                            END AS done
                                                  FROM      dbo.srvpl_service_claims sc
                                                            INNER JOIN dbo.srvpl_contract2devices c2d ON sc.id_contract2devices = c2d.id_contract2devices
                                                            INNER JOIN dbo.srvpl_devices d ON c2d.id_device = d.id_device
                                                            INNER JOIN dbo.srvpl_contracts c ON c2d.id_contract = c.id_contract
                                                            INNER JOIN dbo.users u ON u.id_user = c.id_manager
                                                  WHERE     sc.enabled = 1
                                                            AND c2d.enabled = 1
                                                            AND d.enabled = 1
                                                            AND c.enabled = 1
                                                            AND ( @id_service_claim IS NULL
                                                              OR ( @id_service_claim IS NOT NULL
                                                              AND sc.id_service_claim = @id_service_claim
                                                              )
                                                              )
                                                            AND ( @id_service_engeneer IS NULL
                                                              OR ( @id_service_engeneer IS NOT NULL
                                                              AND sc.id_service_engeneer = @id_service_engeneer
                                                              )
                                                              )
                                                            AND ( @id_service_admin IS NULL
                                                              OR ( @id_service_admin IS NOT NULL
                                                              AND c2d.id_service_admin = @id_service_admin
                                                              )
                                                              )
                                                            AND ( @id_manager IS NULL
                                                              OR ( @id_manager IS NOT NULL
                                                              AND c.id_manager = @id_manager
                                                              )
                                                              )
                                                            AND ( @date_begin IS NULL
                                                              OR ( @date_begin IS NOT NULL
                                                              AND CONVERT(DATE, sc.planing_date) >= CONVERT(DATE, @date_begin)
                                                              )
                                                              )
                                                            AND ( @date_end IS NULL
                                                              OR ( @date_end IS NOT NULL
                                                              AND CONVERT(DATE, sc.planing_date) <= CONVERT(DATE, @date_end)
                                                              )
                                                              )
                                                            AND ( @date_month IS NULL
                                                              OR ( @date_month IS NOT NULL
                                                              AND MONTH(sc.planing_date) = MONTH(@date_month)
                                                              AND YEAR(sc.planing_date) = YEAR(@date_month)
                                                              )
                                                              )
                                                            AND ( ( @is_done IS NULL
                                                              OR @is_done < 0
                                                              )
                                                              OR ( @is_done = 1
                                                              AND EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.id_service_claim = sc.id_service_claim
                                                              AND scm.enabled = 1 )
                                                              )
                                                              OR ( @is_done = 0
                                                              AND NOT EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.id_service_claim = sc.id_service_claim
                                                              AND scm.enabled = 1 )
                                                              )
                                                              )
						--No Set Service Engeneer
                                                            AND ( ( @no_set IS NULL
                                                              OR @no_set < 0
                                                              )
                                                              OR ( @no_set = 1
                                                              AND sc.id_service_engeneer IS NOT NULL
                                                              )
                                                              OR ( @no_set = 0
                                                              AND sc.id_service_engeneer IS NULL
                                                              )
                                                              )
                                                ) AS t
                                      GROUP BY  t.display_name ,
                                                t.id_manager
                                    ) AS tt
                            ORDER BY tt.display_name
                        END
                    ELSE
                        IF @action = 'getPlanExecuteServManagerContractorList'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END

                                IF YEAR(@date_month) = YEAR(GETDATE())
                                    AND MONTH(@date_month) = MONTH(GETDATE())
                                    AND @date_begin IS NULL
                                    AND @date_end IS NULL
                                    AND ( @is_done IS NULL
                                          OR @is_done < 0
                                        )
                                    AND ( @no_set = 1 )
                                    BEGIN
                                        SELECT  *
                                        FROM    srvpl_getPlanExecuteServManagerContractorList_curr_month_cache t
                                        WHERE   id_manager = @id_manager
                                    END
                                ELSE
                                    BEGIN

                                        SELECT  tt.NAME AS contractor ,
                                                tt.id_contractor ,
                                                tt.id_manager ,
                                                tt.plan_cnt ,
                                                tt.done_cnt ,
                                                tt.plan_cnt - tt.done_cnt AS residue ,
                                                CONVERT(DECIMAL(10, 0), ( CONVERT(DECIMAL(10,
                                                              2), tt.done_cnt)
                                                              / CONVERT(DECIMAL(10,
                                                              2), tt.plan_cnt) )
                                                * 100) AS done_percent
                                        FROM    ( SELECT    t.NAME ,
                                                            t.id_contractor ,
                                                            t.id_manager ,
                                                            SUM(t.[plan]) AS plan_cnt ,
                                                            SUM(t.done) AS done_cnt
                                                  FROM      ( SELECT
                                                              ctr.NAME ,
                                                              ctr.id AS id_contractor ,
                                                              c.id_manager ,
                                                              1 AS [plan] ,
                                                              CASE
                                                              WHEN EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.id_service_claim = sc.id_service_claim
                                                              AND scm.enabled = 1 )
                                                              THEN 1
                                                              ELSE 0
                                                              END AS done
                                                              FROM
                                                              dbo.srvpl_service_claims sc
                                                              INNER JOIN dbo.srvpl_contract2devices c2d ON sc.id_contract2devices = c2d.id_contract2devices
                                                              INNER JOIN dbo.srvpl_devices d ON sc.id_device = d.id_device
                                                              INNER JOIN dbo.srvpl_contracts c ON sc.id_contract = c.id_contract
                                                              INNER JOIN dbo.get_contractor(NULL)
                                                              AS ctr ON c.id_contractor = ctr.id
                                                              WHERE
                                                              sc.enabled = 1
                                                              AND d.enabled = 1
                                                              AND c.enabled = 1
                                                              AND c2d.enabled = 1
                                                              AND ( @id_service_claim IS NULL
                                                              OR ( @id_service_claim IS NOT NULL
                                                              AND sc.id_service_claim = @id_service_claim
                                                              )
                                                              )
                                                              AND ( @id_service_engeneer IS NULL
                                                              OR ( @id_service_engeneer IS NOT NULL
                                                              AND sc.id_service_engeneer = @id_service_engeneer
                                                              )
                                                              )
                                                              AND ( @id_service_admin IS NULL
                                                              OR ( @id_service_admin IS NOT NULL
                                                              AND c2d.id_service_admin = @id_service_admin
                                                              )
                                                              )
                                                              AND ( @id_manager IS NULL
                                                              OR ( @id_manager IS NOT NULL
                                                              AND c.id_manager = @id_manager
                                                              )
                                                              )
                                                              AND ( @id_contractor IS NULL
                                                              OR ( @id_contractor IS NOT NULL
                                                              AND c.id_contractor = @id_contractor
                                                              )
                                                              )
                                                              AND ( @date_begin IS NULL
                                                              OR ( @date_begin IS NOT NULL
                                                              AND CONVERT(DATE, sc.planing_date) >= CONVERT(DATE, @date_begin)
                                                              )
                                                              )
                                                              AND ( @date_end IS NULL
                                                              OR ( @date_end IS NOT NULL
                                                              AND CONVERT(DATE, sc.planing_date) <= CONVERT(DATE, @date_end)
                                                              )
                                                              )
                                                              AND ( @date_month IS NULL
                                                              OR ( @date_month IS NOT NULL
                                                              AND MONTH(sc.planing_date) = MONTH(@date_month)
                                                              AND YEAR(sc.planing_date) = YEAR(@date_month)
                                                              )
                                                              )
                                                              AND ( ( @is_done IS NULL
                                                              OR @is_done < 0
                                                              )
                                                              OR ( @is_done = 1
                                                              AND EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.id_service_claim = sc.id_service_claim
                                                              AND scm.enabled = 1 )
                                                              )
                                                              OR ( @is_done = 0
                                                              AND NOT EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.id_service_claim = sc.id_service_claim
                                                              AND scm.enabled = 1 )
                                                              )
                                                              )
							--No Set Service Engeneer
                                                              AND ( ( @no_set IS NULL
                                                              OR @no_set < 0
                                                              )
                                                              OR ( @no_set = 1
                                                              AND sc.id_service_engeneer IS NOT NULL
                                                              )
                                                              OR ( @no_set = 0
                                                              AND sc.id_service_engeneer IS NULL
                                                              )
                                                              )
                                                            ) AS t
                                                  GROUP BY  t.NAME ,
                                                            t.id_contractor ,
                                                            t.id_manager
                                                ) AS tt
                                        ORDER BY tt.NAME
                                    END
                            END
                        ELSE
                            IF @action = 'getPlanExecuteEngeneerList'
                                BEGIN
                                    IF @sp_test IS NOT NULL
                                        BEGIN
                                            RETURN
                                        END
                                    IF YEAR(@date_month) = YEAR(GETDATE())
                                        AND MONTH(@date_month) = MONTH(GETDATE())
                                        --AND @id_service_claim IS NULL
                                        AND @id_manager IS NULL
                                        AND @date_begin IS NULL
                                        AND @date_end IS NULL
                                        AND ( @is_done IS NULL
                                              OR @is_done < 0
                                            )
                                        AND ( @no_set = 1 )
                                        BEGIN
                                            SELECT  *
                                            FROM    srvpl_getPlanExecuteEngeneerList_curr_month t
                                            WHERE   ( @id_service_engeneer IS NULL
                                                      OR ( @id_service_engeneer IS NOT NULL
                                                           AND t.id_service_engeneer = @id_service_engeneer
                                                         )
                                                    )
                                        END
                                    ELSE
                                        BEGIN
                                            SELECT  tt.display_name AS service_engeneer ,
                                                    tt.id_service_engeneer ,
                                                    tt.plan_cnt ,
                                                    tt.done_cnt ,
                                                    tt.plan_cnt - tt.done_cnt AS residue ,
                                                    CONVERT(DECIMAL(10, 0), ( CONVERT(DECIMAL(10,
                                                              2), tt.done_cnt)
                                                              / CONVERT(DECIMAL(10,
                                                              2), tt.plan_cnt) )
                                                    * 100) AS done_percent
                                            FROM    ( SELECT  t.display_name ,
                                                              t.id_service_engeneer ,
                                                              SUM(t.[plan]) AS plan_cnt ,
                                                              SUM(t.done) AS done_cnt
                                                      FROM    ( SELECT
                                                              u.display_name ,
                                                              id_service_engeneer ,
                                                              1 AS [plan] ,
                                                              CASE
                                                              WHEN EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.id_service_claim = sc.id_service_claim
                                                              AND scm.enabled = 1 )
                                                              THEN 1
                                                              ELSE 0
                                                              END AS done
                                                              FROM
                                                              dbo.srvpl_service_claims sc
                                                              INNER JOIN srvpl_contract2devices c2d ON sc.id_contract2devices = c2d.id_contract2devices
                                                              INNER JOIN dbo.srvpl_devices d ON sc.id_device = d.id_device
                                                              INNER JOIN dbo.srvpl_contracts c ON sc.id_contract = c.id_contract
                                                              INNER JOIN dbo.users u ON u.id_user = sc.id_service_engeneer
                                                              WHERE
                                                              sc.enabled = 1
                                                              AND d.enabled = 1
                                                              AND c.enabled = 1
                                                              AND c2d.enabled = 1
                                                              AND ( @id_service_claim IS NULL
                                                              OR ( @id_service_claim IS NOT NULL
                                                              AND sc.id_service_claim = @id_service_claim
                                                              )
                                                              )
                                                              AND ( @id_service_engeneer IS NULL
                                                              OR ( @id_service_engeneer IS NOT NULL
                                                              AND sc.id_service_engeneer = @id_service_engeneer
                                                              )
                                                              )
                                                              AND ( @id_manager IS NULL
                                                              OR ( @id_manager IS NOT NULL
                                                              AND c.id_manager = @id_manager
                                                              )
                                                              )
                                                              AND ( @date_begin IS NULL
                                                              OR ( @date_begin IS NOT NULL
                                                              AND CONVERT(DATE, sc.planing_date) >= CONVERT(DATE, @date_begin)
                                                              )
                                                              )
                                                              AND ( @date_end IS NULL
                                                              OR ( @date_end IS NOT NULL
                                                              AND CONVERT(DATE, sc.planing_date) <= CONVERT(DATE, @date_end)
                                                              )
                                                              )
                                                              AND ( @date_month IS NULL
                                                              OR ( @date_month IS NOT NULL
                                                              AND MONTH(sc.planing_date) = MONTH(@date_month)
                                                              AND YEAR(sc.planing_date) = YEAR(@date_month)
                                                              )
                                                              )
                                                              AND ( ( @is_done IS NULL
                                                              OR @is_done < 0
                                                              )
                                                              OR ( @is_done = 1
                                                              AND EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.id_service_claim = sc.id_service_claim
                                                              AND scm.enabled = 1 )
                                                              )
                                                              OR ( @is_done = 0
                                                              AND NOT EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.id_service_claim = sc.id_service_claim
                                                              AND scm.enabled = 1 )
                                                              )
                                                              )
								--No Set Service Engeneer
                                                              AND ( ( @no_set IS NULL
                                                              OR @no_set < 0
                                                              )
                                                              OR ( @no_set = 1
                                                              AND sc.id_service_engeneer IS NOT NULL
                                                              )
                                                              OR ( @no_set = 0
                                                              AND sc.id_service_engeneer IS NULL
                                                              )
                                                              )
                                                              ) AS t
                                                      GROUP BY t.display_name ,
                                                              t.id_service_engeneer
                                                    ) AS tt
                                            ORDER BY tt.display_name
                                        END 
                                END
                            ELSE
                                IF @action = 'getPlanExecuteContractorList'
                                    BEGIN
                                        IF @sp_test IS NOT NULL
                                            BEGIN
                                                RETURN
                                            END
									
                                        IF YEAR(@date_month) = YEAR(GETDATE())
                                            AND MONTH(@date_month) = MONTH(GETDATE())
                                            AND @id_service_claim IS NULL
                                            AND @id_manager IS NULL
                                            AND @date_begin IS NULL
                                            AND @date_end IS NULL
                                            AND ( @is_done IS NULL
                                                  OR @is_done < 0
                                                )
                                            AND ( @no_set = 1 )
                                            BEGIN
                                                SELECT  *
                                                FROM    srvpl_getPlanExecuteContractorList_curr_month_cache t
                                                WHERE   t.id_service_engeneer = @id_service_engeneer
                                            END
                                        ELSE
                                            BEGIN
									
                                                SELECT  tt.NAME AS contractor ,
                                                        tt.id_contractor ,
                                                        tt.id_service_engeneer ,
                                                        tt.plan_cnt ,
                                                        tt.done_cnt ,
                                                        tt.plan_cnt
                                                        - tt.done_cnt AS residue ,
                                                        CONVERT(DECIMAL(10, 0), ( CONVERT(DECIMAL(10,
                                                              2), tt.done_cnt)
                                                              / CONVERT(DECIMAL(10,
                                                              2), tt.plan_cnt) )
                                                        * 100) AS done_percent
                                                FROM    ( SELECT
                                                              t.NAME ,
                                                              t.id_contractor ,
                                                              t.id_service_engeneer ,
                                                              SUM(t.[plan]) AS plan_cnt ,
                                                              SUM(t.done) AS done_cnt
                                                          FROM
                                                              ( SELECT
                                                              ctr.NAME ,
                                                              ctr.id AS id_contractor ,
                                                              sc.id_service_engeneer ,
                                                              1 AS [plan] ,
                                                              CASE
                                                              WHEN EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.id_service_claim = sc.id_service_claim
                                                              AND scm.enabled = 1 )
                                                              THEN 1
                                                              ELSE 0
                                                              END AS done
                                                              FROM
                                                              dbo.srvpl_service_claims sc
                                                              INNER JOIN srvpl_contract2devices c2d ON sc.id_contract2devices = c2d.id_contract2devices
                                                              INNER JOIN dbo.srvpl_devices d ON sc.id_device = d.id_device
                                                              INNER JOIN dbo.srvpl_contracts c ON sc.id_contract = c.id_contract
                                                              INNER JOIN dbo.get_contractor(NULL)
                                                              AS ctr ON c.id_contractor = ctr.id
                                                              WHERE
                                                              sc.enabled = 1
                                                              AND d.enabled = 1
                                                              AND c.enabled = 1
                                                              AND c2d.enabled = 1
                                                              AND ( @id_service_claim IS NULL
                                                              OR ( @id_service_claim IS NOT NULL
                                                              AND sc.id_service_claim = @id_service_claim
                                                              )
                                                              )
                                                              AND ( @id_service_engeneer IS NULL
                                                              OR ( @id_service_engeneer IS NOT NULL
                                                              AND sc.id_service_engeneer = @id_service_engeneer
                                                              )
                                                              )
                                                              AND ( @id_manager IS NULL
                                                              OR ( @id_manager IS NOT NULL
                                                              AND c.id_manager = @id_manager
                                                              )
                                                              )
                                                              AND ( @id_contractor IS NULL
                                                              OR ( @id_contractor IS NOT NULL
                                                              AND c.id_contractor = @id_contractor
                                                              )
                                                              )
                                                              AND ( @date_begin IS NULL
                                                              OR ( @date_begin IS NOT NULL
                                                              AND CONVERT(DATE, sc.planing_date) >= CONVERT(DATE, @date_begin)
                                                              )
                                                              )
                                                              AND ( @date_end IS NULL
                                                              OR ( @date_end IS NOT NULL
                                                              AND CONVERT(DATE, sc.planing_date) <= CONVERT(DATE, @date_end)
                                                              )
                                                              )
                                                              AND ( @date_month IS NULL
                                                              OR ( @date_month IS NOT NULL
                                                              AND MONTH(sc.planing_date) = MONTH(@date_month)
                                                              AND YEAR(sc.planing_date) = YEAR(@date_month)
                                                              )
                                                              )
                                                              AND ( ( @is_done IS NULL
                                                              OR @is_done < 0
                                                              )
                                                              OR ( @is_done = 1
                                                              AND EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.id_service_claim = sc.id_service_claim
                                                              AND scm.enabled = 1 )
                                                              )
                                                              OR ( @is_done = 0
                                                              AND NOT EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.id_service_claim = sc.id_service_claim
                                                              AND scm.enabled = 1 )
                                                              )
                                                              )
									--No Set Service Engeneer
                                                              AND ( ( @no_set IS NULL
                                                              OR @no_set < 0
                                                              )
                                                              OR ( @no_set = 1
                                                              AND sc.id_service_engeneer IS NOT NULL
                                                              )
                                                              OR ( @no_set = 0
                                                              AND sc.id_service_engeneer IS NULL
                                                              )
                                                              )
                                                              ) AS t
                                                          GROUP BY t.id_service_engeneer ,
                                                              t.NAME ,
                                                              t.id_contractor
                                                        ) AS tt
                                                ORDER BY tt.NAME
                                            END
                                    END
                                ELSE
                                    IF @action = 'getPlanExecuteDeviceList'
                                        BEGIN
                                            IF @sp_test IS NOT NULL
                                                BEGIN
                                                    RETURN
                                                END
									
                                            IF YEAR(@date_month) = YEAR(GETDATE())
                                                AND MONTH(@date_month) = MONTH(GETDATE())
                                                AND @date_begin IS NULL
                                                AND @date_end IS NULL
                                                AND ( @is_done IS NULL
                                                      OR @is_done < 0
                                                    )
                                                AND ( @no_set = 1 )
                                                BEGIN
                                                    SELECT  *
                                                    FROM    srvpl_getPlanExecuteDeviceList_curr_month_cache t
                                                    WHERE   ( @id_service_engeneer IS NULL
                                                              OR ( @id_service_engeneer IS NOT NULL
                                                              AND t.id_service_engeneer = @id_service_engeneer
                                                              )
                                                            )
                                                            AND ( @id_service_admin IS NULL
                                                              OR ( @id_service_admin IS NOT NULL
                                                              AND t.id_service_admin = @id_service_admin
                                                              )
                                                              )
                                                            AND ( @id_manager IS NULL
                                                              OR ( @id_manager IS NOT NULL
                                                              AND t.id_manager = @id_manager
                                                              )
                                                              )
                                                END
                                            ELSE
                                                BEGIN
									
                                                    SELECT  tt.device ,
                                                            tt.id_device ,
                                                            tt.plan_cnt ,
                                                            tt.done_cnt ,
                                                            tt.plan_cnt
                                                            - tt.done_cnt AS residue ,
                                                            CONVERT(DECIMAL(10,
                                                              0), ( CONVERT(DECIMAL(10,
                                                              2), tt.done_cnt)
                                                              / CONVERT(DECIMAL(10,
                                                              2), tt.plan_cnt) )
                                                            * 100) AS done_percent ,
                                                            tt.address ,
                                                            dbo.get_city_full_name(tt.id_city) AS city ,
                                                            ( SELECT
                                                              display_name
                                                              FROM
                                                              users u
                                                              WHERE
                                                              u.id_user = tt.id_service_engeneer
                                                            ) AS service_engeneer ,
                                                            tt.date_came ,
                                                            tt.id_service_claim ,
                                                            tt.id_contractor ,
                                                            tt.is_limit_device_claims
                                                    FROM    ( SELECT
                                                              t.device ,
                                                              t.id_device ,
                                                              t.id_city ,
                                                              t.ADDRESS ,
                                                              SUM(t.[plan]) AS plan_cnt ,
                                                              SUM(t.done) AS done_cnt ,
                                                              t.id_service_engeneer ,
                                                              t.date_came ,
                                                              t.id_service_claim ,
                                                              t.id_contractor ,
                                                              t.is_limit_device_claims
                                                              FROM
                                                              ( SELECT
                                                              dbo.srvpl_fnc('getDeviceShortCollectedNameNoBr',
                                                              NULL,
                                                              d.id_device,
                                                              NULL, NULL) AS device ,
                                                              sc.id_device ,
                                                              c2d.id_city ,
                                                              c2d.address ,
                                                              1 AS [plan] ,
                                                              CASE
                                                              WHEN EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.id_service_claim = sc.id_service_claim
                                                              AND scm.enabled = 1 )
                                                              THEN 1
                                                              ELSE 0
                                                              END AS done ,
                                                              sc.id_service_engeneer ,
                                                              ( SELECT
                                                              MAX(date_came)
                                                              FROM
                                                              dbo.srvpl_service_cames cam
                                                              WHERE
                                                              cam.enabled = 1
                                                              AND cam.id_service_claim = sc.id_service_claim
                                                              GROUP BY cam.id_service_claim
                                                              ) AS date_came ,
                                                              sc.id_service_claim ,
                                                              c.id_contractor ,
                                                              CASE
                                                              WHEN c.handling_devices IS NOT NULL
                                                              OR c.handling_devices > 0
                                                              THEN 1
                                                              ELSE 0
                                                              END AS is_limit_device_claims
                                                              FROM
                                                              dbo.srvpl_service_claims sc
                                                              INNER JOIN dbo.srvpl_contract2devices c2d ON sc.id_contract2devices = c2d.id_contract2devices
                                                              INNER JOIN dbo.srvpl_devices d ON sc.id_device = d.id_device
                                                              INNER JOIN dbo.srvpl_contracts c ON sc.id_contract = c.id_contract
                                                              INNER JOIN dbo.get_contractor(NULL)
                                                              AS ctr ON c.id_contractor = ctr.id
                                                              WHERE
                                                              sc.enabled = 1
                                                              AND c2d.enabled = 1
                                                              AND d.enabled = 1
                                                              AND c.enabled = 1
                                                              AND ( @id_service_claim IS NULL
                                                              OR ( @id_service_claim IS NOT NULL
                                                              AND sc.id_service_claim = @id_service_claim
                                                              )
                                                              )
                                                              AND ( @id_service_engeneer IS NULL
                                                              OR ( @id_service_engeneer IS NOT NULL
                                                              AND sc.id_service_engeneer = @id_service_engeneer
                                                              )
                                                              )
                                                              AND ( @id_service_admin IS NULL
                                                              OR ( @id_service_admin IS NOT NULL
                                                              AND c2d.id_service_admin = @id_service_admin
                                                              )
                                                              )
                                                              AND ( @id_contractor IS NULL
                                                              OR ( @id_contractor IS NOT NULL
                                                              AND c.id_contractor = @id_contractor
                                                              )
                                                              )
                                                              AND ( @date_begin IS NULL
                                                              OR ( @date_begin IS NOT NULL
                                                              AND CONVERT(DATE, sc.planing_date) >= CONVERT(DATE, @date_begin)
                                                              )
                                                              )
                                                              AND ( @date_end IS NULL
                                                              OR ( @date_end IS NOT NULL
                                                              AND CONVERT(DATE, sc.planing_date) <= CONVERT(DATE, @date_end)
                                                              )
                                                              )
                                                              AND ( @date_month IS NULL
                                                              OR ( @date_month IS NOT NULL
                                                              AND MONTH(sc.planing_date) = MONTH(@date_month)
                                                              AND YEAR(sc.planing_date) = YEAR(@date_month)
                                                              )
                                                              )
                                                              AND ( ( @is_done IS NULL
                                                              OR @is_done < 0
                                                              )
                                                              OR ( @is_done = 1
                                                              AND EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.id_service_claim = sc.id_service_claim
                                                              AND scm.enabled = 1 )
                                                              )
                                                              OR ( @is_done = 0
                                                              AND NOT EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.id_service_claim = sc.id_service_claim
                                                              AND scm.enabled = 1 )
                                                              )
                                                              )
										--No Set Service Engeneer
                                                              AND ( ( @no_set IS NULL
                                                              OR @no_set < 0
                                                              )
                                                              OR ( @no_set = 1
                                                              AND sc.id_service_engeneer IS NOT NULL
                                                              )
                                                              OR ( @no_set = 0
                                                              AND sc.id_service_engeneer IS NULL
                                                              )
                                                              )
                                                              ) AS t
                                                              GROUP BY t.id_service_claim ,
                                                              t.device ,
                                                              t.id_contractor ,
                                                              t.id_device ,
                                                              t.id_city ,
                                                              t.ADDRESS ,
                                                              t.id_service_engeneer ,
                                                              t.date_came ,
                                                              t.is_limit_device_claims
                                                            ) AS tt
                                                    ORDER BY tt.device
                                                END
                                        END

        IF @action = 'getCounterReportContractorList'
            BEGIN
	--Выбираем всех контрагентов у которых есть активные договоры
                SELECT  ctr.id ,
                        ctr.NAME ,
                        inn
                FROM    dbo.get_contractor(NULL) ctr
                        INNER JOIN dbo.srvpl_contracts c ON c.id_contractor = ctr.id
                WHERE   c.enabled = 1
                        AND dbo.srvpl_fnc('checkContractIsActiveOnMonth', NULL,
                                          c.id_contract, @date_month, NULL) = '1'
                        AND ( @id_manager IS NULL
                              OR ( @id_manager IS NOT NULL
                                   AND c.id_manager = @id_manager
                                 )
                            )
                GROUP BY ctr.id ,
                        ctr.NAME ,
                        inn
                ORDER BY ctr.NAME ,
                        inn
            END
        ELSE
            IF @action = 'getCounterReportContractorContractsList'
                BEGIN
                    SELECT  c.number ,
                            c.date_begin ,
                            c.date_end ,
                            ( SELECT    display_name
                              FROM      dbo.users
                              WHERE     id_user = c.id_manager
                            ) AS manager ,
                            c.id_contractor ,
                            c.id_contract ,
                            ( SELECT    COUNT(1)
                              FROM      dbo.srvpl_contract2devices c2d
                                        INNER JOIN dbo.srvpl_contracts c2 ON c2d.id_contract = c2.id_contract
                                        INNER JOIN dbo.srvpl_devices d ON c2d.id_device = d.id_device
                              WHERE     c2d.enabled = 1
                                        AND c2.enabled = 1
                                        AND d.enabled = 1
                                        AND c2d.id_contract = c.id_contract
                            ) AS dev_count --количество аппаратов
                    FROM    dbo.srvpl_contracts c
                    WHERE   c.enabled = 1
                            AND dbo.srvpl_fnc('checkContractIsActiveOnMonth',
                                              NULL, c.id_contract, @date_month,
                                              NULL) = '1'
                            AND ( @id_contractor IS NULL
                                  OR ( @id_contractor IS NOT NULL
                                       AND c.id_contractor = @id_contractor
                                     )
                                )
                            AND ( ( @id_manager IS NULL
                                    OR @id_manager <= 0
                                  )
                                  OR ( @id_manager > 0
                                       AND c.id_manager = @id_manager
                                     )
                                )
                END
            ELSE
                IF @action = 'getCounterReportContractorContractDeviceList'
                    BEGIN
                    
                        DECLARE @w_begin DECIMAL(5, 2) ,
                            @w_end DECIMAL(5, 2) ,
                            @l_begin DECIMAL(5, 2) ,
                            @l_end DECIMAL(5, 2)

                        IF @wear_begin IS NOT NULL
                            AND @wear_begin > 0
                            AND @wear_begin > 1
                            BEGIN
                                SET @w_begin = CONVERT(DECIMAL(10, 2), @wear_begin)
                                    / 100
                            END 

                        IF @wear_end IS NOT NULL
                            AND @wear_end > 0
                            AND @wear_end > 1
                            BEGIN
                                SET @w_end = CONVERT(DECIMAL(10, 2), @wear_end)
                                    / 100
                            END 
    
                        IF @loading_begin IS NOT NULL
                            AND @loading_begin > 0
                            AND @loading_begin > 1
                            BEGIN
                                SET @l_begin = CONVERT(DECIMAL(10, 2), @loading_begin)
                                    / 100
                            END 

                        IF @loading_end IS NOT NULL
                            AND @loading_end > 0
                            AND @loading_end > 1
                            BEGIN
                                SET @l_end = CONVERT(DECIMAL(10, 2), @loading_end)
                                    / 100
                            END     


                        SELECT  /*0*/
                                id_contract ,
                                /*1*/
                                id_device ,
                                /*2*/
                                device_name ,
                                /*3*/
                                last_date ,
                                /*4*/
                                last_counter ,
                                /*5*/
                                max_volume ,--максимальный объем печати в месяц
                                /*6*/
                                wear ,--износ
                                /*7*/
                                id_contractor ,
                                /*8*/
                                contractor_name ,
                                /*9*/
                                contract_number ,
                                /*10*/
                                cur_vol ,
                                /*11*/
                                prev_vol ,
                                /*12*/
                                prev_prev_vol ,
                                /*13*/
                                cur_vol_color ,
                                /*14*/
                                prev_vol_color ,
                                /*15*/
                                prev_prev_vol_color ,
                                /*16*/
                                cur_vol_total ,
                                /*17*/
                                prev_vol_total ,
                                /*18*/
                                prev_prev_vol_total ,
                                /*19*/
                                cur_loading ,
                                /*20*/
                                prev_loading ,
                                /*21*/
                                prev_prev_loading ,
                                /*22*/
                                vendor ,
                                /*23*/
                                has_came ,--Есть хоть один выезд в заданном месяце
        /*24*/
                                cur_is_average ,
        /*25*/
                                prev_is_average ,
                                /*26*/
                                prev_prev_is_average
                        FROM    ( SELECT    id_contract ,
                                            id_device ,
                                            device_name ,
                                            last_date ,
                                            last_counter ,
                                            max_volume ,--максимальный объем печати в месяц
                                            wear ,--износ
                                            id_contractor ,
                                            contractor_name ,
                                            contract_number ,
                                            cur_vol ,
                                            prev_vol ,
                                            prev_prev_vol ,
                                            cur_vol_color ,
                                            prev_vol_color ,
                                            prev_prev_vol_color ,
                                            cur_vol_total ,
                                            prev_vol_total ,
                                            prev_prev_vol_total ,
                                            CASE WHEN max_volume > 0
                                                 THEN CONVERT(DECIMAL(10, 2), CONVERT(DECIMAL(10,
                                                              2), cur_vol_total)
                                                      / CONVERT(DECIMAL(10, 2), max_volume))
                                                 ELSE NULL
                                            END AS cur_loading ,
                                            CASE WHEN max_volume > 0
                                                 THEN CONVERT(DECIMAL(10, 2), CONVERT(DECIMAL(10,
                                                              2), prev_vol_total)
                                                      / CONVERT(DECIMAL(10, 2), max_volume))
                                                 ELSE NULL
                                            END AS prev_loading ,
                                            CASE WHEN max_volume > 0
                                                 THEN CONVERT(DECIMAL(10, 2), CONVERT(DECIMAL(10,
                                                              2), prev_prev_vol_total)
                                                      / CONVERT(DECIMAL(10, 2), max_volume))
                                                 ELSE NULL
                                            END AS prev_prev_loading ,
                                            vendor ,
                                            CASE WHEN EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              srvpl_service_cames cam7
                                                              INNER JOIN srvpl_service_claims cl7 ON cam7.id_service_claim = cl7.id_service_claim
                                                              WHERE
                                                              cam7.enabled = 1
                                                              AND cl7.enabled = 1
                                                              AND YEAR(cl7.planing_date) = YEAR(@date_month)
                                                              AND MONTH(cl7.planing_date) = MONTH(@date_month)
                                                              AND cl7.id_device = t7.id_device
                                                              AND cl7.id_contract = t7.id_contract )
                                                 THEN 1
                                                 ELSE 0
                                            END AS has_came ,
                                            cur_is_average ,
                                            prev_is_average ,
                                            prev_prev_is_average
                                  FROM      ( SELECT    id_contract ,
                                                        id_device ,
                                                        device_name ,
                                                        last_date ,
                                                        last_counter ,
                                                        max_volume ,--максимальный объем печати в месяц
                                                        wear ,--износ
                                                        id_contractor ,
                                                        contractor_name ,
                                                        contract_number ,
                                                        cur_vol ,
                                                        prev_vol ,
                                                        prev_prev_vol ,
                                                        cur_vol_color ,
                                                        prev_vol_color ,
                                                        prev_prev_vol_color ,
                                                        ISNULL(cur_vol, 0)
                                                        + ISNULL(cur_vol_color,
                                                              0) AS cur_vol_total ,
                                                        ISNULL(prev_vol, 0)
                                                        + ISNULL(prev_vol_color,
                                                              0) AS prev_vol_total ,
                                                        ISNULL(prev_prev_vol,
                                                              0)
                                                        + ISNULL(prev_prev_vol_color,
                                                              0) AS prev_prev_vol_total ,
                                                        vendor ,
                                                        cur_is_average ,
                                                        prev_is_average ,
                                                        prev_prev_is_average
                                              FROM      ( SELECT
                                                              id_contract ,
                                                              id_device ,
                                                              device_name ,
                                                              last_date ,
                                                              last_counter ,
                                                              max_volume ,--максимальный объем печати в месяц
                                                              wear ,--износ
                                                              id_contractor ,
                                                              ctr.NAME AS contractor_name ,
                                                              number AS contract_number ,
                                                              ( SELECT
                                                              ISNULL(dd.volume_counter,
                                                              0)
                                                              FROM
                                                              dbo.srvpl_device_data dd
                                                              WHERE
                                                              dd.enabled = 1
                                                              AND dd.id_contract = t5.id_contract
                                                              AND dd.id_device = t5.id_device
                                                  --Выбираем текущий  месяца
                                                              AND ( ( YEAR(dd.date_month) = YEAR(@date_month)
                                                              AND MONTH(dd.date_month) = MONTH(@date_month)
                                          )
                                                              )
                                                              ) AS cur_vol ,
                                                              ( SELECT
                                                              ISNULL(dd.volume_counter,
                                                              0)
                                                              FROM
                                                              dbo.srvpl_device_data dd
                                                              WHERE
                                                              dd.enabled = 1
                                                              AND dd.id_contract = t5.id_contract
                                                              AND dd.id_device = t5.id_device
                                                  --Выбираем предыдущий  месяц
                                                              AND ( ( YEAR(dd.date_month) = YEAR(DATEADD(month,
                                                              -1, @date_month))
                                                              AND MONTH(dd.date_month) = MONTH(DATEADD(month,
                                                              -1, @date_month))
                                             )
                                                              )
                                                              ) AS prev_vol ,
                                                              ( SELECT
                                                              ISNULL(dd.volume_counter,
                                                              0)
                                                              FROM
                                                              dbo.srvpl_device_data dd
                                                              WHERE
                                                              dd.enabled = 1
                                                              AND dd.id_contract = t5.id_contract
                                                              AND dd.id_device = t5.id_device
                                                  --Выбираем ПРЕДпредыдущий  месяц
                                                              AND ( ( YEAR(dd.date_month) = YEAR(DATEADD(month,
                                                              -2, @date_month))
                                                              AND MONTH(dd.date_month) = MONTH(DATEADD(month,
                                                              -2, @date_month))
                                             )
                                                              )
                                                              ) AS prev_prev_vol ,
                                                              ( SELECT
                                                              ISNULL(dd.volume_counter_colour,
                                                              0)
                                                              FROM
                                                              dbo.srvpl_device_data dd
                                                              WHERE
                                                              dd.enabled = 1
                                                              AND dd.id_contract = t5.id_contract
                                                              AND dd.id_device = t5.id_device
                                                  --Выбираем текущий  месяца
                                                              AND ( ( YEAR(dd.date_month) = YEAR(@date_month)
                                                              AND MONTH(dd.date_month) = MONTH(@date_month)
                                          )
                                                              )
                                                              ) AS cur_vol_color ,
                                                              ( SELECT
                                                              ISNULL(dd.volume_counter_colour,
                                                              0)
                                                              FROM
                                                              dbo.srvpl_device_data dd
                                                              WHERE
                                                              dd.enabled = 1
                                                              AND dd.id_contract = t5.id_contract
                                                              AND dd.id_device = t5.id_device
                                                  --Выбираем предыдущий  месяц
                                                              AND ( ( YEAR(dd.date_month) = YEAR(DATEADD(month,
                                                              -1, @date_month))
                                                              AND MONTH(dd.date_month) = MONTH(DATEADD(month,
                                                              -1, @date_month))
                                             )
                                                              )
                                                              ) AS prev_vol_color ,
                                                              ( SELECT
                                                              ISNULL(dd.volume_counter_colour,
                                                              0)
                                                              FROM
                                                              dbo.srvpl_device_data dd
                                                              WHERE
                                                              dd.enabled = 1
                                                              AND dd.id_contract = t5.id_contract
                                                              AND dd.id_device = t5.id_device
                                                  --Выбираем ПРЕДпредыдущий  месяц
                                                              AND ( ( YEAR(dd.date_month) = YEAR(DATEADD(month,
                                                              -2, @date_month))
                                                              AND MONTH(dd.date_month) = MONTH(DATEADD(month,
                                                              -2, @date_month))
                                             )
                                                              )
                                                              ) AS prev_prev_vol_color ,
                                                              vendor ,
                                                              ( SELECT
                                                              is_average
                                                              FROM
                                                              dbo.srvpl_device_data dd
                                                              WHERE
                                                              dd.enabled = 1
                                                              AND dd.id_contract = t5.id_contract
                                                              AND dd.id_device = t5.id_device
                                                  --Выбираем текущий  месяца
                                                              AND ( ( YEAR(dd.date_month) = YEAR(@date_month)
                                                              AND MONTH(dd.date_month) = MONTH(@date_month)
                                          )
                                                              )
                                                              ) AS cur_is_average ,
                                                              ( SELECT
                                                              is_average
                                                              FROM
                                                              dbo.srvpl_device_data dd
                                                              WHERE
                                                              dd.enabled = 1
                                                              AND dd.id_contract = t5.id_contract
                                                              AND dd.id_device = t5.id_device
                                                  --Выбираем предыдущий  месяц
                                                              AND ( ( YEAR(dd.date_month) = YEAR(DATEADD(month,
                                                              -1, @date_month))
                                                              AND MONTH(dd.date_month) = MONTH(DATEADD(month,
                                                              -1, @date_month))
                                             )
                                                              )
                                                              ) AS prev_is_average ,
                                                              ( SELECT
                                                              is_average
                                                              FROM
                                                              dbo.srvpl_device_data dd
                                                              WHERE
                                                              dd.enabled = 1
                                                              AND dd.id_contract = t5.id_contract
                                                              AND dd.id_device = t5.id_device
                                                  --Выбираем ПРЕДпредыдущий  месяц
                                                              AND ( ( YEAR(dd.date_month) = YEAR(DATEADD(month,
                                                              -2, @date_month))
                                                              AND MONTH(dd.date_month) = MONTH(DATEADD(month,
                                                              -2, @date_month))
                                             )
                                                              )
                                                              ) AS prev_prev_is_average
                                                          FROM
                                                              ( SELECT
                                                              id_contract ,
                                                              id_device ,
                                                              device_name ,
                                                              last_date ,
                                                              last_counter ,
                                                              max_volume ,--максимальный объем печати в месяц
                                                              CASE
                                                              WHEN max_volume > 0
                                                              AND max_volume IS NOT NULL
                                                              THEN CONVERT(DECIMAL(15,
                                                              2), CONVERT(DECIMAL(15,
                                                              2), last_counter)
                                                              / ( CONVERT(DECIMAL(15,
                                                              2), max_volume)
                                                              * CONVERT(DECIMAL(15,
                                                              2), 12)
                                                              * CONVERT(DECIMAL(15,
                                                              2), 5) ))
                                                              ELSE NULL
                                                              END AS wear ,--износ
                                                              id_contractor ,
                                                              number ,
                                                              vendor
                                                              FROM
                                                              ( SELECT
                                                              id_contract ,
                                                              id_device ,
                                                              device_name ,
                                                              last_date ,
                                                              ( SELECT
                                                              ISNULL(dd3.counter,
                                                              0)
                                                              + ISNULL(dd3.counter_colour,
                                                              0)
                                                              FROM
                                                              dbo.srvpl_device_data dd3
                                                              WHERE
                                                              dd3.enabled = 1
                                                              AND dd3.id_contract = tt.id_contract
                                                              AND dd3.id_device = tt.id_device
                                                              AND dd3.date_month = last_date
                                                              ) AS last_counter ,
                                                              max_volume ,
                                                              id_contractor ,
                                                              number ,
                                                              vendor
                                                              FROM
                                                              ( SELECT
                                                              id_contract ,
                                                              id_device ,
                                                              dbo.srvpl_fnc('getDeviceShortCollectedNameNoBr',
                                                              NULL,
                                                              t.id_device,
                                                              NULL, NULL) AS device_name ,
                                                              ( SELECT
                                                              MAX(date_month)
                                                              FROM
                                                              dbo.srvpl_device_data dd2
                                                              WHERE
                                                              dd2.enabled = 1
                                                              AND dd2.id_contract = t.id_contract
                                                              AND dd2.id_device = t.id_device
                                                              ) AS last_date ,
                                                              max_volume ,
                                                              id_contractor ,
                                                              number ,
                                                              vendor
                                                              FROM
                                                              ( SELECT
                                                              c2d.id_contract ,
                                                              c2d.id_device ,
                                                              dm.max_volume ,
                                                              c.id_contractor ,
                                                              number ,
                                                              dm.vendor
                                                              FROM
                                                              dbo.srvpl_contract2devices c2d
                                                              INNER JOIN dbo.srvpl_contracts c ON c2d.id_contract = c.id_contract
                                                              INNER JOIN dbo.srvpl_devices d ON c2d.id_device = d.id_device
                                                              INNER JOIN dbo.srvpl_device_models dm ON d.id_device_model = dm.id_device_model
                                                              WHERE
                                                              c2d.enabled = 1
                                                              AND c.enabled = 1
                                                              AND d.enabled = 1
                                                              AND dbo.srvpl_fnc('checkContractIsActiveOnMonth',
                                                              NULL,
                                                              c.id_contract,
                                                              @date_month,
                                                              NULL) = '1'
                                                              AND ( @id_contractor IS NULL
                                                              OR ( @id_contractor IS NOT NULL
                                                              AND c.id_contractor = @id_contractor
                                                              )
                                                              )
                                                              AND ( ( @id_manager IS NULL
                                                              OR @id_manager <= 0
                                                              )
                                                              OR ( @id_manager > 0
                                                              AND c.id_manager = @id_manager
                                                              )
                                                              )
                                                              GROUP BY c2d.id_contract ,
                                                              number ,
                                                              c.id_contractor ,
                                                              c2d.id_device ,
                                                              dm.vendor ,
                                                              dm.max_volume
                                                              ) AS t
                                                              ) AS tt
                                                              ) AS ttt
                                                              ) AS t5
                                                              INNER JOIN get_contractor(NULL) ctr ON id_contractor = ctr.id
                                                          WHERE
                                                              ( ( @w_begin IS NULL
                                                              OR @w_begin <= 0
                                                              )
                                                              OR ( ( @w_begin IS NOT NULL
                                                              AND @w_begin > 0
                                                              )
                                                              AND ( wear >= @w_begin )
                                                              )
                                                              )
                                                              AND ( ( @w_end IS NULL
                                                              OR @w_end <= 0
                                                              )
                                                              OR ( ( @w_end IS NOT NULL
                                                              AND @w_end > 0
                                                              )
                                                              AND ( wear <= @w_end )
                                                              )
                                                              )
                                                        ) AS t6
                                            ) AS t7
                                ) AS t8
                        WHERE   ( ( @l_begin IS NULL
                                    OR @l_begin <= 0
                                  )
                                  OR ( ( @l_begin IS NOT NULL
                                         AND @l_begin > 0
                                       )
                                       AND ( cur_loading >= @l_begin
                                             OR prev_loading >= @l_begin
                                             OR prev_prev_loading >= @l_begin
                                           )
                                     )
                                )
                                AND ( ( @l_end IS NULL
                                        OR @l_end <= 0
                                      )
                                      OR ( ( @l_end IS NOT NULL
                                             AND @l_end > 0
                                           )
                                           AND ( cur_loading <= @l_end
                                                 OR prev_loading <= @l_end
                                                 OR prev_prev_loading <= @l_end
                                               )
                                         )
                                    )
                                AND ( ( @lst_vendor IS NULL
                                        OR LTRIM(RTRIM(@lst_vendor)) = ''
                                      )
                                      OR ( @lst_vendor IS NOT NULL
                                           AND LTRIM(RTRIM(@lst_vendor)) != ''
                                           AND vendor IN (
                                           SELECT   value
                                           FROM     dbo.Split(@lst_vendor, ',') )
                                         )
                                    )
                                AND ( ( @has_cames IS NULL
                                        OR @has_cames < 0
                                      )
                                      OR ( @has_cames IS NOT NULL
                                           AND @has_cames = 1
                                           AND has_came = 1
                                         )
                                      OR ( @has_cames IS NOT NULL
                                           AND @has_cames = 0
                                           AND has_came = 0
                                         )
                                    )
                        ORDER BY id_contract ,
                                device_name                           
                    END
                ELSE
                    IF @action = 'getCounterReportContractorContractDeviceData'
                        BEGIN
                            SELECT  dd.id_contract ,
                                    dd.id_device ,
                                    dd.counter ,
                                    dd.counter_colour ,
                                    ( ISNULL(dd.counter, 0)
                                      + ISNULL(dd.counter_colour, 0) ) AS counter_total ,
                                    dd.volume_counter ,
                                    dd.volume_counter_colour ,
                                    ( ISNULL(dd.volume_counter, 0)
                                      + ISNULL(dd.volume_counter_colour, 0) ) AS volume_total ,
                                    dd.date_month ,
                                    YEAR(dd.date_month) AS d_year ,
                                    MONTH(dd.date_month) AS d_month ,
                                    c.id_contractor ,
        --CASE WHEN EXISTS ( SELECT   1
        --                   FROM     dbo.srvpl_device_data dd2
        --                   WHERE    dd2.enabled = 1
        --                            AND dd2.id_contract = dd.id_contract
        --                            AND dd2.id_device = dd.id_device
        --                            AND ( YEAR(dd2.date_month) = YEAR(DATEADD(month,
        --                                                      -1,
        --                                                      dd.date_month))
        --                                  AND MONTH(dd2.date_month) = MONTH(DATEADD(month,
        --                                                      -1,
        --                                                      dd.date_month))
        --                                ) ) THEN 1
        --     ELSE 0
        --END AS has_prev_month_record
                                    dd.is_average
                            FROM    dbo.srvpl_device_data dd
                                    INNER JOIN dbo.srvpl_contracts c ON dd.id_contract = c.id_contract
                                    INNER JOIN dbo.srvpl_devices d ON d.id_device = dd.id_device
                            WHERE   dd.enabled = 1
                                    AND c.enabled = 1
                                    AND d.enabled = 1
                                    AND dbo.srvpl_fnc('checkContractIsActiveOnMonth',
                                                      NULL, c.id_contract,
                                                      @date_month, NULL) = '1'
                                                  
                                                  --Выбираем текущий и два предыдущих месяца
                                    AND ( ( YEAR(dd.date_month) = YEAR(@date_month)
                                            AND MONTH(dd.date_month) = MONTH(@date_month)
                                          )
                                          OR ( YEAR(dd.date_month) = YEAR(DATEADD(month,
                                                              -1, @date_month))
                                               AND MONTH(dd.date_month) = MONTH(DATEADD(month,
                                                              -1, @date_month))
                                             )
                                          OR ( YEAR(dd.date_month) = YEAR(DATEADD(month,
                                                              -2, @date_month))
                                               AND MONTH(dd.date_month) = MONTH(DATEADD(month,
                                                              -2, @date_month))
                                             )
                                        )
                                    AND ( @id_contractor IS NULL
                                          OR ( @id_contractor IS NOT NULL
                                               AND c.id_contractor = @id_contractor
                                             )
                                        )
                                    AND ( ( @id_manager IS NULL
                                            OR @id_manager <= 0
                                          )
                                          OR ( @id_manager > 0
                                               AND c.id_manager = @id_manager
                                             )
                                        )
                        END
            

        IF @action = 'getEngeneerAllocList'
            BEGIN
                IF MONTH(@date_month) = MONTH(GETDATE())
                    AND YEAR(@date_month) = YEAR(GETDATE())
                    BEGIN
                        SELECT  *
                        FROM    [unit_prog].[dbo].[srvpl_getEngeneerAllocList _curr_month]
                        WHERE   ( @id_service_engeneer IS NULL
                                  OR ( @id_service_engeneer IS NOT NULL
                                       AND id_service_engeneer = @id_service_engeneer
                                     )
                                )
                        ORDER BY CASE @norm_order
                                   WHEN 1 THEN [exec_diff]
                                 END DESC ,
                                CASE @norm_order
                                  WHEN 0 THEN [exec_diff]
                                END ,
                                CASE WHEN @norm_order IS NULL
                                          OR @norm_order > 1
                                          OR @norm_order < 0 THEN order_num
                                END ,
                                CASE WHEN @norm_order IS NULL
                                          OR @norm_order > 1
                                          OR @norm_order < 0
                                     THEN service_engeneer
                                END
                    END
                ELSE
                    BEGIN
                        SELECT  tttttt.*
                        FROM    ( SELECT    ttttt.* ,
                                            exec_claims - cur_norm_exec AS exec_diff ,
                                            CASE WHEN exec_claims IS NOT NULL
                                                      AND exec_claims > 0
                                                 THEN ( CONVERT(DECIMAL(10, 2), exec_claims)
                                                        / CONVERT(DECIMAL(10,
                                                              2), cur_norm_exec) )
                                                      * 100
                                                 ELSE 0
                                            END AS norm_exec_percent
                                  FROM      ( SELECT    tttt.* ,
                                                        ( norm * exec_days ) AS cur_norm_exec ,
                                                        CONVERT(DECIMAL(10, 2), exec_claims)
                                                        / CONVERT(DECIMAL(10,
                                                              2), exec_days) AS cur_norm ,
                                                        DATEDIFF(day,
                                                              DATEADD(day,
                                                              1
                                                              - DAY(@date_month),
                                                              @date_month),
                                                              DATEADD(month, 1,
                                                              DATEADD(day,
                                                              1
                                                              - DAY(@date_month),
                                                              @date_month)))
                                                        - exec_days AS residue_days
                                              FROM      ( SELECT
                                                              ttt.* ,
                                                              DATEDIFF(day,
                                                              DATEADD(day,
                                                              1
                                                              - DAY(@date_month),
                                                              @date_month),
                                                              ttt.last_exec_day) AS exec_days
                                                          FROM
                                                              ( SELECT
                                                              tt.* ,
                                                              CASE
                                                              WHEN tt.last_claim_day < GETDATE()
                                                              THEN GETDATE()
                                                              ELSE tt.last_claim_day
                                                              END AS last_exec_day ,
                                                              ( tt.cnt
                                                              - tt.exec_claims ) AS residue ,
                                                              CONVERT(DECIMAL(10,
                                                              2), tt.cnt)
                                                              / CONVERT(DECIMAL(10,
                                                              2), days_in_month) AS norm ,
                                                              CASE
                                                              WHEN service_engeneer = 'не назначено'
                                                              THEN 1
                                                              ELSE 0
                                                              END AS order_num
                                                              FROM
                                                              ( SELECT
                                                              t.id_service_engeneer ,
                                                              ( SELECT
                                                              city
                                                              FROM
                                                              users eng_u
                                                              WHERE
                                                              eng_u.id_user = t.id_service_engeneer
                                                              ) AS engeneer_city ,
                                                              ( SELECT
                                                              company
                                                              FROM
                                                              users eng_u
                                                              WHERE
                                                              eng_u.id_user = t.id_service_engeneer
                                                              ) AS engeneer_org ,
                                                              ( SELECT
                                                              position
                                                              FROM
                                                              users eng_u
                                                              WHERE
                                                              eng_u.id_user = t.id_service_engeneer
                                                              ) AS engeneer_pos ,
                                                              ISNULL(( SELECT
                                                              display_name
                                                              FROM
                                                              users u
                                                              WHERE
                                                              u.id_user = t.id_service_engeneer
                                                              ),
                                                              'не назначено') AS service_engeneer ,
                                                              COUNT(1) AS cnt ,
                                                              SUM(exec_claim) AS exec_claims ,
                                                              DATEDIFF(day,
                                                              DATEADD(day,
                                                              1
                                                              - DAY(@date_month),
                                                              @date_month),
                                                              DATEADD(month, 1,
                                                              DATEADD(day,
                                                              1
                                                              - DAY(@date_month),
                                                              @date_month))) AS days_in_month ,
                                                              ISNULL(( SELECT
                                                              MAX(date_came)
                                                              FROM
                                                              dbo.srvpl_service_cames scam
                                                              INNER JOIN dbo.srvpl_service_claims sc2 ON scam.id_service_claim = sc2.id_service_claim
                                                              INNER JOIN dbo.srvpl_contract2devices c2d2 ON sc2.id_contract2devices = c2d2.id_contract2devices
                                                              INNER JOIN dbo.srvpl_contracts c2 ON c2d2.id_contract = c2.id_contract
                                                              INNER JOIN dbo.srvpl_devices d2 ON c2d2.id_device = d2.id_device
                                                              WHERE
                                                              scam.enabled = 1
                                                              AND sc2.enabled = 1
                                                              AND c2d2.enabled = 1
                                                              AND c2.enabled = 1
                                                              AND d2.enabled = 1
                                                              AND sc2.id_service_engeneer IS NOT NULL
                                                              AND sc2.id_service_engeneer > 0
                                                              AND ( @id_service_engeneer IS NULL
                                                              OR ( @id_service_engeneer IS NOT NULL
                                                              AND sc2.id_service_engeneer = @id_service_engeneer
                                                              )
                                                              )
                                                              AND ( @date_month IS NULL
                                                              OR ( @date_month IS NOT NULL
                                                              AND MONTH(sc2.planing_date) = MONTH(@date_month)
                                                              AND YEAR(sc2.planing_date) = YEAR(@date_month)
                                                              )
                                                              )
                                                              ),
                                                              CONVERT(DATETIME, CONVERT(NVARCHAR, YEAR(@date_month))
                                                              + '-'
                                                              + CONVERT(NVARCHAR, MONTH(@date_month))
                                                              + '-' + '01')) AS last_claim_day
                                                              FROM
                                                              ( SELECT
                                                              sc.id_service_engeneer ,
                                                              CASE
                                                              WHEN EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.enabled = 1
                                                              AND sc.id_service_claim = scm.id_service_claim )
                                                              THEN 1
                                                              ELSE 0
                                                              END AS exec_claim
                                                              FROM
                                                              dbo.srvpl_service_claims sc
                                                              INNER JOIN dbo.srvpl_contract2devices c2d ON sc.id_contract2devices = c2d.id_contract2devices
                                                              INNER JOIN dbo.srvpl_contracts c ON c2d.id_contract = c.id_contract
                                                              INNER JOIN dbo.srvpl_devices d ON c2d.id_device = d.id_device
                                                              WHERE
                                                              sc.enabled = 1
                                                              AND c2d.enabled = 1
                                                              AND c.enabled = 1
                                                              AND d.enabled = 1
                                    --AND sc.id_service_engeneer IS NOT NULL
                                    --AND sc.id_service_engeneer > 0
                                                              AND ( @id_service_engeneer IS NULL
                                                              OR ( @id_service_engeneer IS NOT NULL
                                                              AND sc.id_service_engeneer = @id_service_engeneer
                                                              )
                                                              )
                                                              AND ( @date_month IS NULL
                                                              OR ( @date_month IS NOT NULL
                                                              AND MONTH(sc.planing_date) = MONTH(@date_month)
                                                              AND YEAR(sc.planing_date) = YEAR(@date_month)
                                                              )
                                                              )
                                    --AND ( @date_day IS NULL
                                    --      OR ( @date_day IS NOT NULL
                                    --           AND EXISTS ( SELECT
                                    --                          1
                                    --                        FROM
                                    --                          dbo.srvpl_service_cames scm
                                    --                        WHERE
                                    --                          scm.enabled = 1
                                    --                          AND sc.id_service_claim = scm.id_service_claim
                                    --                          AND CONVERT(DATE, scm.date_came) = CONVERT(DATE, @date_day) )
                                    --         )
                                    --    )
                                                              ) AS t
                                                              GROUP BY t.id_service_engeneer
                                                              ) AS tt
                                                              ) AS ttt
                                                        ) AS tttt
                                            ) AS ttttt
                                ) AS tttttt
                        ORDER BY CASE @norm_order
                                   WHEN 1 THEN [exec_diff]
                                 END DESC ,
                                CASE @norm_order
                                  WHEN 0 THEN [exec_diff]
                                END ,
                                CASE WHEN @norm_order IS NULL
                                          OR @norm_order > 1
                                          OR @norm_order < 0 THEN order_num
                                END ,
                                CASE WHEN @norm_order IS NULL
                                          OR @norm_order > 1
                                          OR @norm_order < 0
                                     THEN service_engeneer
                                END
                    END
            END
        ELSE
            IF @action = 'getEngeneerDayAlloc'
                BEGIN
                    IF YEAR(@date_month) = YEAR(GETDATE())
                        AND MONTH(@date_month) = MONTH(GETDATE())
                        BEGIN
                            SELECT  CONVERT(DATE, date_came, 104) AS date_came ,
                                    id_service_engeneer ,
                                    SUM(exec_claims) AS exec_claims
                            FROM    [unit_prog].[dbo].[srvpl_getEngeneerDayAlloc_curr_month]
                            GROUP BY id_service_engeneer ,
                                    CONVERT(DATE, date_came, 104)
                            ORDER BY id_service_engeneer ,
                                    date_came
                        END 
                    ELSE
                        BEGIN
                            SELECT  sc.id_service_engeneer ,
                                    scm.date_came ,
                                    COUNT(1) AS exec_claims
                            FROM    dbo.srvpl_service_claims sc
                                    INNER JOIN dbo.srvpl_service_cames scm ON sc.id_service_claim = scm.id_service_claim
                                    INNER JOIN dbo.srvpl_contract2devices c2d ON sc.id_contract2devices = c2d.id_contract2devices
                                    INNER JOIN dbo.srvpl_contracts c ON c2d.id_contract = c.id_contract
                                    INNER JOIN dbo.srvpl_devices d ON c2d.id_device = d.id_device
                            WHERE   sc.enabled = 1
                                    AND c2d.enabled = 1
                                    AND c.enabled = 1
                                    AND d.enabled = 1
                                    AND YEAR(scm.date_came) = YEAR(@date_month)
                                    AND MONTH(scm.date_came) = MONTH(@date_month)
                            GROUP BY sc.id_service_engeneer ,
                                    scm.date_came
                            ORDER BY sc.id_service_engeneer ,
                                    date_came
                        END
                    
                    
                END
                
            ELSE
                IF @action = 'getDaysInMonth'
                    BEGIN
                        DECLARE @startDate DATETIME= CAST(MONTH(@date_month) AS VARCHAR)
                            + '/' + '01/'
                            + +CAST(YEAR(@date_month) AS VARCHAR) -- mm/dd/yyyy

                        DECLARE @endDate DATETIME
                        SET @endDate = DATEADD(s, -1,
                                               DATEADD(mm,
                                                       DATEDIFF(m, 0,
                                                              @date_month) + 1,
                                                       0));
                        WITH    Calender
                                  AS ( SELECT   @startDate AS CalanderDate
                                       UNION ALL
                                       SELECT   CalanderDate + 1
                                       FROM     Calender
                                       WHERE    CalanderDate + 1 <= @endDate
                                     )
                            SELECT  CONVERT(VARCHAR(10), CalanderDate, 25) AS [day] ,
                                    DAY(CalanderDate) AS dasplay_day
                            FROM    Calender
                        OPTION  ( MAXRECURSION 0 )
                    END

	--=================================
	--TariffFeatures
	--=================================	
        IF @action = 'getTariffFeatureList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  tf.id_feature ,
                        tf.NAME AS NAME ,
                        tf.sys_name ,
                        tf.price
                FROM    dbo.srvpl_tariff_features tf
                WHERE   tf.enabled = 1
                ORDER BY tf.order_num
            END
        ELSE
            IF @action = 'saveTariffFeature'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    EXEC dbo.sk_service_planing @action = N'updTariffFeature',
                        @id_feature = @id_feature, @price = @price,
                        @id_creator = @id_creator
                END
            ELSE
                IF @action = 'setDeviceTariff'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END

                        SELECT  @tariff = CONVERT(DECIMAL(10, 2), ISNULL(dbo.srvpl_fnc('getDeviceTariffPrice',
                                                              NULL, @id_device,
                                                              NULL, NULL), 0))

                        EXEC dbo.sk_service_planing @action = 'updDevice',
                            @id_device = @id_device, @tariff = @tariff,
                            @id_creator = @id_creator
                    END
                ELSE
                    IF @action = 'setNewDeviceTariff'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END

                            DECLARE curs CURSOR LOCAL
                            FOR
                                SELECT  id_device
                                FROM    dbo.srvpl_devices d
                                WHERE   d.enabled = 1
                                        AND d.old_id_device IS NULL
						--Все или только с пустым тарифом
                                        AND ( ( ( @all IS NULL
                                                  OR @all = 0
                                                )
                                                AND ( d.tariff IS NULL
                                                      OR d.tariff = 0
                                                    )
                                              )
                                              OR @all = 1
                                            )

                            OPEN curs

                            FETCH NEXT
					FROM curs
					INTO @id_device

                            WHILE @@FETCH_STATUS = 0
                                BEGIN
                                    EXEC dbo.ui_service_planing @action = 'setDeviceTariff',
                                        @id_device = @id_device,
                                        @id_creator = @id_creator

                                    FETCH NEXT
						FROM curs
						INTO @id_device
                                END

                            CLOSE curs

                            DEALLOCATE curs
                        END

	--=================================
	--PaymentTariff
	--=================================	
        IF @action = 'getPaymentTariffList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  tf.id_user_role ,
                        pr.NAME AS role_name ,
                        tf.NAME AS NAME ,
                        tf.price
                FROM    dbo.srvpl_payment_tariffs tf
                        INNER JOIN srvpl_user_roles pr ON tf.id_user_role = pr.id_user_role
                WHERE   tf.enabled = 1
                        AND pr.ENABLED = 1
                ORDER BY tf.order_num
            END
        ELSE
            IF @action = 'savePaymentTariff'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    EXEC dbo.sk_service_planing @action = N'updPaymentTariff',
                        @id_user_role = @id_user_role, @price = @price,
                        @id_creator = @id_creator
                END

	--=================================
	--UserRolePayment
	--=================================	
        IF @action = 'getServiceAdminsPaymentList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  ttt.id_service_admin ,
                        u2ur.id_user_role ,
                        pt.price AS base_price ,
                        u.display_name AS [user_name] ,
                        ur.NAME AS role_name ,
                        CONVERT(DECIMAL(10, 2), ( pt.price * SQRT(cames_count) )) AS payment ,
                        cames_count
                FROM    ( SELECT    tt.id_service_admin ,
                                    SUM(tt.cames_count) AS cames_count
                          FROM      ( SELECT    t.id_service_admin ,
                                                CONVERT(DECIMAL(10, 2), ( dev_admin_cames_count
                                                              / dev_cames_count )) AS cames_count
                                      FROM      ( SELECT    sc.id_device ,
                                                            sc.id_service_admin ,
                                                            ( SELECT
                                                              COUNT(1)
                                                              FROM
                                                              dbo.srvpl_service_cames scm2
                                                              INNER JOIN dbo.srvpl_service_claims sc2 ON sc2.id_service_claim = scm2.id_service_claim
                                                              INNER JOIN srvpl_contract2devices c2d2 ON sc2.id_contract2devices = c2d2.id_contract2devices
                                                              INNER JOIN dbo.srvpl_devices d2 ON sc2.id_device = d2.id_device
                                                              INNER JOIN dbo.srvpl_contracts c2 ON sc2.id_contract = c2.id_contract
                                                              WHERE
                                                              scm2.enabled = 1
                                                              AND sc2.enabled = 1
                                                              AND d2.enabled = 1
                                                              AND c2.enabled = 1
                                                              AND c2d2.enabled = 1
                                                              AND sc2.id_device = sc.id_device
                                                              AND ( @id_service_engeneer IS NULL
                                                              OR ( @id_service_engeneer IS NOT NULL
                                                              AND scm2.id_service_engeneer = @id_service_engeneer
                                                              )
                                                              )
                                                              AND ( @id_service_admin IS NULL
                                                              OR ( @id_service_admin IS NOT NULL
                                                              AND sc2.id_service_admin = @id_service_admin
                                                              )
                                                              )
                                                              AND ( @date_month IS NULL
                                                              OR ( @date_month IS NOT NULL
                                                              AND YEAR(scm2.date_came) = YEAR(@date_month)
                                                              AND MONTH(scm2.date_came) = MONTH(@date_month)
                                                              )
                                                              )
                                                              GROUP BY sc2.id_device
                                                            ) AS dev_cames_count ,
                                                            ( SELECT
                                                              COUNT(1)
                                                              FROM
                                                              dbo.srvpl_service_cames scm2
                                                              INNER JOIN dbo.srvpl_service_claims sc2 ON sc2.id_service_claim = scm2.id_service_claim
                                                              INNER JOIN srvpl_contract2devices c2d2 ON sc2.id_contract2devices = c2d2.id_contract2devices
                                                              INNER JOIN dbo.srvpl_devices d2 ON sc2.id_device = d2.id_device
                                                              INNER JOIN dbo.srvpl_contracts c2 ON sc2.id_contract = c2.id_contract
                                                              WHERE
                                                              scm2.enabled = 1
                                                              AND sc2.enabled = 1
                                                              AND d2.enabled = 1
                                                              AND c2.enabled = 1
                                                              AND c2d2.enabled = 1
                                                              AND sc2.id_device = sc.id_device
                                                              AND sc2.id_service_admin = sc.id_service_admin
                                                              AND ( @id_service_engeneer IS NULL
                                                              OR ( @id_service_engeneer IS NOT NULL
                                                              AND scm2.id_service_engeneer = @id_service_engeneer
                                                              )
                                                              )
                                                              AND ( @id_service_admin IS NULL
                                                              OR ( @id_service_admin IS NOT NULL
                                                              AND sc2.id_service_admin = @id_service_admin
                                                              )
                                                              )
                                                              AND ( @date_month IS NULL
                                                              OR ( @date_month IS NOT NULL
                                                              AND MONTH(scm2.date_came) = MONTH(@date_month)
                                                              AND YEAR(scm2.date_came) = YEAR(@date_month)
                                                              )
                                                              )
                                                              GROUP BY sc2.id_device ,
                                                              sc2.id_service_admin
                                                            ) AS dev_admin_cames_count
                                                  FROM      dbo.srvpl_service_claims sc
                                                            INNER JOIN dbo.srvpl_service_cames scm ON SC.id_service_claim = scm.id_service_claim
                                                            INNER JOIN srvpl_contract2devices c2d ON sc.id_contract2devices = c2d.id_contract2devices
                                                            INNER JOIN dbo.srvpl_devices d ON sc.id_device = d.id_device
                                                            INNER JOIN dbo.srvpl_contracts c ON sc.id_contract = c.id_contract
                                                  WHERE     sc.enabled = 1
                                                            AND d.enabled = 1
                                                            AND c.enabled = 1
                                                            AND c2d.enabled = 1
                                                            AND ( @id_service_engeneer IS NULL
                                                              OR ( @id_service_engeneer IS NOT NULL
                                                              AND scm.id_service_engeneer = @id_service_engeneer
                                                              )
                                                              )
                                                            AND ( @id_service_admin IS NULL
                                                              OR ( @id_service_admin IS NOT NULL
                                                              AND sc.id_service_admin = @id_service_admin
                                                              )
                                                              )
                                                            AND ( @date_month IS NULL
                                                              OR ( @date_month IS NOT NULL
                                                              AND YEAR(scm.date_came) = YEAR(@date_month)
                                                              AND MONTH(scm.date_came) = MONTH(@date_month)
                                                              )
                                                              )
                                                  GROUP BY  sc.id_device ,
                                                            sc.id_service_admin
                                                ) AS t
                                    ) AS tt
                          GROUP BY  tt.id_service_admin
                        ) AS ttt
                        INNER JOIN srvpl_user2user_roles u2ur ON u2ur.id_user = ttt.id_service_admin
                        INNER JOIN users u ON u.id_user = u2ur.id_user
                        INNER JOIN srvpl_user_roles ur ON ur.id_user_role = u2ur.id_user_role
                        INNER JOIN srvpl_payment_tariffs pt ON u2ur.id_user_role = pt.id_user_role
                WHERE   u2ur.ENABLED = 1
                        AND u.enabled = 1
                        AND ur.ENABLED = 1
                        AND pt.ENABLED = 1
                ORDER BY [user_name]

                --SELECT  * ,
                --        ( base_price * SQRT(exec_device_count) ) AS payment
                --FROM    ( SELECT    u2ur.id_user ,
                --                    u2ur.id_user_role ,
                --                    pt.price AS base_price ,
                --                    u.display_name AS [user_name] ,
                --                    ur.NAME AS role_name ,
                --                    ( SELECT    COUNT(1)
                --                      FROM      dbo.srvpl_service_claims sc
                --                                INNER JOIN dbo.srvpl_contract2devices c2d ON sc.id_contract2devices = c2d.id_contract2devices
                --                      WHERE     sc.enabled = 1
                --                                AND c2d.ENABLED = 1
                --                                AND ( @date_month IS NULL
                --                                      OR ( @date_month IS NOT NULL
                --                                           AND MONTH(sc.planing_date) = MONTH(@date_month)
                --                                           AND YEAR(sc.planing_date) = YEAR(@date_month)
                --                                         )
                --                                    )
                --                                AND c2d.id_service_admin = u2ur.id_user
                --                      GROUP BY  c2d.id_service_admin
                --                    ) AS device_count ,
                --                    ( SELECT    COUNT(1)
                --                      FROM      dbo.srvpl_service_claims sc
                --                                INNER JOIN dbo.srvpl_contract2devices c2d ON sc.id_contract2devices = c2d.id_contract2devices
                --                      WHERE     sc.enabled = 1
                --                                AND c2d.ENABLED = 1
                --                                AND ( @date_month IS NULL
                --                                      OR ( @date_month IS NOT NULL
                --                                           AND MONTH(sc.planing_date) = MONTH(@date_month)
                --                                           AND YEAR(sc.planing_date) = YEAR(@date_month)
                --                                         )
                --                                    )
                --                                AND c2d.id_service_admin = u2ur.id_user
                --                                AND EXISTS ( SELECT
                --                                              1
                --                                             FROM
                --                                              dbo.srvpl_service_cames scam
                --                                             WHERE
                --                                              scam.enabled = 1
                --                                              AND scam.id_service_claim = sc.id_service_claim )
                --                      GROUP BY  c2d.id_service_admin
                --                    ) AS exec_device_count
                --          FROM      srvpl_user2user_roles u2ur
                --                    INNER JOIN users u ON u.id_user = u2ur.id_user
                --                    INNER JOIN srvpl_user_roles ur ON ur.id_user_role = u2ur.id_user_role
                --                    INNER JOIN srvpl_payment_tariffs pt ON u2ur.id_user_role = pt.id_user_role
                --          WHERE     u2ur.ENABLED = 1
                --                    AND u.enabled = 1
                --                    AND ur.ENABLED = 1
                --                    AND pt.ENABLED = 1
                --        ) AS t
                --ORDER BY [user_name]
            END

	--=================================
	--User2UserRole
	--=================================	
        IF @action = 'getUser2UserRoleList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  u2ur.id_user2user_role ,
                        u2ur.id_user_role ,
                        u2ur.[id_user] ,
                        u.display_name AS [USER_NAME] ,
                        ur.NAME AS role_name
                FROM    dbo.srvpl_user2user_roles u2ur
                        INNER JOIN dbo.users u ON u.id_user = u2ur.id_user
                        INNER JOIN srvpl_user_roled ur ON u2ur.id_user_role = ur.id_user_role
                WHERE   u2ur.enabled = 1
            END
        ELSE
            IF @action = 'getUser2UserRole'
                BEGIN
                    SELECT  id_user2user_role ,
                            id_user_role ,
                            [id_user]
                    FROM    dbo.srvpl_user2user_roles u2ur
                    WHERE   u2ur.ENABLED = 1
                            AND u2ur.id_user = @id_user --u2ur.id_user2user_role = @id_user2user_role
                END
            ELSE
                IF @action = 'saveUser2UserRole'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END

                        SET @var_str = 'insUser2UserRole'

                        IF EXISTS ( SELECT  1
                                    FROM    dbo.srvpl_user2user_roles t
                                    WHERE   t.ENABLED = 1
							--AND t.id_user_role = @id_user_role
                                            AND t.id_user = @id_user )
                            BEGIN
                                SET @var_str = 'updUser2UserRole'

                                SELECT  @id_user2user_role = id_user2user_role
                                FROM    dbo.srvpl_user2user_roles t
                                WHERE   t.ENABLED = 1
						--AND t.id_user_role = @id_user_role
                                        AND t.id_user = @id_user
                            END

                        EXEC dbo.sk_service_planing @action = @var_str,
                            @id_user2user_role = @id_user2user_role,
                            @id_user_role = @id_user_role, @id_user = @id_user,
                            @id_creator = @id_creator
                    END
                ELSE
                    IF @action = 'closeUser2UserRole'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END

                            EXEC dbo.sk_service_planing @action = N'closeUser2UserRole',
                                @id_user2user_role = @id_user2user_role,
                                @id_creator = @id_creator
                        END

	--=================================
	--UserRoles
	--=================================	                    
        IF @action = 'getUserRoleSelectionList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  t.id_user_role AS id ,
                        t.NAME AS NAME
                FROM    dbo.srvpl_user_roles t
                WHERE   t.enabled = 1
            END

	--=================================
	--ContractorList
	--=================================	
        IF @action = 'getContractorShortSelectionList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  id ,
                        CASE WHEN @show_inn = 1 THEN name_inn
                             ELSE NAME
                        END AS NAME
                FROM    dbo.get_contractor(NULL) ctr
		--INNER JOIN dbo.srvpl_contracts c ON c.id_contractor = ctr.id
                WHERE   EXISTS ( SELECT 1
                                 FROM   dbo.srvpl_contracts c
                                 WHERE  c.enabled = 1
                                        AND c.id_contractor = ctr.id )
			--FILTER
                        AND ( @filter_text IS NULL
                              OR ( @filter_text IS NOT NULL
                                   AND name_inn LIKE '%' + @filter_text + '%'
                                 )
                            )
			--ID_CONTRACTOR
                        AND ( ( @id_contractor IS NULL
                                OR @id_contractor <= 0
                              )
                              OR ( @id_contractor > 0
                                   AND ctr.id = @id_contractor
                                 )
                            )
                        AND ( ( @id_city IS NULL
                                OR @id_city <= 0
                              )
                              OR ( @id_city > 0
                                   AND EXISTS ( SELECT  1
                                                FROM    dbo.srvpl_contract2devices c2d
                                                        INNER JOIN dbo.srvpl_contracts c ON c2d.id_contract = c.id_contract
                                                WHERE   c2d.enabled = 1
                                                        AND c.enabled = 1
                                                        AND ctr.id = c.id_contractor
                                                        AND c2d.id_city = @id_city )
                                 )
                            )
                        AND ( ( @address IS NULL
                                OR LTRIM(RTRIM(@address)) = ''
                              )
                              OR ( @address IS NOT NULL
                                   AND EXISTS ( SELECT  1
                                                FROM    dbo.srvpl_contract2devices c2d
                                                        INNER JOIN dbo.srvpl_contracts c ON c2d.id_contract = c.id_contract
                                                WHERE   c2d.enabled = 1
                                                        AND c.enabled = 1
                                                        AND ctr.id = c.id_contractor
                                                        AND c2d.address = @address )
                                 )
                            )
                ORDER BY CASE WHEN @order_by_name = 1 THEN ctr.NAME
                         END ,
                        CASE WHEN @order_by_name IS NULL
                                  OR @order_by_name = 0 THEN ctr.inn
                        END
            END
        ELSE
            IF @action = 'getSrvplContractorList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
					
                    SELECT  t.id_contractor ,
                            t.NAME ,
                            SUM(cnt) AS cnt ,
                            SUM(set_cnt) AS set_cnt ,--назначенные
                            ( SELECT    COUNT(1)
                              FROM      dbo.srvpl_contract2devices c2d2
                                        INNER JOIN dbo.srvpl_contracts c2 ON c2d2.id_contract = c2.id_contract
                                        INNER JOIN dbo.srvpl_devices d2 ON c2d2.id_device = d2.id_device
                              WHERE     c2d2.enabled = 1
                                        AND c2.enabled = 1
                                        AND d2.ENABLED = 1
                                        AND c2.id_contractor = t.id_contractor
                                        --Активный на дату
                                        AND dbo.srvpl_fnc('checkContractIsActiveOnMonth',
                                                          NULL, c2.id_contract,
                                                          @date_month, NULL) = '1'
                            ) AS dev_cnt
                    FROM    ( SELECT    c.id_contractor ,
                                        ctr.NAME ,
                                        1 AS cnt ,
                                        CASE WHEN sc.id_service_engeneer IS NOT NULL
                                             THEN 1
                                             ELSE 0
                                        END AS set_cnt
                              FROM      dbo.srvpl_service_claims sc
                                        INNER JOIN dbo.srvpl_contract2devices c2d ON sc.id_contract2devices = c2d.id_contract2devices
                                        INNER JOIN dbo.srvpl_contracts c ON c2d.id_contract = c.id_contract
                                        INNER JOIN dbo.srvpl_devices d ON c2d.id_device = d.id_device
                                        INNER JOIN dbo.srvpl_service_intervals si ON c2d.id_service_interval = si.id_service_interval
                                        INNER JOIN dbo.get_contractor(NULL) ctr ON c.id_contractor = ctr.id
                              WHERE     sc.enabled = 1
                                        AND c2d.enabled = 1
                                        AND c.enabled = 1
                                        AND d.ENABLED = 1
						--Активный на дату
                                        AND dbo.srvpl_fnc('checkContractIsActiveOnMonth',
                                                          NULL,
                                                          c2d.id_contract,
                                                          @date_month, NULL) = '1'
						--ID_CONTRACTOR
                                        AND ( ( @id_contractor IS NULL
                                                OR @id_contractor <= 0
                                              )
                                              OR ( @id_contractor > 0
                                                   AND c.id_contractor = @id_contractor
                                                 )
                                            )
                                        AND ( ( @id_city IS NULL
                                                OR @id_city <= 0
                                              )
                                              OR ( @id_city > 0
                                                   AND c2d.id_city = @id_city
                                                 )
                                            )
                                        AND ( ( @address IS NULL
                                                OR LTRIM(RTRIM(@address)) = ''
                                              )
                                              OR ( @address IS NOT NULL
                                                   AND c2d.address LIKE '%'
                                                   + @address + '%'
                                                 )
                                            )
                                        AND ( ( @id_service_admin IS NULL
                                                OR @id_service_admin <= 0
                                              )
                                              OR ( @id_service_admin > 0
                                                   AND c2d.id_service_admin = @id_service_admin
                                                 )
                                            )
						--No Set Service Engeneer
                                        AND ( ( @no_set IS NULL
                                                OR @no_set < 0
                                              )
                                              OR ( @no_set = 1
                                                   AND sc.id_service_engeneer IS NOT NULL
                                                 )
                                              OR ( @no_set = 0
                                                   AND sc.id_service_engeneer IS NULL
                                                 )
                                            )
                                        AND ( ( @is_done IS NULL
                                                OR @is_done < 0
                                              )
                                              OR ( @is_done = 1
                                                   AND EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.enabled = 1
                                                              AND scm.id_service_claim = sc.id_service_claim )
                                                 )
                                              OR ( @is_done = 0
                                                   AND NOT EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.enabled = 1
                                                              AND scm.id_service_claim = sc.id_service_claim )
                                                 )
                                            )
                                        AND ( @date_month IS NULL
                                              OR ( @date_month IS NOT NULL
                                                   AND MONTH(sc.planing_date) = MONTH(@date_month)
                                                   AND YEAR(sc.planing_date) = YEAR(@date_month)
                                                 )
                                            )
                            ) AS t
                    GROUP BY t.id_contractor ,
                            t.NAME
                    ORDER BY t.NAME
                END
            ELSE
                IF @action = 'getSrvplContractorDeviceList'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END

				--Выбираем записи из плана работ и соединяем со списоком устройств где нет планового обслуживания
                        SELECT  t.has_came ,
                                t.planing_date ,
                                t.id_service_engeneer_plan ,
                                t.id_service_claim ,
                                t.id_contract2devices ,
                                t.device ,
                                t.show_date_end ,
                                t.contract_date_end ,
                                t.ADDRESS ,
                                city ,
                                contract_number ,
                                CASE WHEN service_engeneer_fact IS NULL
                                     THEN service_engeneer_plan
                                     ELSE service_engeneer_fact
                                END AS service_engeneer ,
                                mark_color ,
                                show_contract_state ,
                                contract_state ,
                                is_limit_device_claims
                        FROM    ( SELECT    CASE WHEN EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.enabled = 1
                                                              AND sc.id_service_claim = scm.id_service_claim )
                                                 THEN 1
                                                 ELSE 0
                                            END AS has_came ,
                                            sc.planing_date ,
                                            sc.id_service_engeneer AS id_service_engeneer_plan ,
                                            ( SELECT    u.display_name
                                              FROM      users u
                                              WHERE     sc.id_service_engeneer = u.id_user
                                            ) AS service_engeneer_plan ,
                                            ( SELECT TOP 1
                                                        u.display_name
                                              FROM      dbo.srvpl_service_cames scm
                                                        INNER JOIN users u ON scm.id_service_engeneer = u.id_user
                                              WHERE     scm.enabled = 1
                                                        AND scm.id_service_engeneer > 0
                                                        AND sc.id_service_claim = scm.id_service_claim
                                            ) AS service_engeneer_fact ,
                                            sc.id_service_claim ,
                                            c2d.id_contract2devices ,
                                            dbo.srvpl_fnc('getContract2DevicesShortCollectedName',
                                                          NULL,
                                                          c2d.id_contract2devices,
                                                          NULL, NULL) AS device ,
                                            CASE WHEN DATEDIFF(MONTH,
                                                              GETDATE(),
                                                              c.date_end) < 1
                                                 THEN 1
                                                 ELSE 0
                                            END AS show_date_end ,
                                            c.date_end AS contract_date_end ,
                                            c2d.address ,
                                            dbo.get_city_full_name(c2d.id_city) AS city ,
                                            c.number AS contract_number ,
                                            sipg.color AS mark_color ,
                                            CASE WHEN cst.MARK = 1 THEN 1
                                                 ELSE 0
                                            END AS show_contract_state ,
                                            cst.name AS contract_state ,
                                            CASE WHEN c.handling_devices IS NOT NULL
                                                      OR c.handling_devices > 0
                                                 THEN 1
                                                 ELSE 0
                                            END AS is_limit_device_claims
                                  FROM      dbo.srvpl_service_claims sc
                                            INNER JOIN dbo.srvpl_contract2devices c2d ON sc.id_contract2devices = c2d.id_contract2devices
                                            INNER JOIN dbo.srvpl_contracts c ON c2d.id_contract = c.id_contract
                                            INNER JOIN dbo.srvpl_devices d ON c2d.id_device = d.id_device
                                            INNER JOIN dbo.srvpl_service_intervals si ON c2d.id_service_interval = si.id_service_interval
                                            INNER JOIN dbo.srvpl_service_interval_plan_groups sipg ON si.id_service_interval_plan_group = sipg.id_service_interval_plan_group
                                            INNER JOIN dbo.get_contractor(NULL) ctr ON c.id_contractor = ctr.id
                                            INNER JOIN dbo.srvpl_contract_statuses cst ON c.id_contract_status = cst.id_contract_status
                                  WHERE     sc.enabled = 1
                                            AND c2d.enabled = 1
                                            AND c.enabled = 1
                                            AND d.ENABLED = 1
						--Активный на дату
                                            AND dbo.srvpl_fnc('checkContractIsActiveOnMonth',
                                                              NULL,
                                                              c2d.id_contract,
                                                              @date_month,
                                                              NULL) = '1'
						--ID_CONTRACTOR
                                            AND ( ( @id_contractor IS NULL
                                                    OR @id_contractor <= 0
                                                  )
                                                  OR ( @id_contractor > 0
                                                       AND c.id_contractor = @id_contractor
                                                     )
                                                )
                                            AND ( ( @id_city IS NULL
                                                    OR @id_city <= 0
                                                  )
                                                  OR ( @id_city > 0
                                                       AND c2d.id_city = @id_city
                                                     )
                                                )
                                            AND ( ( @address IS NULL
                                                    OR LTRIM(RTRIM(@address)) = ''
                                                  )
                                                  OR ( @address IS NOT NULL
                                                       AND c2d.address LIKE '%'
                                                       + @address + '%'
                                                     )
                                                )
                                            AND ( ( @id_service_admin IS NULL
                                                    OR @id_service_admin <= 0
                                                  )
                                                  OR ( @id_service_admin > 0
                                                       AND c2d.id_service_admin = @id_service_admin
                                                     )
                                                )
						--No Set Service Engeneer
                                            AND ( ( @no_set IS NULL
                                                    OR @no_set < 0
                                                  )
                                                  OR ( @no_set = 1
                                                       AND sc.id_service_engeneer IS NOT NULL
                                                     )
                                                  OR ( @no_set = 0
                                                       AND sc.id_service_engeneer IS NULL
                                                     )
                                                )
                                            AND ( ( @is_done IS NULL
                                                    OR @is_done < 0
                                                  )
                                                  OR ( @is_done = 1
                                                       AND EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.enabled = 1
                                                              AND scm.id_service_claim = sc.id_service_claim )
                                                     )
                                                  OR ( @is_done = 0
                                                       AND NOT EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              dbo.srvpl_service_cames scm
                                                              WHERE
                                                              scm.enabled = 1
                                                              AND scm.id_service_claim = sc.id_service_claim )
                                                     )
                                                )
                                            AND ( @date_month IS NULL
                                                  OR ( @date_month IS NOT NULL
                                                       AND MONTH(sc.planing_date) = MONTH(@date_month)
                                                       AND YEAR(sc.planing_date) = YEAR(@date_month)
                                                     )
                                                )
                                ) AS T
                        UNION ALL
                        SELECT  NULL AS has_came ,
                                NULL AS planing_date ,
                                NULL AS id_service_engeneer_plan ,
                                NULL AS id_service_claim ,
                                c2d.id_contract2devices ,
                                dbo.srvpl_fnc('getContract2DevicesShortCollectedName',
                                              NULL, c2d.id_contract2devices,
                                              NULL, NULL) AS device ,
                                CASE WHEN DATEDIFF(MONTH, GETDATE(),
                                                   c.date_end) < 1 THEN 1
                                     ELSE 0
                                END AS show_date_end ,
                                c.date_end AS contract_date_end ,
                                c2d.address ,
                                dbo.get_city_full_name(c2d.id_city) AS city ,
                                c.number AS contract_number ,
                                NULL AS service_engeneer ,
                                sipg.color AS mark_color ,
                                cst.MARK AS show_contract_state ,
                                cst.name AS contract_state ,
                                CASE WHEN c.handling_devices IS NOT NULL
                                          OR c.handling_devices > 0 THEN 1
                                     ELSE 0
                                END AS is_limit_device_claims
                        FROM    dbo.srvpl_contract2devices c2d
                                INNER JOIN dbo.srvpl_contracts c ON c2d.id_contract = c.id_contract
                                INNER JOIN dbo.srvpl_service_intervals si ON c2d.id_service_interval = si.id_service_interval
                                INNER JOIN dbo.srvpl_service_interval_plan_groups sipg ON si.id_service_interval_plan_group = sipg.id_service_interval_plan_group
                                INNER JOIN dbo.get_contractor(NULL) ctr ON c.id_contractor = ctr.id
                                INNER JOIN dbo.srvpl_contract_statuses cst ON c.id_contract_status = cst.id_contract_status
                        WHERE   c2d.enabled = 1
                                AND c.enabled = 1
                                AND si.per_month IS NULL
					--Активный на дату
                                AND dbo.srvpl_fnc('checkContractIsActiveOnMonth',
                                                  NULL, c2d.id_contract,
                                                  @date_month, NULL) = '1'
					--ID_CONTRACTOR
                                AND ( ( @id_contractor IS NULL
                                        OR @id_contractor <= 0
                                      )
                                      OR ( @id_contractor > 0
                                           AND c.id_contractor = @id_contractor
                                         )
                                    )
                                AND ( ( @id_city IS NULL
                                        OR @id_city <= 0
                                      )
                                      OR ( @id_city > 0
                                           AND c2d.id_city = @id_city
                                         )
                                    )
                                AND ( ( @address IS NULL
                                        OR LTRIM(RTRIM(@address)) = ''
                                      )
                                      OR ( @address IS NOT NULL
                                           AND c2d.address LIKE '%' + @address
                                           + '%'
                                         )
                                    )
                                AND ( ( @id_service_admin IS NULL
                                        OR @id_service_admin <= 0
                                      )
                                      OR ( @id_service_admin > 0
                                           AND c2d.id_service_admin = @id_service_admin
                                         )
                                    )
                        ORDER BY t.contract_number ,
                                t.device
                    END

	--=================================
	--PriceDiscounts
	--=================================	
        IF @action = 'getPriceDiscountSelectionList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  pd.id_price_discount AS id ,
                        NAME AS NAME
                FROM    dbo.srvpl_contract_price_descounts pd
                WHERE   pd.ENABLED = 1
                ORDER BY order_num
            END
            
    --=================================
	--AktScan
	--=================================	
        IF @action = 'getAktScanList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  id_akt_scan ,
                        name ,
                        [file_name] ,
                        full_path ,
                        cames_add ,
                        date_cames_add ,
                        id_adder
                FROM    dbo.srvpl_akt_scans
                WHERE   enabled = 1
                        AND cames_add = 0
            END
        ELSE
            IF @action = 'getAktScan'
                BEGIN
                    SELECT  id_akt_scan ,
                            name ,
                            [file_name] ,
                            full_path ,
                            cames_add ,
                            date_cames_add ,
                            id_adder ,
                            dattim1 ,
                            dattim2 ,
                            enabled ,
                            id_creator
                    FROM    dbo.srvpl_akt_scans
                    WHERE   id_akt_scan = @id_akt_scan
                END
            ELSE
                IF @action = 'saveAktScan'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END

                        SET @var_str = 'insAktScan'

                        IF EXISTS ( SELECT  1
                                    FROM    dbo.srvpl_akt_scans t
                                    WHERE   id_akt_scan = @id_akt_scan )
                            BEGIN
                                SET @var_str = 'updAktScan'
                            END

                        EXEC dbo.sk_service_planing @action = @var_str,
                            @id_akt_scan = @id_akt_scan, @name = @name,
                            @file_name = @file_name, @full_path = @full_path,
                            @cames_add = @cames_add,
                            @date_cames_add = @date_cames_add,
                            @id_adder = @id_adder, @id_creator = @id_creator
                    END
                ELSE
                    IF @action = 'closeAktScan'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END

                            EXEC dbo.sk_service_planing @action = N'closeAktScan',
                                @id_akt_scan = @id_akt_scan,
                                @id_creator = @id_creator
                        END
            
            
            
            
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
    ON OBJECT::[dbo].[ui_service_planing] TO [sqlUnit_prog]
    AS [dbo];

