
create procedure ChangePositionsProduct
(
	@ids nvarchar(max),
	@product nvarchar(500)
)
as
update ClaimPosition set ProductManager = @product where Deleted = 0 and Id in (select * from dbo.Split(@ids,','));
