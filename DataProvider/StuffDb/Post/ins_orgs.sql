delete organizations --where id between 1 and 4
go
insert into organizations (name, display_in_list, full_name)
values (N'Копир', 1, N'ООО "Юнит-Копир"')
insert into organizations (name, display_in_list, full_name)
values (N'УК', 1, N'ООО "Управляющая компания ЮНИТ"')
insert into organizations (name, display_in_list, full_name)
values (N'Коммуникации', 1, N'ООО "Юнит-Коммуникации"')
insert into organizations (name, display_in_list, full_name)
values (N'Компьютер', 1, N'ООО "Юнит-Компьютер"')