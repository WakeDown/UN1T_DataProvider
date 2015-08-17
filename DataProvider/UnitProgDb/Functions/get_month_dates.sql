-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[get_month_dates]	 
(	
	@date_month date
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT [date] FROM [unit_prog].[dbo].[get_dates_list] (
   [unit_prog].[dbo].get_first_month_date(@date_month)
  ,[unit_prog].[dbo].get_last_month_date(@date_month))
)
