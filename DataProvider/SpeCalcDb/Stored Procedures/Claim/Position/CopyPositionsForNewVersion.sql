CREATE PROCEDURE [dbo].[CopyPositionsForNewVersion]
	@idClaim int,
	@calcVersion int,
	@creatorSid varchar(46),
	@ids nvarchar(max)
	as begin
	set nocount on;
	begin try
	begin tran posVer
	declare @newVersion int, @curIdPosition int, @newIdPosition int
	set @newVersion = isnull((select max(Version)+1 from ClaimPosition where Deleted=0 and [IdClaim]=@idClaim), 1)


	declare curs Cursor for
	 select [Id]           
		   from [dbo].[ClaimPosition] where Deleted=0  and [IdClaim]=@idClaim and Version=@calcVersion

		   -- and id in (select value from Split(@ids, ','))

		   OPEN curs   
FETCH NEXT FROM curs INTO @curIdPosition  

WHILE @@FETCH_STATUS = 0   
BEGIN   
       INSERT INTO [dbo].[ClaimPosition]
           ([IdClaim]
           ,[RowNumber]
           ,[CatalogNumber]
           ,[Name]
           ,[ReplaceValue]
           ,[Unit]
           ,[Value]
           ,[ProductManager]
           ,[Comment]
           ,[Price]
           ,[SumMax]
           ,[PositionState]
           ,[Author]
           ,[Deleted]
           ,[Currency]
           ,[PriceTzr]
           ,[SumTzr]
           ,[PriceNds]
           ,[SumNds]
           ,[Version],
		   CopyFromVersion,
		   IdPositionParent)
		   select [IdClaim]
           ,[RowNumber]
           ,[CatalogNumber]
           ,[Name]
           ,[ReplaceValue]
           ,[Unit]
           ,[Value]
           ,[ProductManager]
           ,[Comment]
           ,[Price]
           ,[SumMax]
           ,[PositionState]
           ,@creatorSid
           ,0
           ,[Currency]
           ,[PriceTzr]
           ,[SumTzr]
           ,[PriceNds]
           ,[SumNds]
           ,@newVersion,
		   @calcVersion,
		   Id
		   from [dbo].[ClaimPosition] where Id =@curIdPosition

		   set @newIdPosition = SCOPE_IDENTITY()

		   if @curIdPosition in (select value from Split(@ids, ','))
		   begin
		   
		   --Те позиции которые були отмечены для актуализации меняем статус на Актуализация
update [dbo].[ClaimPosition] 
set PositionState=6
where Id =@newIdPosition
		   
		   end

		   
		   --if (@newIdPosition <= 0) throw 1, '@newIdPosition <= 0', 16;
		   if (@newIdPosition > 0 )
		   begin
		   insert into CalculateClaimPosition ([IdPosition], [IdClaim],[CatalogNumber],[Name], 
	[ReplaceValue] ,
    [PriceCurrency],
    [SumCurrency] ,
    [PriceRub],
    [SumRub],
    [Provider],
    [ProtectFact],
    [ProtectCondition],
    [Comment],
    [Author],
    [Deleted],
    --[DeletedUser],
    --[DeleteDate],
    [Currency] ,
    [PriceUsd]  ,
    [PriceEur]    ,
    [PriceEurRicoh] ,
    [PriceRubl]      ,
    [DeliveryTime],
    [Version],
	IdCalcPosParent)
	select @newIdPosition, [IdClaim],[CatalogNumber],[Name],
	[ReplaceValue],
	[PriceCurrency],
    [SumCurrency] ,
    [PriceRub],
    [SumRub],
    [Provider],
    [ProtectFact],
    [ProtectCondition],
    [Comment],
    @creatorSid,
    0,
    --[DeletedUser],
    --[DeleteDate],
    [Currency] ,
    [PriceUsd]  ,
    [PriceEur]    ,
    [PriceEurRicoh] ,
    [PriceRubl]      ,
    [DeliveryTime],
	@newVersion,
	Id from CalculateClaimPosition where Deleted=0 and IdPosition=@curIdPosition
	end
       FETCH NEXT FROM curs INTO @curIdPosition    
END   

CLOSE curs   
DEALLOCATE curs


	commit tran posVer

	select @newVersion as newVersion

	end try
	begin catch
	rollback tran posVer;
		THROW;

	end catch
	end
