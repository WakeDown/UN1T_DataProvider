CREATE VIEW [dbo].[employees_view]
	AS SELECT  e.id ,
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
				e.dattim1 as date_create,
				case when d.hidden=1 then 1 else 0 end as is_hidden,
				e.newvbie_delivery,
				d.sys_name as dep_sys_name,
				p.sys_name as pos_sys_name,
				e.full_name_dat,
				e.full_name_rod,
				e.id_budget,
				CASE WHEN e.id_department IS NOT NULL THEN 
				CASE WHEN EXISTS(SELECT 1 FROM departments dd WHERE dd.enabled=1 and dd.id_chief=e.id) THEN 1 ELSE 0 end
				ELSE NULL END AS is_chief 
        FROM    employees e
                INNER JOIN employee_states es ON e.id_emp_state = es.id
                INNER JOIN positions p ON e.id_position = p.id
				INNER JOIN positions p_org ON e.id_position_org = p_org.id
                INNER JOIN organizations o ON e.id_organization = o.id
                INNER JOIN cities c ON e.id_city = c.id
                INNER JOIN departments d ON e.id_department = d.id
        WHERE   e.enabled = 1 and es.sys_name IN ( 'STUFF' )
