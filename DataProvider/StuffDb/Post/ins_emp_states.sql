delete employee_states where id between 1 and 4
go

insert into employee_states (id, name, sys_name, display_in_list)
values(1, N'Кандидат', N'CANDIDATE', 1)
insert into employee_states (id, name, sys_name, display_in_list)
values(2, N'Сотрудник', N'STUFF', 1)
insert into employee_states (id, name, sys_name, display_in_list)
values(3, N'Декрет', N'DECREE', 0)
insert into employee_states (id, name, sys_name, display_in_list)
values(4, N'Уволен', N'FIRED', 0)
