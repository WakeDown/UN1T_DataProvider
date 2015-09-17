CREATE PROCEDURE [dbo].[get_employee_list]
	@id INT = NULL ,
    @id_emp_state INT = NULL ,
    @get_photo BIT = 0 ,
    @id_department INT = NULL,
	@ad_sid VARCHAR(46) = NULL,
	@id_city INT = NULL,
	@id_manager int = null,
	@id_budget int = null
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
                manager,
                manager_email ,
                emp_state ,
                position ,
                organization ,
                city ,
                department ,
                CASE WHEN @get_photo = 1
                     THEN ( SELECT TOP 1
                                    picture
                            FROM    photos ph
                            WHERE   ph.enabled = 1
                                    AND ph.id_employee = e.id
                          )
                     ELSE NULL
                END AS photo,
				CASE WHEN @id_department IS NOT NULL THEN 
				CASE WHEN EXISTS(SELECT 1 FROM departments dd WHERE dd.id=@id_department AND dd.id_chief=e.id) THEN 0 ELSE 1 end
				ELSE NULL END AS is_chief,
				 male,
				id_position_org,
				position_org,
				has_ad_account,
				ad_login,
				is_hidden,
				id_budget
        FROM    employees_view e
        WHERE  
		( @id IS NULL 
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND e.id = @id
                         )
                    )
				AND ( @ad_sid IS NULL OR @ad_sid = ''
                      OR ( @ad_sid IS NOT NULL
                           AND @ad_sid != ''
                           AND e.ad_sid = @ad_sid
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
					AND ( ( @id_city IS NULL
                        OR @id_city <= 0
                      )
                      OR ( @id_city IS NOT NULL
                           AND @id_city > 0
                           AND id_city = @id_city
                         )
                    )
					AND ( ( @id_manager IS NULL
                        OR @id_manager <= 0
                      )
                      OR ( @id_manager IS NOT NULL
                           AND @id_manager > 0
                           AND id_manager = @id_manager
                         )
                    )
					AND ( ( @id_budget IS NULL
                        OR @id_budget <= 0
                      )
                      OR ( @id_budget IS NOT NULL
                           AND @id_budget > 0
                           AND id_budget = @id_budget
                         )
                    )
					ORDER BY is_chief, e.full_name
    END
