-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ui_zip_claim_reports] @action NVARCHAR(50), @id_contractor INT=null, @date_begin DATETIME=null, @date_end DATETIME=null
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        IF @action = 'getClaimReport'
            BEGIN
                SELECT  cl.id_claim ,
                        cl.dattim1 ,
                        CASE WHEN cl.id_device IS NULL OR cl.id_device<=0 then
                        cl.device_model ELSE dbo.srvpl_fnc('getDeviceShortCollectedNameNoSerialNoBr', NULL, cl.id_device, NULL, null) END AS device_model ,
                        cl.serial_num ,
                        ctr.NAME AS contractor ,
                        cl.city ,
                        ( SELECT    display_name
                          FROM      dbo.users u
                          WHERE     u.id_user = cl.id_engeneer
                        ) AS engeneer ,
                        ( SELECT    display_name
                          FROM      dbo.users u
                          WHERE     u.id_user = cl.id_service_admin
                        ) AS service_admin ,
                        ( SELECT    display_name
                          FROM      dbo.users u
                          WHERE     u.id_user = cl.id_operator
                        ) AS operator ,
                        ( SELECT    display_name
                          FROM      dbo.users u
                          WHERE     u.id_user = cl.id_manager
                        ) AS manager ,
                        st.name AS claim_state ,
                        ec.name AS device_state ,
                        ( SELECT    COUNT(1)
                          FROM      dbo.zipcl_claim_units un
                          WHERE     un.enabled = 1
                                    AND un.id_claim = cl.id_claim
                        ) AS zip_count ,
                        ( SELECT TOP 1
                                    ch.date_change
                          FROM      dbo.zipcl_claim_state_changes ch
                          WHERE     ch.id_claim = cl.id_claim
                                    AND ch.id_claim_state = 8
                          ORDER BY  ch.id_claim_state_change DESC
                        ) AS [SEND] ,--Передано
                        ( SELECT TOP 1
                                    ch.date_change
                          FROM      dbo.zipcl_claim_state_changes ch
                          WHERE     ch.id_claim = cl.id_claim
                                    AND ch.id_claim_state = 9
                          ORDER BY  ch.id_claim_state_change DESC
                        ) AS MANSEL ,--Назначено
                        ( SELECT TOP 1
                                    ch.date_change
                          FROM      dbo.zipcl_claim_state_changes ch
                          WHERE     ch.id_claim = cl.id_claim
                                    AND ch.id_claim_state = 3
                          ORDER BY  ch.id_claim_state_change DESC
                        ) AS PRICE ,--Проставлены цены
                        ( SELECT TOP 1
                                    ch.date_change
                          FROM      dbo.zipcl_claim_state_changes ch
                          WHERE     ch.id_claim = cl.id_claim
                                    AND ch.id_claim_state = 4
                          ORDER BY  ch.id_claim_state_change DESC
                        ) AS PRICEOK ,--Согласованы цены
                        ( SELECT TOP 1
                                    ch.date_change
                          FROM      dbo.zipcl_claim_state_changes ch
                          WHERE     ch.id_claim = cl.id_claim
                                    AND ch.id_claim_state = 5
                          ORDER BY  ch.id_claim_state_change DESC
                        ) AS PRICEFAIL ,--Не согласованы цены
                        ( SELECT TOP 1
                                    ch.date_change
                          FROM      dbo.zipcl_claim_state_changes ch
                          WHERE     ch.id_claim = cl.id_claim
                                    AND ch.id_claim_state = 6
                          ORDER BY  ch.id_claim_state_change DESC
                        ) AS REQUESTNUM ,--Указан номер требования
                        ( SELECT TOP 1
                                    ch.date_change
                          FROM      dbo.zipcl_claim_state_changes ch
                          WHERE     ch.id_claim = cl.id_claim
                                    AND ch.id_claim_state = 7
                          ORDER BY  ch.id_claim_state_change DESC
                        ) AS DONE ,--Завершена
                        cl.cancel_comment ,--Причина отклонения
                        ( SELECT TOP 1
                                    ch.date_change
                          FROM      dbo.zipcl_claim_state_changes ch
                          WHERE     ch.id_claim = cl.id_claim
                                    AND ch.id_claim_state = 10
                          ORDER BY  ch.id_claim_state_change DESC
                        ) AS ETORDER ,--Заказано
                        ( SELECT TOP 1
                                    ch.date_change
                          FROM      dbo.zipcl_claim_state_changes ch
                          WHERE     ch.id_claim = cl.id_claim
                                    AND ch.id_claim_state = 11
                          ORDER BY  ch.id_claim_state_change DESC
                        ) AS ETDOCS ,--Оформлено
                        ( SELECT TOP 1
                                    ch.date_change
                          FROM      dbo.zipcl_claim_state_changes ch
                          WHERE     ch.id_claim = cl.id_claim
                                    AND ch.id_claim_state = 13
                          ORDER BY  ch.id_claim_state_change DESC
                        ) AS ETPREP ,--Готово к отгрузке
                        ( SELECT TOP 1
                                    ch.date_change
                          FROM      dbo.zipcl_claim_state_changes ch
                          WHERE     ch.id_claim = cl.id_claim
                                    AND ch.id_claim_state = 12
                          ORDER BY  ch.id_claim_state_change DESC
                        ) AS ETSHIP ,--Отгружено
                        ( SELECT TOP 1
                                    ch.date_change
                          FROM      dbo.zipcl_claim_state_changes ch
                          WHERE     ch.id_claim = cl.id_claim
                                    AND ch.id_claim_state = 21
                          ORDER BY  ch.id_claim_state_change DESC
                        ) AS SUPPLY ,--Запрошены цены
                        cl.request_num,
                        cl.address
                FROM    dbo.zipcl_zip_claims cl
                        INNER JOIN dbo.get_contractor(NULL) ctr ON cl.id_contractor = ctr.id
                        INNER JOIN dbo.zipcl_claim_states st ON cl.id_claim_state = st.id_claim_state
                        INNER JOIN dbo.zipcl_engeneer_conclusions ec ON cl.id_engeneer_conclusion = ec.id_engeneer_conclusion
                WHERE   cl.enabled = 1
                        AND ( (@id_contractor IS NULL OR @id_contractor <= 0)
                              OR ( @id_contractor IS NOT NULL AND @id_contractor > 0
                                   AND cl.id_contractor = @id_contractor
                                 )
                            )
                        AND ( @date_begin IS NULL
                              OR ( @date_begin IS NOT NULL
                                   AND cl.dattim1 >= @date_begin
                                 )
                            )
                        AND ( @date_end IS NULL
                              OR ( @date_end IS NOT NULL
                                   AND cl.dattim1 <= @date_end
                                 )
                            )
    
            END
    END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ui_zip_claim_reports] TO [sqlUnit_prog]
    AS [dbo];

