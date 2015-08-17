-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ui_device_install]
    @action NVARCHAR(50) ,
    @id_user INT = NULL ,
    @id_device_install INT = NULL ,
    @id_device INT = NULL ,
    @id_claim INT = NULL ,
    @id_contract INT = NULL ,
    @id_contractor INT = NULL ,
    @contract_number NVARCHAR(50) = NULL ,
    @plan_date DATETIME = NULL ,
    @id_device_model INT = NULL ,
    @device NVARCHAR(150) = NULL ,
    @id_city INT = NULL ,
    @city NVARCHAR(150) = NULL ,
    @address NVARCHAR(150) = NULL ,
    @object_name NVARCHAR(150) = NULL ,
    @contact_name NVARCHAR(150) = NULL ,
    @add_devices NVARCHAR(500) = NULL ,
    @id_manager INT = NULL ,
    @id_service_admin INT = NULL ,
    @descr NVARCHAR(MAX) = NULL ,
    @is_close BIT = NULL ,
    @id_creator INT = NULL ,
    @id_devinst_state INT = NULL ,
    @et_number NVARCHAR(50) = NULL ,
    @device_model NVARCHAR(150) = NULL ,
    @contractor NVARCHAR(150) = NULL,
    @rows_count INT = NULL
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
            @var_str NVARCHAR(150)

	/****===DEFAULT VALUES===****/
        SET @def_dattim2 = '3.3.3333'
        SET @def_enabled = 1
        SET @def_order_num = 500
    /*/>*/

	--/>
        IF @action NOT LIKE 'get%'
            BEGIN
		--<Сохраняем в лог список параметров
                SELECT TOP 1
                        @id_program = id_program
                FROM    programs p
                WHERE   p.enabled = 1
                        AND LOWER(p.sys_name) = LOWER('DEVICEINSTALL')
                        
                SELECT  @log_params = CASE WHEN @action IS NULL THEN ''
                                           ELSE ' @action='
                                                + CONVERT(NVARCHAR, @action)
                                      END + CASE WHEN @id_user IS NULL THEN ''
                                                 ELSE ' @id_user='
                                                      + CONVERT(NVARCHAR(MAX), @id_user)
                                            END
                        + CASE WHEN @id_device_install IS NULL THEN ''
                               ELSE ' @id_device_install='
                                    + CONVERT(NVARCHAR(MAX), @id_device_install)
                          END + CASE WHEN @id_device IS NULL THEN ''
                                     ELSE ' @id_device='
                                          + CONVERT(NVARCHAR(MAX), @id_device)
                                END + CASE WHEN @id_claim IS NULL THEN ''
                                           ELSE ' @id_claim='
                                                + CONVERT(NVARCHAR(MAX), @id_claim)
                                      END
                        + CASE WHEN @id_contract IS NULL THEN ''
                               ELSE ' @id_contract='
                                    + CONVERT(NVARCHAR(MAX), @id_contract)
                          END + CASE WHEN @id_contractor IS NULL THEN ''
                                     ELSE ' @id_contractor='
                                          + CONVERT(NVARCHAR(MAX), @id_contractor)
                                END
                        + CASE WHEN @contract_number IS NULL THEN ''
                               ELSE ' @contract_number='
                                    + CONVERT(NVARCHAR(MAX), @contract_number)
                          END + CASE WHEN @plan_date IS NULL THEN ''
                                     ELSE ' @plan_date='
                                          + CONVERT(NVARCHAR(MAX), @plan_date)
                                END
                        + CASE WHEN @id_device_model IS NULL THEN ''
                               ELSE ' @id_device_model='
                                    + CONVERT(NVARCHAR(MAX), @id_device_model)
                          END + CASE WHEN @device IS NULL THEN ''
                                     ELSE ' @device='
                                          + CONVERT(NVARCHAR(MAX), @device)
                                END + CASE WHEN @id_city IS NULL THEN ''
                                           ELSE ' @id_city='
                                                + CONVERT(NVARCHAR(MAX), @id_city)
                                      END + CASE WHEN @city IS NULL THEN ''
                                                 ELSE ' @city='
                                                      + CONVERT(NVARCHAR(MAX), @city)
                                            END
                        + CASE WHEN @address IS NULL THEN ''
                               ELSE ' @address='
                                    + CONVERT(NVARCHAR(MAX), @address)
                          END + CASE WHEN @object_name IS NULL THEN ''
                                     ELSE ' @object_name='
                                          + CONVERT(NVARCHAR(MAX), @object_name)
                                END + CASE WHEN @contact_name IS NULL THEN ''
                                           ELSE ' @contact_name='
                                                + CONVERT(NVARCHAR(MAX), @contact_name)
                                      END
                        + CASE WHEN @add_devices IS NULL THEN ''
                               ELSE ' @add_devices='
                                    + CONVERT(NVARCHAR(MAX), @add_devices)
                          END + CASE WHEN @id_manager IS NULL THEN ''
                                     ELSE ' @id_manager='
                                          + CONVERT(NVARCHAR(MAX), @id_manager)
                                END
                        + CASE WHEN @id_service_admin IS NULL THEN ''
                               ELSE ' @id_service_admin='
                                    + CONVERT(NVARCHAR(MAX), @id_service_admin)
                          END + CASE WHEN @descr IS NULL THEN ''
                                     ELSE ' @descr='
                                          + CONVERT(NVARCHAR(MAX), @descr)
                                END + CASE WHEN @is_close IS NULL THEN ''
                                           ELSE ' @is_close='
                                                + CONVERT(NVARCHAR(MAX), @is_close)
                                      END
                        + CASE WHEN @id_creator IS NULL THEN ''
                               ELSE ' @id_creator='
                                    + CONVERT(NVARCHAR(MAX), @id_creator)
                          END + CASE WHEN @id_devinst_state IS NULL THEN ''
                                     ELSE ' @id_devinst_state='
                                          + CONVERT(NVARCHAR(MAX), @id_devinst_state)
                                END + CASE WHEN @et_number IS NULL THEN ''
                                           ELSE ' @et_number='
                                                + CONVERT(NVARCHAR(MAX), @et_number)
                                      END
                        + CASE WHEN @device_model IS NULL THEN ''
                               ELSE ' @device_model='
                                    + CONVERT(NVARCHAR(MAX), @device_model)
                          END + CASE WHEN @contractor IS NULL THEN ''
                                     ELSE ' @contractor='
                                          + CONVERT(NVARCHAR(MAX), @contractor)
                                END+ CASE WHEN @rows_count IS NULL THEN ''
                                     ELSE ' @rows_count='
                                          + CONVERT(NVARCHAR(MAX), @rows_count)
                                END 
            END
	
    --=================================
	--DeviceInstalls
	--=================================
        IF @action = 'getDeviceInstallList'
            BEGIN
                SELECT  * ,
                        ( city_end + CASE WHEN [address] IS NULL THEN ' '
                                          ELSE ', '
                                     END + [address]
                          + CASE WHEN [OBJECT_NAME] IS NULL THEN ' '
                                 ELSE ', '
                            END + [OBJECT_NAME] ) AS device_place
                FROM    ( SELECT    * ,
                                    CASE WHEN city_2 IS NULL THEN city
                                         ELSE city_2
                                    END AS city_end
                          FROM      ( SELECT    id_device_install ,
                                                id_claim ,
                                                id_contract ,
                                                id_contractor ,
                                                contractor,
                                                et_number ,
                                                contract_number ,
                                                plan_date ,
                                                id_device_model ,
                                                id_device ,
                                                device_model ,
                                                device ,
                                                id_city ,
                                                city ,
                                                address ,
                                                object_name ,
                                                ( SELECT    name
                                                  FROM      dbo.cities c
                                                  WHERE     c.enabled = 1
                                                            AND c.id_city = di.id_city
                                                ) AS city_2 ,
                                                contact_name ,
                                                add_devices ,
                                                ( SELECT    display_name
                                                  FROM      users u
                                                  WHERE     u.id_user = di.id_manager
                                                ) AS manager ,
                                                id_manager ,
                                                ( SELECT    display_name
                                                  FROM      users u
                                                  WHERE     u.id_user = di.id_service_admin
                                                ) AS service_admin ,
                                                id_service_admin ,
                                                descr ,
                                                id_devinst_state
                                      FROM      dbo.devinst_device_installs di
                                      WHERE     di.enabled = 1
                                    ) AS t
                        ) AS tt
            END
        ELSE
            IF @action = 'getDeviceInstall'
                BEGIN
                    SELECT  id_device_install ,
                            id_claim ,
                            id_contract ,
                            id_contractor ,
                            et_number ,
                            contract_number ,
                            plan_date ,
                            id_device_model ,
                            id_device ,
                            device_model ,
                            device ,
                            id_city ,
                            city ,
                            address ,
                            object_name ,
                            contact_name ,
                            add_devices ,
                            id_manager ,
                            id_service_admin ,
                            descr ,
                            dattim1 ,
                            dattim2 ,
                            id_creator ,
                            enabled ,
                            id_devinst_state
                    FROM    dbo.devinst_device_installs di
                    WHERE   di.id_device_install = @id_device_install
                END
            ELSE
                IF @action = 'saveDeviceInstall'
                    BEGIN
                        SET @var_str = 'insDeviceInstall'
								
                        IF EXISTS ( SELECT  1
                                    FROM    dbo.devinst_device_installs t
                                    WHERE   t.id_device_install = @id_device_install )
                            BEGIN
                                SET @var_str = 'updDeviceInstall'  
                                        
                            END
                        ELSE
                            BEGIN
                                SELECT  @id_devinst_state = id_devinst_state
                                FROM    dbo.devinst_states ds
                                WHERE   ds.enabled = 1
                                        AND UPPER(sys_name) = 'NEW'
                            END  
                              
                        IF @id_contractor IS NOT NULL
                            AND @id_contractor > 0
                            BEGIN
                                SELECT  @contractor = name_inn
                                FROM    dbo.get_contractor(@id_contractor) 
                            END   
                       
                        EXEC @id_device_install = dbo.sk_device_install @action = @var_str, -- nvarchar(50)
                            @id_claim = @id_claim, @id_contract = @id_contract,
                            @id_contractor = @id_contractor,
                            @contract_number = @contract_number,
                            @plan_date = @plan_date,
                            @id_device_model = @id_device_model,
                            @id_device = @id_device, @device = @device,
                            @id_city = @id_city, @city = @city,
                            @address = @address, @object_name = @object_name,
                            @contact_name = @contact_name,
                            @add_devices = @add_devices,
                            @id_manager = @id_manager,
                            @id_service_admin = @id_service_admin,
                            @descr = @descr,
                            @id_devinst_state = @id_devinst_state,
                            @et_number = @et_number,
                            @device_model = @device_model,
                            @id_creator = @id_creator,
                            @contractor = @contractor
                                        
                        SELECT  @id_device_install AS id_device_install             
                    END
                ELSE
                    IF @action = 'closeDeviceInstall'
                        BEGIN
                            EXEC dbo.sk_zip_claims @action = N'closeDeviceInstall',
                                @id_device_install = @id_device_install,
                                @id_creator = @id_creator
                        END
                        
                        
    --=================================
	--DeviceInstallStateChanges
	--=================================	
        IF @action = 'saveDeviceInstallStateChange'
            BEGIN
				--Сохраняем факт изменения статуса
                EXEC dbo.sk_device_install @action = N'insDeviceInstallStateChanges',
                    @id_device_install = @id_device_install,
                    @id_devinst_state = @id_devinst_state,
                    @id_creator = @id_creator
                
                --Записываем текущий статус к заявке
                EXEC dbo.ui_device_install @action = N'saveDeviceInstall',
                    @id_device_install = @id_device_install,
                    @id_devinst_state = @id_devinst_state,
                    @id_creator = @id_creator
                
            END
    
    END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ui_device_install] TO [sqlUnit_prog]
    AS [dbo];

