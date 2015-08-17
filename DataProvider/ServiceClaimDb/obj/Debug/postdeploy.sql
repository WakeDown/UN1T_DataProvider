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
if not exists(select 1 from claim_states)
begin
	insert into claim_states (name, sys_name, order_num)
	values (N'Новая', N'NEW', 10)
	insert into claim_states (name, sys_name, order_num)
	values (N'Техподдержка', N'TECH', 20)
	insert into claim_states (name, sys_name, order_num)
	values (N'Назначено', N'SET', 30)
	insert into claim_states (name, sys_name, order_num)
	values (N'Выполнена', N'END', 40)
end
GO
