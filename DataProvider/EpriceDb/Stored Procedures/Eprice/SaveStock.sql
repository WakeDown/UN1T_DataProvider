CREATE PROCEDURE SaveStock
(
	@partNumber nvarchar(100),
	@currency int,
	@location int,
	@value int,
	@price decimal(18,2),
	@provider int,
  @recordDate datetime2(7)
)
AS
DECLARE @id int;
SET @id = (SELECT Id FROM Product WHERE PartNumber = @partNumber);
IF @id IS NOT NULL
BEGIN
	INSERT INTO Stock VALUES(@id, @currency, @location, @value, @price, @provider, @recordDate)
END
