update pos
set pos.name_dat = import.name_dat, pos.name_rod = import.name_rod
from positions pos inner join position_import import on pos.id=import.id