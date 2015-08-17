-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[srvpl_get_device_name]
    (
      @id INT ,
      @settings NVARCHAR(50) = NULL
    )
RETURNS NVARCHAR(500)
AS
    BEGIN
        DECLARE @result NVARCHAR(MAX) ,
            @new_line NVARCHAR(10) ,
            @var_int INT ,
            @action NVARCHAR(50)
        
        SET @new_line = '<br />'
        
        IF @settings IS NULL
            OR LTRIM(RTRIM(@settings)) = ''
            BEGIN
                SELECT  @result = ( SELECT  ISNULL(t.vendor, '') + ' '
                                            + ISNULL(t.name, '')
                                    FROM    ( SELECT    dm.vendor ,
                                                        dm.name
                                              FROM      dbo.srvpl_device_models dm
                                              WHERE     dm.id_device_model = d.id_device_model
                                            ) AS t
                                  ) + ISNULL(d.serial_num, '')
                FROM    dbo.srvpl_devices d
                WHERE   d.id_device = @id
            END
        ELSE IF @settings = 'no_serial_num'
        BEGIN
        SELECT  @result = ( SELECT  ISNULL(t.vendor, '') + ' '
                                            + ISNULL(t.name, '')
                                    FROM    ( SELECT    dm.vendor ,
                                                        dm.name
                                              FROM      dbo.srvpl_device_models dm
                                              WHERE     dm.id_device_model = d.id_device_model
                                            ) AS t
                                  )
                FROM    dbo.srvpl_devices d
                WHERE   d.id_device = @id
        end
        

        RETURN @result

    END
