CREATE PROCEDURE LoadAllUN1TCategory
AS 
SELECT *, (SELECT COUNT(*) FROM ProviderCategory WHERE IdUN1TCategory = UN1TCategory.Id) FROM UN1TCategory
