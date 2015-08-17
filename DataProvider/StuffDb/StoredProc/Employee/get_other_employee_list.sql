CREATE PROCEDURE [dbo].[get_other_employee_list]
@id_emp_state int,
@id_department int = null
	AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  e.id ,
                e.full_name ,
                p.name AS position ,
                o.name AS organization ,
                c.name AS city ,
                d.name AS department ,
                CASE WHEN male = 1 THEN 1
                     ELSE 0
                END AS male ,
                id_position_org ,
                p_org.name AS position_org,
				d.hidden as is_hidden
        FROM    employees e
                INNER JOIN employee_states st ON e.id_emp_state = st.id
                INNER JOIN positions p ON e.id_position = p.id
                INNER JOIN positions p_org ON e.id_position_org = p_org.id
                INNER JOIN organizations o ON e.id_organization = o.id
                INNER JOIN cities c ON e.id_city = c.id
                INNER JOIN departments d ON e.id_department = d.id
        WHERE   e.enabled = 1 and e.id_emp_state = @id_emp_state
		 AND ( ( @id_department IS NULL
                        OR @id_department <= 0
                      )
                      OR ( @id_department IS NOT NULL
                           AND @id_department > 0
                           AND id_department = @id_department
                         )
                    )
					ORDER BY e.full_name
                         
    END
