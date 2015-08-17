CREATE PROCEDURE DeleteUN1TCategory
(
	@id int
)
AS 
DELETE FROM UN1TCategory WHERE Id = @id
