CREATE PROCEDURE [dbo].[service_sheet_ordered_zip_item_copy_from_issued]
	@id_service_sheet int,	
	@creator_sid varchar(46)
AS
begin
set nocount on;
declare @id_issued_zip_item int

declare curs cursor FAST_FORWARD for
select id from service_sheet_issued_zip_items where enabled=1 and id_service_sheet=@id_service_sheet

OPEN curs

begin try

FETCH NEXT FROM curs
INTO @id_issued_zip_item


BEGIN tran
WHILE @@FETCH_STATUS = 0
BEGIN

	insert into service_sheet_ordered_zip_items (id_issued_zip_item, id_service_sheet, creator_sid, part_num, name, count)
	select @id_issued_zip_item, @id_service_sheet, @creator_sid, part_num, name, count from service_sheet_issued_zip_items where id=@id_issued_zip_item

	FETCH NEXT FROM curs
	INTO @id_issued_zip_item

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
