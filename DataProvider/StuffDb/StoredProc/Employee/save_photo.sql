﻿CREATE PROCEDURE [dbo].[save_photo]
    @id_employee INT ,
    @picture IMAGE
AS
    BEGIN
        SET nocount ON;
        IF EXISTS ( SELECT  1
                    FROM    photos p
                    WHERE   p.id_employee = @id_employee )
            BEGIN
                UPDATE  photos
                SET     picture = @picture
				where id_employee = @id_employee
            END
        ELSE
            BEGIN
                INSERT  INTO photos
                        ( id_employee ,picture )
                VALUES  ( @id_employee, @picture )
            END
    END
