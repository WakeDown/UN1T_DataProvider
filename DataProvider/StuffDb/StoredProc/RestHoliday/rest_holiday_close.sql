CREATE PROCEDURE [dbo].[rest_holiday_close]
	@id int,
	@deleter_sid varchar(46)
AS
	begin
	set nocount on;
	update rest_holidays
	set enabled=0, deleter_sid=@deleter_sid, dattim2=getdate()
	where id=@id
	end
