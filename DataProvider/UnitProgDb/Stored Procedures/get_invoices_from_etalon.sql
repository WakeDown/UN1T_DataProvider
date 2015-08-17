-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[get_invoices_from_etalon]
	
AS
BEGIN
	SET NOCOUNT ON;

--SELECT 
----ИНН
--ctr.o2s5xclow3t as [ИНН],
----КПП
--ctr.ithcg2ed5hl8 as [КПП],
----№ сч. фактуры - 
--sf.o2s5xcm9gd7 as [№ сч. фактуры],
----дата сч. фактуры - 
--sf.o2s5xcljjcl as [дата сч. фактуры],
----Сумма по сч. фактуре - 
--sf.o2s5xclwhkd as [Сумма по сч. фактуре],
----Статус сч. Фактуры - 
--sf.ixvblg5sd6wj as [Статус сч. Фактуры]
--FROM [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_o2s5xclwmid sf
--INNER JOIN [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_o2s5xclp1y3 ctr ON ctr.recordid = sf.o2s5xclwi70

    DECLARE /*@table NVARCHAR(MAX), @html NVARCHAR(MAX),*/ @xml NVARCHAR(MAX), @rows_count NVARCHAR(50)

----------SET @html = ''

----------SET @table = ''

----------SET @html = '<!DOCTYPE html><html xmlns="http://www.w3.org/1999/xhtml"><head runat="server"><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/><title></title></head><body>'

----------SET @table = '<table><tr><td>ИНН</td><td>КПП</td><td>№ сч. фактуры</td><td>Дата сч. фактуры</td><td>Сумма по сч. фактуре</td><td>Статус сч. Фактуры</td></tr>'

SET @xml = '<?xml version="1.0" encoding="UTF-8" ?><root>'

----------SET @table = @table +
SET @xml = @xml +
cast ((
----------(закоментировано) Ниже выводится счета фактуры из Эталон
----------SELECT 
----------[Tag] = 1, [Parent] = 0, 

------------ИНН
----------[tr!1!td!element] = ctr.o2s5xclow3t,
------------КПП
----------[tr!1!td!element] = ctr.ithcg2ed5hl8,
------------№ сч. фактуры - 
----------[tr!1!td!element] = sf.o2s5xcm9gd7,
------------дата сч. фактуры - 
----------[tr!1!td!element] = CONVERT(VARCHAR, sf.o2s5xcljjcl, 104),
------------Сумма по сч. фактуре - 
----------[tr!1!td!element] = sf.o2s5xclwhkd,
------------Статус сч. Фактуры - 
----------[tr!1!td!element] = sf.ixvblg5sd6wj
----------FROM [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_o2s5xclwmid sf
----------INNER JOIN [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_o2s5xclp1y3 ctr ON ctr.recordid = sf.o2s5xclwi70
------------WHERE YEAR(sf.o2s5xcljjcl) = YEAR(GETDATE()) AND MONTH(sf.o2s5xcljjcl) = MONTH(GETDATE())
----------for xml explicit

/*
--Выгрузка контрагентов у которых есть хотябы одна отгрузка по счету и сумма фактической оплаты по отгрузкам
SELECT * FROM (
SELECT ctr.full_name, ctr.inn, SUM(CONVERT(DECIMAL(10,2), fs.ixvblg5vvlxn)) AS summ FROM dbo.get_contractor(NULL) AS ctr
INNER JOIN [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_ixvblm2ba8yp s ON ctr.id = s.o2s5xclwi70
INNER JOIN [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_ixsjtkbunr4o p on s.recordid = p.ixvblg5vvjxm
INNER JOIN [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_ixsjtkbuqxqv fs ON p.recordid = fs.ixsjtkbuqxm2
WHERE ltrim(rtrim(p.ixsjtkbunqfe)) = 'Фактическая отгрузка' and YEAR(s.o2s5xd19zhb) IN (2013, 2014)
GROUP BY ctr.full_name, ctr.inn
) AS T
WHERE T.summ > 10000000
*/


--Ниже выводится список Счетов на предоплату для которых есть хотябы одна фактическая отгрузка из Эталон
SELECT 
[Tag] = 1, [Parent] = 0,
--Номер Счета на предоплату
[invoice!1!code!element] = s.o2s5xcm9gd7, 
--Сумма по Счету на предоплату
[invoice!1!amount!element] = s.o2s5xclwhkd, 
--Дата Счета на предоплату
[invoice!1!date!element] = s.o2s5xcljjcl,  
--КПП
[invoice!1!kpp!element] = ctr.ithcg2ed5hl8, 
--ИНН
[invoice!1!inn!element] = ctr.o2s5xclow3t
FROM [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_ixvblm2ba8yp s
INNER JOIN [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_o2s5xclp1y3 ctr ON ctr.recordid = s.o2s5xclwi70
WHERE EXISTS(SELECT 1 FROM [ufs-db2].[UNIT_WORK].UNIT_WORK.et6_ixsjtkbunr4o p where s.recordid = p.ixvblg5vvjxm and ltrim(rtrim(p.ixsjtkbunqfe)) = 'Фактическая отгрузка')
for xml explicit
) as NVARCHAR(MAX) )

----------SET @table = @table + '</table>'

----------SET @html = @html + @table + '</body></html>'


----------SELECT @html AS html

SET @xml = @xml + '</root>'

SELECT @xml AS data

END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[get_invoices_from_etalon] TO [sqlUnit_prog]
    AS [dbo];

