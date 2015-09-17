CREATE PROCEDURE [dbo].[close_budget]
	@id int,
	@deleter_sid varchar(46)
	as begin
	set nocount on;
	update budget
	set dattim2=getdate(), enabled=0, deleter_sid=@deleter_sid
	where id=@id

	end
