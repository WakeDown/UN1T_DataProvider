CREATE PROCEDURE CreateProviderCategory
(
	@id nvarchar(100),
	@idType int,
	@idParent nvarchar(100),
	@idParentType int,
	@provider int,
	@idUN1TCategory int
)
AS 
INSERT INTO ProviderCategory VALUES(@id, @idType, @idParent, @idParentType, @provider, @idUN1TCategory)
