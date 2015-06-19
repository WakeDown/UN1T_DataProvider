
CREATE procedure FilterTenderClaimsCount
(
 @idClaim int = null,
 @tenderNumber nvarchar(150) = null,
 @claimStatusIds nvarchar(max) = null,
 @manager nvarchar(500) = null,
 @managerSubDivision nvarchar(500) = null,
 @tenderStartFrom datetime = null,
 @tenderStartTo datetime = null,
 @overdie bit = null,
 @idProductManager nvarchar(500) = null,
 @author nvarchar(150) = null
)
as
select count(*) from TenderClaim where Deleted = 0 and ((@idClaim is null) or (@idClaim is not null and Id = @idClaim)) 
and ((@tenderNumber is null) or (@tenderNumber is not null and TenderNumber = @tenderNumber))
and ((@claimStatusIds is null) or (@claimStatusIds is not null and ClaimStatus in (select * from dbo.Split(@claimStatusIds,','))))
and ((@manager is null) or (@manager is not null and Manager = @manager))
and ((@managerSubDivision is null) or (@managerSubDivision is not null and ManagerSubDivision = @managerSubDivision))
and ((@author is null) or (@author is not null and Author = @author))
and ((@idProductManager is null) or (@idProductManager is not null and @idProductManager in (select ProductManager from ClaimPosition where IdClaim = [TenderClaim].Id)))
and ((@overdie is null) or (@overdie is not null and 
((@overdie = 1 and GETDATE() > ClaimDeadline  and ClaimStatus not in(1,8)) or (@overdie = 0 and GETDATE() < ClaimDeadline  and ClaimStatus not in(1,8)))))
and ((@tenderStartFrom is null and @tenderStartTo is null) or (@tenderStartFrom is not null and @tenderStartTo is not null
and ClaimDeadline BETWEEN @tenderStartFrom AND @tenderStartTo) or (@tenderStartFrom is null and @tenderStartTo is not null
and ClaimDeadline <= @tenderStartTo) or (@tenderStartFrom is not null and @tenderStartTo is null
and ClaimDeadline >= @tenderStartFrom))
