
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sk_send_message]
    @action NVARCHAR(50) = NULL ,
    @sp_test BIT = NULL ,
    @id_program INT =NULL,
    @subject NVARCHAR(100) ,
    @body NVARCHAR(MAX) ,
    @recipients NVARCHAR(MAX) = NULL
    --,    @uid NVARCHAR(100) = NULL
AS
    BEGIN
        SET NOCOUNT ON;
	
        DECLARE @log_params NVARCHAR(MAX) ,
            @log_descr NVARCHAR(MAX) ,
            --@proc_name NVARCHAR(150) ,
            --@prog_name NVARCHAR(150) ,
            @mail_profile VARCHAR(1) 
            --, @id_sended_mail_type INT
            --, @result SMALLINT
            ,@support_email NVARCHAR(50)
            
            SET @support_email = 'man@unitgroup.ru'
		
        --SET @result = 1
		
		--Профиль для отправки почты с сервера (необходимо создать)
        SET @mail_profile = '1'
        --SELECT  @proc_name = OBJECT_NAME(@@PROCID)

        IF @id_program IS NULL
            BEGIN
                SELECT  @id_program = p.id_program
                FROM    programs p
                WHERE   p.enabled = 1
                        AND LOWER(p.sys_name) = LOWER('EMPTY')
            END
	
	
	--****Если нужно пропустить вызовы селектов их может быть очень много
	--IF @action LIKE 'get%' BEGIN GOTO Actions END
        SELECT  @log_params = CASE WHEN @action IS NULL THEN ''
                                   ELSE ' @action='
                                        + CONVERT(NVARCHAR, @action)
                              END + CASE WHEN @sp_test IS NULL THEN ''
                                         ELSE ' @sp_test='
                                              + CONVERT(NVARCHAR, @sp_test)
                                    END
                + CASE WHEN @id_program IS NULL THEN ''
                       ELSE ' @id_program=' + CONVERT(NVARCHAR, @id_program)
                  END + CASE WHEN @recipients IS NULL THEN ''
                             ELSE ' @recipients='
                                  + CONVERT(NVARCHAR, @recipients)
                        END
	
        EXEC sk_log @action = 'insLog', @proc_name = 'sk_send_message',
            @id_program = @id_program, @params = @log_params, @body = @body,
            @subject = @subject, @recipients = @recipients,
            @descr = @log_descr
	
	/*+ CASE 
	WHEN @param IS NULL
	THEN ''
	ELSE ' @param=' + CONVERT(NVARCHAR, @param)
	END*/	    
	
	
        Actions:
        BEGIN TRY	
	--Действия  
            IF @action = 'configure_server'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
				
				--!!!ЗАПУСКАТЬ СКОПИРОВАВ В ОТДЕЛЬНОЕ ОКНО!!!
				
				---- Сначала включим Service broker - он необходим для создания очередей
				---- писем, используемых DBMail
				--IF (SELECT is_broker_enabled FROM sys.databases WHERE [name] = 'msdb') = 0
				--	ALTER DATABASE msdb SET ENABLE_BROKER WITH ROLLBACK AFTER 10 SECONDS
				--GO
				---- Включим непосредственно систему DBMail
				--sp_configure 'Database Mail XPs', 1
				--GO
				--RECONFIGURE
				--GO	
				
				----Далее нужно проверить, запущена ли служба DBMail:
				--EXECUTE msdb.dbo.sysmail_help_status_sp

				----И если она не запущена (ее статус не «STARTED»), то запустить ее запросом
				--EXECUTE msdb.dbo.sysmail_start_sp
				
				---- Создадим SMTP-аккаунт для отсылки писем
				--EXECUTE msdb.dbo.sysmail_add_account_sp
				--	-- Название аккаунта
				--		@account_name = 'udb-1@un1t.group',
				--	-- Краткое описание аккаунта
				--		@description = N'Почтовый аккаунт udb-1@un1t.group',
				--	-- Почтовый адрес
				--		@email_address = 'udb-1@un1t.group',
				--	-- Имя, отображаемое в письме в поле "От:"
				--		@display_name = N'Сервер автоматических уведомлений',
				--	-- Адрес, на который получателю письма нужно отправлять ответ
				--	-- Если ответа не требуется, обычно пишут "no-reply"
				--		@replyto_address = 'no-reply@un1t.group',
				--	-- Домен или IP-адрес SMTP-сервера
				--		@mailserver_name = 'ums-1',
				--	-- Порт SMTP-сервера, обычно 25
				--		@port = 25,
				--	-- Имя пользователя. Некоторые почтовые системы требуют указания всего
				--	-- адреса почтового ящика вместо одного имени пользователя
				--		@username = 'admin',
				--	-- Пароль к почтовому ящику
				--		@password = 'MyPassword',
				--	-- Защита SSL при подключении, большинство SMTP-серверов сейчас требуют SSL
				--		@enable_ssl = 1;
				---- Создадим профиль администратора почтовых рассылок
				--EXECUTE msdb.dbo.sysmail_add_profile_sp
				--		@profile_name = 'MySite Admin Mailer';
				---- Подключим SMTP-аккаунт к созданному профилю
				--EXECUTE msdb.dbo.sysmail_add_profileaccount_sp
				--		@profile_name = 'MySite Admin Mailer',
				--		@account_name = 'udb-1@un1t.group',
				--	-- Указатель номера SMTP-аккаунта в профиле
				--		@sequence_number = 1;
				---- Установим права доступа к профилю для роли DatabaseMailUserRole базы MSDB
				--EXECUTE msdb.dbo.sysmail_add_principalprofile_sp
				--		@profile_name = 'MySite Admin Mailer',
				--		@principal_id = 0,
				--		@is_default = 1;
				
				----Для добавления пользователю роли DatabaseMailUserRole используется стандартная процедура sp_addrolemember:
				--exec sp_addrolemember @rolename = 'DatabaseMailUserRole',
				--		@membername = '<имя_пользователя>';
				
				----Теперь отправим тестовое письмо:
				--EXEC msdb.dbo.sp_send_dbmail
				--	-- Созданный нами профиль администратора почтовых рассылок
				--		@profile_name = 'MySite Admin Mailer',
				--	-- Адрес получателя
				--		@recipients = 'friend@mysite.ru',
				--	-- Текст письма
				--		@body = N'Испытание системы SQL Server Database Mail',
				--	-- Тема
				--		@subject = N'Тестовое сообщение',
				--	-- Для примера добавим к письму результаты произвольного SQL-запроса
				--		@query = 'SELECT TOP 10 name FROM sys.objects';
				
				----Если что-то не в порядке, сначала нужно посмотреть на статус письма:
				--SELECT * FROM msdb.dbo.sysmail_allitems

				----А затем заглянуть в лог:
				--SELECT * FROM msdb.dbo.sysmail_event_log
				
				----Успешно отправленные письма можно посмотреть таким SQL-запросом:
				--SELECT sent_account_id, sent_date FROM msdb.dbo.sysmail_sentitems
                    SELECT  NULL
                END	    
            ELSE
				IF @action = 'sendSupportEmail'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                		EXEC dbo.sk_send_message @action = N'send_email', -- nvarchar(50)
                		    @id_program = @id_program, -- int
                		    @subject = @subject, -- nvarchar(100)
                		    @body = @body, -- nvarchar(max)
                		    @recipients = @support_email -- nvarchar(max)
                		
                	END
                	else
                IF @action = 'send_email'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END
                	
                        --BEGIN TRY
                        --BEGIN TRANSACTION
					
                    --SELECT  @id_sended_mail_type = id_sended_mail_type
                    --FROM    dbo.sended_mail_types smd
                    --WHERE   smd.id_program = @id_call_program
                    --        AND LOWER(smd.sys_name) = LOWER('noticeDaysDelayAgreementsDOCMGR')
					
				--избавляемся от текстовой трактовки скобок html тэгов после выполнения операции for xml path()
                    --SET @mail_body = REPLACE(REPLACE(@mail_body, '&lt;', '<'), '&gt;', '>')

                        EXEC msdb.dbo.sp_send_dbmail @profile_name = @mail_profile,
                            @recipients = @recipients, @subject = @subject,
                            @body_format = 'HTML', @body = @body

                    --EXEC dbo.sk_sended_mails @id_program = @id_call_program,
                    --    @id_sended_mail_type = @id_sended_mail_type,
                    --    @uid = @uid

                        --COMMIT TRANSACTION
                        --END TRY

                        --BEGIN CATCH
                        --    SET @result = 0
                        --    SELECT  @log_descr = ERROR_MESSAGE()
                        --IF @@TRANCOUNT > 0
                        --    ROLLBACK TRAN
                        --END CATCH
                    END 
	--/Действия
        END TRY

        BEGIN CATCH
            --SET @result = 0
            SELECT  @log_descr = ERROR_MESSAGE()
        END CATCH
	--Логирование
        EXEC sk_log @action = 'insMessageLog', 
			--@proc_name = @proc_name,
            @id_program = @id_program, @params = @log_params, @body = @body,
            @subject = @subject, @recipients = @recipients,
            @descr = @log_descr
            --/Логирование
           
        --SELECT  @result
    END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[sk_send_message] TO [sqlUnit_prog]
    AS [dbo];

