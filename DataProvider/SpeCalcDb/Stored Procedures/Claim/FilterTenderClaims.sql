
CREATE PROCEDURE FilterTenderClaims
    (
      @rowCount INT ,
      @idClaim INT = NULL ,
      @tenderNumber NVARCHAR(150) = NULL ,
      @claimStatusIds NVARCHAR(MAX) = NULL ,
      @manager NVARCHAR(500) = NULL ,
      @managerSubDivision NVARCHAR(500) = NULL ,
      @tenderStartFrom DATETIME = NULL ,
      @tenderStartTo DATETIME = NULL ,
      @overdie BIT = NULL ,
      @idProductManager NVARCHAR(500) = NULL ,
      @author NVARCHAR(150) = NULL
    )
AS
    SELECT TOP ( @rowCount )
            *
    FROM    TenderClaim
    WHERE   Deleted = 0
            AND ( ( @idClaim IS NULL )
                  OR ( @idClaim IS NOT NULL
                       AND Id = @idClaim
                     )
                )
            AND ( ( @tenderNumber IS NULL )
                  OR ( @tenderNumber IS NOT NULL
                       AND TenderNumber = @tenderNumber
                     )
                )
            AND ( ( @claimStatusIds IS NULL )
                  OR ( @claimStatusIds IS NOT NULL
                       AND ClaimStatus IN (
                       SELECT   *
                       FROM     dbo.Split(@claimStatusIds, ',') )
                     )
                )
            AND ( ( @manager IS NULL )
                  OR ( @manager IS NOT NULL
                       AND (Manager = @manager OR Author=@manager)

                     )
                )
            AND ( ( @managerSubDivision IS NULL )
                  OR ( @managerSubDivision IS NOT NULL
                       AND ManagerSubDivision = @managerSubDivision
                     )
                )
            AND ( ( @author IS NULL )
                  OR ( @author IS NOT NULL
                       AND Author = @author
                     )
                )
            AND ( ( @idProductManager IS NULL )
                  OR ( @idProductManager IS NOT NULL
                       AND @idProductManager IN (
                       SELECT   ProductManager
                       FROM     ClaimPosition
                       WHERE    IdClaim = [TenderClaim].Id )
                     )
                )
            AND ( ( @overdie IS NULL )
                  OR ( @overdie IS NOT NULL
                       AND ( ( @overdie = 1
                               AND GETDATE() > ClaimDeadline
                               AND ClaimStatus NOT IN ( 1, 8 )
                             )
                             OR ( @overdie = 0
                                  AND GETDATE() < ClaimDeadline
                                  AND ClaimStatus NOT IN ( 1, 8 )
                                )
                           )
                     )
                )
            AND ( ( @tenderStartFrom IS NULL
                    AND @tenderStartTo IS NULL
                  )
                  OR ( @tenderStartFrom IS NOT NULL
                       AND @tenderStartTo IS NOT NULL
                       AND ClaimDeadline BETWEEN @tenderStartFrom
                                         AND     @tenderStartTo
                     )
                  OR ( @tenderStartFrom IS NULL
                       AND @tenderStartTo IS NOT NULL
                       AND ClaimDeadline <= @tenderStartTo
                     )
                  OR ( @tenderStartFrom IS NOT NULL
                       AND @tenderStartTo IS NULL
                       AND ClaimDeadline >= @tenderStartFrom
                     )
                )
    ORDER BY Id DESC
