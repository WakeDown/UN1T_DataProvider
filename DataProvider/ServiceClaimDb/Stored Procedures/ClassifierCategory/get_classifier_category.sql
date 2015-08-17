CREATE PROCEDURE [dbo].[get_classifier_category]
	@id int = null,
	@number nvarchar(20) = null
	as begin set nocount on;

	select id, id_parent, name, number, descr
	from classifier_categories c
	where c.enabled=1 and (@id is null or @id <= 0 or (@id is not null and @id > 0 and c.id=@id))
	and (@number is null or @number ='' or (@number is not null and @number != '' and c.number=@number))
	end
