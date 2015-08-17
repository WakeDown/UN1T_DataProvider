CREATE PROCEDURE UpdateUN1TCategory
(
	@id int,
	@name nvarchar(250)
)
AS 
UPDATE UN1TCategory SET Name = @name WHERE Id = @id
