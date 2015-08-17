
create procedure GetTenderClaimCount
as
select count(*) from TenderClaim where Deleted = 0
