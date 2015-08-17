-- =============================================
-- Author:		Anton Rekhov
-- Create date: 18.03.2014
-- Description:	Получаем контрагентов, так как их список находится в БД Эталон на другом сервере, поэтому так делаем
-- =============================================
CREATE FUNCTION [dbo].[get_contractor]
    (
      --если NULL то возвращаем весь список
      @id_contractor INT = NULL
    )
RETURNS TABLE
AS
RETURN
    ( SELECT    ctr.recordid AS id ,
                ctr.o2s5xclow3h COLLATE Cyrillic_General_CI_AS AS NAME ,
                ctr.o2s5xclow3h + ' (ИНН ' + CONVERT(NVARCHAR, ctr.o2s5xclow3t)
                + ')' COLLATE Cyrillic_General_CI_AS AS name_inn ,
                ctr.o2s5xclsha0 COLLATE Cyrillic_General_CI_AS AS full_name ,
                ctr.o2s5xclow3t COLLATE Cyrillic_General_CI_AS AS inn
      FROM      [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_o2s5xclp1y3 ctr
      WHERE     ctr.recordid > 0 
                --Filter
                AND ( @id_contractor IS NULL
                      OR ( @id_contractor > 0
                           AND ctr.recordid = @id_contractor
                         )
                    )
                --/Filter
    )
