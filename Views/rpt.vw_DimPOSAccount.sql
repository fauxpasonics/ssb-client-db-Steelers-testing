SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [rpt].[vw_DimPOSAccount] WITH SCHEMABINDING
AS


SELECT DimAccountId, ETL_CreatedDate, ETL_UpdatedDate, ETL_IsDeleted, ETL_DeletedDate, ETL_SourceSystem, ETL_DeltaHashKey,
	ETL_SSID, ETL_SSID_Id, Id, Prefix, FirstName, MiddleName, LastName, Suffix, Username, Email, Phone, Gender, IsActive,
	AccountType, IsLoyaltyMember, LoyaltyId, CreatedDate, UpdatedDate 
FROM dbo.DimPOSAccount
;



GO
