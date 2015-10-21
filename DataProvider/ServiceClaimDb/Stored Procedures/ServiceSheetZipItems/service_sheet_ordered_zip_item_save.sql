CREATE PROCEDURE [dbo].[service_sheet_ordered_zip_item_save]
	@id int = null,
	@id_service_sheet int,
	@part_num nvarchar(50),
	@name nvarchar(500) = null,
	@count int,
	@creator_sid varchar(46)
AS
begin
set nocount on;
	insert into service_sheet_ordered_zip_items (id_service_sheet, part_num, name, count ,creator_sid)
	values (@id_service_sheet, @part_num, @name, @count ,@creator_sid)
end
