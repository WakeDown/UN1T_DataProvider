-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION get_first_month_date	
(
	@date_month date
)
RETURNS date
AS
BEGIN
DECLARE @result date
	set @result = CAST(MONTH(@date_month) AS VARCHAR)
                            + '/' + '01/'
                            + +CAST(YEAR(@date_month) AS VARCHAR)

RETURN @result
END
