/*
Скрипт развертывания для tenderProcessing

Этот код был создан программным средством.
Изменения, внесенные в этот файл, могут привести к неверному выполнению кода и будут потеряны
в случае его повторного формирования.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "tenderProcessing"
:setvar DefaultFilePrefix "tenderProcessing"
:setvar DefaultDataPath "E:\mssql\"
:setvar DefaultLogPath "E:\mssql\"

GO
:on error exit
GO
/*
Проверьте режим SQLCMD и отключите выполнение скрипта, если режим SQLCMD не поддерживается.
Чтобы повторно включить скрипт после включения режима SQLCMD выполните следующую инструкцию:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'Для успешного выполнения этого скрипта должен быть включен режим SQLCMD.';
        SET NOEXEC ON;
    END


GO
IF (SELECT is_default
    FROM   [$(DatabaseName)].[sys].[filegroups]
    WHERE  [name] = N'ContentDBFSGroup') = 0
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            MODIFY FILEGROUP [ContentDBFSGroup] DEFAULT;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Выполняется изменение [dbo].[LoadCalculateClaimPositionForClaim]...';


GO

ALTER procedure LoadCalculateClaimPositionForClaim
(
	@id int
)
as
select [Id]         ,
    [IdPosition]    ,
    [IdClaim]     ,
    [CatalogNumber] ,
    [Name]         ,
    [ReplaceValue]  ,
    [PriceCurrency]  ,
    [SumCurrency]   ,
    [PriceRub]     ,
    [SumRub]      ,
    [Provider]    ,
    [ProtectFact] ,
    [ProtectCondition] ,
    [Comment]  ,
    [Author]  ,
    [Deleted]  ,
    [DeletedUser] ,
    [DeleteDate]  ,
    [Currency]   ,
    [PriceUsd]  ,
    [PriceEur]  ,
    [PriceEurRicoh]  ,
    [PriceRubl]   ,
    [DeliveryTime]  
from CalculateClaimPosition where Deleted = 0 and IdClaim = @id
GO
PRINT N'Выполняется изменение [dbo].[SaveCalculateClaimPosition]...';


GO

ALTER PROCEDURE [dbo].[SaveCalculateClaimPosition]
    (
      @idPosition INT ,
      @idClaim INT ,
      @catalogNumber NVARCHAR(500) = '' ,
      @name NVARCHAR(1000) = '' ,
      @replaceValue NVARCHAR(1000) = '' ,
      @priceCurrency DECIMAL(18, 2) = -1 ,
      @sumCurrency DECIMAL(18, 2) = -1 ,
      @priceRub DECIMAL(18, 2) = -1 ,
      @sumRub DECIMAL(18, 2) = -1 ,
      @provider NVARCHAR(150) = '' ,
      @protectFact INT = NULL ,
      @protectCondition NVARCHAR(500) = '' ,
      @comment NVARCHAR(1500) = '' ,
      @author NVARCHAR(150) ,
      @currency INT = NULL ,
      @priceUsd DECIMAL(18, 2) = NULL ,
      @priceEur DECIMAL(18, 2) = NULL ,
      @priceEurRicoh DECIMAL(18, 2) = NULL ,
      @priceRubl DECIMAL(18, 2) = NULL ,
      @deliveryTime INT = NULL
    )
AS
    DECLARE @id INT;
    INSERT  INTO CalculateClaimPosition
            ( IdPosition ,
              IdClaim ,
              CatalogNumber ,
              Name ,
              ReplaceValue ,
              PriceCurrency ,
              SumCurrency ,
              PriceRub ,
              SumRub ,
              Provider ,
              ProtectFact ,
              ProtectCondition ,
              Comment ,
              Author ,
              DELETED ,
              [DeletedUser] ,
              [DeleteDate] ,
			  [Currency],
              [PriceUsd] ,
              [PriceEur] ,
              [PriceEurRicoh] ,
              [PriceRubl] ,
              [DeliveryTime]
            )
    VALUES  ( @idPosition ,
              @idClaim ,
              @catalogNumber ,
              @name ,
              @replaceValue ,
              @priceCurrency ,
              @sumCurrency ,
              @priceRub ,
              @sumRub ,
              @provider ,
              @protectFact ,
              @protectCondition ,
              @comment ,
              @author ,
              0 ,
              NULL ,
              NULL ,
              NULL ,
              @priceUsd ,
              @priceEur ,
              @priceEurRicoh ,
              @priceRubl ,
              @deliveryTime
            )
    SET @id = @@IDENTITY;
    SELECT  @id;
GO
/*
Шаблон скрипта после развертывания							
--------------------------------------------------------------------------------------
 В данном файле содержатся инструкции SQL, которые будут добавлены в скрипт построения.		
 Используйте синтаксис SQLCMD для включения файла в скрипт после развертывания.			
 Пример:      :r .\myfile.sql								
 Используйте синтаксис SQLCMD для создания ссылки на переменную в скрипте после развертывания.		
 Пример:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

GRANT EXECUTE ON SCHEMA ::dbo TO sqlUnit_prog
DELETE QuestionStates

INSERT INTO QuestionStates (id, name, sys_name, order_num)
Values (1, N'Создан', N'NEW', 1)

INSERT INTO QuestionStates (id, name, sys_name, order_num)
Values (2, N'Передан', N'SENT', 2)

INSERT INTO QuestionStates (id, name, sys_name, order_num)
Values (3, N'В работе', N'PROCESS', 3)

INSERT INTO QuestionStates (id, name, sys_name, order_num)
Values (4, N'Получен ответ', N'GETANSWER', 4)

INSERT INTO QuestionStates (id, name, sys_name, order_num)
Values (5, N'Подтвержден', N'APROVE', 5)
GO

GO
PRINT N'Обновление завершено.';


GO
