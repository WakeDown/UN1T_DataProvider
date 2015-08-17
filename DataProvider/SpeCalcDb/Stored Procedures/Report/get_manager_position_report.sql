CREATE PROCEDURE [dbo].[get_manager_position_report]
	@date_start DATE, @date_end date
AS
begin

SELECT c.Manager,
(SELECT COUNT(1) FROM dbo.ClaimPosition p WHERE p.Deleted=0 and p.IdClaim=c.Id) AS position_count,
(SELECT COUNT(1) FROM dbo.CalculateClaimPosition cp WHERE cp.Deleted=0 AND cp.IdClaim=c.id ) AS calc_count,
c.ClaimStatus,
s.Value,
c.ManagerSubDivision
FROM dbo.TenderClaim c
INNER JOIN dbo.ClaimStatus s ON c.ClaimStatus=s.Id
WHERE c.Deleted = 0
AND c.RecordDate BETWEEN @date_start AND @date_end

end
