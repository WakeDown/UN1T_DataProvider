-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sk_srvpl_cache] @action NVARCHAR(150)
AS
    BEGIN
        SET NOCOUNT ON;

        IF @action = 'srvpl_getPlanExecuteContractorList_curr_month_cache'
            BEGIN
                DELETE  srvpl_getPlanExecuteContractorList_curr_month_cache
                
                INSERT  INTO srvpl_getPlanExecuteContractorList_curr_month_cache
                        ( [contractor] ,
                          [id_contractor] ,
                          [id_service_engeneer] ,
                          [plan_cnt] ,
                          [done_cnt] ,
                          [residue] ,
                          [done_percent] ,
                          date_cache
                        )
                        SELECT  [contractor] ,
                                [id_contractor] ,
                                [id_service_engeneer] ,
                                [plan_cnt] ,
                                [done_cnt] ,
                                [residue] ,
                                [done_percent] ,
                                GETDATE()
                        FROM    srvpl_getPlanExecuteContractorList_curr_month t
            END
        ELSE
            IF @action = 'srvpl_getPlanExecuteDeviceList_curr_month_cache'
                BEGIN
                    DELETE  srvpl_getPlanExecuteDeviceList_curr_month_cache

                    INSERT  INTO srvpl_getPlanExecuteDeviceList_curr_month_cache
                            ( [device] ,
                              [id_device] ,
                              [plan_cnt] ,
                              [done_cnt] ,
                              [residue] ,
                              [done_percent] ,
                              [address] ,
                              [city] ,
                              [service_engeneer] ,
                              [id_service_engeneer] ,
                              [date_came] ,
                              [id_service_claim] ,
                              [id_contractor] ,
                              [date_cache] ,
                              id_service_admin ,
                              id_manager,
                              is_limit_device_claims
                            )
                            SELECT  [device] ,
                                    [id_device] ,
                                    [plan_cnt] ,
                                    [done_cnt] ,
                                    [residue] ,
                                    [done_percent] ,
                                    [address] ,
                                    [city] ,
                                    [service_engeneer] ,
                                    [id_service_engeneer] ,
                                    [date_came] ,
                                    [id_service_claim] ,
                                    [id_contractor] ,
                                    GETDATE() ,
                                    id_service_admin ,
                                    id_manager,
                                    is_limit_device_claims
                            FROM    srvpl_getPlanExecuteDeviceList_curr_month t
                END
            ELSE
                IF @action = 'srvpl_getPlanExecuteServAdminContractorList_curr_month_cache'
                    BEGIN
                        DELETE  srvpl_getPlanExecuteServAdminContractorList_curr_month_cache
						
                        INSERT  INTO srvpl_getPlanExecuteServAdminContractorList_curr_month_cache
                                ( [contractor] ,
                                  [id_contractor] ,
                                  [id_service_admin] ,
                                  [plan_cnt] ,
                                  [done_cnt] ,
                                  [residue] ,
                                  [done_percent] ,
                                  date_cache
                                )
                                SELECT  [contractor] ,
                                        [id_contractor] ,
                                        [id_service_admin] ,
                                        [plan_cnt] ,
                                        [done_cnt] ,
                                        [residue] ,
                                        [done_percent] ,
                                        GETDATE()
                                FROM    srvpl_getPlanExecuteServAdminContractorList_curr_month t
                    END
                ELSE
                    IF @action = 'srvpl_getPlanExecuteServManagerContractorList_curr_month_cache'
                        BEGIN
                            DELETE  srvpl_getPlanExecuteServManagerContractorList_curr_month_cache
							
                            INSERT  INTO srvpl_getPlanExecuteServManagerContractorList_curr_month_cache
                                    ( [contractor] ,
                                      [id_contractor] ,
                                      [id_manager] ,
                                      [plan_cnt] ,
                                      [done_cnt] ,
                                      [residue] ,
                                      [done_percent] ,
                                      date_cache
                                    )
                                    SELECT  [contractor] ,
                                            [id_contractor] ,
                                            [id_manager] ,
                                            [plan_cnt] ,
                                            [done_cnt] ,
                                            [residue] ,
                                            [done_percent] ,
                                            GETDATE()
                                    FROM    srvpl_getPlanExecuteServManagerContractorList_curr_month t
                        END
    END
