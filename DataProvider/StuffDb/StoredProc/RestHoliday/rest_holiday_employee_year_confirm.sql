CREATE PROCEDURE [dbo].[rest_holiday_employee_year_confirm]
	@employee_sid varchar(46),
	@year int,
	@can_edit bit = null,
	@confirmed bit = null,
	@creator_sid varchar(46) = null
AS
begin
set nocount on;

if (@can_edit is not null)
begin
update rest_holidays
set can_edit=@can_edit, can_edit_creator_sid=@creator_sid
where employee_sid=@employee_sid and year=@year and confirmed=0
end

if @confirmed is not null
begin
update rest_holidays
set confirmed=@confirmed, confirmator_sid=@creator_sid
where  employee_sid=@employee_sid and year=@year
end
end