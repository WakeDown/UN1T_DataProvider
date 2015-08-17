
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ui_agreements]
    @action NVARCHAR(50) = NULL ,
    @sp_test BIT = NULL --переменная для тестирования
    ,
    @id_user INT = NULL ,
    @number NVARCHAR(50) = NULL ,
    @reg_number NVARCHAR(15) = NULL ,
    @doc_date DATETIME = NULL ,
    @id_department INT = NULL ,
    @id_contract_type INT = NULL ,
    @id_company INT = NULL ,
    @id_contractor INT = NULL ,
    @amount MONEY = NULL ,
    @id_doc_manager INT = NULL ,
    @id_creator INT = NULL ,
    @id_agr_scheme INT = NULL ,
    @name NVARCHAR(MAX) = NULL ,
    @amount1 MONEY = NULL ,
    @amount2 MONEY = NULL ,
    @order_num INT = NULL ,
    @id_main_matcher INT = NULL ,
    @id_agr_matcher INT = NULL ,
    @id_agr_manager INT = NULL ,
    @id_agr_state INT = NULL ,
    @id_agreement INT = NULL ,
    @id_agr_result INT = NULL ,
    @comment NVARCHAR(MAX) = NULL ,
    @id_agr_process INT = NULL ,
    @id_doc_type INT = NULL ,
    @agr_type NVARCHAR(MAX) = NULL ,
    @doc_type NVARCHAR(50) = NULL ,
    @descr NVARCHAR(MAX) = NULL ,
    @available BIT = NULL ,
    @id_matchers2schemes INT = NULL ,
    @id_document INT = NULL ,
    @code_num INT = NULL ,
    @id_new_agr_process INT = NULL ,
    @id_old_agr_process INT = NULL ,
    @agr_date DATETIME = NULL ,
    @contract_num NVARCHAR(15) = NULL ,
    @contract_date DATETIME = NULL ,
    @outputString VARCHAR(MAX) = NULL OUTPUT ,
    @add_docs NVARCHAR(MAX) = NULL ,
    @id_updater INT = NULL ,
    @date_period_start DATETIME = NULL ,
    @date_period_end DATETIME = NULL ,
    @no_contract_date BIT = NULL ,
    @no_contract_number BIT = NULL ,
    @sys_name NVARCHAR(50) = NULL ,
    @text NVARCHAR(MAX) = NULL ,
    @id_proc_answer INT = NULL ,
    @file_path NVARCHAR(MAX) = NULL ,
    @id_doc_scan INT = NULL ,
    @id_agr_state_arr NVARCHAR(150) = NULL ,
    @display_name NVARCHAR(150) = NULL ,
    @id_doc_type_option INT = NULL ,
    @id_dt2dto INT = NULL ,
    @enabled BIT = NULL ,
    @matchers_notice BIT = NULL ,
    @id_agr_scheme_type INT = NULL ,
    @id_parent INT = NULL ,
    @have_moscow_access BIT = 0,
    @is_electron BIT = null
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @error_text NVARCHAR(MAX) ,
            @mail_text NVARCHAR(MAX) ,
            @id_program INT ,
            @var_int INT ,
            @log_params NVARCHAR(MAX) ,
            @log_descr NVARCHAR(MAX) ,
            @nolimit_digit DECIMAL ,
            @append_mail_text NVARCHAR(MAX) ,
            @new_line NVARCHAR(20) ,
            @select_all_value INT ,
            @null_value INT ,
            @active_id_agr_result INT ,
            @empty_id_agr_result INT ,
            @var_str NVARCHAR(MAX) ,
            @var_bit BIT ,
            @matcher_mail_text NVARCHAR(MAX) = NULL ,
            @send_mail2matcher BIT = NULL ,
            @matcher_mail NVARCHAR(100) = NULL ,
            @prog_name NVARCHAR(100) = NULL ,
            @id_sended_mail_type INT ,
            @doc_manager_mail_text NVARCHAR(MAX) ,
            @is_new_agreement BIT ,
            @have_notice BIT ,
            @mail_subject NVARCHAR(350) ,
            @prog_root_link NVARCHAR(100) ,
            @link NVARCHAR(150)

        SET @prog_root_link = 'http:\\agreement.un1t.group'
        SET @null_value = -1
        SET @select_all_value = -13
        SET @nolimit_digit = 999999999999
        SET @new_line = '<br />'
        SET @prog_name = 'Электронное согласование документов'

        IF @action NOT LIKE 'get%'
            BEGIN
                SELECT TOP 1
                        @id_program = id_program
                FROM    programs p
                WHERE   p.enabled = 1
                        AND LOWER(p.sys_name) = LOWER('AGREEMENTS')

                SELECT  @log_params = CASE WHEN @action IS NULL THEN ''
                                           ELSE ' @action='
                                                + CONVERT(NVARCHAR, @action)
                                      END + CASE WHEN @sp_test IS NULL THEN ''
                                                 ELSE ' @sp_test='
                                                      + CONVERT(NVARCHAR, @sp_test)
                                            END
                        + CASE WHEN @enabled IS NULL THEN ''
                               ELSE ' @enabled=' + CONVERT(NVARCHAR, @enabled)
                          END + CASE WHEN @id_dt2dto IS NULL THEN ''
                                     ELSE ' @id_dt2dto='
                                          + CONVERT(NVARCHAR, @id_dt2dto)
                                END + CASE WHEN @display_name IS NULL THEN ''
                                           ELSE ' @display_name='
                                                + CONVERT(NVARCHAR, @display_name)
                                      END
                        + CASE WHEN @id_agr_scheme_type IS NULL THEN ''
                               ELSE ' @id_agr_scheme_type='
                                    + CONVERT(NVARCHAR, @id_agr_scheme_type)
                          END + CASE WHEN @id_doc_type_option IS NULL THEN ''
                                     ELSE ' @id_doc_type_option='
                                          + CONVERT(NVARCHAR, @id_doc_type_option)
                                END
                        + CASE WHEN @id_agr_state_arr IS NULL THEN ''
                               ELSE ' @id_agr_state_arr='
                                    + CONVERT(NVARCHAR, @id_agr_state_arr)
                          END + CASE WHEN @file_path IS NULL THEN ''
                                     ELSE ' @file_path='
                                          + CONVERT(NVARCHAR, @file_path)
                                END + CASE WHEN @id_doc_scan IS NULL THEN ''
                                           ELSE ' @id_doc_scan='
                                                + CONVERT(NVARCHAR, @id_doc_scan)
                                      END
                        + CASE WHEN @id_proc_answer IS NULL THEN ''
                               ELSE ' @id_proc_answer='
                                    + CONVERT(NVARCHAR, @id_proc_answer)
                          END + CASE WHEN @text IS NULL THEN ''
                                     ELSE ' @text=' + CONVERT(NVARCHAR, @text)
                                END
                        + CASE WHEN @no_contract_date IS NULL THEN ''
                               ELSE ' @no_contract_date='
                                    + CONVERT(NVARCHAR, @no_contract_date)
                          END + CASE WHEN @sys_name IS NULL THEN ''
                                     ELSE ' @sys_name='
                                          + CONVERT(NVARCHAR, @sys_name)
                                END
                        + CASE WHEN @no_contract_number IS NULL THEN ''
                               ELSE ' @no_contract_number='
                                    + CONVERT(NVARCHAR, @no_contract_number)
                          END + CASE WHEN @date_period_start IS NULL THEN ''
                                     ELSE ' @date_period_start='
                                          + CONVERT(NVARCHAR, @date_period_start)
                                END
                        + CASE WHEN @date_period_end IS NULL THEN ''
                               ELSE ' @date_period_end='
                                    + CONVERT(NVARCHAR, @date_period_end)
                          END + CASE WHEN @id_updater IS NULL THEN ''
                                     ELSE ' @id_updater='
                                          + CONVERT(NVARCHAR, @id_updater)
                                END + CASE WHEN @contract_date IS NULL THEN ''
                                           ELSE ' @contract_date='
                                                + CONVERT(NVARCHAR, @contract_date)
                                      END
                        + CASE WHEN @contract_num IS NULL THEN ''
                               ELSE ' @contract_num='
                                    + CONVERT(NVARCHAR, @contract_num)
                          END + CASE WHEN @id_user IS NULL THEN ''
                                     ELSE ' @id_user='
                                          + CONVERT(NVARCHAR, @id_user)
                                END + CASE WHEN @number IS NULL THEN ''
                                           ELSE ' @number='
                                                + CONVERT(NVARCHAR, @number)
                                      END
                        + CASE WHEN @reg_number IS NULL THEN ''
                               ELSE ' @reg_number='
                                    + CONVERT(NVARCHAR, @reg_number)
                          END + CASE WHEN @doc_date IS NULL THEN ''
                                     ELSE ' @doc_date='
                                          + CONVERT(NVARCHAR, @doc_date)
                                END + CASE WHEN @id_department IS NULL THEN ''
                                           ELSE ' @id_department='
                                                + CONVERT(NVARCHAR, @id_department)
                                      END
                        + CASE WHEN @id_contract_type IS NULL THEN ''
                               ELSE ' @id_contract_type='
                                    + CONVERT(NVARCHAR, @id_contract_type)
                          END + CASE WHEN @id_company IS NULL THEN ''
                                     ELSE ' @id_company='
                                          + CONVERT(NVARCHAR, @id_company)
                                END + CASE WHEN @id_contractor IS NULL THEN ''
                                           ELSE ' @id_contractor='
                                                + CONVERT(NVARCHAR, @id_contractor)
                                      END + CASE WHEN @amount IS NULL THEN ''
                                                 ELSE ' @amount='
                                                      + CONVERT(NVARCHAR, @amount)
                                            END
                        + CASE WHEN @id_doc_manager IS NULL THEN ''
                               ELSE ' @id_doc_manager='
                                    + CONVERT(NVARCHAR, @id_doc_manager)
                          END + CASE WHEN @id_creator IS NULL THEN ''
                                     ELSE ' @id_creator='
                                          + CONVERT(NVARCHAR, @id_creator)
                                END + CASE WHEN @id_agr_scheme IS NULL THEN ''
                                           ELSE ' @id_agr_scheme='
                                                + CONVERT(NVARCHAR, @id_agr_scheme)
                                      END + CASE WHEN @name IS NULL THEN ''
                                                 ELSE ' @name='
                                                      + CONVERT(NVARCHAR, @name)
                                            END
                        + CASE WHEN @amount1 IS NULL THEN ''
                               ELSE ' @amount1=' + CONVERT(NVARCHAR, @amount1)
                          END + CASE WHEN @amount2 IS NULL THEN ''
                                     ELSE ' @amount2='
                                          + CONVERT(NVARCHAR, @amount2)
                                END + CASE WHEN @order_num IS NULL THEN ''
                                           ELSE ' @order_num='
                                                + CONVERT(NVARCHAR, @order_num)
                                      END
                        + CASE WHEN @id_main_matcher IS NULL THEN ''
                               ELSE ' @id_main_matcher='
                                    + CONVERT(NVARCHAR, @id_main_matcher)
                          END + CASE WHEN @id_agr_matcher IS NULL THEN ''
                                     ELSE ' @id_agr_matcher='
                                          + CONVERT(NVARCHAR, @id_agr_matcher)
                                END
                        + CASE WHEN @id_agr_manager IS NULL THEN ''
                               ELSE ' @id_agr_manager='
                                    + CONVERT(NVARCHAR, @id_agr_manager)
                          END + CASE WHEN @id_agr_state IS NULL THEN ''
                                     ELSE ' @id_agr_state='
                                          + CONVERT(NVARCHAR, @id_agr_state)
                                END + CASE WHEN @id_agreement IS NULL THEN ''
                                           ELSE ' @id_agreement='
                                                + CONVERT(NVARCHAR, @id_agreement)
                                      END
                        + CASE WHEN @id_agr_result IS NULL THEN ''
                               ELSE ' @id_agr_result='
                                    + CONVERT(NVARCHAR, @id_agr_result)
                          END + CASE WHEN @comment IS NULL THEN ''
                                     ELSE ' @comment='
                                          + CONVERT(NVARCHAR, @comment)
                                END
                        + CASE WHEN @id_agr_process IS NULL THEN ''
                               ELSE ' @id_agr_process='
                                    + CONVERT(NVARCHAR, @id_agr_process)
                          END + CASE WHEN @id_doc_type IS NULL THEN ''
                                     ELSE ' @id_doc_type='
                                          + CONVERT(NVARCHAR, @id_doc_type)
                                END + CASE WHEN @agr_type IS NULL THEN ''
                                           ELSE ' @agr_type='
                                                + CONVERT(NVARCHAR, @agr_type)
                                      END
                        + CASE WHEN @doc_type IS NULL THEN ''
                               ELSE ' @doc_type='
                                    + CONVERT(NVARCHAR, @doc_type)
                          END + CASE WHEN @descr IS NULL THEN ''
                                     ELSE ' @descr='
                                          + CONVERT(NVARCHAR, @descr)
                                END + CASE WHEN @available IS NULL THEN ''
                                           ELSE ' @available='
                                                + CONVERT(NVARCHAR, @available)
                                      END
                        + CASE WHEN @id_matchers2schemes IS NULL THEN ''
                               ELSE ' @id_matchers2schemes='
                                    + CONVERT(NVARCHAR, @id_matchers2schemes)
                          END + CASE WHEN @id_document IS NULL THEN ''
                                     ELSE ' @id_document='
                                          + CONVERT(NVARCHAR, @id_document)
                                END + CASE WHEN @code_num IS NULL THEN ''
                                           ELSE ' @code_num='
                                                + CONVERT(NVARCHAR, @code_num)
                                      END
                        + CASE WHEN @id_new_agr_process IS NULL THEN ''
                               ELSE ' @id_new_agr_process='
                                    + CONVERT(NVARCHAR, @id_new_agr_process)
                          END + CASE WHEN @id_old_agr_process IS NULL THEN ''
                                     ELSE ' @id_old_agr_process='
                                          + CONVERT(NVARCHAR, @id_old_agr_process)
                                END + CASE WHEN @agr_date IS NULL THEN ''
                                           ELSE ' @agr_date='
                                                + CONVERT(NVARCHAR, @agr_date)
                                      END
                        + CASE WHEN @add_docs IS NULL THEN ''
                               ELSE ' @add_docs='
                                    + CONVERT(NVARCHAR(MAX), @add_docs)
                          END + CASE WHEN @id_parent IS NULL THEN ''
                                     ELSE ' @id_parent='
                                          + CONVERT(NVARCHAR(MAX), @id_parent)
                                END
                        + CASE WHEN @have_moscow_access IS NULL THEN ''
                               ELSE ' @have_moscow_access='
                                    + CONVERT(NVARCHAR(150), @have_moscow_access)
                          END
                          + CASE WHEN @is_electron IS NULL THEN ''
                               ELSE ' @is_electron='
                                    + CONVERT(NVARCHAR(150), @is_electron)
                          END

                EXEC sk_log @action = 'insLog', @proc_name = 'ui_agreements',
                    @id_program = @id_program, @params = @log_params,
                    @descr = @log_descr
            END

	--=================================
	--Получение списка согласований
	--=================================	
        IF @action = 'getAgreementsList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                EXEC @active_id_agr_result = ui_agreements @action = 'getActiveProcResultId'

                EXEC @empty_id_agr_result = ui_agreements @action = 'getEmptyProcResultId'

                SELECT  t.id ,
                        t.table_order_num ,
                        t.id_agreement ,
                        t.id_agr_scheme ,
                        t.id_agr_manager ,
                        t.id_agr_state ,
                        t.STATE ,
                        t.agr_manager ,
                        t.amount ,
                        t.doc_date ,
                        t.doc_number ,
                        t.contract_num ,
                        t.contract_date ,
                        t.doc_manager ,
                        t.doc_type ,
                        t.btn_match_visible ,
                        t.id_agr_process ,
                        t.btn_close_visible ,
                        t.btn_sent2client_visible ,
                        t.btn_comeback_visible ,
                        t.btn_clip_visible ,
                        t.btn_agr_list_visible ,
                        t.btn_recover_visible ,
                        t.time_limit AS limit_minutes ,
                        CASE WHEN t.time_limit > 0 THEN 0
                             ELSE 1
                        END AS limit_is_end ,
                        t.full_limit_hours ,
                        t.info ,
                        t.scheme_type_image ,
                        scheme_type_descr
                FROM    ( SELECT    a.id_agreement AS id ,
                                    ROW_NUMBER() OVER ( ORDER BY a.id_agreement DESC ) AS table_order_num ,
                                    a.id_agreement ,
                                    a.id_agr_scheme ,
                                    a.id_agr_manager ,
                                    a.id_agr_state ,
                                    s.NAME AS STATE ,
                                    u.display_name AS agr_manager ,
                                    d.amount ,
                                    CONVERT(NVARCHAR, d.doc_date, 104) AS doc_date ,
                                    d.number AS doc_number ,
                                    ISNULL(d.contract_num, 'Без номера') AS contract_num ,
                                    CASE WHEN d.contract_date IS NULL
                                         THEN 'Без даты'
                                         ELSE CONVERT(NVARCHAR, d.contract_date, 104)
                                    END AS contract_date ,
                                    uu.display_name AS doc_manager ,
                                    dt.display_name AS doc_type ,
                                    CASE WHEN EXISTS ( SELECT id_agr_process
                                                       FROM   agr_processes p
                                                              INNER JOIN agr_matchers m ON p.id_agr_matcher = m.id_agr_matcher
                                                              OR ( p.id_agr_matcher = m.id_main_matcher
                                                              AND m.enabled = 1
                                                              )
                                                       WHERE  p.enabled = 1
                                                              AND m.id_user = @id_user
                                                              AND p.id_agreement = a.id_agreement
                                                              AND p.id_agr_result = @active_id_agr_result )
						--статус "В процессе"
                                              AND LOWER(s.sys_name) = LOWER('PROCESS')
                                         THEN 1
                                         ELSE 0
                                    END AS btn_match_visible
				--//////////////////OLD/////////////////Для жестких согласований
				--,(
				--	SELECT TOP 1 pp.id_agr_process
				--	FROM agr_processes pp
				--	INNER JOIN agr_matchers m ON pp.id_agr_matcher = m.id_agr_matcher
				--		OR (
				--			pp.id_agr_matcher = m.id_main_matcher
				--			AND m.enabled = 1
				--			)
				--	WHERE pp.enabled = 1
				--		AND m.id_user = @id_user
				--		AND pp.id_agreement = a.id_agreement
				--		AND pp.id_agr_result = @active_id_agr_result
				--	) AS id_agr_process
				--END//////////////////OLD/////////////////
                                    ,
                                    ( SELECT    CONVERT(NVARCHAR, pp.id_agr_process)
                                                + ','
                                      FROM      agr_processes pp
                                                INNER JOIN agr_matchers m ON pp.id_agr_matcher = m.id_agr_matcher
                                                              OR ( pp.id_agr_matcher = m.id_main_matcher
                                                              AND m.enabled = 1
                                                              )
                                      WHERE     pp.enabled = 1
                                                AND m.id_user = @id_user
                                                AND pp.id_agreement = a.id_agreement
                                                AND pp.id_agr_result = @active_id_agr_result
                                    FOR
                                      XML PATH('')
                                    ) AS id_agr_process ,
                                    CASE WHEN EXISTS ( SELECT 1
                                                       FROM   agr_processes pp
                                                       WHERE  pp.id_agreement = a.id_agreement
								--только для офис менеджера и создателя
                                                              AND ( a.id_agr_manager = @id_user
                                                              OR a.id_creator = @id_user
                                                              )
								--согласование не завершено
                                                              AND EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              agr_states stt
                                                              WHERE
                                                              a.id_agr_state = stt.id_agr_state
                                                              AND LOWER(stt.sys_name) IN (
                                                              LOWER('NEW'),
                                                              LOWER('PROCESS') ) )
								--не помечено на удаление
                                                              AND LOWER(s.sys_name) != LOWER('TODELETE') --Нет процессов с результатом
								--AND NOT EXISTS (
								--	SELECT 1
								--	FROM agr_processes ppp
								--	WHERE ppp.id_agreement = a.id_agreement
								--		AND ppp.id_agr_result NOT IN (
								--			@empty_id_agr_result
								--			,@active_id_agr_result
								--			)
								--	)
							) THEN 1     ELSE 0
                                    END AS btn_close_visible ,
                                    CASE WHEN
						--только для офис менеджера и создателя
                                              ( a.id_agr_manager = @id_user
                                                OR a.id_creator = @id_user
                                              )
						--согласование завершено
                                              AND LOWER(s.sys_name) = LOWER('MATCHED')
                                         THEN 1
                                         ELSE 0
                                    END AS btn_sent2client_visible ,
                                    CASE WHEN
						--статус согласования "Отправлено клиенту" или "Согласовано"
                                              LOWER(s.sys_name) IN (
                                              LOWER('SENT'), LOWER('MATCHED') )
                                         THEN 1
                                         ELSE 0
                                    END AS btn_comeback_visible ,
                                    CASE WHEN
						--есть прикрепленные документы
                                              EXISTS ( SELECT 1
                                                       FROM   agr_doc_scan ads
                                                       WHERE  ads.enabled = 1
                                                              AND ads.id_agreement = a.id_agreement )
						--статус согласования "Отправлено клиенту", "Согласовано" или "В бухгалтерии"
                                              AND LOWER(s.sys_name) IN (
                                              LOWER('SENT'), LOWER('MATCHED'),
                                              LOWER('ARCHIVE') ) THEN 1
                                         ELSE 0
                                    END AS btn_clip_visible ,
                                    CASE WHEN
						--статус согласования "Создано" или "В процессе"
						--lower(s.sys_name) IN (
						--	lower('PROCESS')
						--	,lower('NEW')
						--	)
                                              1 = 1 THEN 1
                                         ELSE 0
                                    END AS btn_agr_list_visible ,
                                    CASE WHEN
						--помечен на удаление
                                              LOWER(s.sys_name) = LOWER('TODELETE')
                                         THEN 1
                                         ELSE 0
                                    END AS btn_recover_visible ,
                                    CASE WHEN LOWER(s.sys_name) IN (
                                              LOWER('PROCESS'), LOWER('NEW') )
                                              AND EXISTS ( SELECT
                                                              1
                                                           FROM
                                                              agr_processes pp
                                                           WHERE
                                                              a.id_agreement = pp.id_agreement
                                                              AND pp.id_agr_result NOT IN (
                                                              @active_id_agr_result,
                                                              @empty_id_agr_result ) )
                                         THEN ( ( SELECT    CONVERT(INT, value)
                                                  FROM      agr_settings ase
                                                  WHERE     ase.enabled = 1
                                                            AND LOWER(ase.sys_name) = LOWER('AGRDURATION')
                                                ) * 60 )
                                              - --так как интересуют только активные согласования, то считаем до текущего времени							
							dbo.get_work_duration('minute',
                                                  ( SELECT  MIN(date_change)
                                                    FROM    agr_processes pp
                                                    WHERE   a.id_agreement = pp.id_agreement
                                                            AND pp.id_agr_result NOT IN (
                                                            @active_id_agr_result,
                                                            @empty_id_agr_result )
                                                  ), GETDATE())
                                         ELSE NULL
                                    END AS time_limit ,
                                    ( SELECT    CONVERT(INT, value)
                                      FROM      agr_settings ase
                                      WHERE     ase.enabled = 1
                                                AND LOWER(ase.sys_name) = LOWER('AGRDURATION')
                                    ) AS full_limit_hours ,
                                    ( ( SELECT  ctr.o2s5xclow3h + ' (ИНН '
                                                + CONVERT(NVARCHAR, ctr.o2s5xclow3t)
                                                + ')' COLLATE Cyrillic_General_CI_AS
                                        FROM    [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_o2s5xclp1y3 ctr
                                        WHERE   ctr.recordid = d.id_contractor
                                      ) + @new_line
                                      + CASE WHEN dt.display_name IS NULL
                                             THEN ''
                                             ELSE dt.display_name
                                        END
                                      + CASE WHEN d.number IS NULL THEN ''
                                             ELSE ' №' + d.number
                                        END
                                      + CASE WHEN d.doc_date IS NULL THEN ''
                                             ELSE ' от '
                                                  + CONVERT(NVARCHAR, d.doc_date, 104)
                                        END
                                      + CASE WHEN ( d.contract_num IS NOT NULL
                                                    OR d.contract_date IS NOT NULL
                                                  )
                                                  AND ( d.number IS NOT NULL
                                                        OR d.doc_date IS NOT NULL
                                                      ) THEN ' договора'
                                             ELSE ''
                                        END
                                      + CASE WHEN d.contract_num IS NULL
                                             THEN ' Без номера'
                                             ELSE ' №' + d.contract_num
                                        END
                                      + CASE WHEN d.contract_date IS NULL
                                             THEN ' Без даты'
                                             ELSE ' от '
                                                  + CONVERT(NVARCHAR, d.contract_date, 104)
                                        END + @new_line + 'Сумма '
                                      + REPLACE(CONVERT(NVARCHAR, d.amount, 1),
                                                ',', ' ') ) AS info ,
                                    (CASE WHEN a.is_electron = 1
                                    THEN
                                    --костыль для электронного согласования
                                    ( SELECT    stt.image
                                      FROM      agr_scheme_types stt                                                
                                      WHERE     stt.sys_name = 'ELECTRON'
                                    ) 
                                    else
                                    ( SELECT    stt.image
                                      FROM      agr_scheme_types stt
                                                INNER JOIN agr_schemes ss ON ss.id_agr_scheme_type = stt.id_agr_scheme_type
                                      WHERE     ss.id_agr_scheme = a.id_agr_scheme
                                    ) 
                                    END)
                                    AS scheme_type_image ,
                                    (CASE WHEN a.is_electron = 1
                                    THEN
                                    --костыль для электронного согласования
                                    ( SELECT    stt.descr
                                      FROM      agr_scheme_types stt                                                
                                      WHERE     stt.sys_name = 'ELECTRON'
                                    ) 
                                    else
                                    ( SELECT    stt.descr
                                      FROM      agr_scheme_types stt
                                                INNER JOIN agr_schemes ss ON ss.id_agr_scheme_type = stt.id_agr_scheme_type
                                      WHERE     ss.id_agr_scheme = a.id_agr_scheme
                                    )
                                    END)
                                    AS scheme_type_descr
                          FROM      dbo.agr_agreements a
                                    INNER JOIN agr_states s ON a.id_agr_state = s.id_agr_state
                                    INNER JOIN users u ON a.id_agr_manager = u.id_user
                                    INNER JOIN agr_documents d ON a.id_document = d.id_document
                                    INNER JOIN agr_doc_types dt ON d.id_doc_type = dt.id_doc_type
                                    INNER JOIN users uu ON d.id_doc_manager = uu.id_user
                                    INNER JOIN companies c ON d.id_company = c.id_company
                          WHERE     a.enabled = 1
                                    AND a.old_id_agreement IS NULL
                                    AND ( @id_user = @null_value
                                          OR ( @id_user != @null_value
						--and					
                                               )
                                        )
				--Фильтр по ID
                                    AND ( @id_agreement IS NULL
                                          OR ( @id_agreement IS NOT NULL
                                               AND a.id_agreement = @id_agreement
                                             )
                                        )
				--Фильтр по периоду (начало)
                                    AND ( @date_period_start IS NULL
                                          OR ( @date_period_start IS NOT NULL
                                               AND CONVERT(DATE, d.dattim1) >= CONVERT(DATE, @date_period_start)
                                             )
                                        )
				--Фильтр по периоду (окончание)
                                    AND ( @date_period_end IS NULL
                                          OR ( @date_period_end IS NOT NULL
                                               AND CONVERT(DATE, d.dattim1) <= CONVERT(DATE, @date_period_end)
                                             )
                                        )
				--Фильтр по типу договоров
                                    AND ( @id_doc_type = @select_all_value
                                          OR ( @id_doc_type != @select_all_value
                                               AND d.id_doc_type = @id_doc_type
                                             )
                                        )
				--Фильтр по номеру договора
                                    AND ( @contract_num IS NULL
                                          OR ( @contract_num IS NOT NULL
                                               AND d.contract_num LIKE @contract_num
                                               + '%'
                                             )
                                        )
				--Фильтр по Без номера договора
                                    AND ( @no_contract_number IS NULL
                                          OR ( @no_contract_number IS NOT NULL
                                               AND d.contract_num IS NULL
                                             )
                                        )
				--Фильтр по штрих-коду
                                    AND ( @code_num IS NULL
                                          OR ( @code_num IS NOT NULL
                                               AND d.code_num = @code_num
                                             )
                                        )
				--Фильтр по дате договора
                                    AND ( @contract_date IS NULL
                                          OR ( @contract_date IS NOT NULL
                                               AND CONVERT(DATE, d.contract_date) = CONVERT(DATE, @contract_date)
                                             )
                                        )
				--Фильтр по Без даты договора
                                    AND ( @no_contract_date IS NULL
                                          OR ( @no_contract_date IS NOT NULL
                                               AND d.contract_date IS NULL
                                             )
                                        )
				--Фильтр по менеджеру по договору
                                    AND ( @id_agr_manager = @select_all_value
                                          OR ( @id_agr_manager != @select_all_value
                                               AND d.id_doc_manager = @id_agr_manager
                                             )
                                        )
				--Фильтр по офис-менеджеру
                                    AND ( @id_doc_manager = @select_all_value
                                          OR ( @id_doc_manager != @select_all_value
                                               AND a.id_agr_manager = @id_doc_manager
                                             )
                                        )
				--Фильтр по статусу согласования
				--AND (
				--	@id_agr_state = @select_all_value
				--	OR (
				--		@id_agr_state != @select_all_value
				--		AND a.id_agr_state = @id_agr_state
				--		)
				--	)
                                    AND ( @id_agr_state_arr IS NULL
                                          OR ( @id_agr_state_arr IS NOT NULL
                                               AND a.id_agr_state IN (
                                               SELECT   value
                                               FROM     dbo.Split(@id_agr_state_arr,
                                                              ',') )
                                             )
                                        )
				--Фильтр по контрагенту
                                    AND ( @id_contractor = @select_all_value
                                          OR ( @id_contractor != @select_all_value
                                               AND d.id_contractor = @id_contractor
                                             )
                                        )
				--Фильтр по организации (юр. лицо Юнит)
                                    AND ( @id_company = @select_all_value
                                          OR ( @id_company != @select_all_value
                                               AND d.id_company = @id_company
                                             )
                                        )
				--На согласование мне
                                    AND ( @id_agr_matcher = @select_all_value
                                          OR ( @id_agr_matcher != @select_all_value
                                               AND @id_agr_matcher IN (
                                               SELECT   m.id_user
                                               FROM     agr_processes p
                                                        INNER JOIN agr_matchers m ON p.id_agr_matcher = m.id_agr_matcher
                                                              OR ( p.id_agr_matcher = m.id_main_matcher
                                                              AND m.enabled = 1
                                                              )
                                               WHERE    p.enabled = 1
                                                        AND p.id_agreement = a.id_agreement
                                                        AND p.id_agr_result = @active_id_agr_result )
                                             )
                                        )
                        --Органичение доступа к филиалу в Москве
                                    AND ( ( @have_moscow_access = 0
                                            AND ( c.sys_name IS NULL
                                                  OR c.sys_name NOT IN (
                                                  'UNITMOSCOW' )
                                                )
                                          )
                                          OR @have_moscow_access = 1
                                        )
                        ) AS t
                ORDER BY t.id DESC
            END

        IF @action = 'getAgreementTitle'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  ( 'Согласование документа '
                          + CASE WHEN dt.display_name IS NULL THEN ''
                                 ELSE dt.display_name
                            END + CASE WHEN d.number IS NULL THEN ''
                                       ELSE ' №' + d.number
                                  END + CASE WHEN d.doc_date IS NULL THEN ''
                                             ELSE ' от '
                                                  + CONVERT(NVARCHAR, d.doc_date, 104)
                                        END
                          + CASE WHEN ( d.contract_num IS NOT NULL
                                        OR d.contract_date IS NOT NULL
                                      )
                                      AND ( d.number IS NOT NULL
                                            OR d.doc_date IS NOT NULL
                                          ) THEN ' договора'
                                 ELSE ''
                            END
                          + CASE WHEN d.contract_num IS NULL
                                 THEN ' Без номера'
                                 ELSE ' №' + d.contract_num
                            END
                          + CASE WHEN d.contract_date IS NULL THEN ' Без даты'
                                 ELSE ' от '
                                      + CONVERT(NVARCHAR, d.contract_date, 104)
                            END + ' (ID ' + CONVERT(NVARCHAR, a.id_agreement)
                          + ')' ) AS title ,
                        REPLACE(CONVERT(NVARCHAR, d.amount, 1), ',', ' ') AS amount ,
                        c.NAME AS company ,
                        d.id_contractor
                FROM    agr_agreements a
                        INNER JOIN agr_documents d ON a.id_document = d.id_document
                        INNER JOIN dbo.companies c ON d.id_company = c.id_company
                        INNER JOIN agr_doc_types dt ON d.id_doc_type = dt.id_doc_type
                WHERE   a.id_agreement = @id_agreement
            END

	--=================================
	--Получение списка согласований для процессов
	--=================================	
        IF @action = 'getProcessAgreementsList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                EXEC @active_id_agr_result = ui_agreements @action = 'getActiveProcResultId'

                EXEC @empty_id_agr_result = ui_agreements @action = 'getEmptyProcResultId'

                SELECT  t.id_agreement ,
                        t.id_agr_scheme ,
                        t.id_document ,
                        t.id_agr_state ,
                        t.id_contractor ,
                        t.title ,
                        t.time_limit AS minutes_to_end ,
                        CASE WHEN t.time_limit > 0 THEN 0
                             ELSE 1
                        END AS limit_is_end
                FROM    ( SELECT    a.id_agreement ,
                                    a.id_agr_scheme ,
                                    a.id_document ,
                                    a.id_agr_state ,
                                    d.id_contractor ,
                                    ( ( SELECT  ctr.o2s5xclow3h + ' (ИНН '
                                                + CONVERT(NVARCHAR, ctr.o2s5xclow3t)
                                                + ')' COLLATE Cyrillic_General_CI_AS
                                        FROM    [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_o2s5xclp1y3 ctr
                                        WHERE   ctr.recordid = d.id_contractor
                                      ) + @new_line
                                      + CASE WHEN dt.display_name IS NULL
                                             THEN ''
                                             ELSE dt.display_name
                                        END
                                      + CASE WHEN d.number IS NULL THEN ''
                                             ELSE ' №' + d.number
                                        END
                                      + CASE WHEN d.doc_date IS NULL THEN ''
                                             ELSE ' от '
                                                  + CONVERT(NVARCHAR, d.doc_date, 104)
                                        END
                                      + CASE WHEN ( d.contract_num IS NOT NULL
                                                    OR d.contract_date IS NOT NULL
                                                  )
                                                  AND ( d.number IS NOT NULL
                                                        OR d.doc_date IS NOT NULL
                                                      ) THEN ' договора'
                                             ELSE ''
                                        END
                                      + CASE WHEN d.contract_num IS NULL
                                             THEN ' Без номера'
                                             ELSE ' №' + d.contract_num
                                        END
                                      + CASE WHEN d.contract_date IS NULL
                                             THEN ' Без даты'
                                             ELSE ' от '
                                                  + CONVERT(NVARCHAR, d.contract_date, 104)
                                        END + '(ID '
                                      + CONVERT(NVARCHAR, a.id_agreement)
                                      + ')' + @new_line + 'Менеджер '
                                      + uu.full_name + @new_line + 'Сумма '
                                      + REPLACE(CONVERT(NVARCHAR, d.amount, 1),
                                                ',', ' ') + '   -   '
                                      + ( SELECT    name
                                          FROM      dbo.agr_contract_types ctrtpe
                                          WHERE     ctrtpe.id_contract_type = d.id_contract_type
                                        ) + '   -   '
                                      + ( SELECT    name
                                          FROM      dbo.departments dep
                                          WHERE     dep.id_department = d.id_department
                                        ) ) AS title ,
                                    CASE WHEN LOWER(s.sys_name) IN (
                                              LOWER('PROCESS'), LOWER('NEW') )
                                              AND EXISTS ( SELECT
                                                              1
                                                           FROM
                                                              agr_processes pp
                                                           WHERE
                                                              a.id_agreement = pp.id_agreement
                                                              AND pp.id_agr_result NOT IN (
                                                              @active_id_agr_result,
                                                              @empty_id_agr_result ) )
                                         THEN ( ( SELECT    CONVERT(INT, value)
                                                  FROM      agr_settings ase
                                                  WHERE     ase.enabled = 1
                                                            AND LOWER(ase.sys_name) = LOWER('AGRDURATION')
                                                ) * 60 )
                                              - --так как интересуют только активные согласования, то считаем до текущего времени							
							dbo.get_work_duration('minute',
                                                  ( SELECT  MIN(date_change)
                                                    FROM    agr_processes pp
                                                    WHERE   a.id_agreement = pp.id_agreement
                                                            AND pp.id_agr_result NOT IN (
                                                            @active_id_agr_result,
                                                            @empty_id_agr_result )
                                                  ), GETDATE())
                                         ELSE NULL
                                    END AS time_limit
                          FROM      agr_agreements a
                                    INNER JOIN agr_documents d ON a.id_document = d.id_document
                                    INNER JOIN agr_doc_types dt ON d.id_doc_type = dt.id_doc_type
                                    INNER JOIN agr_states s ON a.id_agr_state = s.id_agr_state
                                    INNER JOIN users uu ON d.id_doc_manager = uu.id_user
                                    INNER JOIN companies c ON d.id_company = c.id_company
                          WHERE     a.enabled = 1
                                    AND a.old_id_agreement IS NULL
                                    --Органичение доступа к филиалу в Москве
                                    AND ( ( @have_moscow_access = 0
                                            AND ( c.sys_name IS NULL
                                                  OR c.sys_name NOT IN (
                                                  'UNITMOSCOW' )
                                                )
                                          )
                                          OR @have_moscow_access = 1
                                        )
                                    AND ( @id_user = @null_value
                                          OR ( @id_user != @null_value
						--and					
                                               )
                                        )
				--Фильтр по ID
                                    AND ( @id_agreement IS NULL
                                          OR ( @id_agreement IS NOT NULL
                                               AND a.id_agreement = @id_agreement
                                             )
                                        )
				----Фильтр по дате согласования
				--AND (
				--@doc_date IS NULL
				--OR (
				--	@doc_date IS not NULL
				--	and 					
				--	)
				--)
				--Фильтр по периоду (начало)
                                    AND ( @date_period_start IS NULL
                                          OR ( @date_period_start IS NOT NULL
                                               AND CONVERT(DATE, d.dattim1) >= CONVERT(DATE, @date_period_start)
                                             )
                                        )
				--Фильтр по периоду (окончание)
                                    AND ( @date_period_end IS NULL
                                          OR ( @date_period_end IS NOT NULL
                                               AND CONVERT(DATE, d.dattim1) <= CONVERT(DATE, @date_period_end)
                                             )
                                        )
				--Фильтр по типу договоров
                                    AND ( @id_doc_type = @select_all_value
                                          OR ( @id_doc_type != @select_all_value
                                               AND d.id_doc_type = @id_doc_type
                                             )
                                        )
				--Фильтр по номеру договора
                                    AND ( @contract_num IS NULL
                                          OR ( @contract_num IS NOT NULL
                                               AND d.contract_num LIKE @contract_num
                                               + '%'
                                             )
                                        )
				--Фильтр по Без номера договора
                                    AND ( @no_contract_number IS NULL
                                          OR ( @no_contract_number IS NOT NULL
                                               AND d.contract_num IS NULL
                                             )
                                        )
				--Фильтр по штрих-коду
                                    AND ( @code_num IS NULL
                                          OR ( @code_num IS NOT NULL
                                               AND d.code_num = @code_num
                                             )
                                        )
				--Фильтр по дате договора
                                    AND ( @contract_date IS NULL
                                          OR ( @contract_date IS NOT NULL
                                               AND CONVERT(DATE, d.contract_date) = CONVERT(DATE, @contract_date)
                                             )
                                        )
				--Фильтр по Без даты договора
                                    AND ( @no_contract_date IS NULL
                                          OR ( @no_contract_date IS NOT NULL
                                               AND d.contract_date IS NULL
                                             )
                                        )
				--Фильтр по менеджеру по договору
                                    AND ( @id_agr_manager = @select_all_value
                                          OR ( @id_agr_manager != @select_all_value
                                               AND d.id_doc_manager = @id_agr_manager
                                             )
                                        )
				--Фильтр по офис-менеджеру
                                    AND ( @id_doc_manager = @select_all_value
                                          OR ( @id_doc_manager != @select_all_value
                                               AND a.id_agr_manager = @id_doc_manager
                                             )
                                        )
				--Фильтр по статусу согласования
				--AND (
				--	@id_agr_state = @select_all_value
				--	OR (
				--		@id_agr_state != @select_all_value
				--		AND a.id_agr_state = @id_agr_state
				--		)
				--	)
                                    AND ( @id_agr_state_arr IS NULL
                                          OR ( @id_agr_state_arr IS NOT NULL
                                               AND a.id_agr_state IN (
                                               SELECT   value
                                               FROM     dbo.Split(@id_agr_state_arr,
                                                              ',') )
                                             )
                                        )
				--Фильтр по контрагенту
                                    AND ( @id_contractor = @select_all_value
                                          OR ( @id_contractor != @select_all_value
                                               AND d.id_contractor = @id_contractor
                                             )
                                        )
				--Фильтр по организации (юр. лицо Юнит)
                                    AND ( @id_company = @select_all_value
                                          OR ( @id_company != @select_all_value
                                               AND d.id_company = @id_company
                                             )
                                        )
                        ) AS t
                ORDER BY t.id_agreement DESC
            END
			--=================================
			--Получение погласования по id
			--=================================
        ELSE
            IF @action = 'getAgreement'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    SELECT  id_agreement ,
                            id_agr_scheme ,
                            id_document ,
                            id_agr_state ,
                            id_agr_manager ,
                            u.display_name AS agr_manager_name ,
                            a.enabled ,
                            id_creator,
                            a.is_electron
                    FROM    agr_agreements a
                            INNER JOIN users u ON a.id_agr_manager = u.id_user
                    WHERE   a.id_agreement = @id_agreement
                END
				--=================================
				--Получение данных для листа погласования
				--=================================
            ELSE
                IF @action = 'getAgreementListData'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END

                        SELECT  a.id_agreement AS id ,
                                dt.NAME AS doc_type ,
                                uu.display_name AS doc_manager_name ,
                                u.display_name AS agr_manager_name ,
                                uu.phone AS doc_manager_phone ,
                                u.phone AS agr_manager_phone ,
                                d.id_contractor ,
                                c.NAME AS company_name ,
                                c.inn AS company_inn ,
                                ISNULL(CONVERT(NVARCHAR, d.contract_date, 104),
                                       'Без даты') AS contract_date ,
                                ISNULL(d.contract_num, 'Без номера') AS contract_num ,
                                d.number AS doc_num ,
                                CONVERT(NVARCHAR, d.doc_date, 104) AS doc_date ,
                                d.id_doc_type ,
                                ct.NAME AS contract_type ,
                                CONVERT(NVARCHAR, d.amount, 1) ,
                                REPLACE(CONVERT(NVARCHAR, d.amount, 1), ',',
                                        ' ') AS contract_amount
                        FROM    agr_agreements a
                                INNER JOIN users u ON a.id_agr_manager = u.id_user
                                INNER JOIN agr_documents d ON a.id_document = d.id_document
                                INNER JOIN users uu ON d.id_doc_manager = uu.id_user
                                INNER JOIN agr_doc_types dt ON d.id_doc_type = dt.id_doc_type
                                INNER JOIN companies c ON d.id_company = c.id_company
                                INNER JOIN agr_contract_types ct ON d.id_contract_type = ct.id_contract_type
                        WHERE   a.id_agreement = @id_agreement
                    END
					--=================================
					--Сохранение согласования (документа)
					--=================================	
                ELSE
                    IF @action = 'saveAgreement'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END

                            IF @id_agreement > 0
                                BEGIN
                                    SELECT  @id_document = id_document
                                    FROM    agr_agreements a
                                    WHERE   a.id_agreement = @id_agreement

						--В данном случае у согласования ничего не обновляется, только документ
                                    EXEC sk_agreements @action = 'updDocument',
                                        @id_document = @id_document,
                                        @id_doc_type = @id_doc_type,
                                        @number = @number,
                                        @reg_number = @reg_number,
                                        @doc_date = @doc_date,
                                        @id_department = @id_department,
                                        @id_contract_type = @id_contract_type,
                                        @id_company = @id_company,
                                        @id_contractor = @id_contractor,
                                        @amount = @amount,
                                        @id_doc_manager = @id_doc_manager,
                                        @id_creator = @id_creator,
                                        @is_electron = @is_electron

						--Так как требуется вернуть id_agr_process, а его по сути не надо возвращать, то возвращаем "бред"
                                    SELECT  @id_agr_process = -1
                                END
                            ELSE
                                BEGIN
						--Вызываем процедуру создания согласования
                                    EXEC @id_agr_process = ui_agreements @action = 'addAgreement',
                                        @id_doc_type = @id_doc_type,
                                        @number = @number,
                                        @reg_number = @reg_number,
                                        @doc_date = @doc_date,
                                        @contract_num = @contract_num,
                                        @contract_date = @contract_date,
                                        @id_department = @id_department,
                                        @id_contract_type = @id_contract_type,
                                        @id_company = @id_company,
                                        @id_contractor = @id_contractor,
                                        @amount = @amount,
                                        @id_doc_manager = @id_doc_manager,
                                        @id_creator = @id_creator,
                                        @id_agr_manager = @id_agr_manager,
                                        @is_electron = @is_electron
                                END

                            SELECT  @id_agr_process AS id_agr_process
                        END
						--=================================
						--Добавление согласования
						--=================================		
                    ELSE
                        IF @action = 'addAgreement'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END

						--Подбираем подходящую схему согласования
                                SET @id_agr_scheme = NULL

                                SELECT  @id_agr_scheme = id_agr_scheme
                                FROM    agr_schemes s
                                WHERE   s.enabled = 1
                                        AND s.id_contract_type = @id_contract_type
                                        AND s.id_department = @id_department
                                        AND @amount BETWEEN s.amount1 AND s.amount2

                                IF @id_agr_scheme IS NULL
                                    BEGIN
                                        SET @error_text = 'Не удалось подобрать подходящую схему согласования.'

                                        RAISERROR (
									@error_text
									,16
									,1
									)

                                        RETURN
                                    END

						--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
						--Выбираем статус NEW
                                SELECT  @id_agr_state = id_agr_state
                                FROM    agr_states s
                                WHERE   LOWER(s.sys_name) = LOWER('NEW')

						--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                                BEGIN TRY
                                    BEGIN TRANSACTION TxnAddAgreement

							--сохраняем договор
                                    EXEC @id_document = sk_agreements @action = 'insDocument',
                                        @id_doc_type = @id_doc_type,
                                        @number = @number,
                                        @reg_number = @reg_number,
                                        @doc_date = @doc_date,
                                        @contract_num = @contract_num,
                                        @contract_date = @contract_date,
                                        @id_department = @id_department,
                                        @id_contract_type = @id_contract_type,
                                        @id_company = @id_company,
                                        @id_contractor = @id_contractor,
                                        @amount = @amount,
                                        @id_doc_manager = @id_doc_manager,
                                        @id_creator = @id_creator,
                                        @add_docs = @add_docs

							--Сохраняем согласование
                                    EXEC @id_agreement = sk_agreements @action = 'insAgreement',
                                        @id_agr_scheme = @id_agr_scheme,
                                        @id_agr_state = @id_agr_state,
                                        @id_agr_manager = @id_agr_manager,
                                        @id_document = @id_document,
                                        @id_creator = @id_creator,
                                        @is_electron = @is_electron

							--Создаем процессы согласования
                                    EXEC ui_agreements @action = 'addAgrProcesses',
                                        @id_agr_scheme = @id_agr_scheme,
                                        @id_agreement = @id_agreement

							--активируем певый процесс
                                    EXEC @id_agr_process = ui_agreements @action = 'activateNextAgrProcess',
                                        @id_agreement = @id_agreement

                                    COMMIT TRANSACTION TxnAddAgreement

                                    RETURN @id_agr_process
                                END TRY

                                BEGIN CATCH
                                    IF @@TRANCOUNT > 0
                                        ROLLBACK TRAN TxnAddAgreement

                                    SELECT  @error_text = ERROR_MESSAGE()
                                            + ' Изменения не были сохранены!'

                                    RAISERROR (
									@error_text
									,16
									,1
									)
                                END CATCH
                            END
							--=================================
							--Закрытие согласования
							--=================================
                        ELSE
                            IF @action = 'closeAgreement'
                                BEGIN
                                    IF @sp_test IS NOT NULL
                                        BEGIN
                                            RETURN
                                        END

                                    EXEC sk_agreements @action = 'closeAgreementById',
                                        @id_agreement = @id_agreement,
                                        @id_creator = @id_creator
                                END
								--=================================
								--Документ отправлен кленту
								--=================================
                            ELSE
                                IF @action = 'setAgreementDocSent2Client'
                                    BEGIN
                                        IF @sp_test IS NOT NULL
                                            BEGIN
                                                RETURN
                                            END

								--Статус "Отправлено клиенту"
                                        SELECT  @id_agr_state = id_agr_state
                                        FROM    agr_states st
                                        WHERE   st.enabled = 1
                                                AND LOWER(st.sys_name) = LOWER('SENT')

                                        EXEC sk_agreements @action = 'updAgreement',
                                            @id_agreement = @id_agreement,
                                            @id_creator = @id_creator,
                                            @id_agr_state = @id_agr_state
                                    END
									--=================================
									--Документ поступил в бухгалтерию
									--=================================
                                ELSE
                                    IF @action = 'setAgreementDocIsComeback'
                                        BEGIN
                                            IF @sp_test IS NOT NULL
                                                BEGIN
                                                    RETURN
                                                END

									--Статус "В бухгалтерии"
                                            SELECT  @id_agr_state = id_agr_state
                                            FROM    agr_states st
                                            WHERE   st.enabled = 1
                                                    AND LOWER(st.sys_name) = LOWER('ARCHIVE')

                                            EXEC sk_agreements @action = 'updAgreement',
                                                @id_agreement = @id_agreement,
                                                @id_creator = @id_creator,
                                                @id_agr_state = @id_agr_state
                                        END
										--=================================
										--Статус согласования на удаление
										--=================================
                                    ELSE
                                        IF @action = 'setAgreementOnDelete'
                                            BEGIN
                                                IF @sp_test IS NOT NULL
                                                    BEGIN
                                                        RETURN
                                                    END

										--Статус "На удаление"
                                                SELECT  @id_agr_state = id_agr_state
                                                FROM    agr_states st
                                                WHERE   st.enabled = 1
                                                        AND LOWER(st.sys_name) = LOWER('TODELETE')

                                                EXEC sk_agreements @action = 'updAgreement',
                                                    @id_agreement = @id_agreement,
                                                    @id_creator = @id_creator,
                                                    @id_agr_state = @id_agr_state
                                            END
											--=================================
											--Восстанавливаем последний статус согласования до пометки на удаление
											--=================================
                                        ELSE
                                            IF @action = 'recoverAgreement'
                                                BEGIN
                                                    IF @sp_test IS NOT NULL
                                                        BEGIN
                                                            RETURN
                                                        END

											--Статус "На удаление"
                                                    SELECT  @var_int = id_agr_state
                                                    FROM    agr_states st
                                                    WHERE   st.enabled = 1
                                                            AND LOWER(st.sys_name) = LOWER('TODELETE')

											--Находим последний статус согласования кроме помеченных на удаление
                                                    SELECT TOP 1
                                                            @id_agr_state = id_agr_state
                                                    FROM    agr_agreements a
                                                    WHERE   a.enabled = 1
                                                            AND a.id_agr_state != @var_int
                                                    ORDER BY a.dattim2 DESC

                                                    EXEC sk_agreements @action = 'updAgreement',
                                                        @id_agreement = @id_agreement,
                                                        @id_creator = @id_creator,
                                                        @id_agr_state = @id_agr_state
                                                END

	--=================================
	--Получение списка процессов для согласования
	--=================================	
        IF @action = 'getAgrProcessList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                EXEC @id_agr_result = ui_agreements @action = 'getActiveProcResultId'

                EXEC @active_id_agr_result = ui_agreements @action = 'getActiveProcResultId'

                SELECT  p.id_agr_process ,
                        m.id_agr_matcher
			--,m.agr_type
			--,m.doc_type
                        ,
                        u.position AS position ,
                        u.display_name AS matcher_name ,
                        ( SELECT    uu.display_name
                          FROM      users uu
                          WHERE     p.id_updater = uu.id_user
                        ) AS real_matcher ,
                        r.NAME AS result ,
                        p.comment ,
                        ROW_NUMBER() OVER ( ORDER BY p.order_num ) AS row_num ,
                        p.order_num ,
                        CASE WHEN p.id_agr_result = @id_agr_result THEN NULL
                             ELSE p.date_change
                        END AS date_change ,
                        CASE WHEN EXISTS ( SELECT   1
                                           FROM     agr_manager2agr_processes m2p
                                           WHERE    m2p.id_agr_process = p.id_agr_process
                                                    AND m2p.dattim2 = CONVERT(DATETIME, '3.3.3333') )
                             THEN 1
                             ELSE 0
                        END AS cur_location ,
                        CASE WHEN @id_user = a.id_agr_manager
                                  AND r.id_agr_result = @active_id_agr_result
                             THEN 1
                             ELSE 0
                        END AS cur_agr_manager ,
                        p.id_agreement ,
                        CASE WHEN
					--елси это менеджер договора или офис- менеджер согласования 
                                  ( @id_user = a.id_agr_manager
                                    OR @id_user = d.id_doc_manager
                                  )
					--данный процесс последний отклоненный у этого согласователя  в этом согласовании
                                  AND ( p.id_agr_process = ( SELECT TOP 1
                                                              pp.id_agr_process
                                                             FROM
                                                              agr_processes pp
                                                             WHERE
                                                              pp.id_agr_matcher = p.id_agr_matcher
                                                              AND pp.id_agreement = p.id_agreement
                                                              AND pp.id_agr_result = ( SELECT
                                                              id_agr_result
                                                              FROM
                                                              agr_results rr
                                                              INNER JOIN agr_result_type tt ON rr.id_agr_result_type = tt.id_agr_result_type
                                                              WHERE
                                                              LOWER(tt.NAME) = LOWER('NO')
                                                              )
                                                             ORDER BY pp.date_change DESC
                                                           ) )
					-- нет положительного результата
                                  AND NOT EXISTS ( SELECT   1
                                                   FROM     agr_processes pp
                                                   WHERE    pp.id_agr_matcher = p.id_agr_matcher
                                                            AND pp.id_agreement = p.id_agreement
                                                            AND pp.id_agr_result = ( SELECT
                                                              id_agr_result
                                                              FROM
                                                              agr_results rr
                                                              INNER JOIN agr_result_type tt ON rr.id_agr_result_type = tt.id_agr_result_type
                                                              WHERE
                                                              LOWER(tt.NAME) = LOWER('YES')
                                                              ) )
					--нет ответа на этот комментарий (процесс)
                                  AND NOT EXISTS ( SELECT   1
                                                   FROM     agr_proc_answers pa
                                                   WHERE    p.id_agr_process = pa.id_agr_process )
                             THEN 1
                             ELSE 0
                        END AS answer_btn_display ,
                        ( SELECT TOP 1
                                    pa.TEXT
                          FROM      agr_proc_answers pa
                          WHERE     pa.id_agr_process = p.id_agr_process
                          ORDER BY  pa.dattim1 DESC
                        ) AS answer ,
                        CASE WHEN r.id_agr_result = @active_id_agr_result
                             THEN CONVERT(DATETIME, '3.3.3333')
                             ELSE date_change
                        END AS date4order
                FROM    agr_processes p
                        INNER JOIN agr_results r ON p.id_agr_result = r.id_agr_result
                        INNER JOIN agr_matchers m ON p.id_agr_matcher = m.id_agr_matcher
                        INNER JOIN users u ON m.id_user = u.id_user
                        INNER JOIN agr_agreements a ON a.id_agreement = p.id_agreement
                        INNER JOIN agr_documents d ON a.id_document = d.id_document
		--inner join users uu on p.id_updater = uu.id_user
                WHERE   p.id_agreement = @id_agreement
                        AND p.enabled = 1
                ORDER BY p.order_num
			--,p.id_agr_result
			--,p.id_agr_matcher
                        ,
                        date4order
            END
			--=================================
			--Получение списка процессов для согласования
			--=================================	
        ELSE
            IF @action = 'getAgrProcessList4Match'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    EXEC @active_id_agr_result = ui_agreements @action = 'getActiveProcResultId'

                    EXEC @id_agr_result = ui_agreements @action = 'getActiveProcResultId'

                    IF @id_agreement IS NULL
                        BEGIN
                            SELECT  @id_agreement = id_agreement
                            FROM    agr_processes
                            WHERE   id_agr_process = @id_agr_process
                        END

                    SELECT  p.id_agr_process ,
                            u.display_name AS matcher_name ,
                            r.NAME AS result ,
                            p.comment
				--,convert(NVARCHAR, p.date_change, 104) AS date_change
                            ,
                            CASE WHEN p.id_agr_result = @id_agr_result
                                 THEN NULL
                                 ELSE p.date_change
                            END AS date_change ,
                            ROW_NUMBER() OVER ( ORDER BY p.order_num ) AS order_num ,
                            CASE WHEN r.id_agr_result = @active_id_agr_result
                                 THEN CONVERT(DATETIME, '3.3.3333')
                                 ELSE date_change
                            END AS date4order ,
                            ( SELECT TOP 1
                                        pa.TEXT
                              FROM      agr_proc_answers pa
                              WHERE     p.id_agr_process = pa.id_agr_process
                              ORDER BY  pa.id_proc_answer
                            ) AS manager_answer
                    FROM    agr_processes p
                            INNER JOIN agr_results r ON p.id_agr_result = r.id_agr_result
                            INNER JOIN agr_matchers m ON p.id_agr_matcher = m.id_agr_matcher
                            INNER JOIN users u ON m.id_user = u.id_user
                    WHERE   p.id_agreement = @id_agreement
                            AND p.enabled = 1
                    ORDER BY p.order_num
				--,p.id_agr_result
				--,p.id_agr_matcher
                            ,
                            date4order
                END
				--=================================
				--Добавление процессов для согласования
				--=================================	
            ELSE
                IF @action = 'addAgrProcesses'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END

                        IF NOT EXISTS ( SELECT  m2s.id_agr_matcher ,
                                                m2s.order_num
                                        FROM    agr_matchers2schemes m2s
                                        WHERE   m2s.id_agr_scheme = @id_agr_scheme
                                                AND m2s.enabled = 1 )
                            BEGIN
                                SET @error_text = 'Для данной схемы согласования не установлены согласователи. Обратитесь к администратору программы.'

                                RAISERROR (
							@error_text
							,16
							,1
							)

                                RETURN
                            END

				--Получаем список согласователей для схемы
                        DECLARE curs CURSOR
                        FOR
                            SELECT  m2s.id_agr_matcher ,
                                    m2s.order_num
                            FROM    agr_matchers2schemes m2s
                            WHERE   m2s.id_agr_scheme = @id_agr_scheme
                                    AND m2s.enabled = 1
                            ORDER BY m2s.order_num

                        EXEC @id_agr_result = ui_agreements @action = 'getEmptyProcResultId'

                        OPEN curs

                        FETCH NEXT
				FROM curs
				INTO @id_agr_matcher, @order_num

				--добавляем процессы согласования
                        WHILE @@FETCH_STATUS = 0
                            BEGIN
                                EXEC sk_agreements @action = 'insAgrProcess',
                                    @id_agreement = @id_agreement,
                                    @id_agr_matcher = @id_agr_matcher,
                                    @order_num = @order_num,
                                    @id_agr_result = @id_agr_result

                                FETCH NEXT
					FROM curs
					INTO @id_agr_matcher, @order_num
                            END

                        CLOSE curs

                        DEALLOCATE curs

				--Выбираем статус PROCESS
                        SELECT  @id_agr_state = id_agr_state
                        FROM    agr_states s
                        WHERE   LOWER(s.sys_name) = LOWER('PROCESS')

				--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                        EXEC sk_agreements @action = 'updAgreement',
                            @id_agreement = @id_agreement,
                            @id_agr_state = @id_agr_state
                    END
					--=================================
					--Получить последный запущенный процесс для согласования
					--=================================	
                ELSE
                    IF @action = 'getProcessMessageData'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END
					
                            SET @is_new_agreement = NULL
                            SET @send_mail2matcher = NULL

                            EXEC @active_id_agr_result = ui_agreements @action = 'getActiveProcResultId'

					--Формируем текст письма
                            IF @id_agr_process IS NOT NULL
                                BEGIN
                                    SELECT  @id_agreement = id_agreement
                                    FROM    agr_processes
                                    WHERE   id_agr_process = @id_agr_process

                                    EXEC @id_agr_result = ui_agreements @action = 'getEmptyProcResultId'

						--Если результат процесса не "пустой"
                                    IF NOT EXISTS ( SELECT  1
                                                    FROM    agr_processes
                                                    WHERE   id_agr_process = @id_agr_process
                                                            AND id_agr_result = @id_agr_result )
                                        BEGIN
							--Если процесс только активирован и это не электронное согласование
                                            IF EXISTS ( SELECT
                                                              1
                                                        FROM  agr_processes
                                                        WHERE id_agr_process = @id_agr_process
                                                              AND id_agr_result = @active_id_agr_result )
                                                              
                                                BEGIN
                                                    SELECT  @var_str = COALESCE(@var_str
                                                              + @new_line, '')
                                                            + ISNULL(u.full_name,
                                                              'ПУСТО')
                                                    FROM    agr_processes p
                                                            INNER JOIN agr_matchers m ON p.id_agr_matcher = m.id_agr_matcher
                                                            INNER JOIN users u ON m.id_user = u.id_user
                                                    WHERE   p.enabled = 1
                                                            AND p.id_agreement = ( SELECT
                                                              id_agreement
                                                              FROM
                                                              dbo.agr_processes
                                                              WHERE
                                                              id_agr_process = @id_agr_process
                                                              )
                                                            AND p.order_num = ( SELECT
                                                              order_num
                                                              FROM
                                                              dbo.agr_processes
                                                              WHERE
                                                              id_agr_process = @id_agr_process
                                                              )
                                                            AND p.id_agr_result = @active_id_agr_result

                                                    SELECT  @mail_text = @new_line
                                                            + 'Необходимо предоставить лист согласования и данный документ '
                                                            + CASE
                                                              WHEN LEN(@var_str) > 0
                                                              AND CHARINDEX(@new_line,
                                                              @var_str) > 0
                                                              THEN 'следующим согласующим лицам: '
                                                              + @new_line
                                                              + @new_line
                                                              ELSE 'согласующему лицу '
                                                              END + @var_str
                                                            + CASE
                                                              WHEN LEN(@var_str) > 0
                                                              AND CHARINDEX(@new_line,
                                                              @var_str) > 0
                                                              THEN @new_line
                                                              + @new_line
                                                              + ' в произвольном порядке'
                                                              ELSE ''
                                                              END
                                                END
									--Если процесс с результатом согласования
                                            ELSE
                                                BEGIN
                                                    SELECT  @mail_text = ( @new_line
                                                              + 'Получен результат - '
                                                              + ISNULL(r.NAME,
                                                              'ПУСТО')
                                                              + ' для данного документа от согласующего лица '
                                                              + ISNULL(uu.full_name,
                                                              'ПУСТО')
                                                              + @new_line
                                                              + @new_line
                                                              + 'комментарий: '
                                                              + ISNULL(p.comment,
                                                              'ПУСТО') ) ,
                                                            @matcher_mail_text = 'От вашего имени совершено действие в программе "'
                                                            + @prog_name + '"'
                                                            + @new_line
                                                            + @new_line
                                                            + @mail_text ,
                                                            @matcher_mail = u.mail
                                                    FROM    agr_processes p
                                                            INNER JOIN agr_results r ON p.id_agr_result = r.id_agr_result
                                                            INNER JOIN agr_matchers m ON p.id_agr_matcher = m.id_agr_matcher
                                                            INNER JOIN users u ON m.id_user = u.id_user
                                                            INNER JOIN users uu ON p.id_updater = uu.id_user
                                                    WHERE   p.id_agr_process = @id_agr_process

								--если согласовал не тот кто является согласующим лицом (заместитель к примеру)
								--и нет временного отключения
                                                    IF NOT EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              agr_processes p
                                                              INNER JOIN agr_matchers m ON p.id_agr_matcher = m.id_agr_matcher
                                                              WHERE
                                                              p.id_agr_process = @id_agr_process
                                                              AND ( m.id_user = p.id_updater
                                                              OR ( m.id_user != p.id_updater
                                                              AND EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              agr_temp_nomails tnm
                                                              WHERE
                                                              tnm.id_user = ( SELECT
                                                              id_user
                                                              FROM
                                                              agr_matchers am
                                                              WHERE
                                                              am.id_agr_matcher = m.id_agr_matcher
                                                              AND am.old_id_matcher IS NULL
                                                              )
                                                              AND GETDATE() BETWEEN tnm.dattim1 AND tnm.dattim2 )
                                                              )
                                                              ) )
                                                        BEGIN
                                                            SET @send_mail2matcher = 1
                                                        END
                                                END
                                        END
                                END
                            ELSE
                                BEGIN
                                    SET @mail_text = 'Согласование по данному документу завершено'
                                END

                            IF @id_new_agr_process = -999
                                BEGIN
                                    SET @outputString = @mail_text

                                    RETURN
                                END
                            ELSE
                                IF @id_new_agr_process > 0
                                    OR @id_new_agr_process IS NULL
                                    BEGIN
							--Проверяем не осталось ли активных процессов с таким же номером
                                        SELECT TOP 1
                                                @id_new_agr_process = id_agr_process
                                        FROM    dbo.agr_processes p
                                        WHERE   p.enabled = 1
                                                AND p.id_agr_result = @active_id_agr_result
                                                AND order_num = ( SELECT
                                                              order_num
                                                              FROM
                                                              dbo.agr_processes
                                                              WHERE
                                                              id_agr_process = @id_agr_process
                                                              )
                                                AND p.id_agreement = ( SELECT
                                                              id_agreement
                                                              FROM
                                                              dbo.agr_processes
                                                              WHERE
                                                              id_agr_process = @id_agr_process
                                                              )

                                        EXEC ui_agreements @action = 'getProcessMessageData',
                                            @id_old_agr_process = @id_agr_process,
                                            @id_agr_process = @id_new_agr_process,
                                            @id_new_agr_process = -999,
                                            @outputString = @append_mail_text OUTPUT
								--SET @mail_text = @mail_text + @new_line + ISNULL(@append_mail_text, '')
                                    END
						
												
                            IF @id_new_agr_process = -1
                                BEGIN
                                    SET @is_new_agreement = 1
                                    SET @doc_manager_mail_text = 'Начато согласование по данному документу.'						
                                END
                            ELSE
                                BEGIN
                                    SET @doc_manager_mail_text = @mail_text								
                                END

                            SELECT  d.id_contractor ,
                                    ( SELECT    @new_line
                                    ) AS new_line ,
                                    ( 'Согласование по документу '
                                      + CASE WHEN dt.display_name IS NULL
                                             THEN ''
                                             ELSE dt.display_name
                                        END
                                      + CASE WHEN d.number IS NULL THEN ''
                                             ELSE ' №' + d.number
                                        END
                                      + CASE WHEN d.doc_date IS NULL THEN ''
                                             ELSE ' от '
                                                  + CONVERT(NVARCHAR, d.doc_date, 104)
                                        END
                                      + CASE WHEN ( d.contract_num IS NOT NULL
                                                    OR d.contract_date IS NOT NULL
                                                  )
                                                  AND ( d.number IS NOT NULL
                                                        OR d.doc_date IS NOT NULL
                                                      ) THEN ' договора'
                                             ELSE ''
                                        END
                                      + CASE WHEN d.contract_num IS NULL
                                             THEN ' Без номера'
                                             ELSE ' №' + d.contract_num
                                        END
                                      + CASE WHEN d.contract_date IS NULL
                                             THEN ' Без даты'
                                             ELSE ' от '
                                                  + CONVERT(NVARCHAR, d.contract_date, 104)
                                        END + ' (ID '
                                      + CONVERT(NVARCHAR, a.id_agreement)
                                      + ')' ) AS mail_subject ,
                                    u.mail AS agr_manager_mail ,
                                    @mail_text + @new_line + @new_line
                                    + ISNULL(@append_mail_text, '') AS agr_manager_mail_text ,
                                    CASE WHEN a.id_agr_state = ( SELECT
                                                              id_agr_state
                                                              FROM
                                                              dbo.agr_states st
                                                              WHERE
                                                              st.enabled = 1
                                                              AND LOWER(st.sys_name) = LOWER('MATCHED')
                                                              )
                                              OR EXISTS ( SELECT
                                                              1
                                                          FROM
                                                              agr_processes
                                                          WHERE
                                                              id_agr_process = @id_agr_process
                                                              AND id_agr_result = ( SELECT
                                                              id_agr_result
                                                              FROM
                                                              agr_results rr
                                                              WHERE
                                                              rr.enabled = 1
                                                              AND rr.id_agr_result_type = ( SELECT
                                                              id_agr_result_type
                                                              FROM
                                                              agr_result_type rtt
                                                              WHERE
                                                              LOWER(rtt.NAME) = LOWER('NO')
                                                              )
                                                              ) )
                                              OR @is_new_agreement = 1
                                         THEN uu.mail
                                         ELSE NULL
                                    END AS doc_manager_mail ,
                                    CASE WHEN a.id_agr_state = ( SELECT
                                                              id_agr_state
                                                              FROM
                                                              dbo.agr_states st
                                                              WHERE
                                                              st.enabled = 1
                                                              AND LOWER(st.sys_name) = LOWER('MATCHED')
                                                              ) THEN
									--если конец согласования или отклонено
                                              ISNULL(@append_mail_text, '')
                                         ELSE CASE WHEN EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              agr_processes
                                                              WHERE
                                                              id_agr_process = @id_agr_process
                                                              AND id_agr_result = ( SELECT
                                                              id_agr_result
                                                              FROM
                                                              agr_results rr
                                                              WHERE
                                                              rr.enabled = 1
                                                              AND rr.id_agr_result_type = ( SELECT
                                                              id_agr_result_type
                                                              FROM
                                                              agr_result_type rtt
                                                              WHERE
                                                              LOWER(rtt.NAME) = LOWER('NO')
                                                              )
                                                              ) ) THEN
											--Если отрицательный результат
                                                        @doc_manager_mail_text
                                                   ELSE CASE WHEN @is_new_agreement = 1
                                                             THEN 
											--если новое согласование
                                                              @doc_manager_mail_text
                                                             ELSE NULL
                                                        END
                                              END
                                    END AS doc_manager_mail_text ,
                                    CASE WHEN @send_mail2matcher = 1
                                         THEN @matcher_mail
                                         ELSE NULL
                                    END AS matcher_mail ,
                                    CASE WHEN @send_mail2matcher = 1
                                         THEN @matcher_mail_text
                                         ELSE NULL
                                    END AS matcher_mail_text ,
                                    REPLACE(CONVERT(NVARCHAR, d.amount, 1),
                                            ',', ' ') AS amount ,
                                    CASE WHEN a.id_agr_manager != a.id_creator
                                         THEN ( SELECT  mail
                                                FROM    users uuu
                                                WHERE   a.id_creator = uuu.id_user
                                              )
                                         ELSE NULL
                                    END AS creator_mail
                            FROM    agr_agreements a
                                    INNER JOIN agr_documents d ON a.id_document = d.id_document
                                    INNER JOIN agr_doc_types dt ON d.id_doc_type = dt.id_doc_type
                                    INNER JOIN users u ON a.id_agr_manager = u.id_user
                                    INNER JOIN users uu ON d.id_doc_manager = uu.id_user
                            WHERE   a.id_agreement = @id_agreement
                        END
						--=================================
						--Активировать процес согласования
						--=================================	
                    ELSE
                        IF @action = 'activateNextAgrProcess'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END
						
                                SET @id_agr_process = NULL
                                SET @order_num = NULL                                

                                EXEC @active_id_agr_result = ui_agreements @action = 'getActiveProcResultId'

                                EXEC @empty_id_agr_result = ui_agreements @action = 'getEmptyProcResultId'

						--Выбираем максимальный порядковый номер активированных процессов
                                SELECT DISTINCT TOP 1
                                        @order_num = order_num
                                FROM    dbo.agr_processes p
                                WHERE   p.id_agreement = @id_agreement
                                        AND p.enabled = 1
                                        AND p.id_agr_result = @active_id_agr_result
                                ORDER BY p.order_num DESC

						--Выбираем минимальный порядковый номер неактивированных процессов
						--Если нет текущих пустых процессов
                                IF @order_num IS NULL
                                    AND NOT EXISTS ( SELECT 1
                                                     FROM   dbo.agr_processes p
                                                     WHERE  p.id_agreement = @id_agreement
                                                            AND p.id_agr_result = @empty_id_agr_result
                                                            AND p.enabled = 1
                                                            AND p.order_num = @order_num )
                                    BEGIN
							--Выбираем следующий порядковый номер
                                        SELECT DISTINCT TOP 1
                                                @order_num = order_num
                                        FROM    dbo.agr_processes p
                                        WHERE   p.id_agreement = @id_agreement
                                                AND p.enabled = 1
                                                AND p.id_agr_result = @empty_id_agr_result
                                        ORDER BY p.order_num
                                    END

						--Проверяем есть ли пустые процессы для данного порядкового номера
                                IF EXISTS ( SELECT  1
                                            FROM    dbo.agr_processes p
                                            WHERE   p.id_agreement = @id_agreement
									--пустые результаты
                                                    AND p.id_agr_result = @empty_id_agr_result
                                                    AND p.enabled = 1
                                                    AND p.order_num = @order_num )
                                    BEGIN
							
							--Активируем все пустые процессы для выбранного порядкового номера							
                                        DECLARE curs CURSOR
                                        FOR
                                            SELECT  p.id_agr_process ,
                                                    p.order_num
                                            FROM    dbo.agr_processes p
                                            WHERE   p.id_agreement = @id_agreement
								--пустые результаты
                                                    AND p.id_agr_result = @empty_id_agr_result
                                                    AND p.enabled = 1
                                                    AND p.order_num = @order_num

                                        OPEN curs

                                        FETCH NEXT
							FROM curs
							INTO @id_agr_process, @order_num
							
							--Смотрим необходимо ли отправлять уведомление согласующим лицам на данном этапе
														
                                        IF EXISTS ( SELECT  1
                                                    FROM    agr_agreements a
                                                            INNER JOIN agr_schemes s ON a.id_agr_scheme = s.id_agr_scheme
                                                    WHERE   a.id_agreement = @id_agreement
                                                            --если установлена функция напоминания для согл. лиц
                                                            AND (s.matchers_notice = 1 OR a.is_electron = 1) )
                                            BEGIN
                                                SET @have_notice = 1	
								--Подготавливаем текст уведомления для согласующих лиц
                                                SET @link = @prog_root_link
                                                    + '/Default.aspx?agr2id='
                                                    + ISNULL(CONVERT(NVARCHAR, @id_agreement),
                                                             '')
                                                SET @mail_text = 'Добрый день.'
                                                    + @new_line
                                                    + 'Необходимо Ваше согласование документа.'
                                                    + @new_line + '<a href="'
                                                    + @link
                                                    + '">Ссылка на согласование документа ID '
                                                    + ISNULL(CONVERT(NVARCHAR, @id_agreement),
                                                             '') + '</a>'
									
                                                SELECT  @mail_subject = ( 'Согласование документа '
                                                              + CASE
                                                              WHEN dt.display_name IS NULL
                                                              THEN ''
                                                              ELSE dt.display_name
                                                              END
                                                              + CASE
                                                              WHEN d.number IS NULL
                                                              THEN ''
                                                              ELSE ' №'
                                                              + d.number
                                                              END
                                                              + CASE
                                                              WHEN d.doc_date IS NULL
                                                              THEN ''
                                                              ELSE ' от '
                                                              + CONVERT(NVARCHAR, d.doc_date, 104)
                                                              END
                                                              + CASE
                                                              WHEN ( d.contract_num IS NOT NULL
                                                              OR d.contract_date IS NOT NULL
                                                              )
                                                              AND ( d.number IS NOT NULL
                                                              OR d.doc_date IS NOT NULL
                                                              )
                                                              THEN ' договора'
                                                              ELSE ''
                                                              END
                                                              + CASE
                                                              WHEN d.contract_num IS NULL
                                                              THEN ' Без номера'
                                                              ELSE ' №'
                                                              + d.contract_num
                                                              END
                                                              + CASE
                                                              WHEN d.contract_date IS NULL
                                                              THEN ' Без даты'
                                                              ELSE ' от '
                                                              + CONVERT(NVARCHAR, d.contract_date, 104)
                                                              END + ' (ID '
                                                              + CONVERT(NVARCHAR, a.id_agreement)
                                                              + ')' ) ,
                                                        @mail_text = @mail_text
                                                        + @new_line
                                                        + '<b>Сумма</b> '
                                                        + REPLACE(CONVERT(NVARCHAR, d.amount, 1),
                                                              ',', ' ')
                                                        + @new_line
                                                        + '<b>Юр. лицо ЮНИТ</b> '
                                                        + c.NAME + @new_line
                                                        + '<b>Контрагент</b> '
                                                        + ( SELECT
                                                              ctr.o2s5xclsha0
                                                              + '(ИНН'
                                                              + ctr.o2s5xclow3t
                                                              + ')'
                                                            FROM
                                                              [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_o2s5xclp1y3 ctr
                                                            WHERE
                                                              ctr.recordid = d.id_contractor
                                                          )
                                                FROM    agr_agreements a
                                                        INNER JOIN agr_documents d ON a.id_document = d.id_document
                                                        INNER JOIN dbo.companies c ON d.id_company = c.id_company
                                                        INNER JOIN agr_doc_types dt ON d.id_doc_type = dt.id_doc_type
                                                WHERE   a.id_agreement = @id_agreement
														
                                            END
                                        ELSE
                                            BEGIN
                                                SET @have_notice = NULL
                                            END
														
                                        WHILE @@FETCH_STATUS = 0
                                            BEGIN
                                                EXEC sk_agreements @action = 'updAgrProcess',
                                                    @id_agr_process = @id_agr_process,
                                                    @id_agr_result = @active_id_agr_result
								
								--Уведомление согласующего лица
                                                IF @have_notice IS NOT NULL
                                                    AND
													--если нет других доступных этапов для данного лица в этом согласовании
                                                    NOT EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              agr_processes ap
                                                              WHERE
                                                              ap.id_agr_process != @id_agr_process
                                                              AND ap.id_agreement = @id_agreement
                                                              AND ap.enabled = 1
                                                              AND ap.id_agr_matcher = ( SELECT
                                                              id_agr_matcher
                                                              FROM
                                                              agr_processes
                                                              WHERE
                                                              id_agr_process = @id_agr_process
                                                              ) )
                                                    BEGIN
                                                        SELECT
                                                              @matcher_mail = u.mail
                                                        FROM  agr_processes ap
                                                              INNER JOIN agr_matchers am ON am.id_agr_matcher = ap.id_agr_matcher
                                                              INNER JOIN users u ON am.id_user = u.id_user
                                                        WHERE ap.id_agr_process = @id_agr_process	
									
													--Раскомментировать при вводе в продакшн
                                                        EXEC sk_send_message @action = 'send_email',
                                                            @id_program = @id_program,
                                                            @subject = @mail_subject,
                                                            @body = @mail_text,
                                                            @recipients = @matcher_mail	
                                                    --/Раскомментировать	
										
													--FORTEST
                                                        --EXEC sk_send_message @action = 'send_email',
                                                        --    @id_program = @id_program,
                                                        --    @subject = @mail_subject,
                                                        --    @body = @mail_text,
                                                        --    @recipients = 'anton.rehov@unitgroup.ru'		
                                                    --/FORTEST
                                                    END
								--/Уведомление
								
                                                FETCH NEXT
								FROM curs
								INTO @id_agr_process, @order_num
                                            END

                                        CLOSE curs

                                        DEALLOCATE curs
                                    END
								--Если ничего не нашли и нет активных процессов, значит процессы закончены и согласование закончено	
                                ELSE
                                    IF NOT EXISTS ( SELECT  1
                                                    FROM    dbo.agr_processes p
                                                    WHERE   p.id_agreement = @id_agreement
										--пустые результаты
                                                            AND p.id_agr_result = @active_id_agr_result
                                                            AND p.enabled = 1
                                                            AND p.order_num = @order_num )
                                        BEGIN
								--Выбираем статус MATCHED
                                            SELECT  @id_agr_state = id_agr_state
                                            FROM    agr_states s
                                            WHERE   LOWER(s.sys_name) = LOWER('MATCHED')

								--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                                            EXEC sk_agreements @action = 'updAgreement',
                                                @id_agreement = @id_agreement,
                                                @id_agr_state = @id_agr_state
                                        END

                                RETURN @id_agr_process
                            END
							--=================================
							--Устанавливает результат процесса согласования и запускаем следующий
							--=================================	
                        ELSE
                            IF @action = 'setAgrProcessResult'
                                BEGIN
                                    IF @sp_test IS NOT NULL
                                        BEGIN
                                            RETURN
                                        END

                                    BEGIN TRY
                                        BEGIN TRANSACTION
                                            TxnSetAgrProcessResult

                                        SELECT  @id_agreement = id_agreement
                                        FROM    agr_processes p
                                        WHERE   p.id_agr_process = @id_agr_process
										
										
										
                                        EXEC sk_agreements @action = 'updAgrProcess',
                                            @id_agr_process = @id_agr_process,
                                            @id_agr_result = @id_agr_result,
                                            @comment = @comment,
                                            @id_updater = @id_updater

								--успешно согласовано
								--IF EXISTS (
								--		SELECT 1
								--		FROM agr_results
								--		WHERE id_agr_result = @id_agr_result
								--			AND id_agr_result_type IN (
								--				SELECT id_agr_result_type
								--				FROM agr_result_type
								--				WHERE lower(NAME) = lower('YES')
								--				)
								--		)
								--BEGIN
								--END
								--ELSE
								--неуспешно согласовано
                                        IF EXISTS ( SELECT  1
                                                    FROM    agr_results
                                                    WHERE   id_agr_result = @id_agr_result
                                                            AND id_agr_result_type IN (
                                                            SELECT
                                                              id_agr_result_type
                                                            FROM
                                                              agr_result_type
                                                            WHERE
                                                              LOWER(NAME) = LOWER('NO') ) )
                                            BEGIN
                                                SELECT  @id_agr_matcher = id_agr_matcher ,
                                                        @order_num = order_num
                                                FROM    agr_processes
                                                WHERE   id_agr_process = @id_agr_process

                                                EXEC @id_agr_result = ui_agreements @action = 'getEmptyProcResultId'

									--пересозаем данный процесс по новой
                                                EXEC sk_agreements @action = 'insAgrProcess',
                                                    @id_agreement = @id_agreement,
                                                    @id_agr_matcher = @id_agr_matcher,
                                                    @order_num = @order_num,
                                                    @id_agr_result = @id_agr_result
                                            END

								--активируем следующий процесс
                                        EXEC @id_new_agr_process = ui_agreements @action = 'activateNextAgrProcess',
                                            @id_agreement = @id_agreement

                                        COMMIT TRANSACTION TxnSetAgrProcessResult

                                        RETURN @id_new_agr_process
                                    END TRY

                                    BEGIN CATCH
                                        IF @@TRANCOUNT > 0
                                            ROLLBACK TRAN TxnSetAgrProcessResult

                                        SELECT  @error_text = ERROR_MESSAGE()

                                        RAISERROR (
										@error_text
										,16
										,1
										)
                                    END CATCH
                                END
								--=================================
								--получаем результаты процессов для кнопок
								--=================================
                            ELSE
                                IF @action = 'getProcResults'
                                    BEGIN
                                        IF @sp_test IS NOT NULL
                                            BEGIN
                                                RETURN
                                            END

                                        SELECT  r.id_agr_result ,
                                                r.display_name ,
                                                rt.NAME AS sys_name
                                        FROM    agr_results r
                                                INNER JOIN agr_result_type rt ON r.id_agr_result_type = rt.id_agr_result_type
                                        WHERE   r.enabled = 1
                                                AND LOWER(rt.NAME) IN (
                                                LOWER('YES'), LOWER('NO') )
                                        ORDER BY r.order_num
                                    END
									--=================================
									--Сохранение результата процесса согласования
									--=================================
                                ELSE
                                    IF @action = 'saveProcResult'
                                        BEGIN
                                            IF @sp_test IS NOT NULL
                                                BEGIN
                                                    RETURN
                                                END

                                            SET @id_new_agr_process = NULL

                                            IF EXISTS ( SELECT
                                                              1
                                                        FROM  agr_processes p
                                                              INNER JOIN agr_matchers m ON p.id_agr_matcher = m.id_agr_matcher
                                                              OR ( p.id_agr_matcher = m.id_main_matcher
                                                              AND m.enabled = 1
                                                              )
                                                        WHERE p.id_agr_process = @id_agr_process
                                                              AND m.id_user = @id_creator )
                                                BEGIN
                                                --Проверяем не отмечен ли уже этот процесс (могут быть повторные вызовы из приложения по F5)
                                                    IF NOT EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              agr_processes p
                                                              WHERE
                                                              p.id_agr_process = @id_agr_process
                                                              AND p.id_agr_result IN (
                                                              SELECT
                                                              id_agr_result
                                                              FROM
                                                              dbo.agr_results r
                                                              WHERE
                                                              r.id_agr_result_type IN (
                                                              SELECT
                                                              rt.id_agr_result_type
                                                              FROM
                                                              dbo.agr_result_type rt
                                                              WHERE
                                                              rt.name IN (
                                                              'YES', 'NO' ) ) ) )
                                                        BEGIN
                                                            EXEC @id_new_agr_process = ui_agreements @action = 'setAgrProcessResult',
                                                              @id_agr_process = @id_agr_process,
                                                              @id_agr_result = @id_agr_result,
                                                              @comment = @comment,
                                                              @id_updater = @id_creator
                                                        END
                                                END
                                            ELSE
                                                BEGIN
                                                    SELECT  @error_text = 'Неверное согласующее лицо. Операция сохранения процесса согласования отмена!'

                                                    RAISERROR (
												@error_text
												,16
												,1
												)
                                                END

                                            SELECT  @id_new_agr_process AS id_new_agr_process
                                        END

	--=================================
	--получаем "новый" результат процесса
	--=================================
        IF @action = 'getEmptyProcResultId'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  @id_agr_result = r.id_agr_result
                FROM    agr_results r
                        INNER JOIN agr_result_type rt ON r.id_agr_result_type = rt.id_agr_result_type
                WHERE   r.enabled = 1
                        AND LOWER(rt.NAME) = LOWER('EMPTY')

                RETURN @id_agr_result
            END
			--=================================
			--получаем "активный" результат процесса
			--=================================
        ELSE
            IF @action = 'getActiveProcResultId'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    SELECT  @id_agr_result = r.id_agr_result
                    FROM    agr_results r
                            INNER JOIN agr_result_type rt ON r.id_agr_result_type = rt.id_agr_result_type
                    WHERE   r.enabled = 1
                            AND LOWER(rt.NAME) = LOWER('ACTIVE')

                    RETURN @id_agr_result
                END

	--=================================
	--Получение документа по ID
	--=================================
        IF @action = 'getDocument'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  d.id_document ,
                        d.id_doc_type ,
                        d.number ,
                        d.reg_number ,
                        d.doc_date ,
                        d.id_department ,
                        d.id_contract_type ,
                        d.id_company
			--,c.name as company_name
                        ,
                        d.id_contractor ,
                        CONVERT(DECIMAL(18, 2), amount) AS amount ,
                        d.id_doc_manager
			--, u.display_name as doc_manager_name
                        ,
                        d.enabled ,
                        d.id_creator ,
                        d.contract_date ,
                        d.contract_num ,
                        d.add_docs
                FROM    agr_documents d
		--inner join users u on d.id_doc_manager = u.id_user
		--inner join companies c on d.id_company = c.id_company
                WHERE   d.id_document = @id_document
            END

	--=================================
	--Список менеджеров (список выбора)
	--=================================
        IF @action = 'getDocManagerSelectionList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  u.id_user AS id ,
                        u.display_name AS NAME
                FROM    users u
                WHERE   u.enabled = 1
                        AND u.old_id_user IS NULL
		--Здесь необходимо добавить условие чтобы выводились приемущественно менеджеры для этой программы
                ORDER BY u.full_name
            END

	--=================================
	--Список менеджеров по договору (список выбора)
	--=================================
        IF @action = 'getFactDocManagerSelectionList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  u.id_user AS id ,
                        u.display_name AS NAME
                FROM    ( SELECT    d.id_doc_manager
                          FROM      agr_documents d
                                    INNER JOIN agr_agreements a ON a.id_document = d.id_document
                          WHERE     a.enabled = 1
                          GROUP BY  d.id_doc_manager
                        ) AS tbl
                        INNER JOIN users u ON tbl.id_doc_manager = u.id_user
                ORDER BY u.full_name
            END

	--=================================
	--Список офис-менеджеров (список выбора)
	--=================================
        IF @action = 'getFactAgrManagerSelectionList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  u.id_user AS id ,
                        u.display_name AS NAME
                FROM    ( SELECT    a.id_agr_manager
                          FROM      agr_agreements a
                          WHERE     a.enabled = 1
                          GROUP BY  a.id_agr_manager
                        ) AS tbl
                        INNER JOIN users u ON tbl.id_agr_manager = u.id_user
                ORDER BY u.full_name
            END

	--=================================
	--Список статусов согласований (список выбора)
	--=================================
        IF @action = 'getAgrStatesSelectionList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  st.id_agr_state AS id ,
                        st.NAME AS NAME
                FROM    agr_states st
                WHERE   st.enabled = 1
                ORDER BY st.order_num
            END

	--=================================
	--Получение ID статуса согласований по системному имени
	--=================================
        IF @action = 'getIdAgrState'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  st.id_agr_state
                FROM    agr_states st
                WHERE   st.enabled = 1
                        AND LOWER(st.sys_name) = LOWER(@sys_name)
            END

	--=================================
	--Список схем согласования
	--=================================
        IF @action = 'getSchemeList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  ROW_NUMBER() OVER ( ORDER BY s.id_agr_scheme DESC ) AS table_order_num ,
                        s.id_agr_scheme ,
                        s.NAME ,
                        ( CONVERT(NVARCHAR, s.amount1) + ' - '
                          + CASE WHEN s.amount2 = @nolimit_digit
                                 THEN 'неограниченно'
                                 ELSE CONVERT(NVARCHAR, s.amount2)
                            END ) AS amount ,
                        d.display_name AS department ,
                        ct.display_name AS contract_type ,
                        CASE WHEN s.matchers_notice = 1 THEN 'Да'
                             ELSE 'Нет'
                        END AS matchers_notice ,
                        ( SELECT    st.image
                          FROM      agr_scheme_types st
                          WHERE     st.id_agr_scheme_type = s.id_agr_scheme_type
                        ) AS scheme_type_image ,
                        ( SELECT    st.descr
                          FROM      agr_scheme_types st
                          WHERE     st.id_agr_scheme_type = s.id_agr_scheme_type
                        ) AS scheme_type_descr
                FROM    agr_schemes s
                        INNER JOIN departments d ON s.id_department = d.id_department
                        INNER JOIN agr_contract_types ct ON s.id_contract_type = ct.id_contract_type
                WHERE   s.old_id_agr_scheme IS NULL
                        AND s.enabled = 1
			--условие по типу договора
                        AND ( @id_contract_type = @select_all_value
                              OR ( @id_contract_type != @select_all_value
                                   AND s.id_contract_type = @id_contract_type
                                 )
                            )
			--условие по подразделению
                        AND ( @id_department = @select_all_value
                              OR ( @id_department != @select_all_value
                                   AND s.id_department = @id_department
                                 )
                            )
			--условие по сумме
                        AND ( @amount IS NULL
                              OR ( @amount IS NOT NULL
                                   AND @amount BETWEEN s.amount1 AND s.amount2
                                 )
                            )
                ORDER BY s.id_agr_scheme DESC
            END
			--=================================
			--Список схем согласования (список выбора)
			--=================================
        ELSE
            IF @action = 'getSchemeSelectionList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    SELECT  s.id_agr_scheme AS id ,
                            s.NAME AS NAME
			--возможно имя сделать состоящим из набора - сумма отдел тип договора
			--,(convert(NVARCHAR, s.amount1) + ' - ' + convert(NVARCHAR, s.amount2)) AS amount
			--,d.display_name AS department
			--,ct.display_name AS contract_type
                    FROM    agr_schemes s
                    WHERE   s.old_id_agr_scheme IS NULL
                            AND s.enabled = 1
                END               
				--=================================
				--Получение схемы согласования по ID
				--=================================
            ELSE
                IF @action = 'getScheme'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END

                        SELECT  id_agr_scheme ,
                                NAME ,
                                id_department ,
                                id_contract_type ,
                                CONVERT(DECIMAL(18, 2), amount1) AS amount1 ,
                                CONVERT(DECIMAL(18, 2), amount2) AS amount2 ,
                                ENABLED ,
                                s.matchers_notice ,
                                s.id_agr_scheme_type
                        FROM    agr_schemes s
                        WHERE   s.id_agr_scheme = @id_agr_scheme
                    END
					--=================================
					--Закрытие схемы согласования
					--=================================
                ELSE
                    IF @action = 'closeScheme'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END

                            EXEC sk_agreements @action = N'closeSchemeById',
                                @id_agr_scheme = @id_agr_scheme,
                                @id_creator = @id_creator
                        END
						--=================================
						--Вставка схемы согласования
						--=================================
                    ELSE
                        IF @action = 'saveScheme'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END

                                IF @name IS NULL
                                    OR @name = ''
                                    BEGIN
                                        SET @name = ( SELECT  NAME
                                                      FROM    departments
                                                      WHERE   id_department = @id_department
                                                    ) + ' '
                                            + ( SELECT  NAME
                                                FROM    agr_contract_types
                                                WHERE   id_contract_type = @id_contract_type
                                              ) + ' от '
                                            + CONVERT(NVARCHAR, @amount1)
                                            + ' до '
                                            + CASE WHEN @amount2 = @nolimit_digit
                                                   THEN 'неограниченно'
                                                   ELSE CONVERT(NVARCHAR, @amount2)
                                              END
                                    END

                                IF @id_agr_scheme > 0
                                    BEGIN
                                        EXEC sk_agreements @action = 'updScheme',
                                            @id_agr_scheme = @id_agr_scheme,
                                            @name = @name,
                                            @id_department = @id_department,
                                            @id_contract_type = @id_contract_type,
                                            @amount1 = @amount1,
                                            @amount2 = @amount2,
                                            @id_creator = @id_creator,
                                            @matchers_notice = @matchers_notice,
                                            @id_agr_scheme_type = @id_agr_scheme_type
                                    END
                                ELSE
                                    BEGIN
                                        IF EXISTS ( SELECT  1
                                                    FROM    agr_schemes s
                                                    WHERE   s.enabled = 1
                                                            AND s.id_department = @id_department
                                                            AND s.id_contract_type = @id_contract_type
                                                            AND ( @amount1
                                                              + 0.01 ) BETWEEN s.amount1 AND s.amount2
                                                            AND ( @amount2
                                                              - 0.01 ) BETWEEN s.amount1 AND s.amount2 )
                                            BEGIN
                                                SELECT  @error_text = 'Сумма попадает в диапазон подобной схемы. Операция сохранения схемы согласования отмена!'

                                                RAISERROR (
										@error_text
										,16
										,1
										)

                                                RETURN
                                            END

                                        EXEC sk_agreements @action = 'insScheme',
                                            @name = @name,
                                            @id_department = @id_department,
                                            @id_contract_type = @id_contract_type,
                                            @amount1 = @amount1,
                                            @amount2 = @amount2,
                                            @id_creator = @id_creator,
                                            @matchers_notice = @matchers_notice,
                                            @id_agr_scheme_type = @id_agr_scheme_type
                                    END
                            END

	 --=================================
			--Список типов схем согласования (список выбора)
			--=================================
        IF @action = 'getSchemeTypesSelectionList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  t.id_agr_scheme_type AS id ,
                        t.NAME AS NAME
                FROM    agr_scheme_types t
                WHERE   t.enabled = 1
            END

	--=================================
	--Список заместителей
	--=================================
        IF @action = 'getSubMatchersList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  m.id_agr_matcher ,
                        m.agr_type ,
                        m.doc_type ,
                        u.position ,
                        m.id_main_matcher ,
                        u.display_name AS sub_matcher_name ,
                        u.full_name ,
                        ROW_NUMBER() OVER ( ORDER BY m.order_num ) AS order_num
                FROM    agr_matchers m
                        INNER JOIN users u ON m.id_user = u.id_user
                WHERE   m.enabled = 1
                        AND m.id_main_matcher = @id_main_matcher
                ORDER BY m.order_num
            END
			--=================================
			--Добавление заместителя
			--=================================
        ELSE
            IF @action = 'addSubMatcher'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    SELECT  @doc_type = m.doc_type ,
                            @agr_type = m.agr_type
                    FROM    agr_matchers m
                    WHERE   m.id_agr_matcher = @id_main_matcher

                    SELECT  @order_num = ( MAX(order_num) + 1 )
                    FROM    agr_matchers m
                    WHERE   m.enabled = 1
                            AND m.id_main_matcher = @id_main_matcher

                    IF @order_num IS NULL
                        OR @order_num < 1
                        BEGIN
                            SET @order_num = 1
                        END

                    EXEC sk_agreements @action = 'insMatcher',
                        @id_user = @id_user, @doc_type = @doc_type,
                        @agr_type = @agr_type, @descr = @descr,
                        @order_num = @order_num,
                        @id_main_matcher = @id_main_matcher,
                        @id_creator = @id_creator
                END
				--=================================
				--Список заместителей (список выбора)
				--=================================
            ELSE
                IF @action = 'getSubMatchersSelectionList'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END

                        SELECT  u.id_user AS id ,
                                u.display_name AS NAME
                        FROM    users u
                        WHERE   u.enabled = 1
                                AND u.old_id_user IS NULL
                                AND u.id_user NOT IN (
                                SELECT  m.id_user
                                FROM    agr_matchers m
                                WHERE   m.enabled = 1
                                        AND ( m.id_agr_matcher = @id_agr_matcher
                                              OR m.id_main_matcher = @id_agr_matcher
                                            ) )
                        ORDER BY NAME
                    END

	--=================================
	--Список согласователей
	--=================================
        IF @action = 'getMatchersList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  ROW_NUMBER() OVER ( ORDER BY m.order_num ) AS table_order_num ,
                        m.id_agr_matcher ,
                        u.position ,
                        u.display_name AS NAME ,
                        u.full_name ,
                        ROW_NUMBER() OVER ( ORDER BY m.order_num ) AS order_num ,
                        CASE WHEN m.available = 1 THEN 'Доступен'
                             ELSE 'Не доступен'
                        END AS available
                FROM    agr_matchers m
                        INNER JOIN users u ON m.id_user = u.id_user
                WHERE   m.enabled = 1
                        AND m.id_main_matcher IS NULL
                ORDER BY m.order_num
            END
			--=================================
			--Получение согласователя по ID
			--=================================
        ELSE
            IF @action = 'getMatcher'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    SELECT  m.id_agr_matcher ,
                            m.id_user ,
                            m.agr_type ,
                            m.doc_type ,
                            m.available ,
                            m.enabled ,
                            m.id_main_matcher ,
                            m.descr
                    FROM    agr_matchers m
                    WHERE   m.id_agr_matcher = @id_agr_matcher
                END
				--=================================
				--Список согласователей (список выбора)
				--=================================
            ELSE
                IF @action = 'getMatchersSelectionList'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END

                        SELECT  m.id_agr_matcher AS id ,
                                u.display_name AS NAME
                        FROM    agr_matchers m
                                INNER JOIN users u ON m.id_user = u.id_user
                        WHERE   m.enabled = 1
                                AND m.id_main_matcher IS NULL
                                AND m.id_agr_matcher NOT IN (
                                SELECT  id_agr_matcher
                                FROM    agr_matchers2schemes m2s
                                WHERE   m2s.enabled = 1
                                        AND m2s.id_agr_scheme = @id_agr_scheme )
                        ORDER BY u.full_name
                    END
                ELSE
                    IF @action = 'saveMatcher'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END

                            IF @id_agr_matcher > 0
                                BEGIN
                                    EXEC sk_agreements @action = N'updMatcher',
                                        @id_agr_matcher = @id_agr_matcher,
                                        @id_user = @id_user,
                                        @doc_type = @doc_type,
                                        @agr_type = @agr_type,
                                        @available = @available,
                                        @descr = @descr,
                                        @order_num = @order_num,
                                        @id_main_matcher = @id_main_matcher,
                                        @id_creator = @id_creator
                                END
                            ELSE
                                BEGIN
                                    EXEC sk_agreements @action = 'insMatcher',
                                        @id_user = @id_user,
                                        @doc_type = @doc_type,
                                        @agr_type = @agr_type, @descr = @descr,
                                        @order_num = @order_num,
                                        @id_main_matcher = @id_main_matcher,
                                        @id_creator = @id_creator
                                END
                        END
                    ELSE
                        IF @action = 'closeMatcher'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END

                                EXEC sk_agreements @action = 'closeMatcherById',
                                    @id_agr_matcher = @id_agr_matcher,
                                    @id_creator = @id_creator
                            END

	--=================================
	--Список согласователей для схемы
	--=================================	
        IF @action = 'getMatchers2SchemeList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  m2s.id_matchers2schemes ,
                        m2s.id_agr_scheme ,
                        m2s.id_agr_matcher ,
                        u.display_name AS matcher_name ,
                        m2s.order_num
			--,ROW_NUMBER() OVER (ORDER BY m2s.order_num) AS order_num
                        ,
                        u.position ,
                        m.agr_type ,
                        m.doc_type
                FROM    agr_matchers2schemes m2s
                        INNER JOIN agr_matchers m ON m2s.id_agr_matcher = m.id_agr_matcher
                        INNER JOIN users u ON m.id_user = u.id_user
                WHERE   m2s.id_agr_scheme = @id_agr_scheme
                        AND m2s.enabled = 1
                ORDER BY m2s.order_num ,
                        u.full_name
            END
			--=================================
			--Добавление согласователя в схему
			--=================================
        ELSE
            IF @action = 'saveMatcher2Scheme'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    IF @order_num IS NULL
                        BEGIN
                            SELECT  @order_num = ( MAX(order_num) + 1 )
                            FROM    agr_matchers2schemes m2s
                            WHERE   m2s.enabled = 1
                                    AND m2s.id_agr_scheme = @id_agr_scheme

                            IF @order_num IS NULL
                                OR @order_num < 1
                                BEGIN
                                    SET @order_num = 1
                                END
                        END

                    IF @id_matchers2schemes IS NULL
                        BEGIN
                            EXEC sk_agreements @action = 'insMatcher2Scheme',
                                @id_agr_scheme = @id_agr_scheme,
                                @id_agr_matcher = @id_agr_matcher,
                                @order_num = @order_num,
                                @id_creator = @id_creator
                        END
                    ELSE
                        BEGIN
                            EXEC sk_agreements @action = 'updMatcher2Scheme',
                                @id_matchers2schemes = @id_matchers2schemes,
                                @order_num = @order_num
                        END
                END
				--=================================
				--Исключение согласователя из схемы
				--=================================
            ELSE
                IF @action = 'closeMatcher2Scheme'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END

                        EXEC sk_agreements @action = 'closeMatcher2SchemeById',
                            @id_matchers2schemes = @id_matchers2schemes,
                            @id_creator = @id_creator
                    END

	--===================
	--Список контрагентов сгруппированый из таблицы документов для фильтра(список выбора)
	--===================
        IF @action = 'getContractorFilterSelectionList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  ctr.recordid AS id ,
                        ctr.o2s5xclow3h + ' (ИНН '
                        + CONVERT(NVARCHAR, ctr.o2s5xclow3t) + ')' AS NAME ,
                        ctr.o2s5xclow3h AS full_name ,
                        ctr.o2s5xclow3t AS inn
                FROM    ( SELECT    d.id_contractor
                          FROM      agr_agreements a
                                    INNER JOIN agr_documents d ON a.id_document = d.id_document
                          WHERE     a.enabled = 1
                          GROUP BY  d.id_contractor
                        ) t
                        INNER JOIN [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_o2s5xclp1y3 ctr ON t.id_contractor = ctr.recordid
                ORDER BY ctr.o2s5xclow3t ,
                        ctr.o2s5xclow3h
            END

	--===================
	--Проверяем причастен ли пользователь к списку согласователей
	--===================
        IF @action = 'checkUserIsMatcher'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  CASE WHEN EXISTS ( SELECT   1
                                           FROM     agr_matchers am
                                           WHERE    am.enabled = 1
                                                    AND am.id_user = @id_user )
                             THEN 1
                             ELSE 0
                        END AS is_matcher
            END

	--===================
	--получаем список местанахождений договоров для офис-менеджеров
	--===================
        IF @action = 'getProcAnswerList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  u.full_name AS creator ,
                        pa.TEXT AS aswer_text ,
                        CONVERT(NVARCHAR, pa.dattim1, 4) AS date_create
                FROM    agr_proc_answers pa
                        INNER JOIN users u ON pa.id_creator = u.id_user
                WHERE   pa.id_agr_process = @id_agr_process
            END
			--=================================
			--Получение данных конкретного процесса согласования
			--=================================	
        ELSE
            IF @action = 'getAgrProcess4Answer'
                BEGIN
                    SELECT  'Комментарий '
                            + CASE WHEN u.id_user = uu.id_user
                                   THEN
							--если ответивишй = согласующее лицо (там иннер джоины)
                                        '(' + u.full_name + ')'
                                   ELSE '(' + uu.full_name + ' от имени '
                                        + u.display_name + ')'
                              END AS comment_title ,
                            p.comment ,
                            ( 'Документ '
                              + CASE WHEN dt.display_name IS NULL THEN ''
                                     ELSE dt.display_name
                                END + CASE WHEN d.number IS NULL THEN ''
                                           ELSE ' №' + d.number
                                      END
                              + CASE WHEN d.doc_date IS NULL THEN ''
                                     ELSE ' от '
                                          + CONVERT(NVARCHAR, d.doc_date, 104)
                                END
                              + CASE WHEN ( d.contract_num IS NOT NULL
                                            OR d.contract_date IS NOT NULL
                                          )
                                          AND ( d.number IS NOT NULL
                                                OR d.doc_date IS NOT NULL
                                              ) THEN ' договора'
                                     ELSE ''
                                END
                              + CASE WHEN d.contract_num IS NULL
                                     THEN ' Без номера'
                                     ELSE ' №' + d.contract_num
                                END
                              + CASE WHEN d.contract_date IS NULL
                                     THEN ' Без даты'
                                     ELSE ' от '
                                          + CONVERT(NVARCHAR, d.contract_date, 104)
                                END + ' (ID '
                              + CONVERT(NVARCHAR, a.id_agreement) + ')' ) AS title
                    FROM    agr_processes p --inner join agr_proc_answers pa on p.id_agr_process = pa.id_agr_process
                            INNER JOIN agr_matchers m ON p.id_agr_matcher = m.id_agr_matcher
                            INNER JOIN users u ON m.id_user = u.id_user
                            INNER JOIN users uu ON p.id_updater = uu.id_user
                            INNER JOIN agr_agreements a ON p.id_agreement = a.id_agreement
                            INNER JOIN agr_documents d ON a.id_document = d.id_document
                            INNER JOIN agr_doc_types dt ON d.id_doc_type = dt.id_doc_type
                    WHERE   p.id_agr_process = @id_agr_process
                END
				--===================
				--Данные для письма согласователю
				--===================
            ELSE
                IF @action = 'getProcessAnswerMessageData'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END

				--SELECT @id_sended_mail_type = id_sended_mail_type
				--FROM dbo.sended_mail_types smd
				--WHERE smd.id_program = @id_program
				--	AND lower(smd.sys_name) = lower('getProcessAnswerMessageData')

				----Смотрим был ти такой ответ уже
				--IF NOT EXISTS (
				--		SELECT 1
				--		FROM dbo.sended_mails sm
				--		WHERE sm.id_sended_mail_type = @id_sended_mail_type
				--			AND uid = @id_proc_answer
				--		)
				--BEGIN					
				--	EXEC dbo.sk_sended_mails @id_program = @id_program
				--		,@id_sended_mail_type = @id_sended_mail_type
				--		,@uid = @id_proc_answer
				
                        SELECT  d.id_contractor ,
                                ( SELECT    @new_line
                                ) AS new_line ,
                                ( 'Согласование по документу '
                                  + CASE WHEN dt.display_name IS NULL THEN ''
                                         ELSE dt.display_name
                                    END + CASE WHEN d.number IS NULL THEN ''
                                               ELSE ' №' + d.number
                                          END
                                  + CASE WHEN d.doc_date IS NULL THEN ''
                                         ELSE ' от '
                                              + CONVERT(NVARCHAR, d.doc_date, 104)
                                    END
                                  + CASE WHEN ( d.contract_num IS NOT NULL
                                                OR d.contract_date IS NOT NULL
                                              )
                                              AND ( d.number IS NOT NULL
                                                    OR d.doc_date IS NOT NULL
                                                  ) THEN ' договора'
                                         ELSE ''
                                    END
                                  + CASE WHEN d.contract_num IS NULL
                                         THEN ' Без номера'
                                         ELSE ' №' + d.contract_num
                                    END
                                  + CASE WHEN d.contract_date IS NULL
                                         THEN ' Без даты'
                                         ELSE ' от '
                                              + CONVERT(NVARCHAR, d.contract_date, 104)
                                    END + ' (ID '
                                  + CONVERT(NVARCHAR, a.id_agreement) + ')' ) AS mail_subject ,
                                @new_line AS new_line ,
                                'На ваш комментарий ('
                                + CONVERT(NVARCHAR, p.date_change, 4) + ')'
                                + @new_line + @new_line + ISNULL(p.comment,
                                                              'ПУСТО')
                                + @new_line + @new_line + ' получен ответ ('
                                + uu.full_name + ')' + @new_line + @new_line
                                + pa.TEXT AS matcher_mail_text ,
                                u.mail AS matcher_mail
                        FROM    agr_proc_answers pa
                                INNER JOIN agr_processes p ON pa.id_agr_process = p.id_agr_process
                                INNER JOIN users u ON u.id_user = p.id_updater
                                INNER JOIN users uu ON pa.id_creator = uu.id_user
                                INNER JOIN agr_agreements a ON p.id_agreement = a.id_agreement
                                INNER JOIN agr_documents d ON a.id_document = d.id_document
                                INNER JOIN agr_doc_types dt ON d.id_doc_type = dt.id_doc_type
                        WHERE   pa.id_proc_answer = @id_proc_answer
				--END
                    END
					--===================
					--сохранение ответа для процесса
					--===================
                ELSE
                    IF @action = 'saveProcAnswer'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END

                            EXEC @id_proc_answer = dbo.sk_agreements @action = 'insProcAnswer',
                                @text = @text, @id_creator = @id_creator,
                                @id_agr_process = @id_agr_process

                            SELECT  @id_proc_answer AS id_proc_answer
                        END

	--===================
	--получаем список местанахождений договоров для офис-менеджеров
	--===================
        IF @action = 'getManager2ProcessList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  m2p.id_agr_manager2agr_processes ,
                        m2p.id_agr_manager ,
                        m2p.id_agr_process
                FROM    agr_manager2agr_processes m2p
                WHERE   m2p.id_agr_manager = @id_agr_manager
                        AND m2p.dattim2 = CONVERT(DATETIME, '3.3.3333')
            END
			--===================
			--Сохранение местанахождения договора для офис-менеджеров
			--===================
        ELSE
            IF @action = 'saveManager2Process'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    SET @var_bit = 1

                    IF EXISTS ( SELECT  1
                                FROM    agr_manager2agr_processes m2p
                                WHERE   m2p.id_agr_process = @id_agr_process
                                        AND m2p.dattim2 = CONVERT(DATETIME, '3.3.3333') )
                        BEGIN
                            SET @var_bit = 0
                        END

			--закрываем все открытые местанахождения для данного согласования
                    DECLARE curs CURSOR
                    FOR
                        SELECT  id_agr_process
                        FROM    agr_processes p
                        WHERE   p.id_agreement = ( SELECT   id_agreement
                                                   FROM     agr_processes
                                                   WHERE    id_agr_process = @id_agr_process
                                                 )

                    OPEN curs

                    FETCH NEXT
			FROM curs
			INTO @var_int

			--добавляем процессы согласования
                    WHILE @@FETCH_STATUS = 0
                        BEGIN
                            EXEC dbo.sk_agreements @action = 'closeManager2Process',
                                @id_agr_process = @var_int

                            FETCH NEXT
				FROM curs
				INTO @var_int
                        END

                    CLOSE curs

                    DEALLOCATE curs

                    IF @var_bit = 1
                        BEGIN
                            EXEC sk_agreements @action = 'insManager2Process',
                                @id_agr_manager = @id_agr_manager,
                                @id_agr_process = @id_agr_process
                        END
                END

	--===================
	--Список сканов на скан
	--===================
        IF @action = 'getDocScanList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  ds.id_doc_scan ,
                        ds.NAME ,
                        ds.file_path ,
                        ds.dattim1 AS date_add ,
                        u.full_name AS creator ,
                        ds.id_parent ,
                        CASE WHEN ds.id_parent IS NULL THEN 1
                             ELSE 0
                        END AS is_actual ,
                        CASE WHEN id_parent IS NULL THEN ds.id_doc_scan
                             ELSE ds.id_parent
                        END AS id_leg
                FROM    agr_doc_scan ds
                        INNER JOIN users u ON ds.id_creator = u.id_user
                WHERE   ds.id_agreement = @id_agreement
                        AND ds.enabled = 1
                ORDER BY id_leg DESC ,
                        id_parent ,
                        ds.dattim1 
            END
			--===================
			--Сохранение ссылки на скан
			--===================
        ELSE
            IF @action = 'saveDocScan'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    EXEC @id_doc_scan = sk_agreements @action = 'insDocScan',
                        @name = @name, @id_agreement = @id_agreement,
                        @file_path = @file_path, @id_creator = @id_creator
                   
                    IF ( @id_parent IS NOT NULL
                         AND @id_parent > 0
                       )
                        BEGIN
                            EXEC dbo.sk_agreements @action = N'updDocScan',
                                @id_doc_scan = @id_parent,
                                @id_parent = @id_doc_scan
                        END
                END
				--===================
				--закрытие ссылки на скан
				--===================
            ELSE
                IF @action = 'closeDocScan'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END

                        EXEC sk_agreements @action = 'closeDocScan',
                            @id_doc_scan = @id_doc_scan, @id_user = @id_user
                    END

	--=================================
	--Список типов согласований (список выбора)
	--=================================
        IF @action = 'getDocTypesSelectionList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  dt.id_doc_type AS id ,
                        dt.display_name AS NAME
                FROM    agr_doc_types dt
                WHERE   dt.enabled = 1
                ORDER BY dt.order_num
            END
			--=================================
			--Список типов согласований (список выбора)
			--=================================
        ELSE
            IF @action = 'getDocTypeOptions'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    SELECT  dto.sys_name ,
                            dt2dto.NAME AS field_title
                    FROM    agr_doc_type2doc_type_options dt2dto
                            INNER JOIN agr_doc_type_options dto ON dt2dto.id_doc_type_option = dto.id_doc_type_option
                    WHERE   dto.enabled = 1
                            AND dt2dto.id_doc_type = @id_doc_type
                END
				--===================
				--Список типов документов
				--===================
            ELSE
                IF @action = 'getDocTypesList'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END

                        SELECT  ROW_NUMBER() OVER ( ORDER BY t.id_doc_type DESC ) AS table_order_num ,
                                t.id_doc_type ,
                                t.NAME ,
                                t.display_name ,
                                t.order_num ,
                                LEFT(t.doc_type_options,
                                     LEN(t.doc_type_options) - 1) AS doc_type_options
                        FROM    ( SELECT    dt.id_doc_type ,
                                            dt.NAME ,
                                            dt.display_name ,
                                            dt.order_num ,
                                            ( SELECT    dto.NAME + ', '
                                              FROM      agr_doc_type2doc_type_options dt2dto
                                                        INNER JOIN agr_doc_type_options dto ON dt2dto.id_doc_type_option = dto.id_doc_type_option
                                              WHERE     dt2dto.id_doc_type = dt.id_doc_type
                                                        AND dt2dto.enabled = 1
                                            FOR
                                              XML PATH('')
                                            ) AS doc_type_options
                                  FROM      agr_doc_types dt
                                  WHERE     dt.enabled = 1
                                ) AS t
                        ORDER BY t.order_num
                    END
					--===================
					--тип документов
					--===================
                ELSE
                    IF @action = 'getDocType'
                        BEGIN
                            SELECT  t.id_doc_type ,
                                    t.NAME ,
                                    t.display_name ,
                                    t.order_num ,
                                    LEFT(t.doc_type_options_ids,
                                         LEN(t.doc_type_options_ids) - 1) AS doc_type_options_ids
                            FROM    ( SELECT    dt.id_doc_type ,
                                                dt.NAME ,
                                                dt.display_name ,
                                                dt.order_num ,
                                                ( SELECT    CONVERT(NVARCHAR(10), dto.id_doc_type_option)
                                                            + '|'
                                                            + CONVERT(NVARCHAR(10), dt2dto.id_doc_type2doc_type_options)
                                                            + '|'
                                                            + dt2dto.NAME
                                                            + ','
                                                  FROM      agr_doc_type2doc_type_options dt2dto
                                                            INNER JOIN agr_doc_type_options dto ON dt2dto.id_doc_type_option = dto.id_doc_type_option
                                                  WHERE     dt2dto.id_doc_type = dt.id_doc_type
                                                            AND dt2dto.enabled = 1
                                                FOR
                                                  XML PATH('')
                                                ) AS doc_type_options_ids
                                      FROM      agr_doc_types dt
                                      WHERE     dt.id_doc_type = @id_doc_type
                                    ) AS t
                        END
						--===================
						--Список опций типов документа
						--===================
                    ELSE
                        IF @action = 'getDocTypeOptionsList'
                            BEGIN
                                SELECT  dto.id_doc_type_option ,
                                        dto.NAME
                                FROM    agr_doc_type_options dto
                                WHERE   dto.enabled = 1
                            END
							--===================
							--Создание типа документа
							--===================
                        ELSE
                            IF @action = 'saveDocType'
                                BEGIN
                                    IF @id_doc_type > 0
                                        BEGIN
                                            EXEC sk_agreements @action = 'updDocType',
                                                @name = @name,
                                                @display_name = @display_name,
                                                @order_num = @order_num,
                                                @id_doc_type = @id_doc_type
                                        END
                                    ELSE
                                        BEGIN
                                            EXEC @id_doc_type = sk_agreements @action = 'insDocType',
                                                @name = @name,
                                                @display_name = @display_name,
                                                @order_num = @order_num
                                        END

                                    SELECT  @id_doc_type AS id_doc_type
                                END
								--===================
								--Закрытие типа документа
								--===================
                            ELSE
                                IF @action = 'closeDocType'
                                    BEGIN
                                        EXEC sk_agreements @action = 'closeDocType',
                                            @id_doc_type = @id_doc_type
                                    END
									--===================
									--Создание опции для типа документа
									--===================
                                ELSE
                                    IF @action = 'saveDocType2Option'
                                        BEGIN
                                            IF @id_dt2dto > 0
                                                BEGIN
                                                    IF @enabled = 1
                                                        BEGIN
                                                            EXEC sk_agreements @action = 'updDocType2Option',
                                                              @id_doc_type = @id_doc_type,
                                                              @id_doc_type_option = @id_doc_type_option,
                                                              @name = @name,
                                                              @id_dt2dto = @id_dt2dto
                                                        END
                                                    ELSE
                                                        BEGIN
                                                            EXEC sk_agreements @action = 'closeDocType2Option',
                                                              @id_dt2dto = @id_dt2dto
                                                        END
                                                END
                                            ELSE
                                                BEGIN
                                                    IF @enabled = 1
                                                        BEGIN
                                                            IF NOT EXISTS ( SELECT
                                                              1
                                                              FROM
                                                              agr_doc_type2doc_type_options dt2o
                                                              WHERE
                                                              dt2o.id_doc_type = @id_doc_type
                                                              AND dt2o.id_doc_type_option = @id_doc_type_option
                                                              AND dt2o.NAME = @name )
                                                              BEGIN
                                                              EXEC sk_agreements @action = 'insDocType2Option',
                                                              @id_doc_type = @id_doc_type,
                                                              @id_doc_type_option = @id_doc_type_option,
                                                              @name = @name
                                                              END
                                                            ELSE
                                                              BEGIN
                                                              SELECT
                                                              @id_dt2dto = dt2o.id_doc_type2doc_type_options
                                                              FROM
                                                              agr_doc_type2doc_type_options dt2o
                                                              WHERE
                                                              dt2o.id_doc_type = @id_doc_type
                                                              AND dt2o.id_doc_type_option = @id_doc_type_option
                                                              AND dt2o.NAME = @name

                                                              EXEC sk_agreements @action = 'uncloseDocType2Option',
                                                              @id_dt2dto = @id_dt2dto
                                                              END
                                                        END
                                                END
                                        END
										--===================
										--Закрытие опции для типа документа
										--===================
                                    ELSE
                                        IF @action = 'closeDocType2Option'
                                            BEGIN
                                                EXEC sk_agreements @action = 'closeDocType2Option',
                                                    @id_dt2dto = @id_dt2dto
                                            END

	--===================
	--Список типов договоров (список выбора)
	--===================
        IF @action = 'getContractTypesSelectionList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  ct.id_contract_type AS id ,
                        ct.display_name AS NAME
                FROM    agr_contract_types ct
                WHERE   ct.enabled = 1
                        AND ct.dattim1 <= GETDATE()
                        AND ct.dattim2 > GETDATE()
                ORDER BY ct.order_num ,
                        ct.NAME
            END
			--===================
			--Список типов договоров (список выбора)
			--===================
        ELSE
            IF @action = 'getContractTypesList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    SELECT  ROW_NUMBER() OVER ( ORDER BY t.id_contract_type DESC ) AS table_order_num ,
                            t.id_contract_type ,
                            t.NAME ,
                            t.display_name ,
                            t.order_num
                    FROM    ( SELECT    ct.id_contract_type ,
                                        ct.NAME ,
                                        ct.display_name ,
                                        ct.order_num
                              FROM      agr_contract_types ct
                              WHERE     ct.enabled = 1
                            ) AS t
                    ORDER BY t.order_num
                END
				--===================
				--тип договора
				--===================
            ELSE
                IF @action = 'getContractType'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END

                        SELECT  ct.id_contract_type ,
                                ct.NAME ,
                                ct.display_name ,
                                ct.order_num
                        FROM    agr_contract_types ct
                        WHERE   ct.id_contract_type = @id_contract_type
                    END
					--===================
					--Закрытие типа договора
					--===================
                ELSE
                    IF @action = 'saveContractType'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END

                            IF @id_contract_type > 0
                                BEGIN
                                    EXEC sk_agreements @action = 'updContractType',
                                        @name = @name,
                                        @display_name = @display_name,
                                        @order_num = @order_num,
                                        @id_contract_type = @id_contract_type
                                END
                            ELSE
                                BEGIN
                                    EXEC @id_contract_type = sk_agreements @action = 'insContractType',
                                        @name = @name,
                                        @display_name = @display_name,
                                        @order_num = @order_num
                                END
                        END
						--===================
						--Закрытие типа договора
						--===================
                    ELSE
                        IF @action = 'closeContractType'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END

                                EXEC sk_agreements @action = 'closeContractType',
                                    @id_contract_type = @id_contract_type
                            END
    END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ui_agreements] TO [agreements_sp_exec]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ui_agreements] TO [UN1T\sqlUnit_prog]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ui_agreements] TO [sqlUnit_prog]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ui_agreements] TO [sqlChecker]
    AS [dbo];

