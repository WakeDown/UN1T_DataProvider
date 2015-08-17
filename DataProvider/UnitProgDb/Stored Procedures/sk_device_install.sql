-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sk_device_install]
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
    @device NVARCHAR(150) ,
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
    @id_devinst_state INT = NULL,
    @et_number NVARCHAR(50) = NULL,
    @device_model NVARCHAR(150) = NULL,
    @contractor NVARCHAR(150) = NULL
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
            @def_order_num INT

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
                                END+ CASE WHEN @device_model IS NULL THEN ''
                                     ELSE ' @device_model='
                                          + CONVERT(NVARCHAR(MAX), @device_model)
                                END + CASE WHEN @contractor IS NULL THEN ''
                                     ELSE ' @contractor='
                                          + CONVERT(NVARCHAR(MAX), @contractor)
                                END 
            END
	
    --=================================
	--DeviceInstalls
	--=================================	
        IF @action = 'insDeviceInstall'
            BEGIN
				
                INSERT  INTO dbo.devinst_device_installs
                        ( id_claim ,
                          id_contract ,
                          id_contractor ,
                          contract_number ,
                          plan_date ,
                          id_device_model ,
                          id_device ,
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
                          id_devinst_state ,
                          dattim1 ,
                          dattim2 ,
                          enabled ,
                          id_creator ,
                          old_id_device_install,
                          et_number,
                          device_model,
                          contractor
				        )
                VALUES  ( @id_claim , -- id_claim - int
                          @id_contract , -- id_contract - int
                          @id_contractor , -- id_contractor - int
                          @contract_number , -- contract_number - nvarchar(50)
                          @plan_date , -- plan_date - datetime
                          @id_device_model , -- id_device_model - int
                          @id_device , -- id_device - int
                          @device , -- device - nvarchar(150)
                          @id_city , -- id_city - int
                          @city , -- city - nvarchar(150)
                          @address , -- address - nvarchar(150)
                          @object_name , -- object_name - nvarchar(150)
                          @contact_name , -- contact_name - nvarchar(150)
                          @add_devices , -- add_device - nvarchar(500)
                          @id_manager , -- id_manager - int
                          @id_service_admin , -- id_service_admin - int
                          @descr , -- descr - nvarchar(max)
                          @id_devinst_state ,
                          GETDATE() , -- dattim1 - datetime
                          @def_dattim2 , -- dattim2 - datetime
                          @def_enabled , -- enabled - bit
                          @id_creator ,
                          NULL , -- old_id_device_install - int
                          @et_number,
                          @device_model,
                          @contractor
				        )
		        
                SELECT  @id_device_install = @@IDENTITY
		        
                RETURN @id_device_install
            END
        ELSE
            IF @action = 'updDeviceInstall'
                BEGIN
                    SELECT  NULL
                
                --Храним историю
                
                    INSERT  INTO dbo.devinst_device_installs
                            ( id_claim ,
                              id_contract ,
                              id_contractor ,
                              contract_number ,
                              plan_date ,
                              id_device_model ,
                              id_device ,
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
                              id_devinst_state ,
                              dattim1 ,
                              dattim2 ,
                              enabled ,
                              id_creator ,
                              old_id_device_install,
                              et_number,
                              device_model,
                              contractor
				            )
                            SELECT  id_claim ,
                                    id_contract ,
                                    id_contractor ,
                                    contract_number ,
                                    plan_date ,
                                    id_device_model ,
                                    id_device ,
                                    device ,
                                    id_city ,
                                    city ,
                                    [address] ,
                                    [object_name] ,
                                    contact_name ,
                                    add_devices ,
                                    id_manager ,
                                    id_service_admin ,
                                    descr ,
                                    id_devinst_state ,
                                    ISNULL(( SELECT TOP 1
                                                    dii.dattim2
                                             FROM   dbo.devinst_device_installs dii
                                             WHERE  dii.old_id_device_install = di.id_device_install
                                             ORDER BY dii.id_device_install DESC
                                           ), dattim1) ,
                                    GETDATE() ,
                                    0 ,
                                    id_creator ,
                                    id_device_install,
                                    et_number,
                                    device_model,
                                    contractor
                            FROM    dbo.devinst_device_installs di
                            WHERE   di.id_device_install = @id_device_install
                
	
                    SELECT  @id_claim = ISNULL(@id_claim,
                                               ( SELECT id_claim
                                                 FROM   devinst_device_installs di
                                                 WHERE  di.id_device_install = @id_device_install
                                               ))
                    SELECT  @id_contract = ISNULL(@id_contract,
                                                  ( SELECT  id_contract
                                                    FROM    devinst_device_installs di
                                                    WHERE   di.id_device_install = @id_device_install
                                                  ))
                    SELECT  @id_contractor = ISNULL(@id_contractor,
                                                    ( SELECT  id_contractor
                                                      FROM    devinst_device_installs di
                                                      WHERE   di.id_device_install = @id_device_install
                                                    ))
                    SELECT  @contract_number = ISNULL(@contract_number,
                                                      ( SELECT
                                                              contract_number
                                                        FROM  devinst_device_installs di
                                                        WHERE di.id_device_install = @id_device_install
                                                      ))
                    SELECT  @plan_date = ISNULL(@plan_date,
                                                ( SELECT    plan_date
                                                  FROM      devinst_device_installs di
                                                  WHERE     di.id_device_install = @id_device_install
                                                ))
                    SELECT  @id_device_model = ISNULL(@id_device_model,
                                                      ( SELECT
                                                              id_device_model
                                                        FROM  devinst_device_installs di
                                                        WHERE di.id_device_install = @id_device_install
                                                      ))
                    SELECT  @id_device = ISNULL(@id_device,
                                                ( SELECT    id_device
                                                  FROM      devinst_device_installs di
                                                  WHERE     di.id_device_install = @id_device_install
                                                ))
                    SELECT  @device = ISNULL(@device,
                                             ( SELECT   device
                                               FROM     devinst_device_installs di
                                               WHERE    di.id_device_install = @id_device_install
                                             ))
                    SELECT  @id_city = ISNULL(@id_city,
                                              ( SELECT  id_city
                                                FROM    devinst_device_installs di
                                                WHERE   di.id_device_install = @id_device_install
                                              ))
                    SELECT  @city = ISNULL(@city,
                                           ( SELECT city
                                             FROM   devinst_device_installs di
                                             WHERE  di.id_device_install = @id_device_install
                                           ))
                    SELECT  @address = ISNULL(@address,
                                              ( SELECT  [address]
                                                FROM    devinst_device_installs di
                                                WHERE   di.id_device_install = @id_device_install
                                              ))
                    SELECT  @object_name = ISNULL(@object_name,
                                                  ( SELECT  [object_name]
                                                    FROM    devinst_device_installs di
                                                    WHERE   di.id_device_install = @id_device_install
                                                  ))
                    SELECT  @contact_name = ISNULL(@contact_name,
                                                   ( SELECT contact_name
                                                     FROM   devinst_device_installs di
                                                     WHERE  di.id_device_install = @id_device_install
                                                   ))
                    SELECT  @add_devices = ISNULL(@add_devices,
                                                  ( SELECT  add_devices
                                                    FROM    devinst_device_installs di
                                                    WHERE   di.id_device_install = @id_device_install
                                                  ))
                    SELECT  @id_manager = ISNULL(@id_manager,
                                                 ( SELECT   id_manager
                                                   FROM     devinst_device_installs di
                                                   WHERE    di.id_device_install = @id_device_install
                                                 ))
                    SELECT  @id_service_admin = ISNULL(@id_service_admin,
                                                       ( SELECT
                                                              id_service_admin
                                                         FROM devinst_device_installs di
                                                         WHERE
                                                              di.id_device_install = @id_device_install
                                                       ))
                    SELECT  @descr = ISNULL(@descr,
                                            ( SELECT    descr
                                              FROM      devinst_device_installs di
                                              WHERE     di.id_device_install = @id_device_install
                                            ))
                    SELECT  @id_creator = ISNULL(@id_creator,
                                                 ( SELECT   id_creator
                                                   FROM     devinst_device_installs di
                                                   WHERE    di.id_device_install = @id_device_install
                                                 ))   
                    SELECT  @id_devinst_state = ISNULL(@id_devinst_state,
                                                       ( SELECT
                                                              id_devinst_state
                                                         FROM devinst_device_installs di
                                                         WHERE
                                                              di.id_device_install = @id_device_install
                                                       ))    
                                                          SELECT  @et_number = ISNULL(@et_number,
                                                       ( SELECT
                                                              et_number
                                                         FROM devinst_device_installs di
                                                         WHERE
                                                              di.id_device_install = @id_device_install
                                                       ))    
                                                          SELECT  @device_model = ISNULL(@device_model,
                                                       ( SELECT
                                                              device_model
                                                         FROM devinst_device_installs di
                                                         WHERE
                                                              di.id_device_install = @id_device_install
                                                       ))    
                                                        SELECT  @contractor = ISNULL(@contractor,
                                                       ( SELECT
                                                              contractor
                                                         FROM devinst_device_installs di
                                                         WHERE
                                                              di.id_device_install = @id_device_install
                                                       ))                                                 
                                                
					----Скрываем запись
                    IF @is_close = 1
                        BEGIN
                            UPDATE  dbo.devinst_device_installs
                            SET     dattim2 = GETDATE() ,
                                    enabled = 0 ,
                                    id_creator = @id_creator
                            WHERE   id_device_install = @id_device_install
                            
                            RETURN @id_device_install
                        END
					
                    UPDATE  dbo.devinst_device_installs
                    SET     id_claim = @id_claim ,
                            id_contract = @id_contract ,
                            id_contractor = @id_contractor ,
                            contract_number = @contract_number ,
                            plan_date = @plan_date ,
                            id_device_model = @id_device_model ,
                            id_device = @id_device ,
                            device = @device ,
                            id_city = @id_city ,
                            city = @city ,
                            [address] = @address ,
                            [object_name] = @object_name ,
                            contact_name = @contact_name ,
                            add_devices = @add_devices ,
                            id_manager = @id_manager ,
                            id_service_admin = @id_service_admin ,
                            descr = @descr ,
                            id_devinst_state = @id_devinst_state,
                            et_number = @et_number,
                            device_model = @device_model,
                            id_creator = @id_creator,
                            contractor = @contractor
                    WHERE   id_device_install = @id_device_install
                        
                    RETURN @id_device_install
                END
        IF @action = 'closeDeviceInstall'
            BEGIN
                SELECT  NULL
            
                EXEC dbo.sk_device_install @action = N'updClaim',
                    @id_device_install = @id_device_install,
                    @id_creator = @id_creator, @is_close = 1				
            END
            
    --=================================
	--DeviceInstallStateChanges
	--=================================	
        IF @action = 'insDeviceInstallStateChanges'
            BEGIN
				
                INSERT  INTO dbo.devinst_state_changes
                        ( id_device_install ,
                          id_devinst_state ,
                          id_creator ,
                          date_change ,
                          enabled
                        )
                VALUES  ( @id_device_install ,
                          @id_devinst_state ,
                          @id_creator ,
                          GETDATE() ,
                          @def_enabled
                        )
		        
                --SELECT  @id_state_change = @@IDENTITY
		        
                --RETURN @id_state_change
            END
    END
