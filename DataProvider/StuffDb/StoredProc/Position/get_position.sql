CREATE PROCEDURE [dbo].[get_position]
	@id int = null
AS
begin
SET NOCOUNT ON;
	select id, name from positions p
	where p.enabled=1
	AND ( @id IS NULL
                      OR ( @id IS NOT NULL
                           AND @id > 0
                           AND p.id = @id
                         )
                    )
end