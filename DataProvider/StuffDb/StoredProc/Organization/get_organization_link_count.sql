CREATE PROCEDURE [dbo].[get_organization_link_count]
(
	@id int
)
AS
BEGIN
	select count(1) from employees_view e where e.id_organization=@id
END
