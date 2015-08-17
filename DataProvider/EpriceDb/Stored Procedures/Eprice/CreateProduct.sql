CREATE PROCEDURE CreateProduct
(
	@idCategory int,
	@name nvarchar(1000),
	@vendor nvarchar(200), 
	@brand nvarchar(200),
	@partNumber nvarchar(100),
  @provider int,
  @recordDate datetime2(7)
)
AS
DECLARE @return int;
DECLARE @count int;
SET @count = (SELECT COUNT(*) FROM Product WHERE PartNumber = @partNumber);
IF @count = 0
BEGIN
	SET @return = 1;
	INSERT INTO Product VALUES(@idCategory, @name, @vendor, @brand, @partNumber, @provider, @recordDate)
END 
IF @count != 0
BEGIN
	SET @return = 0;
	IF @brand IS NOT NULL
	BEGIN
		DECLARE @currentBrand nvarchar(200);
		SET @currentBrand = (SELECT Brand FROM Product WHERE PartNumber = @partNumber);
		IF @currentBrand IS NULL
		BEGIN
			UPDATE Product SET Brand = @brand WHERE PartNumber = @partNumber
		END
	END
	IF @vendor IS NOT NULL
	BEGIN
		DECLARE @currentVendor nvarchar(200);
		SET @currentVendor = (SELECT Vendor FROM Product WHERE PartNumber = @partNumber);
		IF @currentVendor IS NULL
		BEGIN
			UPDATE Product SET Vendor = @vendor WHERE PartNumber = @partNumber
		END
	END
END
SELECT @return
