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
values(1, 'Кандидат', 'CANDIDATE', 1)
insert into employee_states (id, name, sys_name, display_in_list)
values(2, 'Сотрудник', 'STUFF', 1)
insert into employee_states (id, name, sys_name, display_in_list)
values(3, 'Декрет', 'DECREE', 0)
insert into employee_states (id, name, sys_name, display_in_list)
values(4, 'Уволен', 'FIRED', 0)

delete organizations --where id between 1 and 4
GO
insert into organizations (name, display_in_list, full_name)
values ('Копир', 1, 'ООО "Юнит-Копир"')
insert into organizations (name, display_in_list, full_name)
values ('УК', 1, 'ООО "Управляющая компания ЮНИТ"')
insert into organizations (name, display_in_list, full_name)
values ('Коммуникации', 1, 'ООО "Юнит-Коммуникации"')
insert into organizations (name, display_in_list, full_name)
values ('Компьютер', 1, 'ООО "Юнит-Компьютер"')
delete cities --where id between 1 and 5
GO
insert into cities (id, name)
values('Екатеринбург')
insert into cities (id, name)
values('Москва')
insert into cities (id, name)
values('Челябинск')
insert into cities (id, name)
values('Пермь')
insert into cities (id, name)
values('Нягань')
--:r .\ins_positions.sql
GO

GO
PRINT N'Обновление завершено.';


GO
