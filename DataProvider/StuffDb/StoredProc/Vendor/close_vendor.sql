CREATE PROCEDURE [dbo].[close_vendor]
	@id int,
	@deleter_sid varchar(46)
AS
	begin set nocount on;

	update vendors
	set enabled=0, dattim2=getdate(), deleter_sid=@deleter_sid
	where id=@id

	end
