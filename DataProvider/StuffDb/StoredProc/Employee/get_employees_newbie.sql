CREATE PROCEDURE [dbo].[get_employees_newbie]
	@date_came date
AS
    BEGIN
        SET NOCOUNT ON;
		--select id, full_name, position,city,department, date_newbie
		--from (
		SELECT id, full_name, position,city,department
		--, case when date_came is not null and convert(date,date_came) > convert(date,date_create) then convert(date,date_came) else convert(date,date_create) end as date_newbie
		FROM employees_view e where e.is_hidden = 0 and newvbie_delivery = 0
		--) as t
		--where t.date_newbie = @date_came
    END