
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ui_unit]
    @action NVARCHAR(50) = NULL ,
    @sp_test BIT = NULL --переменная для тестирования
    ,
    @user_sid NVARCHAR(50) = NULL ,
    @id_user INT = NULL ,
    @id_et_user INT = NULL ,
    @program_name NVARCHAR(150) = NULL ,
    @id_contractor INT = NULL ,
    @have_moscow_access BIT = 0 ,
    @name NVARCHAR(150) = NULL ,
    @id_city INT = NULL ,
    @id_creator INT = NULL ,
    @region NVARCHAR(150) = NULL ,
    @area NVARCHAR(150) = NULL ,
    @locality NVARCHAR(100) = NULL ,
    @coordinates GEOGRAPHY = NULL ,
    @coord NVARCHAR(50) = NULL ,
    @filter_text NVARCHAR(150) = NULL
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
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
                                    + CONVERT(NVARCHAR, @user_sid)
                          END + CASE WHEN @id_user IS NULL THEN ''
                                     ELSE ' @id_user='
                                          + CONVERT(NVARCHAR, @id_user)
                                END + CASE WHEN @id_et_user IS NULL THEN ''
                                           ELSE ' @id_et_user='
                                                + CONVERT(NVARCHAR, @id_et_user)
                                      END
                        + CASE WHEN @id_contractor IS NULL THEN ''
                               ELSE ' @id_contractor='
                                    + CONVERT(NVARCHAR, @id_contractor)
                          END + CASE WHEN @program_name IS NULL THEN ''
                                     ELSE ' @program_name='
                                          + CONVERT(NVARCHAR(150), @program_name)
                                END
                        + CASE WHEN @have_moscow_access IS NULL THEN ''
                               ELSE ' @have_moscow_access='
                                    + CONVERT(NVARCHAR(150), @have_moscow_access)
                          END + CASE WHEN @name IS NULL THEN ''
                                     ELSE ' @name='
                                          + CONVERT(NVARCHAR(150), @name)
                                END + CASE WHEN @id_city IS NULL THEN ''
                                           ELSE ' @id_city='
                                                + CONVERT(NVARCHAR(150), @id_city)
                                      END
                        + CASE WHEN @id_creator IS NULL THEN ''
                               ELSE ' @id_creator='
                                    + CONVERT(NVARCHAR(150), @id_creator)
                          END + CASE WHEN @region IS NULL THEN ''
                                     ELSE ' @region='
                                          + CONVERT(NVARCHAR(150), @region)
                                END + CASE WHEN @area IS NULL THEN ''
                                           ELSE ' @area='
                                                + CONVERT(NVARCHAR(150), @area)
                                      END
                        + CASE WHEN @locality IS NULL THEN ''
                               ELSE ' @locality='
                                    + CONVERT(NVARCHAR(100), @locality)
                          END + CASE WHEN @coordinates IS NULL THEN ''
                                     ELSE ' @coordinates='
                                          + CONVERT(NVARCHAR(50), @coordinates)
                                END + CASE WHEN @coord IS NULL THEN ''
                                           ELSE ' @coord='
                                                + CONVERT(NVARCHAR(50), @coord)
                                      END
                        + CASE WHEN @filter_text IS NULL THEN ''
                               ELSE ' @filter_text='
                                    + CONVERT(NVARCHAR(150), @filter_text)
                          END 

                EXEC sk_log @action = 'insLog', @proc_name = 'ui_unit',
                    @id_program = @id_program, @params = @log_params
            END

--===================
	--Список городов (список выбора)
	--===================
        IF @action = 'getCitiesSelectionList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
			
                SELECT  *
                FROM    ( SELECT    c.id_city AS id ,
                                    dbo.get_city_full_name(c.id_city) AS NAME ,
                                    order_num
                          FROM      cities c
                          WHERE     c.enabled = 1
                        ) AS t
                WHERE   ( ( @name IS NULL
                            or LTRIM(RTRIM(@name)) = ''
                          )
                          OR ( @name IS NOT NULL
                               AND t.NAME LIKE '%' + @name + '%'
                             )
                        )
                ORDER BY t.order_num ,
                        t.NAME
            END
        ELSE
            IF @action = 'getCityList'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END
				
                    SELECT  t.id_city ,
                            ISNULL(t.region, '-') AS region ,
                            ISNULL(t.area, '-') AS area ,
                            ISNULL(t.name, '-') AS name ,
                            ISNULL(t.locality, '-') AS locality ,
                            coord
                    FROM    dbo.cities t
                    WHERE   t.enabled = 1
                --<Filter
                --Name
                            AND ( @name IS NULL
                                  OR ( @name IS NOT NULL
                                       AND t.NAME LIKE '%' + @name + '%'
                                     )
                                )
                                --region
                            AND ( @region IS NULL
                                  OR ( @region IS NOT NULL
                                       AND t.region LIKE '%' + @region + '%'
                                     )
                                )
                                --Area
                            AND ( @area IS NULL
                                  OR ( @area IS NOT NULL
                                       AND t.area LIKE '%' + @area + '%'
                                     )
                                )
                                --locality
                            AND ( @locality IS NULL
                                  OR ( @locality IS NOT NULL
                                       AND t.locality LIKE '%' + @locality
                                       + '%'
                                     )
                                )
                --</Filter>
                    ORDER BY t.region ,
                            t.area ,
                            t.name ,
                            t.locality DESC
                END
            ELSE
                IF @action = 'getCity'
                    BEGIN
                        SELECT  [id_city] ,
                                [name] ,
                                region ,
                                area ,
                                locality ,
                                coordinates ,
                                coord ,
                                dbo.get_city_full_name(c.id_city) AS collected_name
                        FROM    dbo.cities c
                        WHERE   c.id_city = @id_city
                    END
                ELSE
                    IF @action = 'saveCity'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END
                                                                
                            SET @var_str = 'insCity'
                                
                            IF EXISTS ( SELECT  1
                                        FROM    dbo.cities t
                                        WHERE   t.id_city = @id_city )
                                BEGIN
                                    SET @var_str = 'updCity'
                                END
                            ELSE
                                BEGIN
                                    EXEC @id_city = dbo.sk_unit @action = @var_str,
                                        @id_city = @id_city, @name = @name,
                                        @id_creator = @id_creator,
                                        @region = @region, @area = @area,
                                        @locality = @locality,
                                        @coordinates = @coordinates,
                                        @coord = @coord
                                
                                    SELECT  @id_city AS id_city                             
                                END												
                        END
                    ELSE
                        IF @action = 'closeCity'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END
                                EXEC dbo.sk_unit @action = N'closeCity',
                                    @is_close = 1, @id_city = @id_city,
                                    @id_creator = @id_creator
                            END


	--===================
	--Список подразделений (список выбора)
	--===================
        IF @action = 'getDepartmentSelectionList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
	
                SELECT  d.id_department AS id ,
                        d.display_name AS NAME
                FROM    departments d
                WHERE   d.enabled = 1
                        AND d.dattim1 <= GETDATE()
                        AND d.dattim2 > GETDATE()
                        --Органичение доступа к филиалу в Москве
                        AND ( ( @have_moscow_access = 0
                                AND ( d.sys_name IS NULL
                                      OR d.sys_name NOT IN ( 'UNITMOSCOW' )
                                    )
                              )
                              OR @have_moscow_access = 1
                            )
                ORDER BY d.order_num ,
                        d.NAME
            END

	--===================
	--Список организаций (список выбора)
	--===================
        IF @action = 'getCompanySelectionList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
	
                SELECT  c.id_company AS id ,
                        c.display_name AS NAME
                FROM    companies c
                WHERE   c.enabled = 1
                        AND c.dattim1 <= GETDATE()
                        AND c.dattim2 > GETDATE()
                        --Органичение доступа к филиалу в Москве
                        AND ( ( @have_moscow_access = 0
                                AND ( c.sys_name IS NULL
                                      OR c.sys_name NOT IN ( 'UNITMOSCOW' )
                                    )
                              )
                              OR @have_moscow_access = 1
                            )
                ORDER BY c.order_num ,
                        c.NAME
            END

	--===================
	--Список контрагентов из программы Эталон (список выбора)
	--===================
        IF @action = 'getContractorSelectionList'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
				
                SELECT  id ,
                        name_inn AS name ,
                        full_name ,
                        inn
                FROM    dbo.get_contractor(NULL) AS ctr
                WHERE   --FILTER
                        ( @filter_text IS NULL
                          OR ( @filter_text IS NOT NULL
                               AND ctr.name LIKE '%' + @filter_text + '%'
                             )
                        )
                           --ID_CONTRACTOR
                        AND ( ( @id_contractor IS NULL
                                OR @id_contractor <= 0
                              )
                              OR ( @id_contractor > 0
                                   AND ctr.id = @id_contractor
                                 )
                            )
                ORDER BY ctr.inn ,
                        ctr.full_name
	
                /*SELECT 
						--FOR TEST
						TOP 100  
						--/FOR TEST
						ctr.recordid AS id ,
                        ctr.o2s5xclow3h + ' (ИНН '
                        + CONVERT(NVARCHAR, ctr.o2s5xclow3t) + ')' AS name ,
                        ctr.o2s5xclow3h AS full_name ,
                        ctr.o2s5xclow3t AS inn
                FROM    [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_o2s5xclp1y3 ctr
                WHERE   ctr.recordid > 0 /*ctr.enabled = 1
										AND ctr.dattim1 <= GETDATE()
										AND ctr.dattim2 > GETDATE()*/
                ORDER BY ctr.o2s5xclow3t ,
                        ctr.o2s5xclow3h*/
            END
	
	--===================
	--СИмя контрагента из программы Эталон
	--===================
        IF @action = 'getContractorData'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
				
                SELECT  name ,
                        inn
                FROM    dbo.get_contractor(@id_contractor) AS ctr
                ORDER BY ctr.inn ,
                        ctr.full_name
				
                /*SELECT  ctr.o2s5xclsha0 AS NAME ,
                        ctr.o2s5xclow3t AS inn
                FROM    [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_o2s5xclp1y3 ctr
                WHERE   ctr.recordid = @id_contractor*/
            END
    END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ui_unit] TO [agreements_sp_exec]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ui_unit] TO [UN1T\sqlUnit_prog]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ui_unit] TO [sqlUnit_prog]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ui_unit] TO [sqlChecker]
    AS [dbo];

