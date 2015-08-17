
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[rep_agreements] @action NVARCHAR(50)
	,@dattim1 DATE = NULL
	,@dattim2 DATE = NULL
	,@id_doc_type INT = - 1
	,@id_contract_type INT = - 1
	,@id_department INT = - 1
	,@id_agr_manager INT = - 1
	,@id_doc_manager INT = - 1
	,@id_agr_state NVARCHAR(150) = NULL
	,@id_agr_scheme NVARCHAR(150) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @select_all_value INT

	SET @select_all_value = - 1

	IF @action = 'overal_report'
	BEGIN
		SELECT ct.NAME AS contract_type
			,dt.NAME AS doc_type
			,dp.NAME AS department
			,ctr.o2s5xclow3h + ' (ИНН ' + CONVERT(NVARCHAR, ctr.o2s5xclow3t) + ')' AS contractor
			,c.NAME AS company
			,agr_u.full_name AS agr_manager
			,doc_u.full_name AS doc_manager
			,CASE 
				WHEN d.amount > 0
					THEN amount
				ELSE 0
				END AS amount
			,1 AS [count]
			,st.NAME AS STATE
		FROM agr_agreements a
		INNER JOIN agr_documents d ON a.id_document = d.id_document
		INNER JOIN agr_contract_types ct ON d.id_contract_type = ct.id_contract_type
		INNER JOIN agr_doc_types dt ON d.id_doc_type = dt.id_doc_type
		INNER JOIN departments dp ON d.id_department = dp.id_department
		INNER JOIN [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_o2s5xclp1y3 ctr ON d.id_contractor = ctr.recordid
		INNER JOIN companies c ON d.id_company = c.id_company
		INNER JOIN users agr_u ON a.id_agr_manager = agr_u.id_user
		INNER JOIN users doc_u ON d.id_doc_manager = doc_u.id_user
		INNER JOIN agr_states st ON a.id_agr_state = st.id_agr_state
		WHERE a.enabled = 1
			AND a.old_id_agreement IS NULL
			AND (
				@dattim1 IS NULL
				OR (
					@dattim1 IS NOT NULL
					AND convert(DATE, a.dattim1) >= convert(DATE, @dattim1)
					)
				)
			AND (
				@dattim2 IS NULL
				OR (
					@dattim2 IS NOT NULL
					AND convert(DATE, a.dattim1) <= convert(DATE, @dattim2)
					)
				)
			--фильтр по типу документа
			AND (
				@id_doc_type = @select_all_value
				OR (
					@id_doc_type != @select_all_value
					AND d.id_doc_type = @id_doc_type
					)
				)
			--фильтр по виду договора
			AND (
				@id_contract_type = @select_all_value
				OR (
					@id_contract_type != @select_all_value
					AND d.id_contract_type = @id_contract_type
					)
				)
			--фильтр по подразделению
			AND (
				@id_department = @select_all_value
				OR (
					@id_department != @select_all_value
					AND d.id_department = @id_department
					)
				)
			--фильтр по офис-менеджеру
			AND (
				@id_agr_manager = @select_all_value
				OR (
					@id_agr_manager != @select_all_value
					AND a.id_agr_manager = @id_agr_manager
					)
				)
			--фильтр по менеджеру
			AND (
				@id_doc_manager = @select_all_value
				OR (
					@id_doc_manager != @select_all_value
					AND d.id_doc_manager = @id_doc_manager
					)
				)
			--фильтр по статусу согласования
			--and ((@id_agr_state = @select_all_value or @id_agr_state is null) or ((@id_agr_state != @select_all_value or @id_agr_state is not null) and a.id_agr_state in (@id_agr_state)))
			AND (
				@id_agr_state IS NULL
				OR (
					@id_agr_state IS NOT NULL
					AND a.id_agr_state IN (
						SELECT value
						FROM dbo.Split(@id_agr_state, ',')
						)
					)
				)
	END

	IF @action = 'duration_report'
	BEGIN
		SELECT tt.contract_type
			,tt.doc_type
			,tt.department
			,tt.company
			,tt.agr_manager
			,tt.doc_manager
			,tt.scheme
			,tt.COUNT
			,tt.duration
			,CONVERT(NVARCHAR(10), tt.duration / 60) + ':' + CONVERT(NVARCHAR(3), tt.duration % 60) AS hh_mm_duration
			,tt.STATE
		FROM (
			SELECT t.contract_type
				,t.doc_type
				,t.department
				,t.company
				,t.agr_manager
				,t.doc_manager
				,t.scheme
				,t.count
				,dbo.get_work_duration('minute', t.dattim1, CASE 
						WHEN is_ended_state = 1
							THEN max_proc_change
						ELSE GETDATE()
						END) AS duration
				,t.STATE
			FROM (
				SELECT ct.NAME AS contract_type
					,dt.NAME AS doc_type
					,dp.NAME AS department
					,ctr.o2s5xclow3h + ' (ИНН ' + CONVERT(NVARCHAR, ctr.o2s5xclow3t) + ')' AS contractor
					,c.NAME AS company
					,agr_u.full_name AS agr_manager
					,doc_u.full_name AS doc_manager
					,a.dattim1 AS dattim1
					,(
						SELECT max(ap.date_change)
						FROM agr_processes ap
						WHERE ap.id_agreement = a.id_agreement
						) AS max_proc_change
					,(
						SELECT min(ap.date_change)
						FROM agr_processes ap
						WHERE ap.id_agreement = a.id_agreement
						) AS min_proc_change
					--, dbo.get_work_duration('minute', a.dattim1,(select max(ap.dattim1) from agr_processes ap where ap.id_agreement = a.id_agreement)) as duration
					,1 AS [count]
					,sch.NAME AS SCHEME
					,CASE 
						WHEN EXISTS (
								SELECT 1
								FROM dbo.agr_states st
								INNER JOIN dbo.agr_state_types stt ON stt.id_state_type = st.id_state_type
								WHERE a.id_agr_state = st.id_agr_state
								)
							THEN 1
						ELSE 0
						END AS is_ended_state
					,st.NAME AS STATE
				FROM agr_agreements a
				INNER JOIN dbo.agr_schemes AS sch ON a.id_agr_scheme = sch.id_agr_scheme
				INNER JOIN agr_documents d ON a.id_document = d.id_document
				INNER JOIN agr_contract_types ct ON d.id_contract_type = ct.id_contract_type
				INNER JOIN agr_doc_types dt ON d.id_doc_type = dt.id_doc_type
				INNER JOIN departments dp ON d.id_department = dp.id_department
				INNER JOIN [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_o2s5xclp1y3 ctr ON d.id_contractor = ctr.recordid
				INNER JOIN companies c ON d.id_company = c.id_company
				INNER JOIN users agr_u ON a.id_agr_manager = agr_u.id_user
				INNER JOIN users doc_u ON d.id_doc_manager = doc_u.id_user
				INNER JOIN agr_states st ON a.id_agr_state = st.id_agr_state
				WHERE a.enabled = 1
					AND a.old_id_agreement IS NULL
					AND (
						@dattim1 IS NULL
						OR (
							@dattim1 IS NOT NULL
							AND convert(DATE, a.dattim1) >= convert(DATE, @dattim1)
							)
						)
					AND (
						@dattim2 IS NULL
						OR (
							@dattim2 IS NOT NULL
							AND convert(DATE, a.dattim1) <= convert(DATE, @dattim2)
							)
						)
					--фильтр по схеме согласования
					AND (
						@id_doc_type = @select_all_value
						OR (
							@id_doc_type != @select_all_value
							AND d.id_doc_type = @id_doc_type
							)
						)
					--фильтр по типу документа
					AND (
						@id_doc_type = @select_all_value
						OR (
							@id_doc_type != @select_all_value
							AND d.id_doc_type = @id_doc_type
							)
						)
					--фильтр по виду договора
					AND (
						@id_contract_type = @select_all_value
						OR (
							@id_contract_type != @select_all_value
							AND d.id_contract_type = @id_contract_type
							)
						)
					--фильтр по подразделению
					AND (
						@id_department = @select_all_value
						OR (
							@id_department != @select_all_value
							AND d.id_department = @id_department
							)
						)
					--фильтр по офис-менеджеру
					AND (
						@id_agr_manager = @select_all_value
						OR (
							@id_agr_manager != @select_all_value
							AND a.id_agr_manager = @id_agr_manager
							)
						)
					--фильтр по менеджеру
					AND (
						@id_doc_manager = @select_all_value
						OR (
							@id_doc_manager != @select_all_value
							AND d.id_doc_manager = @id_doc_manager
							)
						)
					--фильтр по статусу согласования
					--and ((@id_agr_state = @select_all_value or @id_agr_state is null) or ((@id_agr_state != @select_all_value or @id_agr_state is not null) and a.id_agr_state in (@id_agr_state)))
					AND (
						@id_agr_state IS NULL
						OR (
							@id_agr_state IS NOT NULL
							AND a.id_agr_state IN (
								SELECT value
								FROM dbo.Split(@id_agr_state, ',')
								)
							)
						)
					AND (
						@id_agr_scheme IS NULL
						OR (
							@id_agr_scheme IS NOT NULL
							AND a.id_agr_scheme IN (
								SELECT value
								FROM dbo.Split(@id_agr_scheme, ',')
								)
							)
						)
				) AS t
			) AS tt
	END
	ELSE
		IF @action = 'comeback_delay_report'
		BEGIN
			--			DECLARE @t TABLE (num int);
			--INSERT INTO @t
			--SELECT 0 AS num
			--UNION ALL
			--SELECT 1
			--UNION ALL
			--SELECT 2
			--UNION ALL
			--SELECT 3
			--UNION ALL
			--SELECT 4
			--UNION ALL
			--SELECT 5
			--UNION ALL
			--SELECT 6
			--UNION ALL
			--SELECT 7
			--UNION ALL
			--SELECT 8
			--UNION ALL
			--SELECT 9
			--SELECT t1.num + t2.Num * 10 + t3.Num * 100 + t4.Num * 1000 + 1
			--FROM @t AS t1
			--		CROSS JOIN @t AS t2
			--		CROSS JOIN @t AS t3
			--		CROSS JOIN @t AS t4 
			--ORDER BY 1
			SELECT tbl.doc_manager
				,tbl.sent_delay
				,tbl.contractor
				,tbl.count
				,tbl.amount
			FROM (
				SELECT 1 AS COUNT
					,u.full_name AS doc_manager
					,DATEDIFF(day, ISNULL((
								SELECT TOP 1 aa.dattim2
								FROM dbo.agr_agreements aa
								WHERE aa.old_id_agreement = a.id_agreement
								ORDER BY aa.dattim2 DESC
								), a.dattim1), GETDATE()) AS sent_delay
					,ctr.o2s5xclow3h + ' (ИНН ' + CONVERT(NVARCHAR, ctr.o2s5xclow3t) + ')' AS contractor
					,d.amount
				FROM dbo.agr_agreements a
				INNER JOIN dbo.agr_documents d ON a.id_document = d.id_document
				INNER JOIN users u ON d.id_doc_manager = u.id_user
				INNER JOIN dbo.agr_states st ON a.id_agr_state = st.id_agr_state
				INNER JOIN [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_o2s5xclp1y3 ctr ON d.id_contractor = ctr.recordid
				WHERE a.enabled = 1
					AND a.old_id_agreement IS NULL
					AND UPPER(st.sys_name) IN (
						'SENT'
						,'MATCHED'
						)
					AND (
						@dattim1 IS NULL
						OR (
							@dattim1 IS NOT NULL
							AND convert(DATE, a.dattim1) >= convert(DATE, @dattim1)
							)
						)
					AND (
						@dattim2 IS NULL
						OR (
							@dattim2 IS NOT NULL
							AND convert(DATE, a.dattim1) <= convert(DATE, @dattim2)
							)
						)
					--фильтр по менеджеру
					AND (
						@id_doc_manager = @select_all_value
						OR (
							@id_doc_manager != @select_all_value
							AND d.id_doc_manager = @id_doc_manager
							)
						)
				) AS tbl
			WHERE tbl.sent_delay > 0
			ORDER BY tbl.sent_delay DESC
		END
		ELSE
			IF @action = 'delay_report2'
			BEGIN
			SELECT id_agreement,agr_state, doc_type,contract_type, department, company, contractor, contractor_inn, amount, doc_manager, agr_manager, dattim1, dattim2, sent_delay AS day_duration			from				(
				SELECT a.id_agreement,
					st.NAME AS agr_state--[Статус согласования]
					,dt.NAME AS doc_type--[Тип документа]
					,ct.NAME AS contract_type--[Вид договора]
					,dp.NAME AS department--Подразделение
					,c.NAME AS company--[Юр. лицо Юнит]
					,ctr.o2s5xclsha0 AS contractor--[Внешняя организация]
					,ctr.o2s5xclow3t AS contractor_inn--[ИНН внешней организации]
					,d.amount --AS Сумма
					,uu.display_name AS doc_manager--Менеджер
					,u.display_name AS agr_manager--[Офис-менеджер]
					,a.dattim1 AS dattim1--[Дата начала согласования (когда создано)]
					,(SELECT     MAX(date_change) AS date_change
                            FROM          dbo.agr_processes AS p
                            WHERE      (a.id_agreement = id_agreement) AND (enabled = 1)) AS dattim2--[Дата окончания согласования], 
				--так как выводятся только завершенные согласования то дату окончания берем максимальную
				--,dbo.get_work_duration('hours', a.dattim1, )  END AS [Продолжительность согласования в рабочих часах (с момента создания)]
				,DATEDIFF(day, ISNULL((
								SELECT TOP 1 aa.dattim2
								FROM dbo.agr_agreements aa
								WHERE aa.old_id_agreement = a.id_agreement
								ORDER BY aa.dattim2 DESC
								), a.dattim1), GETDATE()) AS sent_delay
				FROM dbo.agr_agreements AS a
				INNER JOIN dbo.agr_documents AS d ON a.id_document = d.id_document
				INNER JOIN dbo.agr_states AS st ON a.id_agr_state = st.id_agr_state
				INNER JOIN dbo.agr_doc_types AS dt ON d.id_doc_type = dt.id_doc_type
				INNER JOIN dbo.departments AS dp ON d.id_department = dp.id_department
				INNER JOIN dbo.agr_contract_types AS ct ON d.id_contract_type = ct.id_contract_type
				INNER JOIN dbo.companies AS c ON d.id_company = c.id_company
				INNER JOIN dbo.users AS u ON a.id_agr_manager = u.id_user
				INNER JOIN dbo.users AS uu ON d.id_doc_manager = uu.id_user
				INNER JOIN [UFS-DB2].UNIT_WORK.UNIT_WORK.et6_o2s5xclp1y3 AS ctr ON d.id_contractor = ctr.recordid
				WHERE (a.enabled = 1)
					AND (a.old_id_agreement IS NULL)
					AND LOWER(st.sys_name) IN (
						LOWER('MATCHED')
						,LOWER('SENT')
						)
						) AS T						
						WHERE sent_delay >= 50
				--ORDER BY sent_delay DESC
			END

	IF @action = 'get_select_all_value'
	BEGIN
		SELECT @select_all_value AS select_all_value
	END
	ELSE
		IF @action = 'get_default_agr_state'
		BEGIN
			SELECT (
					SELECT convert(NVARCHAR, id_agr_state) + ', '
					FROM agr_states st
					WHERE st.sys_name IN (
							'SENT'
							,'ARCHIVE'
							,'MATCHED'
							)
					FOR XML path('')
					) AS agr_state_ids
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
				ELSE
					IF @action = 'doc_type_selection_list'
					BEGIN
						SELECT @select_all_value AS id
							,'--все--' AS NAME
						
						UNION ALL
						
						SELECT dt.id_doc_type
							,dt.display_name
						FROM agr_doc_types dt
						WHERE dt.enabled = 1
					END
					ELSE
						IF @action = 'contract_type_selection_list'
						BEGIN
							SELECT @select_all_value AS id
								,'--все--' AS NAME
							
							UNION ALL
							
							SELECT ct.id_contract_type
								,ct.display_name
							FROM agr_contract_types ct
							WHERE ct.enabled = 1
						END
						ELSE
							IF @action = 'department_selection_list'
							BEGIN
								SELECT @select_all_value AS id
									,'--все--' AS NAME
								
								UNION ALL
								
								SELECT d.id_department
									,d.display_name
								FROM departments d
								WHERE d.enabled = 1
							END
							ELSE
								IF @action = 'agr_manager_selection_list'
								BEGIN
									SELECT @select_all_value AS id
										,'--все--' AS NAME
									
									UNION ALL
									
									SELECT u.id_user
										,u.full_name
									FROM (
										SELECT a.id_agr_manager
										FROM agr_agreements a
										GROUP BY a.id_agr_manager
										) AS t
									INNER JOIN users u ON t.id_agr_manager = u.id_user
								END
								ELSE
									IF @action = 'doc_manager_selection_list'
									BEGIN
										SELECT @select_all_value AS id
											,'--все--' AS NAME
										
										UNION ALL
										
										SELECT u.id_user
											,u.full_name
										FROM (
											SELECT d.id_doc_manager
											FROM agr_documents d
											GROUP BY d.id_doc_manager
											) AS t
										INNER JOIN users u ON t.id_doc_manager = u.id_user
									END
									ELSE
										IF @action = 'agr_state_selection_list'
										BEGIN
											--select @select_all_value as id, '--все--' as name
											--union all
											SELECT st.id_agr_state AS id
												,st.NAME AS NAME
											FROM agr_states st
											WHERE st.enabled = 1
										END
										ELSE
											IF @action = 'agr_scheme_selection_list'
											BEGIN
												--select @select_all_value as id, '--все--' as name
												--union all
												SELECT s.id_agr_scheme AS id
													,s.NAME AS NAME
												FROM dbo.agr_schemes s
												WHERE s.enabled = 1
											END
											ELSE
												IF @action = 'comeback_delay_count'
												BEGIN
													--													DECLARE @t TABLE (num int);
													--INSERT INTO @t
													--SELECT 0 AS num
													--UNION ALL
													--SELECT 1
													--UNION ALL
													--SELECT 2
													--UNION ALL
													--SELECT 3
													--UNION ALL
													--SELECT 4
													--UNION ALL
													--SELECT 5
													--UNION ALL
													--SELECT 6
													--UNION ALL
													--SELECT 7
													--UNION ALL
													--SELECT 8
													--UNION ALL
													--SELECT 9;
													--SELECT t1.num + t2.Num * 10 + t3.Num * 100 + t4.Num * 1000 + 1
													--FROM @t AS t1
													--		CROSS JOIN @t AS t2
													--		CROSS JOIN @t AS t3
													--		CROSS JOIN @t AS t4 
													--ORDER BY 1;
													DECLARE @LowerBound INT
													DECLARE @UpperBound INT

													SET @LowerBound = 1
													SET @UpperBound = 50

													CREATE TABLE #TMP (Number INT)

													WHILE @LowerBound <= @UpperBound
													BEGIN
														INSERT INTO #TMP (Number)
														VALUES (@LowerBound)

														SET @LowerBound = @LowerBound + 1
													END

													SELECT Number
													FROM #TMP

													DROP TABLE #TMP
												END
END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[rep_agreements] TO [sqlUnit_prog]
    AS [dbo];

