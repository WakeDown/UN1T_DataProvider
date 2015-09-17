CREATE PROCEDURE [dbo].[close_vendor_state]
	@id int,
	@deleter_sid varchar(46)
	as begin
	set nocount on;
	update vendor_states
	set enabled = 0, dattim2 = getdate(), deleter_sid = @deleter_sid
	where id=@id

	end
