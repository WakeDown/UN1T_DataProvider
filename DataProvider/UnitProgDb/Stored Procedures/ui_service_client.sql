-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE ui_service_client
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
    @date_month DATE = NULL ,
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
    @id_device_data INT = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
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
                          END

                EXEC sk_log @action = 'insLog',
                    @proc_name = 'ui_service_client',
                    @id_program = @id_program, @params = @log_params,
                    @descr = @log_descr
			--/>
            END
            
            
            --=================================
	--Contracts
	--=================================	
        IF @action = 'getDevicesCounterList'
            BEGIN
				SELECT null
            
            end
            
END
