CREATE PROCEDURE SaveProductProperty
(
	@partNumber nvarchar(100),
	@provider int,
	@idPropertyProvider varchar(100),
	@idPropertyProviderType int,
	@name nvarchar(200),
	@value nvarchar(500)
)
AS
DECLARE @id int;
SET @id = (SELECT Id FROM Product WHERE PartNumber = @partNumber);
IF @id IS NOT NULL
BEGIN
	DECLARE @count int;
	SET @count = (SELECT COUNT(*) FROM ProductProperty WHERE IdProduct = @id AND Provider = @provider AND IdPropertyProvider = @idPropertyProvider);
	IF @count = 0
	BEGIN
		INSERT INTO ProductProperty VALUES(@id, @provider, @idPropertyProvider, @idPropertyProviderType, @name, @value)
	END
END
