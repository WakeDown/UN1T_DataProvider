CREATE PROCEDURE [dbo].[close_claim]@sid varchar(46), @deleter_sid varchar(46)
AS
    BEGIN
        SET NOCOUNT ON;
        UPDATE  claims
        SET     enabled = 0, dattim2 = getdate(), deleter_sid=@deleter_sid
        WHERE   sid = @sid
    END
