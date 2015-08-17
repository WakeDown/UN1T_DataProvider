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