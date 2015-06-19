
CREATE procedure [dbo].[SaveTenderClaim]
(
	@tenderNumber nvarchar(150) = '',
	@tenderStart datetime,
	@claimDeadline datetime,
	@kPDeadline datetime,
	@comment nvarchar(1000) = '',
	@customer nvarchar(150),
	@customerInn nvarchar(150)=NULL,
	@totalSum decimal(18,2) = -1,
	@dealType int,
	@tenderUrl nvarchar(1500) = '',
	@tenderStatus int,
	@manager nvarchar(500),
	@managerSubDivision nvarchar(500),
	@claimStatus int,
	@recordDate datetime,
	@author nvarchar(150),
	@currencyUsd decimal(18,2) = -1,
	@currencyEur decimal(18,2) = -1,
	@deliveryDate datetime = null,
	@deliveryPlace nvarchar(1000) = '',
	@auctionDate datetime = null,
	@deleted BIT,
	@idSumCurrency int = NULL,
	@deliveryDateEnd datetime = null
)
as
declare @id int;
insert into TenderClaim values(@tenderNumber, @tenderStart, @claimDeadline, @kPDeadline, @comment, @customer, 
	@customerInn, @totalSum, @dealType, @tenderUrl, @tenderStatus, @manager, @managerSubDivision, @claimStatus, @recordDate, 
	@deleted, @author, null, null, @currencyUsd, @currencyEur, @deliveryDate, @deliveryPlace, @auctionDate, @idSumCurrency, @deliveryDateEnd)
set @id = @@IDENTITY;
select @id;
