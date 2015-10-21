CREATE PROCEDURE [dbo].[service_sheet_not_installed_zip_item_save_list]
	@id_ordered_zip_item_list nvarchar(max),
	@id_service_sheet int,	
	@creator_sid varchar(46)
AS
begin
set nocount on;
declare @id_ordered_zip_item int
declare curs cursor FAST_FORWARD for
select value from SplitInt(@id_ordered_zip_item_list, ',')

OPEN curs

begin try

FETCH NEXT FROM curs
INTO @id_ordered_zip_item


BEGIN tran
WHILE @@FETCH_STATUS = 0
BEGIN

	insert into service_sheet_not_installed_zip_items (id_ordered_zip_item, id_service_sheet, creator_sid)
	values (@id_ordered_zip_item, @id_service_sheet, @creator_sid)

	FETCH NEXT FROM curs
	INTO @id_ordered_zip_item

	end
	COMMIT tran
	CLOSE curs
	DEALLOCATE curs
	end try
	begin catch
		rollback tran;
		CLOSE curs;
		DEALLOCATE curs;
		THROW;  
	end catch

	
end