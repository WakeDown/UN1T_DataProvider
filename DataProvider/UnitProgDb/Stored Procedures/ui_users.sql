
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ui_users]
    @action NVARCHAR(50) = NULL ,
    @sp_test BIT = NULL --переменная для тестирования
    ,
    @user_sid NVARCHAR(50) = NULL ,
    @id_user INT = NULL ,
    @id_et_user INT = NULL ,
    @id_user_right INT = NULL ,
    @program_name NVARCHAR(150) = NULL ,
    @right_name NVARCHAR(50) = NULL ,
    @ad_group_sid NVARCHAR(50) = NULL ,
    @sys_name NVARCHAR(150) = NULL ,
    @login NVARCHAR(50) = NULL ,
    @name NVARCHAR(50) = NULL ,
    @surname NVARCHAR(50) = NULL ,
    @patronymic NVARCHAR(50) = NULL ,
    @mail NVARCHAR(50) = NULL ,
    @id_city INT = NULL ,
    @city NVARCHAR(50) = NULL ,
    @id_company INT = NULL ,
    @company NVARCHAR(100) = NULL ,
    @id_department INT = NULL ,
    @department NVARCHAR(150) = NULL ,
    @id_position INT = NULL ,
    @position NVARCHAR(100) = NULL ,
    @id_manager INT = NULL ,
    @manager NVARCHAR(150) = NULL ,
    @phone NVARCHAR(20) = NULL ,
    @mobile NVARCHAR(20) = NULL ,
    @info NVARCHAR(MAX) = NULL ,
    @id_state INT = NULL ,
    @user_state NVARCHAR(50) = NULL
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @log_params NVARCHAR(MAX) ,
            @id_program INT ,
            @var_str NVARCHAR(50)

        IF @id_program IS NULL
            BEGIN
                SELECT  @id_program = id_program
                FROM    programs p
                WHERE   p.enabled = 1
                        AND LOWER(p.sys_name) = LOWER(@program_name)
            END

        IF @action NOT LIKE 'get%'
            BEGIN
                SELECT  @log_params = CASE WHEN @action IS NULL THEN ''
                                           ELSE ' @action='
                                                + CONVERT(NVARCHAR, @action)
                                      END + CASE WHEN @sp_test IS NULL THEN ''
                                                 ELSE ' @sp_test='
                                                      + CONVERT(NVARCHAR, @sp_test)
                                            END
                        + CASE WHEN @user_sid IS NULL THEN ''
                               ELSE ' @user_sid='
                                    + CONVERT(NVARCHAR(50), @user_sid)
                          END + CASE WHEN @id_user IS NULL THEN ''
                                     ELSE ' @id_user='
                                          + CONVERT(NVARCHAR, @id_user)
                                END + CASE WHEN @id_et_user IS NULL THEN ''
                                           ELSE ' @id_et_user='
                                                + CONVERT(NVARCHAR, @id_et_user)
                                      END
                        + CASE WHEN @id_user_right IS NULL THEN ''
                               ELSE ' @id_user_right='
                                    + CONVERT(NVARCHAR, @id_user_right)
                          END + CASE WHEN @program_name IS NULL THEN ''
                                     ELSE ' @program_name='
                                          + CONVERT(NVARCHAR, @program_name)
                                END + CASE WHEN @right_name IS NULL THEN ''
                                           ELSE ' @right_name='
                                                + CONVERT(NVARCHAR(50), @right_name)
                                      END
                        + CASE WHEN @sys_name IS NULL THEN ''
                               ELSE ' @sys_name='
                                    + CONVERT(NVARCHAR(150), @sys_name)
                          END + CASE WHEN @login IS NULL THEN ''
                                     ELSE ' @login='
                                          + CONVERT(NVARCHAR(50), @login)
                                END + CASE WHEN @name IS NULL THEN ''
                                           ELSE ' @name='
                                                + CONVERT(NVARCHAR(50), @name)
                                      END + CASE WHEN @surname IS NULL THEN ''
                                                 ELSE ' @surname='
                                                      + CONVERT(NVARCHAR(50), @surname)
                                            END
                        + CASE WHEN @patronymic IS NULL THEN ''
                               ELSE ' @patronymic='
                                    + CONVERT(NVARCHAR(50), @patronymic)
                          END + CASE WHEN @mail IS NULL THEN ''
                                     ELSE ' @mail='
                                          + CONVERT(NVARCHAR(50), @mail)
                                END + CASE WHEN @id_city IS NULL THEN ''
                                           ELSE ' @id_city='
                                                + CONVERT(NVARCHAR, @id_city)
                                      END + CASE WHEN @city IS NULL THEN ''
                                                 ELSE ' @city='
                                                      + CONVERT(NVARCHAR(50), @city)
                                            END
                        + CASE WHEN @id_company IS NULL THEN ''
                               ELSE ' @id_company='
                                    + CONVERT(NVARCHAR, @id_company)
                          END + CASE WHEN @company IS NULL THEN ''
                                     ELSE ' @company='
                                          + CONVERT(NVARCHAR(100), @company)
                                END + CASE WHEN @id_department IS NULL THEN ''
                                           ELSE ' @id_department='
                                                + CONVERT(NVARCHAR, @id_department)
                                      END
                        + CASE WHEN @department IS NULL THEN ''
                               ELSE ' @department='
                                    + CONVERT(NVARCHAR(150), @department)
                          END + CASE WHEN @id_position IS NULL THEN ''
                                     ELSE ' @id_position='
                                          + CONVERT(NVARCHAR, @id_position)
                                END + CASE WHEN @position IS NULL THEN ''
                                           ELSE ' @position='
                                                + CONVERT(NVARCHAR(100), @position)
                                      END
                        + CASE WHEN @id_manager IS NULL THEN ''
                               ELSE ' @id_manager='
                                    + CONVERT(NVARCHAR, @id_manager)
                          END + CASE WHEN @phone IS NULL THEN ''
                                     ELSE ' @phone='
                                          + CONVERT(NVARCHAR(20), @phone)
                                END + CASE WHEN @mobile IS NULL THEN ''
                                           ELSE ' @mobile='
                                                + CONVERT(NVARCHAR(20), @mobile)
                                      END + CASE WHEN @info IS NULL THEN ''
                                                 ELSE ' @info='
                                                      + CONVERT(NVARCHAR(MAX), @info)
                                            END
                        + CASE WHEN @id_state IS NULL THEN ''
                               ELSE ' @id_state='
                                    + CONVERT(NVARCHAR, @id_state)
                          END + CASE WHEN @user_state IS NULL THEN ''
                                     ELSE ' @user_state='
                                          + CONVERT(NVARCHAR(50), @user_state)
                                END

                EXEC sk_log @action = 'insLog', @proc_name = 'ui_users',
                    @id_program = @id_program, @params = @log_params
            END

	--===================
	--Получение SID группы в AD
	--===================
        IF @action = 'getUserGroupSid'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                SELECT  ug.sid
                FROM    dbo.user_groups ug
                WHERE   ug.id_program = @id_program
                        AND ug.sys_name = @sys_name
            END
			--===================
			--Пользователь по SID в AD
			--===================
        ELSE
            IF @action = 'getUserBySid'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

			--Выбираем пользователя по SID, берем без условий включенности и даты так как нужен пользователь по SID а не просто работающий пользователь
                    SELECT  u.id_user ,
                            u.LOGIN ,
                            u.sid ,
                            u.full_name ,
                            u.display_name ,
                            u.mail ,
                            u.enabled ,
                            u.company
                    FROM    users u
                    WHERE   u.sid = @user_sid
                            AND u.old_id_user IS NULL
				--AND u.dattim1 <= GETDATE()
				--AND u.dattim2 > GETDATE()
				--AND u.enabled = 1
                END
				--===================
				--Пользователь по id_user
				--===================
            ELSE
                IF @action = 'getUserById'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END

				--Выбираем пользователя по SID, берем без условий включенности и даты так как нужен пользователь по SID а не просто работающий пользователь
                        SELECT  u.id_user ,
                                u.LOGIN ,
                                u.full_name ,
                                u.display_name ,
                                u.mail ,
                                u.enabled
                        FROM    dbo.users u
                        WHERE   u.id_user = @id_user
					--AND u.dattim1 <= GETDATE()
					--AND u.dattim2 > GETDATE()
					--AND u.enabled = 1
                    END
					--===================
					--Пользователь эталона по id_user
					--===================
                ELSE
                    IF @action = 'getEtUserByUserId'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END

                            SELECT  @id_et_user = u2eu.id_et_user
                            FROM    dbo.users2et_users u2eu
                            WHERE   u2eu.id_user = @id_user
                                    AND u2eu.enabled = 1
                                    AND u2eu.dattim1 <= GETDATE()
                                    AND u2eu.dattim2 > GETDATE()
						--SELECT [USERID] AS id_et_user
						--	,[USERNAME] AS et_display_name
						--	,[NAME] AS et_login
						--	,[PASSWORD] AS et_password
						--	,[AD_SDDL_SID] AS ad_sid
						--FROM [ufs-db2].[UNIT_WORK].[UNIT_WORK].[USERLIST] eu
						--WHERE eu.USERID = @id_et_user
                        END
						--===================
						--Список рабочих учетных записей
						--===================
                    ELSE
                        IF @action = 'getUsersList'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END

                                SELECT  [id_user] ,
                                        [login] ,
                                        [sid] ,
                                        [name] ,
                                        [surname] ,
                                        [patronymic] ,
                                        [full_name] ,
                                        [display_name] ,
                                        [mail] ,
                                        [id_city] ,
                                        [city] ,
                                        [id_company] ,
                                        [company] ,
                                        [id_department] ,
                                        [department] ,
                                        [id_position] ,
                                        [position] ,
                                        [id_manager] ,
                                        [manager] ,
                                        [phone] ,
                                        [mobile] ,
                                        [info] ,
                                        [id_state] ,
                                        [enabled] ,
                                        [dattim1] ,
                                        [dattim2] ,
                                        [old_id_user]
                                FROM    dbo.users u
                                WHERE   u.enabled = 1
                                        AND u.old_id_user IS NULL
                                        AND u.dattim1 <= GETDATE()
                                        AND u.dattim2 > GETDATE()
                                ORDER BY display_name
                            END
							--===================
							--Список рабочих учетных записей (список выбора)
							--===================
                        ELSE
                            IF @action = 'getUsersSelectionList'
                                BEGIN
                                    IF @sp_test IS NOT NULL
                                        BEGIN
                                            RETURN
                                        END

                                    SELECT  [id_user] AS id ,
                                            [display_name] AS NAME ,
                                            [login] ,
                                            sid
                                    FROM    dbo.users u
                                    WHERE   u.enabled = 1
                                            AND u.dattim1 <= GETDATE()
                                            AND u.dattim2 > GETDATE()
                                    ORDER BY display_name
                                END

	--===================
	--Вставка пользователя
	--===================
        IF @action = 'saveUser'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

    --            IF ( @id_user IS NULL
    --                 OR @id_user <= 0
    --               )
    --                AND @user_sid IS NOT NULL
    --                BEGIN
    --                    SELECT  @id_user = id_user
    --                    FROM    dbo.users u
    --                    WHERE enabled=1 and   u.sid = @user_sid
    --                            AND u.old_id_user IS NULL
    --                END

    --            IF @id_state IS NULL
    --                OR @id_state <= 0
    --                BEGIN
    --                    SELECT  @id_state = id_state
    --                    FROM    user_states us
    --                    WHERE   us.sys_name = @user_state
    --                END
				
				
				
				--if @id_user > 0
				--begin
				-- set @var_str = 'updUser'
				--end
				--else
				--begin
				--	set @var_str = 'insUser'
				--END
				
                SET @var_str = 'insUser'
				
                IF ( @user_sid IS NOT NULL
                     AND LTRIM(RTRIM(@user_sid)) <> ''
                     AND EXISTS ( SELECT    1
                                  FROM      dbo.users u
                                  WHERE     enabled = 1
                                            AND u.sid = @user_sid
                                            AND u.old_id_user IS NULL )
                   )
                    OR ( @id_user IS NOT NULL
                         AND @id_user > 0
                         AND EXISTS ( SELECT    1
                                      FROM      dbo.users
                                      WHERE     id_user = @id_user )
                       )
                    BEGIN
                        SET @var_str = 'updUser'
                        
                        SELECT  @id_user = id_user
                        FROM    dbo.users u
                        WHERE   enabled = 1
                                AND u.sid = @user_sid
                                AND u.old_id_user IS NULL
                    END
                    
                IF @id_state IS NULL
                    OR @id_state <= 0
                    BEGIN
                        SELECT  @id_state = id_state
                        FROM    user_states us
                        WHERE   us.sys_name = @user_state
                    END
				
				--select count(1) from users
				--count   --date_count
				--2507006 --20150428 1620
				
                EXEC sk_users @action = @var_str, @id_user = @id_user,
                    @login = @login, @sid = @user_sid, @name = @name,
                    @surname = @surname, @patronymic = @patronymic,
                    @mail = @mail, @id_city = @id_city, @city = @city,
                    @id_company = @id_company, @company = @company,
                    @id_department = @id_department, @department = @department,
                    @id_position = @id_position, @position = @position,
                    @id_manager = @id_manager, @manager = @manager,
                    @phone = @phone, @mobile = @mobile, @info = @info,
                    @id_state = @id_state

--UPD 09.09.2014
                --IF @id_user > 0
                --    BEGIN
                --        EXEC sk_users @action = 'updUser', @id_user = @id_user,
                --            @login = @login, @sid = @user_sid, @name = @name,
                --            @surname = @surname, @patronymic = @patronymic,
                --            @mail = @mail, @id_city = @id_city, @city = @city,
                --            @id_company = @id_company, @company = @company,
                --            @id_department = @id_department,
                --            @department = @department,
                --            @id_position = @id_position, @position = @position,
                --            @id_manager = @id_manager, @manager = @manager,
                --            @phone = @phone, @mobile = @mobile, @info = @info,
                --            @id_state = @id_state
                --    END
                --ELSE
                --    BEGIN
                --        EXEC @id_user = sk_users @action = 'insUser',
                --            @login = @login, @sid = @user_sid, @name = @name,
                --            @surname = @surname, @patronymic = @patronymic,
                --            @mail = @mail, @id_city = @id_city, @city = @city,
                --            @id_company = @id_company, @company = @company,
                --            @id_department = @id_department,
                --            @department = @department,
                --            @id_position = @id_position, @position = @position,
                --            @id_manager = @id_manager, @manager = @manager,
                --            @phone = @phone, @mobile = @mobile, @info = @info,
                --            @id_state = @id_state
                --    END
            END

	--===================
	--Устанавливает id_manager для всех пользователей
	--===================
        IF @action = 'setManagerId'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                IF @id_user IS NULL
                    AND @user_sid IS NOT NULL
                    BEGIN
                        SELECT  @id_user = id_user
                        FROM    users u
                        WHERE   u.sid = @user_sid
                                AND u.old_id_user IS NULL
                    END

                IF @manager IS NULL
                    OR @manager = ''
                    BEGIN
                        SELECT  @manager = manager
                        FROM    users u
                        WHERE   u.id_user = @id_user
                    END

                SELECT  @id_manager = id_user
                FROM    users u
                WHERE   u.sid = @manager
                        AND u.old_id_user IS NULL

		--Устанавливаем начальника только у НЕ уволенных пользователей
                IF EXISTS ( SELECT  1
                            FROM    users
                            WHERE   id_user = @id_user
                                    AND id_state IN (
                                    SELECT  id_state
                                    FROM    user_states us
                                    WHERE   us.sys_name != 'FIRED' ) )
                    BEGIN
                        IF @id_manager > 0
                            BEGIN
                                EXEC sk_users @action = 'updUser',
                                    @id_user = @id_user,
                                    @id_manager = @id_manager
                            END
                    END
            END
            
        IF @action = 'checkUserIsMoscou'
            BEGIN
                IF EXISTS ( SELECT  1
                            FROM    dbo.users
                            WHERE   old_id_user IS NULL
                                    AND city like '%Москва%'
                                    AND sid = @user_sid )
                    BEGIN
                        SELECT  1 AS result
                    END
                ELSE
                    BEGIN
                        SELECT  0 AS result
                    END
            END
    END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ui_users] TO [agreements_sp_exec]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ui_users] TO [UN1T\sqlUnit_prog]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ui_users] TO [sqlUnit_prog]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ui_users] TO [sqlChecker]
    AS [dbo];

