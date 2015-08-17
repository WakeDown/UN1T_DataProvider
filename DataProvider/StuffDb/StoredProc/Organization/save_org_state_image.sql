CREATE PROCEDURE [dbo].[save_org_state_image]
	@id_organization INT,
	@data VARBINARY(MAX)
AS
BEGIN
set NOCOUNT ON;
declare @id int
INSERT INTO org_state_images(id_organization, data)
values(@id_organization, @data)
select @id=@@IDENTITY
select @id as id
END
