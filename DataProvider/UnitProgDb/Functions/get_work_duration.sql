
-- =============================================
-- Author:		Anton Rehov
-- Create date: 17.10.2013
-- Description:	Расчет рабочего времени за период, возможность указать желаемый интерсал для возврата (минуты, часы, дни)
-- =============================================
CREATE FUNCTION [dbo].[get_work_duration] (
	@interval NVARCHAR(50) --minute, hour, day
	,@date_start DATETIME
	,@date_end DATETIME
	)
RETURNS INT
AS
BEGIN
	DECLARE @duration INT
		,@end_work_time TIME
		,@start_work_time TIME
		,@end_short_work_time TIME
		,@work_day_duration INT
		,@hours_to_short INT
		,@error_text NVARCHAR(max)
		,@minutes_till_start INT
		,@minutes_to_end INT
		,@full_time_work_days INT
		,@full_time_work_hours INT

	SELECT @start_work_time = wh.TIME
	FROM work_hours wh
	WHERE upper(wh.sys_name) = 'BEGIN'

	SELECT @end_work_time = wh.TIME
	FROM work_hours wh
	WHERE upper(wh.sys_name) = 'END'

	SELECT @end_short_work_time = wh.TIME
	FROM work_hours wh
	WHERE upper(wh.sys_name) = 'SHORTEND'

	SET @work_day_duration = 8 --нормальная продолжительность рабочего дня
	SET @hours_to_short = 1 --количество часов для сокращения

	--if @start_work_time is null or @end_work_time is null
	--begin
	--	SELECT @error_text = 'Проверьте наличие время начала рабочего дня, время окончания, время окончания короткого дня'
	--	RAISERROR (
	--			@error_text
	--			,16
	--			,1
	--			)
	--end
	IF 
		--если начало и окончание в один день
		CONVERT(DATE, @date_start) = CONVERT(DATE, @date_end)
		--время окончания не больше чем конец рабочего дня
		AND (
			CONVERT(TIME, @date_end) <= @end_work_time
			OR EXISTS (
				SELECT 1
				FROM work_days wd
				WHERE wd.DATE = CONVERT(DATE, @date_end)
					AND wd.work_hours != @work_day_duration
					AND (CONVERT(TIME, @date_end) <= @end_short_work_time)
				)
			)
	BEGIN
		IF EXISTS (
				SELECT 1
				FROM work_days wd
				WHERE wd.DATE = CONVERT(DATE, @date_start)
				)
		BEGIN
			SELECT @minutes_till_start =
				--время от начальной даты до конца рабочего дня
				DATEDIFF(minute, CASE 
						WHEN
							--ли дата начала меньше времени начала рабочего дня
							convert(TIME, @date_start) < @start_work_time
							THEN @start_work_time
						ELSE convert(TIME, @date_start)
						END, convert(TIME, @date_end))
		END

		IF @minutes_till_start < 0
		BEGIN
			SET @minutes_till_start = 0
		END

		IF lower(@interval) = 'minute'
		BEGIN
			SET @duration = @minutes_till_start
		END
		ELSE
			IF LOWER(@interval) = 'hour'
			BEGIN
				SET @duration = @minutes_till_start / 60
			END
			ELSE
				IF LOWER(@interval) = 'day'
				BEGIN
					SET @duration = 1
				END
				ELSE
				BEGIN
					SET @duration = NULL
				END
	END
	ELSE
	BEGIN
		IF EXISTS (
				SELECT 1
				FROM work_days wd
				WHERE wd.DATE = CONVERT(DATE, @date_start)
				)
		BEGIN
			SELECT @minutes_till_start =
				--время от начальной даты до конца рабочего дня
				DATEDIFF(minute, CASE 
						WHEN
							--время начала меньше времени начала рабочего дня
							convert(TIME, @date_start) < @start_work_time
							THEN @start_work_time
						ELSE convert(TIME, @date_start)
						END, CASE 
						WHEN
							--если сокращенный день
							EXISTS (
								SELECT 1
								FROM work_days wd
								WHERE wd.DATE = CONVERT(DATE, @date_start)
									AND wd.work_hours != @work_day_duration
								)
							THEN @end_short_work_time
						ELSE @end_work_time
						END)
		END

		IF @minutes_till_start < 0
		BEGIN
			SET @minutes_till_start = 0
		END

		IF EXISTS (
				SELECT 1
				FROM work_days wd
				WHERE wd.DATE = CONVERT(DATE, @date_end)
				)
		BEGIN
			SELECT @minutes_to_end =
				--время до конца раббочего дня в день окончания
				DATEDIFF(MINUTE, @start_work_time, CASE 
						WHEN
							--время окончания не больше чем конец рабочего дня
							CONVERT(TIME, @date_end) <= @end_work_time
							OR EXISTS (
								SELECT 1
								FROM work_days wd
								WHERE wd.DATE = CONVERT(DATE, @date_end)
									AND wd.work_hours != @work_day_duration
									AND (CONVERT(TIME, @date_end) <= @end_short_work_time)
								)
							THEN CONVERT(TIME, @date_end)
						ELSE
							--если времени больше чем конец рабочего дня
							CASE 
								WHEN
									--если сокращенный день
									EXISTS (
										SELECT 1
										FROM work_days wd
										WHERE wd.DATE = CONVERT(DATE, @date_start)
											AND wd.work_hours != @work_day_duration
										)
									THEN @end_short_work_time
								ELSE @end_work_time
								END
						END)
		END

		IF @minutes_to_end < 0
		BEGIN
			SET @minutes_to_end = 0
		END

		SET @full_time_work_days = 0
		SET @full_time_work_hours = 0

		--Если есть полные рабочие дни в промежутке меджу датой начала и датой окончания
		IF datediff(day, @date_start, @date_end) > 1
		BEGIN
			SELECT @full_time_work_days = COUNT(1)
			FROM work_days wd
			WHERE wd.DATE BETWEEN @date_start
					AND @date_end
				AND wd.DATE NOT IN (
					CONVERT(DATE, @date_start)
					,CONVERT(DATE, @date_end)
					)

			SELECT @full_time_work_hours = SUM(wd.work_hours)
			FROM work_days wd
			WHERE wd.DATE BETWEEN @date_start
					AND @date_end
				AND wd.DATE NOT IN (
					CONVERT(DATE, @date_start)
					,CONVERT(DATE, @date_end)
					)
		END

		IF lower(@interval) = 'minute'
		BEGIN
			SET @duration = isnull(@minutes_till_start, 0) + isnull(@minutes_to_end, 0) + (isnull(@full_time_work_hours, 0) * 60)
		END
		ELSE
			IF LOWER(@interval) = 'hour'
			BEGIN
				SET @duration = ((isnull(@minutes_till_start, 0) + isnull(@minutes_to_end, 0)) / 60) + isnull(@full_time_work_hours, 0)
			END
			ELSE
				IF LOWER(@interval) = 'day'
				BEGIN
					SET @duration =
						--начальный и конечный день
						2 + isnull(@full_time_work_days, 0)
				END
				ELSE
				BEGIN
					SET @duration = NULL
				END
	END

	RETURN @duration
END
