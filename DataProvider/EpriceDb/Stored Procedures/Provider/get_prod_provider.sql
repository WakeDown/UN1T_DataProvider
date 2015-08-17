CREATE PROCEDURE [dbo].[get_prod_provider]
    @id INT = NULL ,
    @sys_name NVARCHAR(20) = NULL
AS
    BEGIN
        SET nocount ON;
        SELECT  id ,
                name ,
                sys_name
        FROM    product_providers p
        WHERE   enabled = 1
                AND ( ( @id IS NOT NULL
                        AND @id > 0
                        AND p.id = @id
                      )
                      OR @id IS NULL
                      OR @id <= 0
                    )
                AND ( ( @sys_name IS NOT NULL
                        AND @sys_name <> ''
                        AND p.sys_name = @sys_name
                      )
                      OR @sys_name IS NULL
                      OR @sys_name = ''
                    )

    END
