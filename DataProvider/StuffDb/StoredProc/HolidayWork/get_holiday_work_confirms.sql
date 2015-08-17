CREATE PROCEDURE [dbo].[get_holiday_work_confirms]
	@date date
AS
begin set nocount on;
	select distinct full_name from holiday_work_confirms hwc where hwc.enabled=1 and convert(date,hwc.dattim1) = @date

end