CREATE PROCEDURE [dbo].[get_employee]
    @id INT = NULL ,
    @get_photo BIT = 0 ,
	@ad_sid VARCHAR(46) = NULL
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
                e.email ,
                work_num ,
                mobil_num ,
                id_emp_state ,
                id_department ,
                id_city ,
                date_came ,
                birth_date ,
                ( SELECT    e2.display_name
                  FROM      employees e2
                  WHERE     e2.id = e.id_manager
                ) AS manager,
                ( SELECT    e2.email
                  FROM      employees e2
                  WHERE     e2.id = e.id_manager
                ) AS manager_email ,
                es.name AS emp_state ,
				es.sys_name as emp_state_sys_name,
                p.name AS position ,
                o.name AS organization ,
                c.name AS city ,
                d.name AS department ,
				case when male=1 then 1 else 0 end as male,
				id_position_org,
				p_org.name as position_org,
				CASE WHEN e.has_ad_account = 1 THEN 1 ELSE 0 END AS has_ad_account,
				ad_login,
				e.dattim1 as date_create
				,
				CASE WHEN @get_photo = 1
                     THEN ( SELECT TOP 1
                                    picture
                            FROM    photos ph
                            WHERE   ph.enabled = 1
                                    AND ph.id_employee = e.id
                          )
                     ELSE NULL
                END AS photo,
				full_name_dat,
				full_name_rod,
				--,
				--CASE WHEN @id_department IS NOT NULL THEN 
				--CASE WHEN EXISTS(SELECT 1 FROM departments dd WHERE dd.id=@id_department AND dd.id_chief=e.id) THEN 0 ELSE 1 end
				--ELSE NULL END AS is_chief
				d.hidden as is_hidden,
				e.date_fired,
				id_budget
        FROM    employees e
		INNER JOIN employee_states es ON e.id_emp_state = es.id
                INNER JOIN positions p ON e.id_position = p.id
				INNER JOIN positions p_org ON e.id_position_org = p_org.id
                INNER JOIN organizations o ON e.id_organization = o.id
                INNER JOIN cities c ON e.id_city = c.id
                INNER JOIN departments d ON e.id_department = d.id
        WHERE ((@id is null or @id <= 0) or (@id is not null and @id > 0 and e.id = @id))
		and ((@ad_sid is null or @ad_sid = '') or (@ad_sid is not null and @ad_sid != '' and e.ad_sid = @ad_sid))
    END
