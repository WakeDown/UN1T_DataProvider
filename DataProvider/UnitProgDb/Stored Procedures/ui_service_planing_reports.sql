-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ui_service_planing_reports]
    @action NVARCHAR(50) ,
    @id_service_claim INT = NULL ,
    @id_service_engeneer INT = NULL ,
    @id_service_admin INT = NULL ,
    @id_contractor INT = NULL ,
    @date_begin DATETIME = NULL ,
    @date_end DATETIME = NULL ,
    @date_month DATE = NULL ,
    @is_done BIT = NULL ,
    @no_set BIT = NULL ,
    @id_manager INT = NULL ,
    @id_contract INT = NULL ,
    @id_device INT = NULL ,
    @data_source NVARCHAR(50) = NULL ,
    @rows_count INT = NULL ,
    @not_null_volume INT = NULL
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        IF @action = 'getDeviceCounterDetail'
            BEGIN
                                                
                  
                                                   
                DECLARE @new_id UNIQUEIDENTIFIER
                SET @new_id = NEWID()

                CREATE TABLE #tmp_device_counter_detail
                    (
                      id UNIQUEIDENTIFIER NOT NULL ,
                      id_contract INT NOT NULL ,
                      id_device INT NOT NULL ,
                      date_counter DATETIME NOT NULL ,
                      COUNTER INT ,
                      counter_color INT ,
                      counter_total INT ,
                      place NVARCHAR(50) NOT NULL ,
                      creator NVARCHAR(150) ,
                      date_create DATETIME NOT NULL ,
                      link_id INT ,
                      NAME NVARCHAR(150) ,
                      SOURCE NVARCHAR(10) ,
                      id_akt_scan INT ,
                      akt_scan_full_path NVARCHAR(500) ,
                      has_akt_scan BIT ,
                      row_num INT NOT NULL
                    )

                INSERT  INTO #tmp_device_counter_detail
                        SELECT  @new_id ,
                                id_contract ,
                                id_device ,
                                date_counter ,
                                counter ,
                                counter_color ,
                                counter_total ,
                                place ,
                                creator ,
                                date_create ,
                                link_id ,
                                name ,
                                source ,
                                id_akt_scan ,
                                akt_scan_full_path ,
                                has_akt_scan ,
                                row_num
                        FROM    ( SELECT    id_contract ,
                                            id_device ,
                                            date_counter ,
                                            counter ,
                                            counter_color ,
                                            counter_total ,
                                            place ,
                                            creator ,
                                            date_create ,
                                            link_id ,
                                            name ,
                                            source ,
                                            id_akt_scan ,
                                            akt_scan_full_path ,
                                            has_akt_scan ,
                                            ROW_NUMBER() OVER ( ORDER BY [date_counter] DESC, counter_total DESC ) AS row_num
                                  FROM      ( SELECT 
        --c.number ,
        --dbo.srvpl_get_device_name(t.id_device, NULL) AS device ,
        --ctr.name_inn AS contractor ,
                                                        t.id_contract ,
                                                        t.id_device ,
                                                        t.planing_date AS date_counter ,
                                                        t.counter ,
                                                        t.counter_colour AS counter_color ,
                                                        ISNULL(t.COUNTER, 0)
                                                        + ISNULL(t.counter_colour,
                                                              0) AS counter_total ,
                                                        t.place ,
                                                        ( SELECT
                                                              display_name
                                                          FROM
                                                              dbo.users AS u
                                                          WHERE
                                                              ( enabled = 1 )
                                                              AND ( id_user = t.id_creator )
                                                        ) AS creator ,
                                                        t.dattim1 AS date_create ,
                                                        link_id ,
                                                        name ,
                                                        source ,
                                                        id_akt_scan ,
                                                        akt_scan_full_path ,
                                                        CASE WHEN id_akt_scan IS NOT NULL
                                                             THEN 1
                                                             ELSE 0
                                                        END AS has_akt_scan
                                              FROM      ( SELECT
                                                              c2d.id_contract ,
                                                              c2d.id_device ,
                                                              d.dattim1 AS planing_date ,
                                                              d.counter ,
                                                              d.counter_colour ,
                                                              'srvpl_contract2devices' AS place ,
                                                              c2d.id_creator ,
                                                              c2d.dattim1 ,
                                                              c2d.id_contract2devices AS link_id ,
                                                              'Первоначальные показания' AS name ,
                                                              'eng' AS SOURCE ,
                                                              NULL AS id_akt_scan ,
                                                              NULL AS akt_scan_full_path
                                                          FROM
                                                              dbo.srvpl_contract2devices
                                                              AS c2d
                                                              INNER JOIN dbo.srvpl_devices
                                                              AS d ON d.id_device = c2d.id_device
                                                              INNER JOIN dbo.srvpl_contracts
                                                              AS c ON c2d.id_contract = c.id_contract
                                                          WHERE
                                                              ( d.enabled = 1 )
                                                              AND ( c.enabled = 1 )
                                                              AND ( c2d.enabled = 1 )
                                                              AND ( d.counter IS NOT NULL )
                                                              OR ( d.enabled = 1 )
                                                              AND ( c.enabled = 1 )
                                                              AND ( c2d.enabled = 1 )
                                                              AND ( d.counter_colour IS NOT NULL )
                                                          UNION ALL
                                                          SELECT
                                                              c2d.id_contract ,
                                                              c2d.id_device ,
                                                              cam.date_came AS planing_date ,
                                                              cam.counter ,
                                                              cam.counter_colour ,
                                                              'srvpl_service_claims' AS place ,
                                                              cam.id_creator ,
                                                              cam.dattim1 ,
                                                              cl.id_service_claim AS link_id ,
                                                              ( SELECT
                                                              display_name
                                                              FROM
                                                              dbo.users AS u
                                                              WHERE
                                                              ( enabled = 1 )
                                                              AND ( id_user = cam.id_service_engeneer )
                                                              ) AS name ,
                                                              'eng' AS SOURCE ,
                                                              cam.id_akt_scan ,
                                                              ( SELECT
                                                              full_path
                                                              FROM
                                                              dbo.srvpl_akt_scans sk
                                                              WHERE
                                                              sk.enabled = 1
                                                              AND sk.id_akt_scan = cam.id_akt_scan
                                                              ) AS akt_scan_full_path
                                                          FROM
                                                              dbo.srvpl_service_claims
                                                              AS cl
                                                              INNER JOIN dbo.srvpl_service_cames
                                                              AS cam ON cl.id_service_claim = cam.id_service_claim
                                                              INNER JOIN dbo.srvpl_contract2devices
                                                              AS c2d ON c2d.id_contract2devices = cl.id_contract2devices
                                                              INNER JOIN dbo.srvpl_devices
                                                              AS d ON d.id_device = c2d.id_device
                                                              INNER JOIN dbo.srvpl_contracts
                                                              AS c ON c2d.id_contract = c.id_contract
                                                          WHERE
                                                              ( d.enabled = 1 )
                                                              AND ( c.enabled = 1 )
                                                              AND ( c2d.enabled = 1 )
                                                              AND ( cl.enabled = 1 )
                                                              AND ( cam.enabled = 1 )
                                                          UNION ALL
                                                          SELECT
                                                              ( SELECT TOP ( 1 )
                                                              id_contract
                                                              FROM
                                                              dbo.srvpl_contracts
                                                              WHERE
                                                              ( enabled = 1 )
                                                              AND ( id_contractor = r.id_contractor )
                                                              AND ( dbo.srvpl_fnc(N'checkContractIsActiveOnMonth',
                                                              NULL,
                                                              id_contract,
                                                              r.date_request,
                                                              NULL) = '1' )
                                                              ) AS id_contract ,
                                                              id_device ,
                                                              date_request AS planing_date ,
                                                              counter ,
                                                              counter_color ,
                                                              'snmp_requests' AS place ,
                                                              NULL AS id_creator ,
                                                              dattim1 ,
                                                              r.id_requset AS link_id ,
                                                              'UN1T Счетчик' AS name ,
                                                              'un1t_cnt' AS source ,
                                                              NULL AS id_akt_scan ,
                                                              NULL AS akt_scan_full_path
                                                          FROM
                                                              dbo.snmp_requests
                                                              AS r
                                                        ) AS t
        --INNER JOIN dbo.srvpl_contracts AS c ON t.id_contract = c.id_contract
        --INNER JOIN dbo.srvpl_devices AS d ON t.id_device = d.id_device
        --INNER JOIN dbo.get_contractor(NULL) AS ctr ON c.id_contractor = ctr.id
                                            ) AS t2
                                  WHERE     id_contract = @id_contract
                                            AND id_device = @id_device
                                            AND ( ( @data_source IS NULL
                                                    OR @data_source = 'all'
                                                  )
                                                  OR ( @data_source IS NOT NULL
                                                       AND @data_source != 'all'
                                                       AND source = @data_source
                                                     )
                                                )
                                ) AS t3
                        ORDER BY row_num
                        --[date_counter] DESC, [counter] DESC
        
        --SELECT * FROM #tmp_device_counter_detail
        
        
        --CREATE TABLE #tmp_device_counter_detail2(
        
        --id UNIQUEIDENTIFIER NOT NULL ,
        --              id_contract INT NOT NULL ,
        --              id_device INT NOT NULL ,
        --              date_counter DATETIME NOT NULL ,
        --              COUNTER INT ,
        --              counter_prev INT,
        --              volume_counter INT,
        --              counter_color INT ,
        --              counter_color_prev INT,
        --              volume_counter_color INT,
        --              counter_total INT ,
        --              counter_total_prev INT,
        --              volume_counter_total INT,
        --              place NVARCHAR(50) NOT NULL ,
        --              creator NVARCHAR(150) ,
        --              date_create DATETIME NOT NULL ,
        --              link_id INT ,
        --              NAME NVARCHAR(150) ,
        --              SOURCE NVARCHAR(10) ,
        --              id_akt_scan INT ,
        --              akt_scan_full_path NVARCHAR(500) ,
        --              has_akt_scan BIT 
        --              ,
        --              row_num INT NOT NULL
                        
        --)
        
        --INSERT INTO #tmp_device_counter_detail2

                SELECT  *
                FROM    ( SELECT    * ,
                                    ROW_NUMBER() OVER ( ORDER BY [date_counter] DESC, [counter_total] DESC ) AS row_num
                          FROM      ( SELECT    date_counter ,
                    --CASE WHEN @group_by_date = 1 THEN MAX(counter) ELSE counter end AS counter ,
                    --CASE WHEN @group_by_date = 1 THEN MAX(volume_counter) ELSE volume_counter end AS volume_counter ,
                    --CASE WHEN @group_by_date = 1 THEN MAX(counter_color) ELSE counter_color end AS counter_color ,
                    --CASE WHEN @group_by_date = 1 THEN MAX(volume_counter_color) ELSE volume_counter_color end AS volume_counter_color ,
                    --CASE WHEN @group_by_date = 1 THEN MAX(counter_total) ELSE counter_total end AS counter_total ,
                    --CASE WHEN @group_by_date = 1 THEN MAX(volume_counter_total) ELSE volume_counter_total end AS volume_counter_total ,
                                                MAX(counter) AS counter ,
                                                MAX(volume_counter) AS volume_counter ,
                                                MAX(counter_color) AS counter_color ,
                                                MAX(volume_counter_color) AS volume_counter_color ,
                                                MAX(counter_total) AS counter_total ,
                                                MAX(volume_counter_total) AS volume_counter_total ,
                                                name ,
                                                source ,
                                                id_akt_scan ,
                                                akt_scan_full_path ,
                                                has_akt_scan
                                      FROM      ( SELECT    t4.id_contract ,
                                                            t4.id_device ,
                                                            CONVERT(DATE, t4.date_counter) AS date_counter ,
                                                            t4.counter ,
                                                            t4.counter_prev ,
                                                            t4.volume_counter ,
                                                            t4.counter_color ,
                                                            t4.counter_color_prev ,
                                                            t4.volume_counter_color ,
                                                            t4.counter_total ,
                                                            t4.counter_total_prev ,
                                                            t4.volume_counter_total ,
                                                            t4.place ,
                                                            t4.creator ,
                                                            t4.date_create ,
                                                            t4.link_id ,
                                                            t4.name ,
                                                            t4.source ,
                                                            t4.id_akt_scan ,
                                                            t4.akt_scan_full_path ,
                                                            t4.has_akt_scan 
                        --,
                        --t4.row_num
                                                  FROM      ( SELECT
                                                              t3.id_contract ,
                                                              t3.id_device ,
                                                              t3.date_counter ,
                                                              t3.counter ,
                                                              t3.counter_prev ,
                                                              CASE
                                                              WHEN t3.counter_prev IS NOT NULL
                                                              AND t3.COUNTER IS NOT NULL
                                                              THEN t3.counter
                                                              - t3.counter_prev
                                                              ELSE NULL
                                                              END AS volume_counter ,
                                                              t3.counter_color ,
                                                              t3.counter_color_prev ,
                                                              CASE
                                                              WHEN t3.counter_color_prev IS NOT NULL
                                                              AND t3.counter_color IS NOT NULL
                                                              THEN t3.counter_color
                                                              - t3.counter_color_prev
                                                              ELSE NULL
                                                              END AS volume_counter_color ,
                                                              t3.counter_total ,
                                                              t3.counter_total_prev ,
                                                              CASE
                                                              WHEN t3.counter_total_prev IS NOT NULL
                                                              AND t3.counter_total IS NOT NULL
                                                              THEN t3.counter_total
                                                              - t3.counter_total_prev
                                                              ELSE NULL
                                                              END AS volume_counter_total ,
                                                              t3.place ,
                                                              t3.creator ,
                                                              t3.date_create ,
                                                              t3.link_id ,
                                                              t3.name ,
                                                              t3.source ,
                                                              t3.id_akt_scan ,
                                                              t3.akt_scan_full_path ,
                                                              t3.has_akt_scan 
                                    --,
                                    --t3.row_num
                                                              FROM
                                                              ( SELECT
                                                              t1.id_contract ,
                                                              t1.id_device ,
                                                              t1.date_counter ,
                                                              t1.counter ,
                                                              t2.counter AS counter_prev ,
                                                              t1.counter_color ,
                                                              t2.counter_color AS counter_color_prev ,
                                                              t1.counter_total ,
                                                              t2.counter_total AS counter_total_prev ,
                                                              t1.place ,
                                                              t1.creator ,
                                                              t1.date_create ,
                                                              t1.link_id ,
                                                              t1.name ,
                                                              t1.source ,
                                                              t1.id_akt_scan ,
                                                              t1.akt_scan_full_path ,
                                                              t1.has_akt_scan 
                                                --,
                                                --t1.row_num
                                                              FROM
                                                              #tmp_device_counter_detail t1
                                                              LEFT OUTER JOIN #tmp_device_counter_detail t2 ON t1.row_num = ( t2.row_num
                                                              - 1 )
                                                              WHERE
                                                              t1.id = @new_id
                                                              ) AS t3
                                                            ) AS t4
                                                  WHERE     ( ( @not_null_volume IS NULL
                                                              OR @not_null_volume < 0
                                                              )
                                                              OR ( @not_null_volume IS NOT NULL
                                                              AND @not_null_volume = 1
                                                              AND ( volume_counter_total IS NULL
                                                              OR volume_counter_total != 0
                                                              )
                                                              )
                                                              OR ( @not_null_volume IS NOT NULL
                                                              AND @not_null_volume = 0
                                                              AND volume_counter_total = 0
                                                              )
                                                            )
                                                ) AS t5
                                      GROUP BY  date_counter ,
                                                name ,
                                                SOURCE ,
                                                id_akt_scan ,
                                                akt_scan_full_path ,
                                                has_akt_scan
        --CASE WHEN @group_by_date = 1 THEN date_counter end,
        --            --counter ,
        --            --volume_counter ,
        --            --counter_color ,
        --            --volume_counter_color ,
        --            --counter_total ,
        --            --volume_counter_total ,
        --            CASE WHEN @group_by_date = 1 THEN name  end,
        --            CASE WHEN @group_by_date = 1 THEN source  end,
        --            CASE WHEN @group_by_date = 1 THEN id_akt_scan  end,
        --            CASE WHEN @group_by_date = 1 THEN akt_scan_full_path  end,
        --            CASE WHEN @group_by_date = 1 THEN has_akt_scan  end
                                    ) AS t6
                        ) AS tbl
                WHERE   ( ( @rows_count IS NULL
                            OR @rows_count <= 0
                          )
                          OR ( @rows_count > 0
                               AND row_num <= @rows_count
                             )
                        )
       
        
                
                --SELECT * FROM #tmp_device_counter_detail
                
                DROP TABLE #tmp_device_counter_detail
                
                ------Пересчитываем объем печати        
                ----SELECT id_contract , id_device, CONVERT(date, date_counter, 102) AS date_counter, counter, counter_prev, volume_counter, counter_color, 
                ----counter_color_prev, volume_counter_color, counter_total, counter_total_prev, volume_counter_total, place, creator, date_create, link_id, 
                ----name, SOURCE, id_akt_scan, akt_scan_full_path, has_akt_scan
                ----FROM (        
                --SELECT    t3.id_contract ,
                --                    t3.id_device ,
                --                    t3.date_counter ,
                --                    t3.counter ,
                --                    t3.counter_prev ,
                --                    CASE WHEN t3.counter_prev IS NOT NULL AND t3.COUNTER IS NOT NULL
                --                         THEN t3.counter
                --                              - t3.counter_prev
                --                         ELSE NULL
                --                    END AS volume_counter ,
                --                    t3.counter_color ,
                --                    t3.counter_color_prev ,
                --                    CASE WHEN t3.counter_color_prev IS NOT NULL AND t3.counter_color IS NOT NULL
                --                         THEN t3.counter_color
                --                              - t3.counter_color_prev
                --                         ELSE NULL
                --                    END AS volume_counter_color ,
                --                    t3.counter_total ,
                --                    t3.counter_total_prev ,
                --                    CASE WHEN t3.counter_total_prev IS NOT NULL AND t3.counter_total IS NOT NULL
                --                         THEN t3.counter_total
                --                              - t3.counter_total_prev
                --                         ELSE NULL
                --                    END AS volume_counter_total ,
                --                    t3.place ,
                --                    t3.creator ,
                --                    t3.date_create ,
                --                    t3.link_id ,
                --                    t3.name ,
                --                    t3.source ,
                --                    t3.id_akt_scan ,
                --                    t3.akt_scan_full_path ,
                --                    t3.has_akt_scan,
                --                    t3.row_num                                                
                --          FROM      ( SELECT    t1.id_contract ,
                --                                t1.id_device ,
                --                                t1.date_counter ,
                --                                t1.counter ,
                --                                t2.counter AS counter_prev ,
                --                                t1.counter_color ,
                --                                t2.counter_color AS counter_color_prev ,
                --                                t1.counter_total ,
                --                                t2.counter_total AS counter_total_prev ,
                --                                t1.place ,
                --                                t1.creator ,
                --                                t1.date_create ,
                --                                t1.link_id ,
                --                                t1.name ,
                --                                t1.source ,
                --                                t1.id_akt_scan ,
                --                                t1.akt_scan_full_path ,
                --                                t1.has_akt_scan,
                --                                ROW_NUMBER() OVER ( ORDER BY t1.date_counter DESC, t1.counter_total DESC ) AS row_num 
                --                      FROM      #tmp_device_counter_detail2 t1
                --                                LEFT OUTER JOIN #tmp_device_counter_detail2 t2 ON t1.row_num = ( t2.row_num
                --                                              - 1 )
                --                      WHERE     t1.id = @new_id
                --                    ) AS t3
                                    
                                    
                --                    ) AS t4
                ----                    GROUP BY 
                ----                    id_contract , id_device, CONVERT(date, date_counter, 102), counter, counter_prev, volume_counter, counter_color, 
                ----counter_color_prev, volume_counter_color, counter_total, counter_total_prev, volume_counter_total, place, creator, date_create, link_id, 
                ----name, SOURCE, id_akt_scan, akt_scan_full_path, has_akt_scan
                ----ORDER BY CONVERT(date, date_counter, 102) DESC, counter_total desc
                                    
                --                --    WHERE   ( ( @rows_count IS NULL
                --                --    OR @rows_count <= 0
                --                --  )
                --                --  OR ( @rows_count > 0
                --                --       AND row_num <= @rows_count
                --                --     )
                --                --) 
                --        --        AND ( (@not_null_volume IS NULL or @not_null_volume < 0)
                --        --  OR ( @not_null_volume IS NOT NULL
                --        --       AND @not_null_volume = 1
                --        --       AND volume_counter_total IS NOT NULL
                --        --       AND volume_counter_total != 0
                --        --     )
                --        --  OR ( @not_null_volume IS NOT NULL
                --        --       AND @not_null_volume = 0
                --        --       AND ( volume_counter_total IS  NULL or volume_counter_total = 0
                --        --           )
                --        --     )
                --        --)
                        
                
                ----SELECT * FROM #tmp_device_counter_detail2
                
                --DROP TABLE #tmp_device_counter_detail2
                                            
                                          
            END
    END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ui_service_planing_reports] TO [sqlUnit_prog]
    AS [dbo];

