if not exists(select 1 from attributes)
begin

insert into attributes(sys_name, value)
values('CLSFRWAGE', '')
insert into attributes(sys_name, value)
values('CLSFROVERHEAD', '')

end