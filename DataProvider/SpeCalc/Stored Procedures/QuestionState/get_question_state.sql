CREATE PROCEDURE [dbo].[get_question_state]
    @id INT = NULL ,
    @sys_name NVARCHAR(50) = NULL
AS
    BEGIN
        SET nocount ON;
        SELECT  id ,
                name ,
                UPPER(sys_name) AS sys_name,
				order_num
        FROM    QuestionStates
        WHERE   enabled = 1
                AND ( @id IS NULL
                      OR @id <= 0
                      OR ( @id > 0
                           AND @id IS NOT NULL
                           AND id = @id
                         )
                    )
                AND ( @sys_name IS NULL
                      OR @sys_name = ''
                      OR ( @sys_name IS NOT NULL
                           AND @sys_name <> ''
                           AND LOWER(sys_name) = LOWER(@sys_name)
                         )
                    )
    END
