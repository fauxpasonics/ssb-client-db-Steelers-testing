SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







/*****Hash Rules for Reference******
WHEN 'int' THEN 'ISNULL(RTRIM(CONVERT(varchar(10),' + COLUMN_NAME + ')),''DBNULL_INT'')'
WHEN 'bigint' THEN 'ISNULL(RTRIM(CONVERT(varchar(10),' + COLUMN_NAME + ')),''DBNULL_BIGINT'')'
WHEN 'datetime' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),' + COLUMN_NAME + ')),''DBNULL_DATETIME'')'  
WHEN 'datetime2' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),' + COLUMN_NAME + ')),''DBNULL_DATETIME'')'
WHEN 'date' THEN 'ISNULL(RTRIM(CONVERT(varchar(10),' + COLUMN_NAME + ',112)),''DBNULL_DATE'')' 
WHEN 'bit' THEN 'ISNULL(RTRIM(CONVERT(varchar(10),' + COLUMN_NAME + ')),''DBNULL_BIT'')'  
WHEN 'decimal' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),'+ COLUMN_NAME + ')),''DBNULL_NUMBER'')' 
WHEN 'numeric' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),'+ COLUMN_NAME + ')),''DBNULL_NUMBER'')' 
ELSE 'ISNULL(RTRIM(' + COLUMN_NAME + '),''DBNULL_TEXT'')'
*****/

CREATE VIEW [etl].[vw_Load_DimCustomer_Merch] AS 

(

	SELECT *
	/*Name*/
	, HASHBYTES('sha2_256',
							ISNULL(RTRIM(FullName),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(Prefix),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(FirstName),'DBNULL_TEXT')
							+ ISNULL(RTRIM(MiddleName),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(LastName),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(Suffix),'DBNULL_TEXT')
							+ ISNULL(RTRIM(CompanyName),'DBNULL_TEXT')
							) AS [NameDirtyHash]
	, 'Dirty' AS [NameIsCleanStatus]
	, NULL AS [NameMasterId]

	/*Address*/
	/*Address*/
	, HASHBYTES('sha2_256', ISNULL(RTRIM(AddressPrimaryStreet),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressPrimarySuite),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressPrimaryCity),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressPrimaryState),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AddressPrimaryZip),'DBNULL_TEXT') 
							---+ ISNULL(RTRIM(AddressPrimaryCounty),'DBNULL_TEXT')
							---+ ISNULL(RTRIM(AddressPrimaryCountry),'DBNULL_TEXT')
							) AS [AddressPrimaryDirtyHash]
	, 'Dirty' AS [AddressPrimaryIsCleanStatus]
	, NULL AS [AddressPrimaryMasterId]
	, HASHBYTES('sha2_256', ISNULL(RTRIM(AddressOneStreet),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressOneSuite),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressOneCity),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressOneState),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AddressOneZip),'DBNULL_TEXT') 
							---+ ISNULL(RTRIM(AddressOneCounty),'DBNULL_TEXT')
							---+ ISNULL(RTRIM(AddressOneCountry),'DBNULL_TEXT')
							) AS [AddressOneDirtyHash]
	, 'Dirty' AS [AddressOneIsCleanStatus]
	, NULL AS [AddressOneMasterId]
	, HASHBYTES('sha2_256', ISNULL(RTRIM(AddressTwoStreet),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressTwoSuite),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressTwoCity),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressTwoState),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AddressTwoZip),'DBNULL_TEXT')
							---+ ISNULL(RTRIM(AddressTwoCounty),'DBNULL_TEXT') 
							---+ ISNULL(RTRIM(AddressTwoCountry),'DBNULL_TEXT')
							) AS [AddressTwoDirtyHash]
	, 'Dirty' AS [AddressTwoIsCleanStatus]
	, NULL AS [AddressTwoMasterId]
	, HASHBYTES('sha2_256', ISNULL(RTRIM(AddressThreeStreet),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressThreeSuite),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressThreeCity),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressThreeState),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AddressThreeZip),'DBNULL_TEXT') 
							---+ ISNULL(RTRIM(AddressThreeCounty),'DBNULL_TEXT')
							---+ ISNULL(RTRIM(AddressThreeCountry),'DBNULL_TEXT')
							) AS [AddressThreeDirtyHash]
	, 'Dirty' AS [AddressThreeIsCleanStatus]
	, NULL AS [AddressThreeMasterId]
	, HASHBYTES('sha2_256', ISNULL(RTRIM(AddressFourStreet),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressFourSuite),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressFourCity),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressFourState),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AddressFourZip),'DBNULL_TEXT')
							---+ ISNULL(RTRIM(AddressFourCounty),'DBNULL_TEXT') 
							---+ ISNULL(RTRIM(AddressFourCountry),'DBNULL_TEXT')
							) AS [AddressFourDirtyHash]
	, 'Dirty' AS [AddressFourIsCleanStatus]
	, NULL AS [AddressFourMasterId]

	/*Contact*/
	, HASHBYTES('sha2_256', ISNULL(RTRIM(Prefix),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(FirstName),'DBNULL_TEXT')
							+ ISNULL(RTRIM(MiddleName),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(LastName),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(Suffix),'DBNULL_TEXT')+ ISNULL(RTRIM(AddressPrimaryStreet),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressPrimarySuite),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressPrimaryCity),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressPrimaryState),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AddressPrimaryZip),'DBNULL_TEXT') 
							--+ ISNULL(RTRIM(AddressPrimaryCounty),'DBNULL_TEXT')
							--+ ISNULL(RTRIM(AddressPrimaryCountry),'DBNULL_TEXT')
							) AS [ContactDirtyHash]

	/*Phone*/
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhonePrimary),'DBNULL_TEXT')) AS [PhonePrimaryDirtyHash]
	, 'Dirty' AS [PhonePrimaryIsCleanStatus]
	, NULL AS [PhonePrimaryMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhoneHome),'DBNULL_TEXT')) AS [PhoneHomeDirtyHash]
	, 'Dirty' AS [PhoneHomeIsCleanStatus]
	, NULL AS [PhoneHomeMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhoneCell),'DBNULL_TEXT')) AS [PhoneCellDirtyHash]
	, 'Dirty' AS [PhoneCellIsCleanStatus]
	, NULL AS [PhoneCellMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhoneBusiness),'DBNULL_TEXT')) AS [PhoneBusinessDirtyHash]
	, 'Dirty' AS [PhoneBusinessIsCleanStatus]
	, NULL AS [PhoneBusinessMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhoneFax),'DBNULL_TEXT')) AS [PhoneFaxDirtyHash]
	, 'Dirty' AS [PhoneFaxIsCleanStatus]
	, NULL AS [PhoneFaxMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhoneOther),'DBNULL_TEXT')) AS [PhoneOtherDirtyHash]
	, 'Dirty' AS [PhoneOtherIsCleanStatus]
	, NULL AS [PhoneOtherMasterId]

	/*Email*/
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(EmailPrimary),'DBNULL_TEXT')) AS [EmailPrimaryDirtyHash]
	, 'Dirty' AS [EmailPrimaryIsCleanStatus]
	, NULL AS [EmailPrimaryMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(EmailOne),'DBNULL_TEXT')) AS [EmailOneDirtyHash]
	, 'Dirty' AS [EmailOneIsCleanStatus]
	, NULL AS [EmailOneMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(EmailTwo),'DBNULL_TEXT')) AS [EmailTwoDirtyHash]
	, 'Dirty' AS [EmailTwoIsCleanStatus]
	, NULL AS [EmailTwoMasterId]

	
	/*Attributes*/
, HASHBYTES('sha2_256', ISNULL(RTRIM(customerType),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(CustomerStatus),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AccountType),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AccountRep),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(CompanyName),'DBNULL_TEXT')
							+ ISNULL(RTRIM(SalutationName),'DBNULL_TEXT')
							+ ISNULL(RTRIM(DonorMailName),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(DonorFormalName),'DBNULL_TEXT')
							+ ISNULL(RTRIM(Birthday),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(Gender),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AccountId),'DBNULL_TEXT')
							+ ISNULL(RTRIM(MergedRecordFlag),'DBNULL_TEXT')
							+ ISNULL(RTRIM(MergedIntoSSID),'DBNULL_TEXT')
							+ ISNULL(RTRIM(IsBusiness),'DBNULL_TEXT')) AS [contactattrDirtyHash]

, HASHBYTES('sha2_256', ISNULL(RTRIM(ExtAttribute1),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute2),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute3),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute4),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute5),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute6),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute7),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute8),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute9),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute10),'DBNULL_TEXT') 
							) AS [extattr1_10DirtyHash]

							, HASHBYTES('sha2_256', ISNULL(RTRIM(ExtAttribute11),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute12),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute13),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute14),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute15),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute16),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute17),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute18),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute19),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute20),'DBNULL_TEXT') 
							) AS [extattr11_20DirtyHash]

							
, HASHBYTES('sha2_256', ISNULL(RTRIM(ExtAttribute21),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute22),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute23),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute24),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute25),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute26),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute27),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute28),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute29),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute30),'DBNULL_TEXT') 
							) AS [extattr21_30DirtyHash]

							
, HASHBYTES('sha2_256', ISNULL(RTRIM(ExtAttribute31),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute32),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute33),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute34),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute35),'DBNULL_TEXT')
							) AS [extattr31_35DirtyHash]




	FROM (


--base set
		SELECT 
			DB_NAME() AS [SourceDB]
			, (SELECT etl.fnGetClientSetting('Merch-SourceSystem')) AS [SourceSystem]
			, 0 AS [SourceSystemPriority]

			/*Standard Attributes*/
			, CAST(DT.CustomerId AS NVARCHAR(100)) [SSID]
			, NULL AS [CustomerType]
			, NULL AS [CustomerStatus]
			, NULL AS [AccountType] 
			, NULL AS [AccountRep] 
			, NULL AS [CompanyName] 
			, NULL AS [SalutationName]
			, NULL AS [DonorMailName]
			, NULL AS [DonorFormalName]
			, CAST(NULL AS DATE) AS [Birthday]
			, NULL AS [Gender] 
			, 0 AS [MergedRecordFlag]
			, NULL AS [MergedIntoSSID]

			/**ENTITIES**/
			/*Name*/
			, NULL AS [Prefix]
			, DT.FirstName AS [FirstName]
			, NULL AS [MiddleName]
			, DT.LastName AS [LastName]
			, NULL AS [Suffix]
			, concat(DT.FirstName, ' ', DT.LAstName) as [FullName]

			/*AddressPrimary*/
            , CASE 
				WHEN ISNULL(DT.Address1,'') = ISNULL(DT.Address2,'') THEN DT.Address1
				ELSE CONCAT(DT.Address1,'',DT.Address2)
				END AS [AddressPrimaryStreet]
			, DT.City AS [AddressPrimaryCity] 
			, DT.[State] AS [AddressPrimaryState] 
			, DT.ZipCode AS [AddressPrimaryZip] 
			, NULL AS [AddressPrimaryCounty]
			, DT.Country AS [AddressPrimaryCountry]
						
			, NULL AS [AddressOneStreet]
			, NULL AS [AddressOneCity] 
			, NULL AS [AddressOneState] 
			, NULL AS [AddressOneZip] 
			, NULL AS [AddressOneCounty] 
			, NULL AS [AddressOneCountry] 
			, NULL AS [AddressTwoStreet]
			, NULL AS [AddressTwoCity] 
			, NULL AS [AddressTwoState] 
			, NULL AS [AddressTwoZip] 
			, NULL AS [AddressTwoCounty] 
			, NULL AS [AddressTwoCountry] 
			, NULL AS [AddressThreeStreet]
			, NULL AS [AddressThreeCity] 
			, NULL AS [AddressThreeState] 
			, NULL AS [AddressThreeZip] 
			, NULL AS [AddressThreeCounty] 
			, NULL AS [AddressThreeCountry] 
			, NULL AS [AddressFourStreet]
			, NULL AS [AddressFourCity] 
			, NULL AS [AddressFourState] 
			, NULL AS [AddressFourZip] 
			, NULL AS [AddressFourCounty]
			, NULL AS [AddressFourCountry]
			, NULL AS [AddressPrimarySuite]
			, NULL AS [AddressOneSuite]
			, NULL AS [AddressTwoSuite]
			, NULL AS [AddressThreeSuite]
			, NULL AS [AddressFourSuite] 

			/*Phone*/
			, DT.PhoneNumber AS [PhonePrimary]
			, NULL AS [PhoneHome]
			, NULL AS [PhoneCell]
			, NULL AS [PhoneBusiness]
			, NULL AS [PhoneFax]
			, NULL AS [PhoneOther]

			/*Email*/
			, DT.Email AS [EmailPrimary]
			, NULL AS [EmailOne]
			, NULL AS [EmailTwo]

			/*Extended Attributes*/
			, DT.PlacedOrderInd AS [ExtAttribute1]	-- nvarchar(100) 
			, NULL AS [ExtAttribute2]	--DT.LoyaltyId AS [ExtAttribute2] 
			, NULL AS [ExtAttribute3]	--DT.ActiveLoyaltyInd AS [ExtAttribute3] 
			, NULL AS [ExtAttribute4]	--DT.PlacedLoyaltyOrderInd AS [ExtAttribute4]
			, DT.CustomerType AS [ExtAttribute5] 
			, NULL AS[ExtAttribute6] 
			, NULL AS[ExtAttribute7] 
			, NULL AS[ExtAttribute8] 
			, NULL AS[ExtAttribute9] 
			, NULL AS[ExtAttribute10] 

			, NULL AS [ExtAttribute11] 
			, NULL AS [ExtAttribute12] 
			, NULL AS [ExtAttribute13] 
			, NULL AS [ExtAttribute14] 
			, NULL AS [ExtAttribute15] 
			, NULL AS [ExtAttribute16] 
			, NULL AS [ExtAttribute17] 
			, NULL AS [ExtAttribute18] 
			, NULL AS [ExtAttribute19] 
			, NULL AS [ExtAttribute20]  

			, NULL AS [ExtAttribute21] --datetime
			, NULL AS [ExtAttribute22] 
			, NULL AS [ExtAttribute23] 
			, NULL AS [ExtAttribute24] 
			, NULL AS [ExtAttribute25] 
			, NULL AS [ExtAttribute26] 
			, NULL AS [ExtAttribute27] 
			, NULL AS [ExtAttribute28] 
			, NULL AS [ExtAttribute29] 
			, NULL AS [ExtAttribute30]  
			, NULL AS [ExtAttribute31] --datetime
			, NULL AS [ExtAttribute32] 
			, NULL AS [ExtAttribute33] 
			, NULL AS [ExtAttribute34] 
			, NULL AS [ExtAttribute35] 

			/*Source Created and Updated*/
			, NULL AS [SSCreatedBy]
			, NULL AS [SSUpdatedBy]
			, CAST(DT.FirstOrderDate AS DATETIME) AS [SSCreatedDate]
			, CAST(DT.FirstOrderDate AS DATETIME) AS [CreatedDate]
			, CAST(DT.LastOrderDate AS DATETIME) AS [SSUpdatedDate]

			, NULL AS [AccountId]
			, NULL AS IsBusiness
			, 0 AS IsDeleted
			
		FROM (
			SELECT MO.CustomerId
			, MA.FirstName
			, MA.LastName
			, MA.Address1
			, MA.Address2
			, MA.City
			, MSP.Abbreviation [State] 
			, MA.ZipPostalCode ZipCode
			, MC.Name Country
			, MA.PhoneNumber
			, COALESCE(MO.Email, MA.Email) Email
--			, ISNULL(SNU.SnuId,0) AS LoyaltyId
--			, CASE WHEN ISNULL(SNU.[Status],'') = 'active' THEN 1 ELSE 0 END AS ActiveLoyaltyInd
--			, CASE WHEN SNUOI.SnuId IS NOT NULL THEN 1 ELSE 0 END AS PlacedLoyaltyOrderInd
			, MINMAX.FirstOrderDate
			, MINMAX.LastOrderDate
			, 'Registered' AS CustomerType
			, 1 AS PlacedOrderInd
			FROM (SELECT MC.Id CustomerId, MO.BillingAddressId, MC.Email,
						ROW_NUMBER() OVER (PARTITION BY MC.Id ORDER BY MO.Deleted, MO.CreatedOnUtc DESC) RowNum
					FROM ods.Merch_Customer MC WITH (NOLOCK)
					JOIN ods.Merch_Order MO WITH (NOLOCK)
						ON MC.Id = MO.CustomerId
					WHERE MO.StoreId = 1
				) MO
			JOIN (SELECT CustomerId, MIN(CreatedOnUtc) FirstOrderDate, MAX(CreatedOnUtc) LastOrderDate
					FROM ods.Merch_Order WITH (NOLOCK)
					GROUP BY CustomerId) MINMAX
				ON MO.CustomerId = MINMAX.CustomerId  
			JOIN ods.Merch_Address MA WITH (NOLOCK)
				ON MO.BillingAddressId = MA.Id
			JOIN ods.Merch_Country MC WITH (NOLOCK)
				ON MA.CountryId = MC.Id
			LEFT JOIN ods.Merch_StateProvince MSP WITH (NOLOCK)
				ON MA.StateProvinceId = MSP.Id
			WHERE MO.RowNum = 1
			GROUP BY MO.CustomerId
				, MA.FirstName
				, MA.LastName
				, MA.Address1
				, MA.Address2
				, MA.City
				, MSP.Abbreviation  
				, MA.ZipPostalCode 
				, MC.Name 
				, MA.PhoneNumber
				, COALESCE(MO.Email, MA.Email) 
--				, ISNULL(SNU.SnuId,0)
--				, CASE WHEN ISNULL(SNU.[Status],'') = 'active' THEN 1 ELSE 0 END
--				, CASE WHEN SNUOI.SnuId IS NOT NULL THEN 1 ELSE 0 END
				, MINMAX.FirstOrderDate
				, MINMAX.LastOrderDate

			UNION

			SELECT MO.CustomerId
			, MA.FirstName
			, MA.LastName
			, MA.Address1
			, MA.Address2
			, MA.City
			, MSP.Abbreviation [State] 
			, MA.ZipPostalCode ZipCode
			, MC.Name Country
			, MA.PhoneNumber
			, MA.Email
--			, ISNULL(SNU.SnuId,0) AS LoyaltyId
--			, CASE WHEN ISNULL(SNU.[Status],'') = 'active' THEN 1 ELSE 0 END AS ActiveLoyaltyInd
--			, CASE WHEN SNUOI.SnuId IS NOT NULL THEN 1 ELSE 0 END AS PlacedLoyaltyOrderInd
			, MINMAX.FirstOrderDate
			, MINMAX.LastOrderDate
			, 'Guest' AS CustomerType
			, 1 AS PlacedOrderInd
			FROM (SELECT MO.CustomerId, MO.BillingAddressId,
						ROW_NUMBER() OVER (PARTITION BY MO.CustomerId ORDER BY MO.Deleted, MO.CreatedOnUtc DESC) RowNum
					FROM ods.Merch_Order MO WITH (NOLOCK)
					LEFT JOIN ods.Merch_Customer MC WITH (NOLOCK)
						ON MC.Id = MO.CustomerId
					WHERE MC.Id IS NULL
					AND MO.StoreId = 1
				) MO
			JOIN (SELECT CustomerId, MIN(CreatedOnUtc) FirstOrderDate, MAX(CreatedOnUtc) LastOrderDate
					FROM ods.Merch_Order (NOLOCK)
					GROUP BY CustomerId
				  ) MINMAX ON MO.CustomerId = MINMAX.CustomerId  
			JOIN ods.Merch_Address MA WITH (NOLOCK) ON MO.BillingAddressId = MA.Id
			JOIN ods.Merch_Country MC WITH (NOLOCK) ON MA.CountryId = MC.Id
			LEFT JOIN ods.Merch_StateProvince MSP WITH (NOLOCK) ON MA.StateProvinceId = MSP.Id
			WHERE MO.RowNum = 1
			GROUP BY MO.CustomerId
				, MA.FirstName
				, MA.LastName
				, MA.Address1
				, MA.Address2
				, MA.City
				, MSP.Abbreviation  
				, MA.ZipPostalCode 
				, MC.Name 
				, MA.PhoneNumber
				, MA.Email 
--				, ISNULL(SNU.SnuId,0)
--				, CASE WHEN ISNULL(SNU.[Status],'') = 'active' THEN 1 ELSE 0 END
--				, CASE WHEN SNUOI.SnuId IS NOT NULL THEN 1 ELSE 0 END
				, MINMAX.FirstOrderDate
				, MINMAX.LastOrderDate
		) DT
		WHERE 1=1
		AND LastOrderDate > DATEADD(DAY,-3,GETDATE())
	) a

)
























GO
