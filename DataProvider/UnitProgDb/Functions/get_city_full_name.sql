-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION get_city_full_name
(
	@id_city INT
)
RETURNS NVARCHAR(250)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @full_name NVARCHAR(250)

	 SELECT @full_name = ISNULL(c.region + CASE WHEN c.locality IS NULL
                                                    AND c.name IS NULL
                                                    AND c.area IS NULL THEN ''
                                               ELSE ', '
                                          END, '') + ISNULL(c.area
                                                            + CASE
                                                              WHEN c.locality IS NULL
                                                              AND c.name IS NULL
                                                              THEN ''
                                                              ELSE ', '
                                                              END, '')
                        + ISNULL(c.name + CASE WHEN c.locality IS NULL THEN ''
                                               ELSE ', '
                                          END, '') + ISNULL(c.locality, '')
                        FROM    dbo.cities c
                        WHERE   c.id_city = @id_city

	RETURN @full_name
END
