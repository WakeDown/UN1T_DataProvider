-- =============================================
-- Author:		Anton Rekhov
-- Create date: 21.10.2013
-- Description:	Проверка, я вляется ли переданные дата, время рабочими
-- =============================================
CREATE FUNCTION [dbo].[is_work_time]
(
	@dattim datetime
)
RETURNS bit
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result bit, @start_work_time time, @end_work_time time, @end_short_work_time time, @work_day_duration int
	
	set @result = 0
	
	SELECT @start_work_time = wh.TIME
	FROM work_hours wh
	WHERE upper(wh.sys_name) = 'BEGIN'

	SELECT @end_work_time = wh.TIME
	FROM work_hours wh
	WHERE upper(wh.sys_name) = 'END'

	SELECT @end_short_work_time = wh.TIME
	FROM work_hours wh
	WHERE upper(wh.sys_name) = 'SHORTEND'
	
	--номальная продолжительность рабочего дня
	set @work_day_duration = 8
	
	
	 
	--день является рабочим
	select @result = 1 from work_days wd where wd.date = convert(date, @dattim) 
	--время окончания не больше чем конец рабочего дня
		AND 
			CONVERT(TIME, @dattim) <= @end_work_time
			or 
				EXISTS (
					SELECT 1
					FROM work_days wd2
					WHERE wd2.DATE = CONVERT(DATE, @dattim)
						AND wd2.work_hours != @work_day_duration
						AND (CONVERT(TIME, @dattim) <= @end_short_work_time)
					)		
			
			and  
			--время начала меньше времени начала рабочего дня
			convert(TIME, @dattim) > @start_work_time 

	RETURN @result

END
