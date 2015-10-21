CREATE PROCEDURE [dbo].[rest_holiday_list_confirm]
	@id_array nvarchar(max),
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
where id in (select value from SplitInt(@id_array, ',')) and confirmed=0
end

if @confirmed is not null
begin
update rest_holidays
set confirmed=@confirmed, confirmator_sid=@creator_sid
where id in (select value from SplitInt(@id_array, ','))
end
end
