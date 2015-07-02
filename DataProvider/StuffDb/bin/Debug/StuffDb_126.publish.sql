/*
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
PRINT N'Операция рефакторинга Rename с помощью ключа e068b3a1-f7e7-4bc6-a2ea-1699f48e65eb пропущена, элемент [dbo].[organizations].[address] (SqlSimpleColumn) не будет переименован в address_ur';


GO
PRINT N'Операция рефакторинга Rename с помощью ключа ea52b8de-f887-4231-b2cb-8cd2ac2de5ea пропущена, элемент [dbo].[organizations].[Bank] (SqlSimpleColumn) не будет переименован в bank';


GO
PRINT N'Выполняется изменение [dbo].[organizations]...';


GO
ALTER TABLE [dbo].[organizations]
    ADD [address_ur]           NVARCHAR (500) NULL,
        [address_fact]         NVARCHAR (500) NULL,
        [phone]                NVARCHAR (50)  NULL,
        [email]                NVARCHAR (50)  NULL,
        [inn]                  NVARCHAR (12)  NULL,
        [kpp]                  NVARCHAR (20)  NULL,
        [ogrn]                 NVARCHAR (20)  NULL,
        [rs]                   NVARCHAR (50)  NULL,
        [bank]                 NVARCHAR (500) NULL,
        [ks]                   NVARCHAR (50)  NULL,
        [bik]                  NVARCHAR (50)  NULL,
        [okpo]                 NVARCHAR (50)  NULL,
        [okved]                NVARCHAR (50)  NULL,
        [manager_name]         NVARCHAR (150) NULL,
        [manager_name_dat]     NVARCHAR (150) NULL,
        [manager_position]     NVARCHAR (250) NULL,
        [manager_position_dat] NVARCHAR (250) NULL;


GO
PRINT N'Выполняется изменение [dbo].[employees_view]...';


GO
ALTER VIEW [dbo].[employees_view]
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
				e.dattim1 as date_create
        FROM    employees e
                INNER JOIN employee_states es ON e.id_emp_state = es.id
                INNER JOIN positions p ON e.id_position = p.id
				INNER JOIN positions p_org ON e.id_position_org = p_org.id
                INNER JOIN organizations o ON e.id_organization = o.id
                INNER JOIN cities c ON e.id_city = c.id
                INNER JOIN departments d ON e.id_department = d.id
        WHERE   e.enabled = 1 and es.sys_name IN ( 'STUFF', 'DECREE' )
GO
PRINT N'Выполняется изменение [dbo].[get_employee]...';


GO
ALTER PROCEDURE [dbo].[get_employee]
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
                END AS photo
				--,
				--CASE WHEN @id_department IS NOT NULL THEN 
				--CASE WHEN EXISTS(SELECT 1 FROM departments dd WHERE dd.id=@id_department AND dd.id_chief=e.id) THEN 0 ELSE 1 end
				--ELSE NULL END AS is_chief
        FROM    employees e
		INNER JOIN employee_states es ON e.id_emp_state = es.id
                INNER JOIN positions p ON e.id_position = p.id
				INNER JOIN positions p_org ON e.id_position_org = p_org.id
                INNER JOIN organizations o ON e.id_organization = o.id
                INNER JOIN cities c ON e.id_city = c.id
                INNER JOIN departments d ON e.id_department = d.id
        WHERE  e.id = @id
    END
GO
PRINT N'Выполняется изменение [dbo].[get_organization]...';


GO
ALTER PROCEDURE [dbo].[get_organization]
	@id int =null
AS
begin
SET NOCOUNT ON;
	select id, name,
	(
	select count(1) from employees_view e where e.id_organization=o.id
	) as emp_count,
	address_ur, 
    address_fact, 
    phone, 
    email , 
    inn , 
    kpp, 
    ogrn, 
    rs , 
    bank , 
    ks , 
    bik , 
    okpo , 
    okved , 
    manager_name , 
    manager_name_dat , 
    manager_position , 
    manager_position_dat 
	from organizations o
	where o.enabled=1
	AND ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND o.id = @id
                         )
                    )
					order by name
end
GO
PRINT N'Выполняется изменение [dbo].[save_organization]...';


GO
ALTER PROCEDURE [dbo].[save_organization]
    @id INT = NULL ,
    @name NVARCHAR(150),
	@creator_sid varchar(46)=null,
	@address_ur NVARCHAR(500) = NULL, 
    @address_fact NVARCHAR(500) = NULL, 
    @phone NVARCHAR(50) = NULL, 
    @email NVARCHAR(50) = NULL, 
    @inn NVARCHAR(12) = NULL, 
    @kpp NVARCHAR(20) = NULL, 
    @ogrn NVARCHAR(20) = NULL, 
    @rs NVARCHAR(50) = NULL, 
    @bank NVARCHAR(500) = NULL, 
    @ks NVARCHAR(50) = NULL, 
    @bik NVARCHAR(50) = NULL, 
    @okpo NVARCHAR(50) = NULL, 
    @okved NVARCHAR(50) = NULL, 
    @manager_name NVARCHAR(150) = NULL, 
    @manager_name_dat NVARCHAR(150) = NULL, 
    @manager_position NVARCHAR(250) = NULL, 
    @manager_position_dat NVARCHAR(250) = NULL
AS
    BEGIN
	SET NOCOUNT ON;
        IF @id IS NOT NULL
            AND @id > 0
            AND EXISTS ( SELECT 1
                         FROM   organizations
                         WHERE  id = @id )
            BEGIN
                UPDATE  organizations
                SET     name = @name 
                WHERE   id = @id
            END
        ELSE
            BEGIN
                INSERT  INTO organizations
                        ( name ,creator_sid,
						address_ur, 
    address_fact, 
    phone, 
    email , 
    inn , 
    kpp, 
    ogrn, 
    rs , 
    bank , 
    ks , 
    bik , 
    okpo , 
    okved , 
    manager_name , 
    manager_name_dat , 
    manager_position , 
    manager_position_dat 
                        )
                VALUES  ( @name ,@creator_sid,
						@address_ur, 
    @address_fact, 
    @phone, 
    @email , 
    @inn , 
    @kpp, 
    @ogrn, 
    @rs , 
    @bank , 
    @ks , 
    @bik , 
    @okpo , 
    @okved , 
    @manager_name , 
    @manager_name_dat , 
    @manager_position , 
    @manager_position_dat 
                        )

						SELECT @id=@@IDENTITY
            END
	 
		SELECT @id AS id
    END
GO
PRINT N'Выполняется обновление [dbo].[close_organization]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[close_organization]';


GO
PRINT N'Выполняется обновление [dbo].[get_city]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_city]';


GO
PRINT N'Выполняется обновление [dbo].[get_city_link_count]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_city_link_count]';


GO
PRINT N'Выполняется обновление [dbo].[get_department]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_department]';


GO
PRINT N'Выполняется обновление [dbo].[get_employee_list]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_employee_list]';


GO
PRINT N'Выполняется обновление [dbo].[get_employees_birthday]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_employees_birthday]';


GO
PRINT N'Выполняется обновление [dbo].[get_employees_newbie]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_employees_newbie]';


GO
PRINT N'Выполняется обновление [dbo].[get_organization_link_count]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_organization_link_count]';


GO
PRINT N'Выполняется обновление [dbo].[get_position]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_position]';


GO
PRINT N'Выполняется обновление [dbo].[get_position_link_count]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[get_position_link_count]';


GO
-- Выполняется этап рефакторинга для обновления развернутых журналов транзакций на целевом сервере
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'e068b3a1-f7e7-4bc6-a2ea-1699f48e65eb')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('e068b3a1-f7e7-4bc6-a2ea-1699f48e65eb')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'ea52b8de-f887-4231-b2cb-8cd2ac2de5ea')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('ea52b8de-f887-4231-b2cb-8cd2ac2de5ea')

GO

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
