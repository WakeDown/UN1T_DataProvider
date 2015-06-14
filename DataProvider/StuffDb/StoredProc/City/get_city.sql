CREATE PROCEDURE [dbo].[get_city]
	@id int = null
	
AS
begin
SET NOCOUNT ON;
	select id, name from cities c
	where c.enabled=1
	AND ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND c.id = @id
                         )
                    )
end
