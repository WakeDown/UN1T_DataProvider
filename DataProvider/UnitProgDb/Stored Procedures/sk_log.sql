
-- =============================================
-- Author:		Anton Rekhov
-- Create date: 26.08.2013
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[sk_log]
    @action NVARCHAR(50) = NULL ,
    @descr NVARCHAR(MAX) = NULL ,
    @proc_name NVARCHAR(150) = NULL ,
    @id_program INT = NULL ,
    @params NVARCHAR(MAX) = NULL ,
    @sp_test BIT = NULL --переменная для тестирования
    ,
    @subject NVARCHAR(100) = NULL ,
    @body NVARCHAR(MAX) = NULL ,
    @recipients NVARCHAR(MAX) = NULL ,
    @error_level INT = NULL
AS
    BEGIN
        SET NOCOUNT ON;

        IF @id_program IS NULL
            BEGIN
                SELECT  @id_program = p.id_program
                FROM    programs p
                WHERE   p.enabled = 1
                        AND LOWER(p.sys_name) = LOWER('EMPTY')
            END

        IF @proc_name IS NULL
            BEGIN
                SET @proc_name = 'NULL'
            END

        IF @params IS NULL
            BEGIN
                SET @params = 'NULL'
            END
            
        SELECT  @error_level = ISNULL(@error_level, 0)

        IF @action = 'insLog'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                INSERT  INTO [dbo].[log_tab]
                        ( [id_program] ,
                          [proc_name] ,
                          params ,
                          [dattim] ,
                          [user] ,
                          [descr] ,
                          error_level
			            )
                VALUES  ( @id_program ,
                          @proc_name ,
                          @params ,
                          GETDATE() ,
                          SYSTEM_USER ,
                          @descr ,
                          @error_level
			            )
            END
        ELSE
            IF @action = 'insMessageLog'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    INSERT  INTO [dbo].[mlog_tab]
                            ( [id_program] ,
                              params ,
                              [dattim] ,
                              [user] ,
                              [descr] ,
                              [SUBJECT] ,
                              body ,
                              recipients ,
                              error_level                        
			                )
                    VALUES  ( @id_program ,
                              @params ,
                              GETDATE() ,
                              SYSTEM_USER ,
                              @descr ,
                              @subject ,
                              @body ,
                              @recipients ,
                              @error_level
			                )
                END
    END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[sk_log] TO [sqlChecker]
    AS [dbo];

