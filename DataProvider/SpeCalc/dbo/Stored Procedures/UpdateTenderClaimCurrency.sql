
create procedure UpdateTenderClaimCurrency
(
	@id int,
	@currencyUsd decimal(18,2) = -1,
	@currencyEur decimal(18,2) = -1
)
as
if @currencyUsd != -1
begin 
	update TenderClaim set CurrencyUsd = @currencyUsd where Id = @id
end
if @currencyEur != -1
begin 
	update TenderClaim set CurrencyEur = @currencyEur where Id = @id
end
