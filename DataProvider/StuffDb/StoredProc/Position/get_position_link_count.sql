CREATE Procedure [dbo].[get_position_link_count]
(
	@id int
)
AS
BEGIN
	select count(1) from employees_view e where e.id_position=@id
END
