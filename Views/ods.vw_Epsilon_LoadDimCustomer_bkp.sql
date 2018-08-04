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

CREATE VIEW [ods].[vw_Epsilon_LoadDimCustomer_bkp] AS (

	SELECT *

	/*Name*/
	, HASHBYTES('sha2_256',
							ISNULL(RTRIM(Prefix),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(FirstName),'DBNULL_TEXT')
							+ ISNULL(RTRIM(MiddleName),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(LastName),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(Suffix),'DBNULL_TEXT')) AS [NameDirtyHash]
	, NULL AS [NameIsCleanStatus]
	, NULL AS [NameMasterId]

	/*Address*/
	, HASHBYTES('sha2_256', ISNULL(RTRIM(AddressPrimaryStreet),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressPrimaryCity),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressPrimaryState),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AddressPrimaryZip),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressPrimaryCounty),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressPrimaryCountry),'DBNULL_TEXT')) AS [AddressPrimaryDirtyHash]
	, NULL AS [AddressPrimaryIsCleanStatus]
	, NULL AS [AddressPrimaryMasterId]
	, HASHBYTES('sha2_256', ISNULL(RTRIM(AddressOneStreet),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressOneCity),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressOneState),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AddressOneZip),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressOneCounty),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressOneCountry),'DBNULL_TEXT')) AS [AddressOneDirtyHash]
	, NULL AS [AddressOneIsCleanStatus]
	, NULL AS [AddressOneMasterId]
	, HASHBYTES('sha2_256', ISNULL(RTRIM(AddressTwoStreet),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressTwoCity),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressTwoState),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AddressTwoZip),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressTwoCounty),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressTwoCountry),'DBNULL_TEXT')) AS [AddressTwoDirtyHash]
	, NULL AS [AddressTwoIsCleanStatus]
	, NULL AS [AddressTwoMasterId]
	, HASHBYTES('sha2_256', ISNULL(RTRIM(AddressThreeStreet),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressThreeCity),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressThreeState),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AddressThreeZip),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressThreeCounty),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressThreeCountry),'DBNULL_TEXT')) AS [AddressThreeDirtyHash]
	, NULL AS [AddressThreeIsCleanStatus]
	, NULL AS [AddressThreeMasterId]
	, HASHBYTES('sha2_256', ISNULL(RTRIM(AddressFourStreet),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressFourCity),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressFourState),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AddressFourZip),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressFourCounty),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressFourCountry),'DBNULL_TEXT')) AS [AddressFourDirtyHash]
	, NULL AS [AddressFourIsCleanStatus]
	, NULL AS [AddressFourMasterId]

	/*Contact*/
	, HASHBYTES('sha2_256', ISNULL(RTRIM(Prefix),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(FirstName),'DBNULL_TEXT')
							+ ISNULL(RTRIM(MiddleName),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(LastName),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(Suffix),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressPrimaryStreet),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressPrimaryCity),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressPrimaryState),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AddressPrimaryZip),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressPrimaryCounty),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressPrimaryCountry),'DBNULL_TEXT')) AS [ContactDirtyHash]
	,  CAST(NULL as nvarchar(50)) AS [ContactGuid]

	/*Phone*/
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhonePrimary),'DBNULL_TEXT')) AS [PhonePrimaryDirtyHash]
	, NULL AS [PhonePrimaryIsCleanStatus]
	, NULL AS [PhonePrimaryMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhoneHome),'DBNULL_TEXT')) AS [PhoneHomeDirtyHash]
	, NULL AS [PhoneHomeIsCleanStatus]
	, NULL AS [PhoneHomeMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhoneCell),'DBNULL_TEXT')) AS [PhoneCellDirtyHash]
	, NULL AS [PhoneCellIsCleanStatus]
	, NULL AS [PhoneCellMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhoneBusiness),'DBNULL_TEXT')) AS [PhoneBusinessDirtyHash]
	, NULL AS [PhoneBusinessIsCleanStatus]
	, NULL AS [PhoneBusinessMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhoneFax),'DBNULL_TEXT')) AS [PhoneFaxDirtyHash]
	, NULL AS [PhoneFaxIsCleanStatus]
	, NULL AS [PhoneFaxMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhoneOther),'DBNULL_TEXT')) AS [PhoneOtherDirtyHash]
	, NULL AS [PhoneOtherIsCleanStatus]
	, NULL AS [PhoneOtherMasterId]

	/*Email*/
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(EmailPrimary),'DBNULL_TEXT')) AS [EmailPrimaryDirtyHash]
	, NULL AS [EmailPrimaryIsCleanStatus]
	, NULL AS [EmailPrimaryMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(EmailOne),'DBNULL_TEXT')) AS [EmailOneDirtyHash]
	, NULL AS [EmailOneIsCleanStatus]
	, NULL AS [EmailOneMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(EmailTwo),'DBNULL_TEXT')) AS [EmailTwoDirtyHash]
	, NULL AS [EmailTwoIsCleanStatus]
	, NULL AS [EmailTwoMasterId]

	FROM (
--base set
		SELECT 
			DB_NAME() AS [SourceDB]
			, (SELECT etl.fnGetClientSetting('Epsilon-SourceSystem')) AS [SourceSystem]
			, 0 AS [SourceSystemPriority]

			/*Standard Attributes*/
			, E.CustomerKey AS [SSID]
			, NULL AS [CustomerType]
			, NULL AS [CustomerStatus]
			, NULL AS [AccountType] 
			, NULL AS [AccountRep] 
			, NULL AS [CompanyName] 
			, NULL AS [SalutationName]
			, NULL AS [DonorMailName]
			, NULL AS [DonorFormalName]
			, CASE WHEN TRY_CAST(E.DOB AS DATE) IS NULL OR E.DOB = '' THEN NULL ELSE CONVERT(DATE,E.DOB) END AS [Birthday]
			, CASE WHEN E.GENDER = '' THEN NULL ELSE E.GENDER END AS [Gender] 
			, 0 AS [MergedRecordFlag]
			, NULL AS [MergedIntoSSID]

			/**ENTITIES**/
			/*Name*/
			, CAST(NULL AS NVARCHAR(100)) AS [Prefix]
			, CAST(CASE WHEN E.FIRSTNAME = '' THEN NULL ELSE E.FIRSTNAME END AS NVARCHAR(100)) AS [FirstName]
			, CAST(NULL AS NVARCHAR(100)) AS [MiddleName]
			,CAST(CASE WHEN E.LASTNAME = '' THEN NULL ELSE E.LASTNAME END AS NVARCHAR(100)) AS [LastName]
			, CAST(NULL AS NVARCHAR(100)) AS [Suffix]

			/*AddressPrimary*/
            , CAST(CASE WHEN 
				CASE WHEN ISNULL(E.AddressLine1,'') = ISNULL(E.AddressLine2,'') THEN E.AddressLine1	ELSE CONCAT(E.AddressLine1,'',E.AddressLine2) END = '' THEN NULL
				ELSE CASE WHEN ISNULL(E.AddressLine1,'') = ISNULL(E.AddressLine2,'') THEN E.AddressLine1 ELSE CONCAT(E.AddressLine1,'',E.AddressLine2) END
				END AS NVARCHAR(500)) AS [AddressPrimaryStreet]
			, CAST(CASE WHEN E.CITY = '' THEN NULL ELSE E.CITY END AS NVARCHAR(200)) AS [AddressPrimaryCity] 
			, CAST(CASE WHEN E.[STATE] = '' THEN NULL ELSE E.[STATE] END AS NVARCHAR(200)) AS [AddressPrimaryState] 
			, CAST(CASE WHEN E.PostalCode = '' THEN NULL ELSE E.PostalCode END AS NVARCHAR(200))AS [AddressPrimaryZip] 
			, CAST(NULL AS NVARCHAR(200)) AS [AddressPrimaryCounty]
			, CAST(CASE WHEN E.COUNTRY = '' THEN NULL ELSE LTRIM(E.COUNTRY) END AS NVARCHAR(200)) AS [AddressPrimaryCountry]
						
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

			/*Phone*/
			, NULL AS [PhonePrimary]
			, NULL AS [PhoneHome]
			, NULL AS [PhoneCell]
			, NULL AS [PhoneBusiness]
			, NULL AS [PhoneFax]
			, NULL AS [PhoneOther]

			/*Email*/
			, CAST(CASE WHEN E.EmailAddress = '' THEN NULL ELSE E.EmailAddress END AS NVARCHAR(256)) AS [EmailPrimary]
			, NULL AS [EmailOne]
			, NULL AS [EmailTwo]

			/*Extended Attributes*/
			, NULL AS [ExtAttribute1]	-- nvarchar(100) 
			, NULL AS [ExtAttribute2]
			, CAST(CASE WHEN E.SNU_STATUS = '' THEN NULL ELSE E.SNU_STATUS END AS NVARCHAR(100)) AS [ExtAttribute3]
			, NULL AS [ExtAttribute4]
			, NULL AS [ExtAttribute5] 
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

			/*Source Created and Updated*/
			, NULL AS [SSCreatedBy]
			, NULL AS [SSUpdatedBy]
			, TRY_CAST(E.JoinDate AS DATETIME) AS [SSCreatedDate]
			, TRY_CAST(E.JoinDate AS DATETIME) AS [CreatedDate]
			, TRY_CAST(E.ModifiedDate AS DATETIME) AS [SSUpdatedDate]

			, NULL AS [AccountId]
			, NULL AS IsBusiness
			, 'Epsilon - ' + E.CustomerKey customer_matchkey

--		select top 1000 *			
		FROM ods.Epsilon_Profile_Updates E
		WHERE E.ETL_UpdatedDate > DATEADD(day,-10,GETDATE())

	) a

)






GO
