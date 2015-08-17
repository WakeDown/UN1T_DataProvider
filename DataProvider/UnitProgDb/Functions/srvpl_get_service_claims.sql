-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [srvpl_get_service_claims] 
(	
	
)
RETURNS TABLE 
AS
RETURN 
(
SELECT sc.[id_service_claim]
      ,sc.[id_contract]
      ,sc.[id_device]
      ,sc.[id_service_admin]
      ,sc.[planing_date]
      ,sc.[id_service_type]
      ,sc.[number]
      ,sc.[id_service_engeneer]
      ,sc.[descr]
      ,sc.[id_service_claim_status]
      ,sc.[dattim1]
      ,sc.[dattim2]
      ,sc.[enabled]
      ,sc.[id_creator]
      ,sc.[order_num]
      ,sc.[id_contract2devices]
      ,sc.[id_service_claim_type]
	FROM      dbo.srvpl_service_claims sc
                                                INNER JOIN dbo.srvpl_service_claim_statuses scs ON sc.id_service_claim_status = scs.id_service_claim_status
                                                INNER JOIN dbo.srvpl_contracts c ON sc.id_contract = c.id_contract
                                                INNER JOIN dbo.srvpl_devices d ON sc.id_device = d.id_device
                                                INNER JOIN dbo.srvpl_contract2devices c2d ON c2d.id_contract2devices = sc.id_contract2devices
                                      WHERE     sc.enabled = 1
                                                AND c2d.enabled = 1
                                                AND c.enabled = 1
                                                AND d.enabled = 1
)
