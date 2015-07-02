CREATE PROCEDURE [dbo].[get_employees_birthday]
    @day DATE = NULL ,
    @month INT = NULL
AS
    BEGIN
        SELECT  *
        FROM    employees_view e
        WHERE   ( @day IS NULL
                  OR ( @day IS NOT NULL
                       AND month(e.birth_date) = month(@day) and day(e.birth_date) = day(@day)
                     )
                )
                AND ( @month IS NULL
                      OR ( @month IS NOT NULL
                           AND MONTH(e.birth_date) = @month
                         )
                    )
					order by month(birth_date), day(birth_date)
    END
