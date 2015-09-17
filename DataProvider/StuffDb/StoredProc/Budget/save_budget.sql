CREATE PROCEDURE [dbo].[save_budget]
	@id int = null,
	@name nvarchar(500),
	@creator_sid varchar(46),
	@descr nvarchar(MAX)=null,
	@id_parent int = null
AS begin
	set nocount on;
	if exists(select 1 from budget where id=@id)
	begin
		update budget
		set name=@name, descr = @descr, id_parent=@id_parent
		where id=@id
	end
	else
	begin
		insert into budget (name, creator_sid, descr, id_parent)
		values(@name, @creator_sid, @descr, @id_parent)
	end
	end