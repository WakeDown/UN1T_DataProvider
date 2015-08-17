CREATE PROCEDURE [dbo].[get_employee_sm]
    @id INT = NULL ,
	@ad_sid VARCHAR(46) = NULL
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  e.id ,
                ad_sid ,
                e.full_name ,
                display_name ,
				email              
        FROM    employees e
        WHERE ((@id is null or @id <= 0) or (@id is not null and @id > 0 and e.id = @id))
		and ((@ad_sid is null or @ad_sid = '') or (@ad_sid is not null and @ad_sid != '' and e.ad_sid = @ad_sid))
    END
