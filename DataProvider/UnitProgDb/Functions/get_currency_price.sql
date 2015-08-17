-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[get_currency_price]
    (
      @currency_name VARCHAR(3) ,
      @date DATETIME
    )
RETURNS DECIMAL(10, 4)
AS
    BEGIN
        DECLARE @price DECIMAL(10, 4) ,
            @id_currency INT


        SELECT  @id_currency = id_currency
        FROM    currency c
        WHERE   UPPER(sys_name) = UPPER(@currency_name)
                     
           
        SELECT TOP 1
                @price = er.price
        FROM    dbo.exchange_rate er
        WHERE   er.ENABLED = 1
                AND er.id_currency = @id_currency
                AND price IS NOT NULL
                AND price > 0
                AND ( @date IS NULL
                      OR ( @date IS NOT NULL
                           AND er.date_rate <= @date
                         )
                    )
        ORDER BY er.date_rate desc

        RETURN @price
    END
