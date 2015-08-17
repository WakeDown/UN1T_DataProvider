
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE hp_call_details @action NVARCHAR(50)
	,@CITY_SOURC NVARCHAR(255) = NULL
	,@IN NVARCHAR(255) = NULL
	,@AUTH NVARCHAR(255) = NULL
	,@LOCATION NVARCHAR(255) = NULL
	,@SVC NVARCHAR(255) = NULL
	,@TERMINAT NVARCHAR(255) = NULL
	,@ZONE NVARCHAR(255) = NULL
	,@COUNTRY NVARCHAR(255) = NULL
	,@DATE DATE = NULL
	,@TIME NVARCHAR(255) = NULL
	,@DURA TIME(0) = NULL
	,@SECONDS FLOAT = NULL
	,@RATE FLOAT = NULL
	,@CHARGE FLOAT = NULL
	,@dattim1 DATETIME = NULL
	,@dattim2 DATETIME = NULL
	,@id_load UNIQUEIDENTIFIER = NULL
	,@check BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @res INT
		,@error_text NVARCHAR(MAX)

	--IF NOT EXISTS (
	--		SELECT *
	--		FROM sysobjects
	--		WHERE [Name] = 'cdet_call_details'
	--			AND xtype = 'U'
	--		)
	--BEGIN
	--	CREATE TABLE cdet_call_details (
	--		id_call_details INT IDENTITY(1, 1) NOT NULL
	--		,[CITY_SOURC] NVARCHAR(255) NULL
	--		,[IN] NVARCHAR(255) NULL
	--		,[AUTH] NVARCHAR(255) NULL
	--		,[LOCATION] NVARCHAR(255) NULL
	--		,[SVC] NVARCHAR(255) NULL
	--		,[TERMINAT] NVARCHAR(255) NULL
	--		,[ZONE] NVARCHAR(255) NULL
	--		,[COUNTRY] NVARCHAR(255) NULL
	--		,[DATE] DATE NULL
	--		,[TIME] NVARCHAR(255) NULL
	--		,[DURA] TIME(0) NULL
	--		,[SECONDS] FLOAT NULL
	--		,[RATE] FLOAT NULL
	--		,[CHARGE] FLOAT NULL
	--		,dattim1 DATETIME NOT NULL
	--		,[id_load] [uniqueidentifier] NOT NULL
	--		,CONSTRAINT [PK_call_details] PRIMARY KEY CLUSTERED ([id_call_details] ASC) WITH (
	--			PAD_INDEX = OFF
	--			,STATISTICS_NORECOMPUTE = OFF
	--			,IGNORE_DUP_KEY = OFF
	--			,ALLOW_ROW_LOCKS = ON
	--			,ALLOW_PAGE_LOCKS = ON
	--			) ON [PRIMARY]
	--		) ON [PRIMARY]
	--END
	
	--Вычисляет повторные записи
	IF @action = 'repeat'
	BEGIN
		SELECT *
		FROM (
			SELECT COUNT(1) AS [count]
				,c.CITY_SOURC
				,c.[IN]
				,c.AUTH
				,c.LOCATION
				,c.SVC
				,c.TERMINAT
				,c.ZONE
				,c.COUNTRY
				,c.DATE
				,c.TIME
				,c.DURA
				,c.SECONDS
				,c.RATE
				,c.CHARGE
			FROM dbo.cdet_call_details c
			GROUP BY c.AUTH
				,c.CHARGE
				,c.CITY_SOURC
				,c.COUNTRY
				,c.DATE
				,c.DURA
				,c.[IN]
				,c.LOCATION
				,c.RATE
				,c.SECONDS
				,c.SVC
				,c.TERMINAT
				,c.TIME
				,c.ZONE
			) AS t
		WHERE t.[count] > 1
		ORDER BY MONTH(t.DATE)
	END

	IF @action = 'insRecord'
	BEGIN
		SET @res = 0

		--IF not EXISTS (
		--		SELECT 1
		--		FROM cdet_call_details c
		--		WHERE CITY_SOURC = @CITY_SOURC
		--			AND [IN] = @IN
		--			AND AUTH = @AUTH
		--			AND LOCATION = @LOCATION
		--			AND SVC = @SVC
		--			AND TERMINAT = @TERMINAT
		--			AND ZONE = @ZONE
		--			AND COUNTRY = @COUNTRY
		--			AND [DATE] = @DATE
		--			AND [TIME] = @TIME
		--			AND DURA = @DURA
		--			AND SECONDS = @SECONDS
		--			AND RATE = @RATE
		--			AND CHARGE = @CHARGE
		--		)
		--BEGIN
		--если за данный месяц записи загружены (существует хоть одна запись за этот месяц и идентификатор загрузки отличается, то не грузим
		IF (@check = 1)
		BEGIN
			IF (
					MONTH(@date) IN (
						SELECT MONTH(c.DATE)
						FROM dbo.cdet_call_details c
						GROUP BY MONTH(c.DATE)
						)
					AND NOT EXISTS (
						SELECT 1
						FROM dbo.cdet_call_details c
						WHERE MONTH(c.DATE) = MONTH(@date)
							AND c.id_load = @id_load
						)
					)
			BEGIN
				SET @error_text = 'Данный месяц (' + DATENAME(month, @DATE) + ') уже загружен.'

				RAISERROR (
						@error_text
						,16
						,1
						)

				RETURN
			END
		END

		INSERT INTO cdet_call_details (
			CITY_SOURC
			,[IN]
			,AUTH
			,LOCATION
			,SVC
			,TERMINAT
			,ZONE
			,COUNTRY
			,[DATE]
			,[TIME]
			,DURA
			,SECONDS
			,RATE
			,CHARGE
			,dattim1
			,id_load
			)
		VALUES (
			@CITY_SOURC
			,@IN
			,@AUTH
			,@LOCATION
			,@SVC
			,@TERMINAT
			,@ZONE
			,@COUNTRY
			,@DATE
			,@TIME
			,@DURA
			,@SECONDS
			,@RATE
			,@CHARGE
			,GETDATE()
			,@id_load
			)

		SET @res = 1

		--END
		SELECT @res AS result
	END
	ELSE
		IF @action = 'report'
		BEGIN
			SELECT c.ZONE
				,c.[IN]
				,c.COUNTRY
				,convert(DATE, c.DATE, 104) AS [date]
				,c.SECONDS / 60 AS [MINUTES]
				,c.CHARGE
				,1 AS [count]
			FROM dbo.cdet_call_details c
			WHERE (
					@IN IS NULL
					OR (
						@in IS NOT NULL
						AND c.[IN] IN (
							SELECT VALUE
							FROM dbo.Split(@IN, ',')
							)
						)
					)
				AND (
					@dattim1 IS NULL
					OR (
						@dattim1 IS NOT NULL
						AND convert(DATE, c.DATE) >= convert(DATE, @dattim1)
						)
					)
				AND (
					@dattim2 IS NULL
					OR (
						@dattim2 IS NOT NULL
						AND convert(DATE, c.DATE) <= convert(DATE, @dattim2)
						)
					)
		END
		ELSE
			IF @action = 'repInList'
			BEGIN
				SELECT [in] AS NAME
					,[in] AS id
				FROM dbo.cdet_call_details c
				GROUP BY c.[IN]
			END
			ELSE
				IF @action = 'get_default_dattim1'
				BEGIN
					--select convert(date,MIN(dattim1)) as dattim1 from agr_agreements
					SELECT CONVERT(DATE, '01.' + convert(NVARCHAR, month(getdate())) + '.' + convert(NVARCHAR, year(getdate())), 104) AS dattim1
				END
				ELSE
					IF @action = 'get_default_dattim2'
					BEGIN
						----Last Day of Previous Month
						--SELECT DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()),0))
						--LastDay_PreviousMonth
						------Last Day of Current Month
						--SELECT DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1,0))
						--LastDay_CurrentMonth
						------Last Day of Next Month
						--SELECT DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+2,0))
						--LastDay_NextMonth
						--select convert(date,GETDATE()) as dattim2
						SELECT convert(DATE, DATEADD(s, - 1, DATEADD(mm, DATEDIFF(m, 0, GETDATE()) + 1, 0)), 104) AS dattim2
					END
END
