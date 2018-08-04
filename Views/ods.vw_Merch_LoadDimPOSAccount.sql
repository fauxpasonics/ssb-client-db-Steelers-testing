SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [ods].[vw_Merch_LoadDimPOSAccount] AS (


SELECT ETL_ID, CustomerId AS ETL_SSID, CustomerId AS ETL_SSID_Id, CustomerId AS Id,
	NULL AS Prefix, FirstName, NULL AS MiddleName, LastName, NULL AS Suffix,
	Username, Email, Phone, NULL AS Gender, Active, AccountType,
	NULL AS IsLoyaltyMember, NULL AS LoyaltyId, CreatedDate, UpdatedDate, ETL_UpdatedDate
FROM (
	
-- select customers in ods.Merch_Customer
	SELECT ETL_ID, CustomerId, Email, Username, FirstName, LastName, Phone,
		Active, AccountType, CreatedDate, UpdatedDate, ETL_UpdatedDate
	FROM (
		SELECT MC.ETL_ID, MC.Id AS CustomerId, MC.Email, MC.Username,
			MA.FirstName, MA.LastName, CONVERT(NVARCHAR(25),MA.PhoneNumber) AS Phone, MC.Active,
			MC.CreatedOnUtc AS CreatedDate, MC.LastActivityDateUtc AS UpdatedDate, MC.ETL_UpdatedDate,
			CASE WHEN MO.CustomerId IS NOT NULL THEN 'Registered' ELSE 'Guest' END AS AccountType,
			ROW_NUMBER() OVER (PARTITION BY MC.Id ORDER BY MA.Id DESC) RowNum
		FROM ods.Merch_Customer MC
		LEFT JOIN ods.Merch_Address MA
			ON MC.Email = MA.Email
		LEFT JOIN ods.Merch_Order MO
			ON MC.Id = MO.CustomerId
		WHERE MC.Email <> ''
		) DT1
	WHERE RowNum = 1

	UNION

-- select customers that are not in ods.Merch_Customer
	SELECT ETL_ID, CustomerId, Email, Username, FirstName, LastName, Phone,
		Active, AccountType, CreatedDate, UpdatedDate, ETL_UpdatedDate
	FROM (
		SELECT MO.ETL_ID, MO.CustomerId, CASE WHEN MA.Email = '' THEN NULL ELSE MA.Email END AS Email, NULL AS Username,
			MA.FirstName, MA.LastName, CONVERT(NVARCHAR(25),MA.PhoneNumber) AS Phone, 0 AS Active,
			COALESCE(MO.CreatedOnUtc,MA.CreatedOnUtc) AS CreatedDate, NULL AS UpdatedDate, MO.ETL_UpdatedDate,
			'Guest' AS AccountType,
			ROW_NUMBER() OVER (PARTITION BY MO.CustomerId ORDER BY MA.Id DESC) RowNum
		FROM ods.Merch_Order MO
		LEFT JOIN ods.Merch_Address MA
			ON MO.BillingAddressId = MA.Id
		LEFT JOIN ods.Merch_Customer MC
			ON MO.CustomerId = MC.Id
		WHERE MC.Id IS NULL
		) DT2
	WHERE RowNum = 1
) A
WHERE 1=1

)























GO
