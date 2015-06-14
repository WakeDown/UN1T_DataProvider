CREATE PROCEDURE [dbo].[get_organization]
	@id int =null
AS
begin
SET NOCOUNT ON;
	select id, name from organizations o
	where o.enabled=1
	AND ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND o.id = @id
                         )
                    )
end
