-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[prepare_name]
(
	@type NVARCHAR(50) = NULL, --types = 'full', 'short'
	@surname nvarchar(150) = NULL,
	@name nvarchar(150) = NULL,
	@patronymic nvarchar(150) = null
)
RETURNS nvarchar(MAX)
AS
BEGIN
	DECLARE @result nvarchar(MAX) = null
	
	SET @name = ISNULL(LTRIM(RTRIM(@name)), '')
	SET @surname = ISNULL(LTRIM(RTRIM(@surname)), '')
	SET @patronymic = ISNULL(LTRIM(RTRIM(@patronymic)), '')

	IF @type = 'full'
	BEGIN
		SELECT @result = @surname + CASE WHEN @name != '' THEN ' ' + @name ELSE '' END
                                    + CASE WHEN @patronymic != ''
                                           THEN ' ' + @patronymic
                                           ELSE ''
                                      END 
	END
	ELSE IF @type = 'short'
	BEGIN
		SELECT @result = @surname + ' ' + CASE WHEN @name != '' then UPPER(SUBSTRING(@name, 0, 2)) ELSE '' end + '.'
                                    + CASE WHEN @patronymic != ''
                                           THEN UPPER(SUBSTRING(@patronymic, 0,
                                                              2)) + '.'
                                           ELSE ''
                                      END
	END

	RETURN @result
END
