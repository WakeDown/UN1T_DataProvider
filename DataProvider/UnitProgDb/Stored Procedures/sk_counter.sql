-- =============================================
-- Author:		Rekhov Anton
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sk_counter]
    @action NVARCHAR(50) = NULL ,
    @descr NVARCHAR(150) = NULL ,
    @id_program INT = NULL ,
    @id_user INT = NULL ,
    @date_came DATETIME = NULL ,
    @id_counter INT = NULL,
    @ip_address NVARCHAR(50) = NULL,
    @user_login NVARCHAR(50) = NULL
AS
    BEGIN
        SET NOCOUNT ON;

        IF @action = 'insCounter'
            BEGIN
                INSERT  INTO dbo.COUNTER
                        ( id_program ,
                          id_user ,
                          date_came ,
                          descr,
                          ip_address,
                          user_login
                        )
                VALUES  ( @id_program ,
                          @id_user ,
                          GETDATE() ,
                          @descr,
                          @ip_address,
                          @user_login
                        )		
            END
    END
