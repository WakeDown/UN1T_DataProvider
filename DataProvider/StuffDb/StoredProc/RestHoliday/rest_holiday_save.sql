CREATE PROCEDURE [dbo].[rest_holiday_save]
	@id int = null,
	@employee_sid varchar(46),
	@start_date datetime,
	@end_date datetime,
	@duration int,
	@can_edit bit,
	@creator_sid varchar(46)
AS
begin
set nocount on;
insert into rest_holidays(employee_sid, start_date,end_date,duration, can_edit,creator_sid)
values(@employee_sid, @start_date,@end_date,@duration, @can_edit,@creator_sid)
end
