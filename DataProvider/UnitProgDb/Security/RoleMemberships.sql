EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'sqltest';


GO
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'UN1T\Anton.Rehov';

