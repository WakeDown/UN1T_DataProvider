CREATE PROCEDURE [dbo].[get_budget]
	@id int
AS
begin
set nocount on;
	select id, name, descr, creator_sid, id_parent
	from budget
	where id=@id
end
