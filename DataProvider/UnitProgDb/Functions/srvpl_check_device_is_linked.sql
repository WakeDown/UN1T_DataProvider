-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[srvpl_check_device_is_linked]
    (
      @id INT ,
      @date DATETIME = NULL
    )
RETURNS BIT
AS
    BEGIN
        DECLARE @result BIT
	
        IF @date IS NULL
            BEGIN
                SET @date = GETDATE()
		
            END
		
        IF EXISTS ( SELECT  1
                    FROM    dbo.srvpl_contract2devices c2d
                    WHERE   c2d.enabled = 1
                            AND c2d.id_device = @id
                            --AND CONVERT(DATE, @date) BETWEEN CONVERT(DATE, c2d.dattim1)
                            --                         AND     CONVERT(DATE, c2d.dattim2)
                            AND dbo.srvpl_check_contract_is_active(c2d.id_contract,
                                                              @date) = 1 )
            BEGIN
                SET @result = 1
            END
        ELSE
            BEGIN
                SET @result = 0
            END
        RETURN @result
    END
