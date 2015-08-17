
-- =============================================
-- Author:		Anton Rekhov
-- Create date: 16.10.2013
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[auto_agreements] @action NVARCHAR(50) = NULL
	,@sp_test BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @log_params NVARCHAR(max)
		,@log_descr NVARCHAR(max)
		,@id_program INT
		,@active_id_agr_result INT
		,@empty_id_agr_result INT
		,@id_agreement INT
		,@new_line NVARCHAR(20)
		,@mail_subject NVARCHAR(150)
		,@agr_manager_mail_address NVARCHAR(70)
		,@doc_manager_mail_address NVARCHAR(70)
		,@mail_body NVARCHAR(max)
		,@mail_profile NVARCHAR(50)
		,@mail_recipients NVARCHAR(max)
		,@long_days_delay_period INT
		,@days_count_to_close INT
		,@id_sended_mail_type INT
		,@id_agr_arr NVARCHAR(max)
		,@long_time_delay_period INT
		,@agr_duration INT

	SET @new_line = '<br />'
	SET @mail_profile = '1'

	SELECT TOP 1 @id_program = id_program
	FROM programs p
	WHERE p.enabled = 1
		AND LOWER(p.sys_name) = LOWER('AGREEMENTS')

	SELECT @log_params = CASE 
			WHEN @action IS NULL
				THEN ''
			ELSE ' @action=' + CONVERT(NVARCHAR, @action)
			END + CASE 
			WHEN @sp_test IS NULL
				THEN ''
			ELSE ' @sp_test=' + CONVERT(NVARCHAR, @sp_test)
			END

	EXEC sk_log @action = 'insLog'
		,@proc_name = 'auto_agreements'
		,@id_program = @id_program
		,@params = @log_params
		,@descr = @log_descr

	--=================================
	--Закрывает (удаляет) все согласования на стадии Новый, Согласование, На удаление если с момента последнего действия в них либо создания если действий не было втечении определенного количества дней
	--=================================	
	IF @action = 'closeLongDaysDelayAgreements'
	BEGIN
		IF @sp_test IS NOT NULL
		BEGIN
			RETURN
		END

		EXEC @active_id_agr_result = ui_agreements @action = 'getActiveProcResultId'

		EXEC @empty_id_agr_result = ui_agreements @action = 'getEmptyProcResultId'

		--количество дней до удаления
		SELECT @days_count_to_close = convert(INT, value)
		FROM agr_settings ase
		WHERE ase.enabled = 1
			AND lower(ase.sys_name) = LOWER('AGRDAYCOUNTTOCLOSE')

		DECLARE curs CURSOR
		FOR
		SELECT a.id_agreement
		FROM agr_agreements a
		WHERE a.enabled = 1
			AND old_id_agreement IS NULL
			AND a.id_agr_state IN (
				SELECT id_agr_state
				FROM agr_states st
				WHERE upper(st.sys_name) IN (
						'NEW'
						,'PROCESS'
						,'TODELETE'
						)
				)
			AND datediff(day, isnull((
						SELECT max(date_change)
						FROM agr_processes p
						WHERE p.id_agreement = a.id_agreement
						), a.dattim1), getdate()) > @days_count_to_close

		OPEN curs

		FETCH NEXT
		FROM curs
		INTO @id_agreement

		--добавляем процессы согласования
		WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC sk_agreements @action = 'closeAgreementById'
				,@id_agreement = @id_agreement
				,@id_creator = NULL

			FETCH NEXT
			FROM curs
			INTO @id_agreement
		END

		CLOSE curs

		DEALLOCATE curs
	END

	--=================================
	--Оправка писем о всех согласованиях на стадии Новый, Согласование, На удаление если с момента последнего действия в них прошло 30, 60 или 90 дней
	--=================================	
	IF @action = 'noticeDaysDelayAgreements'
	BEGIN
		IF @sp_test IS NOT NULL
		BEGIN
			RETURN
		END

		--какой промежуток между отправкой писем в днях
		SELECT @long_days_delay_period = convert(INT, value)
		FROM agr_settings ase
		WHERE ase.enabled = 1
			AND lower(ase.sys_name) = LOWER('AGRLONGDAYSREMINDPERIOD')

		--количество дней до удаления
		SELECT @days_count_to_close = convert(INT, value)
		FROM agr_settings ase
		WHERE ase.enabled = 1
			AND lower(ase.sys_name) = LOWER('AGRDAYCOUNTTOCLOSE')

		EXEC @active_id_agr_result = ui_agreements @action = 'getActiveProcResultId'

		EXEC @empty_id_agr_result = ui_agreements @action = 'getEmptyProcResultId'

		SET @mail_subject = 'Зависшие согласования'

		IF OBJECT_ID('dbo.#tmp_agr_long_days_notice', 'U') IS NOT NULL
		BEGIN
			DROP TABLE dbo.#tmp_agr_long_days_notice
		END

		CREATE TABLE dbo.#tmp_agr_long_days_notice (
			id_agreement INT
			,days_delay INT
			,agr_manager_mail NVARCHAR(100)
			,doc_manager_mail NVARCHAR(100)
			,mail_body NVARCHAR(max)
			)

		INSERT INTO dbo.#tmp_agr_long_days_notice
		SELECT t.id_agreement
			,t.days_delay
			,u.mail AS agr_manager_mail
			,uu.mail AS doc_manager_mail
			,(
				'Согласование по документу ' + CASE 
					WHEN dt.display_name IS NULL
						THEN ''
					ELSE dt.display_name
					END + CASE 
					WHEN d.number IS NULL
						THEN ''
					ELSE ' №' + d.number
					END + CASE 
					WHEN d.doc_date IS NULL
						THEN ''
					ELSE ' от ' + CONVERT(NVARCHAR, d.doc_date, 104)
					END + CASE 
					WHEN (
							d.contract_num IS NOT NULL
							OR d.contract_date IS NOT NULL
							)
						AND (
							d.number IS NOT NULL
							OR d.doc_date IS NOT NULL
							)
						THEN ' договора'
					ELSE ''
					END + CASE 
					WHEN d.contract_num IS NULL
						THEN ' Без номера'
					ELSE ' №' + d.contract_num
					END + CASE 
					WHEN d.contract_date IS NULL
						THEN ' Без даты'
					ELSE ' от ' + CONVERT(NVARCHAR, d.contract_date, 104)
					END + ' (ID ' + CONVERT(NVARCHAR, t.id_agreement) + ')  <b>ВНИМАНИЕ!</b> до удаления осталось дней - ' + convert(NVARCHAR, @days_count_to_close - days_delay)
				--+ @new_line + ctr.o2s5xclsha0 + '(ИНН ' + ctr.o2s5xclow3t + ')'
				) AS mail_body
		FROM (
			SELECT a.id_agreement
				,a.id_document
				,a.id_agr_manager
				,datediff(day, isnull((
							SELECT max(date_change)
							FROM agr_processes p
							WHERE p.id_agreement = a.id_agreement
							), a.dattim1), getdate()) AS days_delay --задержка в днях
			FROM agr_agreements a
			WHERE a.enabled = 1
				AND old_id_agreement IS NULL
				AND a.id_agr_state IN (
					SELECT id_agr_state
					FROM agr_states st
					WHERE upper(st.sys_name) IN (
							'NEW'
							,'PROCESS'
							,'TODELETE'
							)
					)
			) AS t
		INNER JOIN agr_documents d ON t.id_document = d.id_document
		INNER JOIN agr_doc_types dt ON d.id_doc_type = dt.id_doc_type
		INNER JOIN users u ON t.id_agr_manager = u.id_user
		INNER JOIN users uu ON d.id_doc_manager = uu.id_user
		WHERE
			--необходимо отправлять каждое первое число месяца
			 DAY(getdate()) = 1
			--сейчас рабочее время
			--dbo.is_work_time(GETDATE()) = 1
			--задержка зависания достигла отметки отправки
			and t.days_delay >= @long_days_delay_period
			AND
			--существует запись об отправке письма и дата последней отправки более чем указаный период либо записи об отправке письма не существует
			(
				(
					EXISTS (
						SELECT 1
						FROM sended_mails sm
						WHERE lower(sm.uid) = convert(NVARCHAR(20), t.id_agreement)
							AND sm.id_sended_mail_type IN (
								SELECT id_sended_mail_type
								FROM dbo.sended_mail_types smd
								WHERE smd.id_program = @id_program
									AND lower(smd.sys_name) IN (
										lower('noticeDaysDelayAgreementsDOCMGR')
										,lower('noticeDaysDelayAgreementsAGRMGR')
										)
								)
						)
					AND (
						SELECT datediff(day, max(sm.dattim), GETDATE())
						FROM sended_mails sm
						WHERE lower(sm.uid) = convert(NVARCHAR(20), t.id_agreement)
						) >= @long_days_delay_period
					)
				OR NOT EXISTS (
					SELECT 1
					FROM sended_mails sm
					WHERE sm.uid = convert(NVARCHAR(20), t.id_agreement)
						AND sm.id_sended_mail_type IN (
							SELECT id_sended_mail_type
							FROM dbo.sended_mail_types smd
							WHERE smd.id_program = @id_program
								AND lower(smd.sys_name) IN (
									lower('noticeDaysDelayAgreementsDOCMGR')
									,lower('noticeDaysDelayAgreementsAGRMGR')
									)
							)
					)
				)

		--выбираем письма для менеджеров по договору
		DECLARE curs_doc_mgrs CURSOR
		FOR
		SELECT (
				SELECT ',' + convert(NVARCHAR(20), tbl2.id_agreement)
				FROM dbo.#tmp_agr_long_days_notice tbl2
				WHERE tbl.doc_manager_mail = tbl2.doc_manager_mail
				FOR XML PATH('')
				) AS id_agr_arr
			,doc_manager_mail
			,(
				SELECT @new_line + mail_body
				FROM dbo.#tmp_agr_long_days_notice tbl2
				WHERE tbl.doc_manager_mail = tbl2.doc_manager_mail
				ORDER BY tbl2.days_delay desc
				FOR XML PATH('')
				) AS mail_body
		FROM dbo.#tmp_agr_long_days_notice tbl
		GROUP BY doc_manager_mail

		OPEN curs_doc_mgrs

		FETCH NEXT
		FROM curs_doc_mgrs
		INTO @id_agr_arr
			,@mail_recipients
			,@mail_body

		SELECT @id_sended_mail_type = id_sended_mail_type
		FROM dbo.sended_mail_types smd
		WHERE smd.id_program = @id_program
			AND lower(smd.sys_name) = lower('noticeDaysDelayAgreementsDOCMGR')

		--отправляем писма и пометки об их отправке
		WHILE @@FETCH_STATUS = 0
		BEGIN
			BEGIN TRY
				BEGIN TRANSACTION

				--//////TEMP FOR TEST
				--SET @doc_manager_mail_address = @mail_recipients
				--SET @mail_recipients = 'anton.rehov@unitgroup.ru'
				--SET @mail_body = 'must send to ' + @doc_manager_mail_address + @new_line + @new_line + @mail_body
				--//////END TEMP
				--избавляемся от текстовой трактовки скобок html тэгов после выполнения операции for xml path()
				SET @mail_body = replace(replace(@mail_body, '&lt;', '<'), '&gt;', '>')

				EXEC msdb.dbo.sp_send_dbmail @profile_name = @mail_profile
					,@recipients = @mail_recipients
					,@subject = @mail_subject
					,@body_format = 'HTML'
					,@body = @mail_body

				EXEC dbo.sk_sended_mails @id_program = @id_program
					,@id_sended_mail_type = @id_sended_mail_type
					,@uid = @id_agr_arr

				COMMIT TRANSACTION
			END TRY

			BEGIN CATCH
				IF @@TRANCOUNT > 0
					ROLLBACK TRAN
			END CATCH

			FETCH NEXT
			FROM curs_doc_mgrs
			INTO @id_agr_arr
				,@mail_recipients
				,@mail_body
		END

		CLOSE curs_doc_mgrs

		DEALLOCATE curs_doc_mgrs

		--END/////выбираем письма для менеджеров по договору
		--выбираем письма для офис-менеджеров
		DECLARE curs_agr_mgrs CURSOR
		FOR
		SELECT (
				SELECT ',' + convert(NVARCHAR(20), tbl2.id_agreement)
				FROM dbo.#tmp_agr_long_days_notice tbl2
				WHERE tbl.agr_manager_mail = tbl2.agr_manager_mail
				FOR XML PATH('')
				) AS id_agr_arr
			,agr_manager_mail
			,(
				SELECT @new_line + mail_body
				FROM dbo.#tmp_agr_long_days_notice tbl2
				WHERE tbl.agr_manager_mail = tbl2.agr_manager_mail
				ORDER BY tbl2.days_delay desc
				FOR XML PATH('')
				) AS mail_body
		FROM dbo.#tmp_agr_long_days_notice tbl
		GROUP BY agr_manager_mail

		OPEN curs_agr_mgrs

		FETCH NEXT
		FROM curs_agr_mgrs
		INTO @id_agr_arr
			,@mail_recipients
			,@mail_body

		SELECT @id_sended_mail_type = id_sended_mail_type
		FROM dbo.sended_mail_types smd
		WHERE smd.id_program = @id_program
			AND lower(smd.sys_name) = lower('noticeDaysDelayAgreementsAGRMGR')

		--отправляем писма и пометки об их отправке
		WHILE @@FETCH_STATUS = 0
		BEGIN
			BEGIN TRY
				BEGIN TRANSACTION

				--//////TEMP FOR TEST 
				--SET @agr_manager_mail_address = @mail_recipients
				--SET @mail_recipients = 'anton.rehov@unitgroup.ru'
				--SET @mail_body = 'must send to ' + @agr_manager_mail_address + @new_line + @new_line + @mail_body
				--//////END TEMP
				--избавляемся от текстовой трактовки скобок html тэгов после выполнения операции for xml path()
				SET @mail_body = replace(replace(@mail_body, '&lt;', '<'), '&gt;', '>')

				EXEC msdb.dbo.sp_send_dbmail @profile_name = @mail_profile
					,@recipients = @mail_recipients
					,@subject = @mail_subject
					,@body_format = 'HTML'
					,@body = @mail_body

				EXEC dbo.sk_sended_mails @id_program = @id_program
					,@id_sended_mail_type = @id_sended_mail_type
					,@uid = @id_agr_arr

				COMMIT TRANSACTION
			END TRY

			BEGIN CATCH
				IF @@TRANCOUNT > 0
					ROLLBACK TRAN
			END CATCH

			FETCH NEXT
			FROM curs_agr_mgrs
			INTO @id_agr_arr
				,@mail_recipients
				,@mail_body
		END

		CLOSE curs_agr_mgrs

		DEALLOCATE curs_agr_mgrs

		--END/////выбираем письма для офис-менеджеров
		IF OBJECT_ID('dbo.#tmp_agr_long_days_notice', 'U') IS NOT NULL
		BEGIN
			DROP TABLE dbo.#tmp_agr_long_days_notice
		END
	END

	--=================================
	--оповещение о просроченных согласованиях (с момента первого действия в нем - отклонения, утверждения)
	--=================================	
	IF @action = 'noticeTimeDelayAgreements'
	BEGIN
		IF @sp_test IS NOT NULL
		BEGIN
			RETURN
		END

		--какой промежуток между отправкой писем в часах
		SELECT @long_time_delay_period = convert(INT, value)
		FROM agr_settings ase
		WHERE ase.enabled = 1
			AND lower(ase.sys_name) = LOWER('AGRLONGIIMEREMINDPERIOD')

		--допустимая продолжитльность согласования
		SELECT @agr_duration = convert(INT, value)
		FROM agr_settings ase
		WHERE ase.enabled = 1
			AND lower(ase.sys_name) = LOWER('AGRDURATION')

		EXEC @active_id_agr_result = ui_agreements @action = 'getActiveProcResultId'

		EXEC @empty_id_agr_result = ui_agreements @action = 'getEmptyProcResultId'

		SET @mail_subject = 'Просроченные согласования'

		IF OBJECT_ID('dbo.#tmp_agr_long_time_notice', 'U') IS NOT NULL
		BEGIN
			DROP TABLE dbo.#tmp_agr_long_time_notice
		END

		CREATE TABLE dbo.#tmp_agr_long_time_notice (
			id_agreement INT
			,time_excess INT
			,agr_manager_mail NVARCHAR(100)
			,doc_manager_mail NVARCHAR(100)
			,mail_body NVARCHAR(max)
			,id_contractor INT
			)

		INSERT INTO dbo.#tmp_agr_long_time_notice
		SELECT t.id_agreement
			,abs(((@agr_duration * 60) - t.minute_duration)) as time_excess
			,u.mail AS agr_manager_mail
			,uu.mail AS doc_manager_mail
			,t.mail_body + + '  <b>ВНИМАНИЕ!</b> Превышено допустимое время согласования на ' + dbo.minutes2HMString(abs((@agr_duration * 60) - t.minute_duration))
			,t.id_contractor
		FROM (
			SELECT a.id_agreement
				,(
					'Согласование по документу ' + CASE 
						WHEN dt.display_name IS NULL
							THEN ''
						ELSE dt.display_name
						END + CASE 
						WHEN d.number IS NULL
							THEN ''
						ELSE ' №' + d.number
						END + CASE 
						WHEN d.doc_date IS NULL
							THEN ''
						ELSE ' от ' + CONVERT(NVARCHAR, d.doc_date, 104)
						END + CASE 
						WHEN (
								d.contract_num IS NOT NULL
								OR d.contract_date IS NOT NULL
								)
							AND (
								d.number IS NOT NULL
								OR d.doc_date IS NOT NULL
								)
							THEN ' договора'
						ELSE ''
						END + CASE 
						WHEN d.contract_num IS NULL
							THEN ' Без номера'
						ELSE ' №' + d.contract_num
						END + CASE 
						WHEN d.contract_date IS NULL
							THEN ' Без даты'
						ELSE ' от ' + CONVERT(NVARCHAR, d.contract_date, 104)
						END + ' (ID ' + CONVERT(NVARCHAR, a.id_agreement) + ')'
					--+ @new_line + ctr.o2s5xclsha0 + '(ИНН ' + ctr.o2s5xclow3t + ')'
					) AS mail_body
				,d.id_contractor
				,a.id_agr_manager
				,d.id_doc_manager
				--так как интересуют только активные согласования, то считаем до текущего времени
				,dbo.get_work_duration('minute', isnull((
						SELECT min(date_change)
						FROM agr_processes pp
						WHERE a.id_agreement = pp.id_agreement
							AND pp.id_agr_result NOT IN (
								@active_id_agr_result
								,@empty_id_agr_result
								)
						), a.dattim1), getdate()) AS minute_duration
			FROM agr_agreements a
			INNER JOIN agr_documents d ON a.id_document = d.id_document
			INNER JOIN agr_doc_types dt ON d.id_doc_type = dt.id_doc_type
			WHERE a.enabled = 1
				AND old_id_agreement IS NULL
				AND a.id_agr_state IN (
					SELECT id_agr_state
					FROM agr_states st
					WHERE upper(st.sys_name) IN (
							'PROCESS'
							)
					)
			) AS t
		INNER JOIN users u ON t.id_agr_manager = u.id_user
		INNER JOIN users uu ON t.id_doc_manager = uu.id_user
		--inner join [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_o2s5xclp1y3 ctr on ctr.recordid = d.id_contractor
		WHERE 
		--сейчас рабочее время
			dbo.is_work_time(GETDATE()) = 1
		--время согласования превышает допустимое время
		and (@agr_duration * 60) - t.minute_duration < 0
		AND
			--существует запись об отправке письма и дата последней отправки более чем указаный период либо записи об отправке письма не существует
			(
				(
					EXISTS (
						SELECT 1
						FROM sended_mails sm
						WHERE lower(sm.uid) = convert(NVARCHAR(20), t.id_agreement)
							AND sm.id_sended_mail_type IN (
								SELECT id_sended_mail_type
								FROM dbo.sended_mail_types smd
								WHERE smd.id_program = @id_program
									AND lower(smd.sys_name) IN (
										lower('noticeTimeDelayAgreementsDOCMGR')
										,lower('noticeTimeDelayAgreementsAGRMGR')
										)
								)
						)
					AND (
						SELECT datediff(hour, max(sm.dattim), GETDATE())
						FROM sended_mails sm
						WHERE lower(sm.uid) = convert(NVARCHAR(20), t.id_agreement)
						) >= @long_time_delay_period
					)
				OR NOT EXISTS (
					SELECT 1
					FROM sended_mails sm
					WHERE sm.uid = convert(NVARCHAR(20), t.id_agreement)
						AND sm.id_sended_mail_type IN (
							SELECT id_sended_mail_type
							FROM dbo.sended_mail_types smd
							WHERE smd.id_program = @id_program
								AND lower(smd.sys_name) IN (
									lower('noticeTimeDelayAgreementsDOCMGR')
									,lower('noticeTimeDelayAgreementsAGRMGR')
									)
							)
					)
				)
			
		
		--выбираем письма для менеджеров по договору
		DECLARE curs_doc_mgrs CURSOR
		FOR
		SELECT (
				SELECT ',' + convert(NVARCHAR(20), tbl2.id_agreement)
				FROM dbo.#tmp_agr_long_time_notice tbl2
				WHERE tbl.doc_manager_mail = tbl2.doc_manager_mail
				FOR XML PATH('')
				) AS id_agr_arr
			,doc_manager_mail
			,(
				SELECT @new_line + mail_body
				FROM dbo.#tmp_agr_long_time_notice tbl2
				WHERE tbl.doc_manager_mail = tbl2.doc_manager_mail
				ORDER BY tbl2.time_excess desc
				FOR XML PATH('')
				) AS mail_body
		FROM dbo.#tmp_agr_long_time_notice tbl
		GROUP BY doc_manager_mail

		OPEN curs_doc_mgrs

		FETCH NEXT
		FROM curs_doc_mgrs
		INTO @id_agr_arr
			,@mail_recipients
			,@mail_body

		SELECT @id_sended_mail_type = id_sended_mail_type
		FROM dbo.sended_mail_types smd
		WHERE smd.id_program = @id_program
			AND lower(smd.sys_name) = lower('noticeTimeDelayAgreementsDOCMGR')

		--отправляем писма и пометки об их отправке
		WHILE @@FETCH_STATUS = 0
		BEGIN
			BEGIN TRY
				BEGIN TRANSACTION

				--//////TEMP FOR TEST
				--SET @doc_manager_mail_address = @mail_recipients
				--SET @mail_recipients = 'anton.rehov@unitgroup.ru'
				--SET @mail_body = 'must send to ' + @doc_manager_mail_address + @new_line + @new_line + @mail_body
				--//////END TEMP
				
				--избавляемся от текстовой трактовки скобок html тэгов после выполнения операции for xml path()
				SET @mail_body = replace(replace(@mail_body, '&lt;', '<'), '&gt;', '>')

				EXEC msdb.dbo.sp_send_dbmail @profile_name = @mail_profile
					,@recipients = @mail_recipients
					,@subject = @mail_subject
					,@body_format = 'HTML'
					,@body = @mail_body

				EXEC dbo.sk_sended_mails @id_program = @id_program
					,@id_sended_mail_type = @id_sended_mail_type
					,@uid = @id_agr_arr

				COMMIT TRANSACTION
			END TRY

			BEGIN CATCH
				IF @@TRANCOUNT > 0
					ROLLBACK TRAN
			END CATCH

			FETCH NEXT
			FROM curs_doc_mgrs
			INTO @id_agr_arr
				,@mail_recipients
				,@mail_body
		END

		CLOSE curs_doc_mgrs

		DEALLOCATE curs_doc_mgrs

		--END/////выбираем письма для менеджеров по договору
		
		--выбираем письма для офис-менеджеров
		DECLARE curs_agr_mgrs CURSOR
		FOR
		SELECT (
				SELECT ',' + convert(NVARCHAR(20), tbl2.id_agreement)
				FROM dbo.#tmp_agr_long_time_notice tbl2
				WHERE tbl.agr_manager_mail = tbl2.agr_manager_mail
				FOR XML PATH('')
				) AS id_agr_arr
			,agr_manager_mail
			,(
				SELECT @new_line + mail_body
				FROM dbo.#tmp_agr_long_time_notice tbl2
				WHERE tbl.agr_manager_mail = tbl2.agr_manager_mail
				ORDER BY tbl2.time_excess desc
				FOR XML PATH('')
				) AS mail_body
		FROM dbo.#tmp_agr_long_time_notice tbl
		GROUP BY agr_manager_mail

		OPEN curs_agr_mgrs

		FETCH NEXT
		FROM curs_agr_mgrs
		INTO @id_agr_arr
			,@mail_recipients
			,@mail_body

		SELECT @id_sended_mail_type = id_sended_mail_type
		FROM dbo.sended_mail_types smd
		WHERE smd.id_program = @id_program
			AND lower(smd.sys_name) = lower('noticeTimeDelayAgreementsAGRMGR')

		--отправляем писма и пометки об их отправке
		WHILE @@FETCH_STATUS = 0
		BEGIN
			BEGIN TRY
				BEGIN TRANSACTION

				--//////TEMP FOR TEST 
				--SET @agr_manager_mail_address = @mail_recipients
				--SET @mail_recipients = 'anton.rehov@unitgroup.ru'
				--SET @mail_body = 'must send to ' + @agr_manager_mail_address + @new_line + @new_line + @mail_body
				--//////END TEMP
				--избавляемся от текстовой трактовки скобок html тэгов после выполнения операции for xml path()
				SET @mail_body = replace(replace(@mail_body, '&lt;', '<'), '&gt;', '>')

				EXEC msdb.dbo.sp_send_dbmail @profile_name = @mail_profile
					,@recipients = @mail_recipients
					,@subject = @mail_subject
					,@body_format = 'HTML'
					,@body = @mail_body

				EXEC dbo.sk_sended_mails @id_program = @id_program
					,@id_sended_mail_type = @id_sended_mail_type
					,@uid = @id_agr_arr

				COMMIT TRANSACTION
			END TRY

			BEGIN CATCH
				IF @@TRANCOUNT > 0
					ROLLBACK TRAN
			END CATCH

			FETCH NEXT
			FROM curs_agr_mgrs
			INTO @id_agr_arr
				,@mail_recipients
				,@mail_body
		END

		CLOSE curs_agr_mgrs

		DEALLOCATE curs_agr_mgrs

		--END/////выбираем письма для офис-менеджеров
		IF OBJECT_ID('dbo.#tmp_agr_long_time_notice', 'U') IS NOT NULL
		BEGIN
			DROP TABLE dbo.#tmp_agr_long_time_notice
		END
	END
END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[auto_agreements] TO [sqlUnit_prog]
    AS [dbo];

