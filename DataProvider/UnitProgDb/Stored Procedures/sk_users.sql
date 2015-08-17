
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sk_users]
	-- Add the parameters for the stored procedure here
    @action NVARCHAR(50) = NULL ,
    @sp_test BIT = NULL --переменная для тестирования
    ,
    @id_user INT = NULL ,
    @login NVARCHAR(50) = NULL ,
    @sid NVARCHAR(50) = NULL ,
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
    @program_name NVARCHAR(150) = NULL
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        DECLARE @log_params NVARCHAR(MAX) ,
            @id_program INT

        IF @id_program IS NULL
            BEGIN
                SELECT  @id_program = id_program
                FROM    programs p
                WHERE   p.enabled = 1
                        AND LOWER(p.sys_name) = LOWER(@program_name)
            END

       
        SELECT  @log_params = CASE WHEN @action IS NULL THEN ''
                                   ELSE ' @action='
                                        + CONVERT(NVARCHAR, @action)
                              END + CASE WHEN @sp_test IS NULL THEN ''
                                         ELSE ' @sp_test='
                                              + CONVERT(NVARCHAR, @sp_test)
                                    END + CASE WHEN @sid IS NULL THEN ''
                                               ELSE ' @sid='
                                                    + CONVERT(NVARCHAR(50), @sid)
                                          END
                + CASE WHEN @id_user IS NULL THEN ''
                       ELSE ' @id_user=' + CONVERT(NVARCHAR, @id_user)
                  END + CASE WHEN @program_name IS NULL THEN ''
                             ELSE ' @program_name='
                                  + CONVERT(NVARCHAR, @program_name)
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
                             ELSE ' @mail=' + CONVERT(NVARCHAR(50), @mail)
                        END + CASE WHEN @id_city IS NULL THEN ''
                                   ELSE ' @id_city='
                                        + CONVERT(NVARCHAR, @id_city)
                              END + CASE WHEN @city IS NULL THEN ''
                                         ELSE ' @city='
                                              + CONVERT(NVARCHAR(50), @city)
                                    END
                + CASE WHEN @id_company IS NULL THEN ''
                       ELSE ' @id_company=' + CONVERT(NVARCHAR, @id_company)
                  END + CASE WHEN @company IS NULL THEN ''
                             ELSE ' @company='
                                  + CONVERT(NVARCHAR(100), @company)
                        END + CASE WHEN @id_department IS NULL THEN ''
                                   ELSE ' @id_department='
                                        + CONVERT(NVARCHAR, @id_department)
                              END + CASE WHEN @department IS NULL THEN ''
                                         ELSE ' @department='
                                              + CONVERT(NVARCHAR(150), @department)
                                    END
                + CASE WHEN @id_position IS NULL THEN ''
                       ELSE ' @id_position=' + CONVERT(NVARCHAR, @id_position)
                  END + CASE WHEN @position IS NULL THEN ''
                             ELSE ' @position='
                                  + CONVERT(NVARCHAR(100), @position)
                        END + CASE WHEN @id_manager IS NULL THEN ''
                                   ELSE ' @id_manager='
                                        + CONVERT(NVARCHAR, @id_manager)
                              END + CASE WHEN @phone IS NULL THEN ''
                                         ELSE ' @phone='
                                              + CONVERT(NVARCHAR(20), @phone)
                                    END + CASE WHEN @mobile IS NULL THEN ''
                                               ELSE ' @mobile='
                                                    + CONVERT(NVARCHAR(20), @mobile)
                                          END
                + CASE WHEN @info IS NULL THEN ''
                       ELSE ' @info=' + CONVERT(NVARCHAR(MAX), @info)
                  END + CASE WHEN @id_state IS NULL THEN ''
                             ELSE ' @id_state=' + CONVERT(NVARCHAR, @id_state)
                        END

        EXEC sk_log @action = 'insLog', @proc_name = 'sk_users',
            @id_program = @id_program, @params = @log_params
           

        IF @action = 'insUser'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                INSERT  INTO [dbo].[users]
                        ( [login] ,
                          [sid] ,
                          [name] ,
                          [surname] ,
                          [patronymic] ,                          
                          full_name ,
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
                          [dattim2]
			            )
                VALUES  ( @login ,
                          @sid ,
                          @name ,
                          @surname ,
                          @patronymic ,
                          dbo.prepare_name('full', @surname, @name, @patronymic) ,
                          dbo.prepare_name('short', @surname, @name, @patronymic) ,
                          @mail ,
                          @id_city ,
                          @city ,
                          @id_company ,
                          @company ,
                          @id_department ,
                          @department ,
                          @id_position ,
                          @position ,
                          @id_manager ,
                          @manager ,
                          @phone ,
                          @mobile ,
                          @info ,
                          @id_state ,
                          1 ,
                          GETDATE() ,
                          '3.3.3333'
			            )
            END
        ELSE
            IF @action = 'updUser'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END



                    SELECT  @login = ISNULL(@login,
                                            ( SELECT    LOGIN
                                              FROM      users
                                              WHERE     id_user = @id_user
                                            ))

                    SELECT  @name = ISNULL(@name, ( SELECT  NAME
                                                    FROM    users
                                                    WHERE   id_user = @id_user
                                                  ))

                    SELECT  @surname = ISNULL(@surname,
                                              ( SELECT  surname
                                                FROM    users
                                                WHERE   id_user = @id_user
                                              ))

                    SELECT  @patronymic = ISNULL(@patronymic,
                                                 ( SELECT   patronymic
                                                   FROM     users
                                                   WHERE    id_user = @id_user
                                                 ))

                    SELECT  @mail = ISNULL(@mail, ( SELECT  mail
                                                    FROM    users
                                                    WHERE   id_user = @id_user
                                                  ))

                    SELECT  @id_city = ISNULL(@id_city,
                                              ( SELECT  id_city
                                                FROM    users
                                                WHERE   id_user = @id_user
                                              ))

                    SELECT  @city = ISNULL(@city, ( SELECT  city
                                                    FROM    users
                                                    WHERE   id_user = @id_user
                                                  ))

                    SELECT  @id_company = ISNULL(@id_company,
                                                 ( SELECT   id_company
                                                   FROM     users
                                                   WHERE    id_user = @id_user
                                                 ))

                    SELECT  @id_department = ISNULL(@id_department,
                                                    ( SELECT  id_department
                                                      FROM    users
                                                      WHERE   id_user = @id_user
                                                    ))

                    SELECT  @department = ISNULL(@department,
                                                 ( SELECT   department
                                                   FROM     users
                                                   WHERE    id_user = @id_user
                                                 ))

                    SELECT  @id_position = ISNULL(@id_position,
                                                  ( SELECT  id_position
                                                    FROM    users
                                                    WHERE   id_user = @id_user
                                                  ))

                    SELECT  @position = ISNULL(@position,
                                               ( SELECT position
                                                 FROM   users
                                                 WHERE  id_user = @id_user
                                               ))

                    SELECT  @id_manager = ISNULL(@id_manager,
                                                 ( SELECT   id_manager
                                                   FROM     users
                                                   WHERE    id_user = @id_user
                                                 ))

                    SELECT  @manager = ISNULL(@manager,
                                              ( SELECT  manager
                                                FROM    users
                                                WHERE   id_user = @id_user
                                              ))

                    SELECT  @phone = ISNULL(@phone,
                                            ( SELECT    phone
                                              FROM      users
                                              WHERE     id_user = @id_user
                                            ))

                    SELECT  @mobile = ISNULL(@mobile,
                                             ( SELECT   mobile
                                               FROM     users
                                               WHERE    id_user = @id_user
                                             ))

                    SELECT  @info = ISNULL(@info, ( SELECT  info
                                                    FROM    users
                                                    WHERE   id_user = @id_user
                                                  ))

                    SELECT  @id_state = ISNULL(@id_state,
                                               ( SELECT id_state
                                                 FROM   users
                                                 WHERE  id_user = @id_user
                                               ))
                                               
                                              SELECT  @company = ISNULL(@company,
                                               ( SELECT company
                                                 FROM   users
                                                 WHERE  id_user = @id_user
                                               )) 

			--Проверяем на наличие отличий
                    IF NOT EXISTS ( SELECT  1
                                    FROM    users u
                                    WHERE   u.id_user = @id_user
                                            AND LOWER(u.LOGIN) = LOWER(@login)
                                            AND lower(u.sid) = lower(@sid)
                                            AND lower(u.NAME) = lower(@name)
                                            AND lower(u.surname) = lower(@surname)
                                            AND lower(u.patronymic) = lower(@patronymic)
                                            AND LOWER(u.mail) = LOWER(@mail)
                                            --AND u.id_city = @id_city
                                            AND lower(u.city) = lower(@city)
                                            --AND u.id_company = @id_company
                                            AND lower(u.company) = lower(@company)
                                            --AND u.id_department = @id_department
                                            AND lower(u.department) = lower(@department)
                                            --AND u.id_position = @id_position
                                            AND lower(u.position) = lower(@position)
                                            AND u.id_manager = @id_manager
                                            AND lower(u.manager) = lower(@manager)
                                            AND lower(u.phone) = lower(@phone)
                                            AND lower(u.mobile) = lower(@mobile)
                                            AND lower(u.info) = lower(@info)
                                            AND u.id_state = @id_state)
                        BEGIN
                            INSERT  INTO [dbo].[users]
                                    ( [sid] ,
                                      [login] ,
                                      [full_name] ,
                                      [display_name] ,
                                      [id_position] ,
                                      [id_manager] ,
                                      [id_department] ,
                                      [name] ,
                                      [surname] ,
                                      [patronymic] ,
                                      [position] ,
                                      [phone] ,
                                      [mobile] ,
                                      [manager] ,
                                      [mail] ,
                                      [info] ,
                                      [id_city] ,
                                      [city] ,
                                      [id_company] ,
                                      [company] ,
                                      [department] ,
                                      [join_date] ,
                                      [birth_date] ,
                                      [id_state] ,
                                      [dattim1] ,
                                      [dattim2] ,
                                      [enabled] ,
                                      old_id_user
					                )
                                    SELECT  [sid] ,
                                            [login] ,
                                            [full_name] ,
                                            [display_name] ,
                                            [id_position] ,
                                            [id_manager] ,
                                            [id_department] ,
                                            [name] ,
                                            [surname] ,
                                            [patronymic] ,
                                            [position] ,
                                            [phone] ,
                                            [mobile] ,
                                            [manager] ,
                                            [mail] ,
                                            [info] ,
                                            [id_city] ,
                                            [city] ,
                                            [id_company] ,
                                            [company] ,
                                            [department] ,
                                            [join_date] ,
                                            [birth_date] ,
                                            [id_state] ,
                                            ISNULL(( SELECT TOP 1
                                                    uu.dattim2
                                             FROM   dbo.users uu
                                             WHERE  uu.old_id_user = u.id_user
                                             ORDER BY uu.old_id_user DESC
                                           ), u.dattim1) ,
                                            GETDATE() ,
                                            0 ,
                                            [id_user]
                                    FROM    dbo.users u
                                    WHERE   u.id_user = @id_user

                            UPDATE  [dbo].[users]
                            SET     [login] = @login ,
                                    [name] = @name ,
                                    [surname] = @surname ,
                                    [patronymic] = @patronymic ,
                                    [full_name] = dbo.prepare_name('full', @surname, @name, @patronymic) ,
                                    [display_name] = dbo.prepare_name('short', @surname, @name, @patronymic) ,
                                    [mail] = @mail ,
                                    [id_city] = @id_city ,
                                    [city] = @city ,
                                    [id_company] = @id_company ,
                                    [company] = @company ,
                                    [id_department] = @id_department ,
                                    [department] = @department ,
                                    [id_position] = @id_position ,
                                    [position] = @position ,
                                    [id_manager] = @id_manager ,
                                    [manager] = @manager ,
                                    [phone] = @phone ,
                                    [mobile] = @mobile ,
                                    [info] = @info ,
                                    [id_state] = @id_state
                            WHERE   id_user = @id_user
                        END
                END
    END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[sk_users] TO [sqlChecker]
    AS [dbo];

