CREATE PROCEDURE [dbo].[save_classifier_category]
@id int = null,
@id_parent int = 0,
	@name nvarchar(4000) = '',
	@number nvarchar(20) = '',
	@descr nvarchar(max) = null,
    @complexity INT  = NULL,
	@creator_sid varchar(46)
	as begin
	set nocount on;

		if (@id is not null and @id > 0 and exists(select 1 from classifier_categories where id=@id))
		begin
			update classifier_categories
			set 
			id_parent=@id_parent, 
			name=@name, number=@number, complexity=@complexity
			--,descr=@descr
			where id=@id			
		end 
		else if (@number is not null and @number != '' and exists(select 1 from classifier_categories where enabled = 1 and number=@number))
		begin
			select top 1 @id = id from classifier_categories where enabled = 1 and number=@number order by id desc

			update classifier_categories
			set 
			id_parent=@id_parent, 
			name=@name, number=@number, complexity=@complexity
			--,descr=@descr
			where id=@id
		end
		else
		begin
			insert into classifier_categories (id_parent,name, number, descr,complexity, creator_sid)
			values (@id_parent,@name, @number, @descr, @complexity, @creator_sid)
			set @id = @@IDENTITY
		end

		select @id as id
	end
