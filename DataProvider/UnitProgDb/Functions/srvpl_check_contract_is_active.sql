-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION srvpl_check_contract_is_active
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
                    FROM    dbo.srvpl_contracts c
                            INNER JOIN dbo.srvpl_contract_statuses st ON c.id_contract_status = st.id_contract_status
                    WHERE   c.enabled = 1
                            AND st.enabled = 1
                            AND UPPER(st.sys_name) NOT IN ( 'DEACTIVE' )
                            AND c.id_contract = @id
                            AND CONVERT(DATE, @date) BETWEEN CONVERT(DATE, c.date_begin)
                                                         AND  CONVERT(DATE, c.date_end) )
            BEGIN
                SET @result = 1	
            END
        ELSE
            BEGIN
                SET @result = 0
            END
                                
        RETURN @result

    END
