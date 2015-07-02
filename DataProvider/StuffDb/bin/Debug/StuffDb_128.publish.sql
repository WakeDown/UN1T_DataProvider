﻿/*
Скрипт развертывания для Stuff

Этот код был создан программным средством.
Изменения, внесенные в этот файл, могут привести к неверному выполнению кода и будут потеряны
в случае его повторного формирования.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "Stuff"
:setvar DefaultFilePrefix "Stuff"
:setvar DefaultDataPath "S:\SQL-DB\MSSQL10_50.MSSQLSERVER\MSSQL\Data\"
:setvar DefaultLogPath "T:\SQL-TL\MSSQL10_50.MSSQLSERVER\MSSQL\Data\"

GO
:on error exit
GO
/*
Проверьте режим SQLCMD и отключите выполнение скрипта, если режим SQLCMD не поддерживается.
Чтобы повторно включить скрипт после включения режима SQLCMD выполните следующую инструкцию:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'Для успешного выполнения этого скрипта должен быть включен режим SQLCMD.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Выполняется изменение [dbo].[get_employee_list]...';


GO
ALTER PROCEDURE [dbo].[get_employee_list]
	@id INT = NULL ,
    @id_emp_state INT = NULL ,
    @get_photo BIT = 0 ,
    @id_department INT = NULL,
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
				ad_login
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
					ORDER BY is_chief, e.full_name
    END
GO
PRINT N'Выполняется создание [dbo].[get_other_employee_list]...';


GO
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
                p_org.name AS position_org
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
GO
/*
Шаблон скрипта после развертывания							
--------------------------------------------------------------------------------------
 В данном файле содержатся инструкции SQL, которые будут добавлены в скрипт построения.		
 Используйте синтаксис SQLCMD для включения файла в скрипт после развертывания.			
 Пример:      :r .\myfile.sql								
 Используйте синтаксис SQLCMD для создания ссылки на переменную в скрипте после развертывания.		
 Пример:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

GRANT EXECUTE ON SCHEMA ::dbo TO sqlUnit_prog
delete employee_states where id between 1 and 4
GO

insert into employee_states (id, name, sys_name, display_in_list, enabled)
values(1, N'Кандидат', N'CANDIDATE', 1, 0)
insert into employee_states (id, name, sys_name, display_in_list)
values(2, N'Сотрудник', N'STUFF', 1)
insert into employee_states (id, name, sys_name, display_in_list)
values(3, N'Декрет', N'DECREE', 0)
insert into employee_states (id, name, sys_name, display_in_list)
values(4, N'Уволен', N'FIRED', 0)

--:r .\ins_orgs.sql
--:r .\ins_cities.sql
--:r .\ins_positions.sql
GO

GO
PRINT N'Обновление завершено.';


GO
