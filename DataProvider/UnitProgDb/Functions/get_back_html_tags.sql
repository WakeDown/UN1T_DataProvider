-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION get_back_html_tags
(
	@string nvarchar(max)
)
RETURNS nvarchar(max)
AS
BEGIN
	DECLARE @result nvarchar(max)

	SELECT @result = replace(replace(@string, '&lt;', '<'), '&gt;', '>')

	RETURN @result

END
