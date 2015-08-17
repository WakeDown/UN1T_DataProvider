update emp
set emp.full_name_dat = import.full_name_dat, emp.full_name_rod = import.full_name_rod
from employees emp inner join employee_import import on emp.id=import.id