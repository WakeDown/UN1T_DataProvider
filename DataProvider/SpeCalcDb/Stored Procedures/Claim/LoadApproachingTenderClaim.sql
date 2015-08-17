
create procedure LoadApproachingTenderClaim
as
select Id from TenderClaim where Deleted = 0 and ClaimStatus not in(4,5,8) and datediff(hour, GETDATE(), ClaimDeadline) <= 24
