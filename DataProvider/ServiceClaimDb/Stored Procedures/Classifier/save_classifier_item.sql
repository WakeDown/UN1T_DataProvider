CREATE PROCEDURE [dbo].[save_classifier_item]
	@id_category int,
	@id_work_type int,
	@time int = null,
	@price decimal(10,2)=null,
	@cost_people decimal(10,2)=null,
	@cost_company decimal(10,2)=null,
	@creator_sid varchar(46)
AS
	begin
	set nocount on;
	declare @id int

	if exists(select 1 from classifier c where c.enabled=1 and c.id_category=@id_category and c.id_work_type=@id_work_type)
	begin
		select @time = isnull(@time, (select time from classifier c where c.enabled=1 and c.id_category=@id_category and c.id_work_type=@id_work_type))
		select @price = isnull(@price, (select price from classifier c where c.enabled=1 and c.id_category=@id_category and c.id_work_type=@id_work_type))
		select @cost_people = isnull(@cost_people, (select cost_people from classifier c where c.enabled=1 and c.id_category=@id_category and c.id_work_type=@id_work_type))
		select @cost_company = isnull(@cost_company, (select cost_company from classifier c where c.enabled=1 and c.id_category=@id_category and c.id_work_type=@id_work_type))

		update c
		set c.time=@time, c.price=@price, c.cost_people=@cost_people, c.cost_company=@cost_company, creator_sid=@creator_sid
		from
		 classifier c where c.enabled=1 and c.id_category=@id_category and c.id_work_type=@id_work_type

		 select @id = c.id from classifier c where c.enabled=1 and c.id_category=@id_category and c.id_work_type=@id_work_type
	end
	else
	begin
	select @time = isnull(@time, -1)
		select @price = isnull(@price, -1)
		select @cost_people = isnull(@cost_people, -1)
		select @cost_company = isnull(@cost_company, -1)

		insert into classifier (id_category, id_work_type, time, price, cost_people, cost_company, creator_sid)
		values (@id_category, @id_work_type, @time, @price, @cost_people, @cost_company, @creator_sid)
		set @id = @@IDENTITY
	end
	select @id as id
	end
