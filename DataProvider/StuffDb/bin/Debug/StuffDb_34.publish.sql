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
PRINT N'Выполняется изменение [dbo].[get_emp_state]...';


GO
ALTER PROCEDURE [dbo].[get_emp_state]
	@id int = null,
	@get_all bit = 0,
	@sys_name nvarchar(20) = null
AS
begin
SET NOCOUNT ON;
	select id, name from employee_states es
	where es.enabled=1
	and (@get_all=0 or (@get_all=1 and es.display_in_list = 1))
	and ((@sys_name is null or ltrim(rtrim(@sys_name)) = '') or (@sys_name is not null and rtrim(ltrim(@sys_name))<>'' and sys_name=@sys_name))
	AND ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND es.id = @id
                         )
                    )
end
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

insert into employee_states (id, name, sys_name, display_in_list)
values(1, N'Кандидат', N'CANDIDATE', 1)
insert into employee_states (id, name, sys_name, display_in_list)
values(2, N'Сотрудник', N'STUFF', 1)
insert into employee_states (id, name, sys_name, display_in_list)
values(3, N'Декрет', N'DECREE', 0)
insert into employee_states (id, name, sys_name, display_in_list)
values(4, N'Уволен', N'FIRED', 0)

delete organizations --where id between 1 and 4
GO
insert into organizations (name, display_in_list, full_name)
values (N'Копир', 1, N'ООО "Юнит-Копир"')
insert into organizations (name, display_in_list, full_name)
values (N'УК', 1, N'ООО "Управляющая компания ЮНИТ"')
insert into organizations (name, display_in_list, full_name)
values (N'Коммуникации', 1, N'ООО "Юнит-Коммуникации"')
insert into organizations (name, display_in_list, full_name)
values (N'Компьютер', 1, N'ООО "Юнит-Компьютер"')
delete cities --where id between 1 and 5
GO
insert into cities (name)
values(N'Екатеринбург')
insert into cities (name)
values(N'Москва')
insert into cities ( name)
values(N'Челябинск')
insert into cities (name)
values(N'Пермь')
insert into cities (name)
values(N'Нягань')
delete positions --where id between 1 and 5
GO
insert into positions (name)
values (N'Директор')
insert into positions (name)
values (N'Руководитель')
insert into positions (name)
values (N'Менеджер')
insert into positions (name)
values (N'Оператор')
insert into positions (name)
values (N'Инженер')
GO

GO
PRINT N'Обновление завершено.';


GO
