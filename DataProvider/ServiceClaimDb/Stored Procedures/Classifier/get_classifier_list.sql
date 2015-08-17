CREATE PROCEDURE [dbo].[get_classifier_list]
AS
	begin
	select null
--	select id_category, name, number, time,price,cost_company, cost_people
--from dbo.classifier c
--inner join classifier_categories cat on cat.enabled=1 and c.id_category=cat.id
--where c.enabled=1 
--and not exists(select 1 from classifier_categories cat2 where cat2.enabled=1 and cat.id=cat2.id_parent)
--order by id_parent, convert(int, replace(number, '.', ''))

	end
