
create procedure LoadOverdieTenderClaim
as
select Id from TenderClaim where Deleted = 0 and ClaimStatus in(2,3,6,7) and ClaimDeadline > GETDATE()
