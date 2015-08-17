CREATE PROCEDURE [dbo].[save_document] 
	@data VARBINARY(MAX),
	@name NVARCHAR(500),
	@creator_sid VARCHAR(46)
AS
BEGIN
	SET NOCOUNT ON;
DECLARE @id int
   INSERT INTO documents (data, name,creator_sid)
   VALUES(@data, @name, @creator_sid)
   SET @id=@@IDENTITY
   SELECT @id AS  id
END