CREATE PROCEDURE [dbo].[get_document_data]
	@sid varchar(46)
AS
begin
set nocount on;
select data from documents where data_sid=@sid
end
