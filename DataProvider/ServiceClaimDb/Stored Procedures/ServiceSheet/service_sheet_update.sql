CREATE PROCEDURE [dbo].[service_sheet_update]
	@id int,
	@not_installed_comment nvarchar(MAX)
AS
begin
set nocount on;

update service_sheet
set not_installed_comment = @not_installed_comment
where id = @id

end
