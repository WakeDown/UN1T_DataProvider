CREATE PROCEDURE CreateUN1TCategory 
(
	@id int,
	@idParent int,
	@name nvarchar(250)
)
AS 
INSERT INTO UN1TCategory VALUES(@id, @idParent, @name)
