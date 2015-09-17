CREATE PROCEDURE [dbo].[get_classifier_attributes]
AS
	begin
	set nocount on;

	select 
	(select convert(decimal(10,2), value) from attributes where sys_name = 'CLSFRWAGE') as wage,
	(select convert(decimal(10,2), value) from attributes where sys_name = 'CLSFROVERHEAD') as overhead

	end
