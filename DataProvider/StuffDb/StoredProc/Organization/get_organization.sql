CREATE PROCEDURE [dbo].[get_organization] @id INT = NULL, @sys_name nvarchar(50) = null
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  id ,
                name ,
                ( SELECT    COUNT(1)
                  FROM      employees_view e
                  WHERE     e.id_organization = o.id
                ) AS emp_count ,
                address_ur ,
                address_fact ,
                phone ,
                email ,
                inn ,
                kpp ,
                ogrn ,
                rs ,
                bank ,
                ks ,
                bik ,
                okpo ,
                okved ,
                manager_name ,
                manager_name_dat ,
                manager_position ,
                manager_position_dat,
				site,
				director_sid,
				id_director
        FROM    organizations o
        WHERE   o.enabled = 1
                AND ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND o.id = @id
                         )
                    )
					AND ( @sys_name IS NULL or @sys_name = ''
                      OR ( @sys_name IS NOT NULL
                           AND @sys_name != ''
                           AND o.sys_name = @sys_name
                         )
                    )
        ORDER BY name
    END
