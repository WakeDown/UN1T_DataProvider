CREATE PROCEDURE [dbo].[get_department] @id INT = NULL, @get_emp_count BIT = 0
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  id ,
                name ,
                id_parent ,
                parent ,
                id_chief ,
                chief,
				CASE WHEN @get_emp_count = 1 THEN 
				(SELECT COUNT(1) FROM employees_view e WHERE e.id_department = d.id)
				 ELSE NULL END AS emp_count
        FROM    departments_view d
        WHERE   ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND d.id = @id
                         )
                    )
					order by d.name
    END