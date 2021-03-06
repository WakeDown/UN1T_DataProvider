﻿CREATE VIEW [dbo].[departments_view]
	AS SELECT  id ,
                name ,
                id_parent ,
                ( SELECT    name
                  FROM      departments d2
                  WHERE     d2.id = d.id_parent
                ) AS parent ,
                id_chief ,
                ( SELECT    display_name
                  FROM      employees e
                  WHERE     e.id = d.id_chief
                ) AS chief,
				case when d.hidden = 1 then 1 else 0 end as hidden
        FROM    departments d
        WHERE   d.enabled = 1
