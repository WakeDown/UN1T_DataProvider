CREATE PROCEDURE [dbo].[get_claim_client_list]
AS
begin
set nocount on;
SELECT c.id_contractor as id, contractor_name as name, COUNT(1) AS cnt 
	FROM dbo.claims_view c
	GROUP BY c.id_contractor, contractor_name
end

