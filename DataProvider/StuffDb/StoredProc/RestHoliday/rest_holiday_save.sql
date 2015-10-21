CREATE PROCEDURE [dbo].[rest_holiday_save]
	@employee_sid varchar(46),
	@start_date datetime,
	@end_date datetime,
	@duration int,
	@creator_sid varchar(46),
	@year int = null
AS
begin
set nocount on;
declare @id int
if @year is null or @year <= 0
begin
select @year = Year(@start_date)
end

insert into rest_holidays(employee_sid, start_date,end_date,duration, creator_sid, year)
values(@employee_sid, @start_date,@end_date,@duration, @creator_sid, @year)

set @id= SCOPE_IDENTITY()
select @id as id
end
