CREATE PROCEDURE [dbo].[DeleteClaimCertFile]
	@Id INT,
	@file VARBINARY(MAX) 
AS
BEGIN
set NOCOUNT ON;
update ClaimCertFiles 
set fileDATA = @file
where Id=@Id

END