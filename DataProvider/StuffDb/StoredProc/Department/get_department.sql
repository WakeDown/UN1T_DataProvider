CREATE PROCEDURE [dbo].[get_department] @id INT = NULL
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  id ,
                name ,
                id_parent ,
                ( SELECT    name
                  FROM      departments d2
                  WHERE     d2.id = d.id_parent
                ) AS parent ,
                id_chief ,
                ( SELECT    display_name
                  FROM      employees e
                  WHERE     e.id = d.id_chief
                ) AS chief
        FROM    departments d
        WHERE   d.enabled = 1
                AND ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND d.id = @id
                         )
                    )
					order by d.name
    END