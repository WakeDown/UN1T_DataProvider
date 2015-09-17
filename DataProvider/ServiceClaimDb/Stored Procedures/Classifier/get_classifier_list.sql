CREATE PROCEDURE [dbo].[get_classifier_list]
AS
	begin
	
	select id_category, id_work_type, time,price,cost_company, cost_people
from dbo.classifier c
--inner join classifier_categories cat on cat.enabled=1 and c.id_category=cat.id
--inner join work_types wt on c.id_work_type=wt.id
where c.enabled=1 
--and cat.enabled=1 and wt.enabled=1

	end
