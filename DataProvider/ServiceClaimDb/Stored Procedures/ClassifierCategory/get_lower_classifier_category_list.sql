CREATE PROCEDURE [dbo].[get_lower_classifier_category_list]
	
AS
	begin
	set nocount on;
select id, id_parent, number, complexity, descr, cat.name
from classifier_categories cat
where cat.enabled=1 and not exists(select 1 from classifier_categories cat2 where cat2.enabled=1 and cat2.id_parent=cat.id)
order by id_parent, convert(int, replace(number, '.', ''))
end