CREATE PROCEDURE [dbo].[get_employee]
    @id INT = NULL ,
    @in_stuff BIT = 0 ,
    @id_emp_state INT = NULL ,
    @get_photo BIT = 0 ,
    @id_department INT = NULL
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  e.id ,
                ad_sid ,
                id_manager ,
                surname ,
                e.name ,
                patronymic ,
                e.full_name ,
                display_name ,
                id_position ,
                id_organization ,
                email ,
                work_num ,
                mobil_num ,
                id_emp_state ,
                id_department ,
                id_city ,
                date_came ,
                birth_date ,
                ( SELECT    display_name
                  FROM      employees e2
                  WHERE     e2.id = e.id_manager
                ) AS manager ,
                es.name AS emp_state ,
                p.name AS position ,
                o.name AS organization ,
                c.name AS city ,
                d.name AS department ,
                CASE WHEN @get_photo = 1
                     THEN ( SELECT TOP 1
                                    picture
                            FROM    photos ph
                            WHERE   ph.enabled = 1
                                    AND ph.id_employee = e.id
                          )
                     ELSE NULL
                END AS photo
        FROM    employees e
                INNER JOIN employee_states es ON e.id_emp_state = es.id
                INNER JOIN positions p ON e.id_position = p.id
                INNER JOIN organizations o ON e.id_organization = o.id
                INNER JOIN cities c ON e.id_city = c.id
                INNER JOIN departments d ON e.id_department = d.id
        WHERE   e.enabled = 1
                AND ( @in_stuff = 0
                      OR ( @in_stuff = 1
                           AND es.sys_name IN ( 'STUFF', 'DECREE' )
                         )
                    )
                AND ( ( @id_emp_state IS NULL )
                      OR ( @id_emp_state IS NOT NULL
                           AND e.id_emp_state = @id_emp_state
                         )
                    )
                AND ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND e.id = @id
                         )
                    )
                AND ( ( @id_department IS NULL
                        OR @id_department <= 0
                      )
                      OR ( @id_department IS NOT NULL
                           AND @id_department > 0
                           AND id_department = @id_department
                         )
                    )
    END
