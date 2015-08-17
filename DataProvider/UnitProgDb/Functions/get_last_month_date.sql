-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION get_last_month_date	
(
	@date_month date
)
RETURNS date
AS
BEGIN
DECLARE @result date
	SET @result = DATEADD(s, -1, DATEADD(mm, DATEDIFF(m, 0, @date_month) + 1, 0));

RETURN @result
END
