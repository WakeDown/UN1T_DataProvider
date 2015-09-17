CREATE PROCEDURE [dbo].[get_language_list]
	as begin
	set nocount on;

	select id, name from languages
	order by order_num, name

	end