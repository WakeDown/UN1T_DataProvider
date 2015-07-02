CREATE PROCEDURE [dbo].[get_employees_newbie]
	@date_came date
AS
    BEGIN
        SET NOCOUNT ON;
		SELECT id, full_name, position,city,department, date_create 
		FROM employees_view where convert(date,date_create) = @date_came
    END