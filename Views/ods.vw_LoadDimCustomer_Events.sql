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
--drop view ods.vw_SOURCESYSTEM_LoadDimCustomer
CREATE VIEW [ods].[vw_LoadDimCustomer_Events] AS ( --Change "SOURCESYSTEM" to the correct source
 
    SELECT *
    /*Name*/
    , HASHBYTES('sha2_256',
                            ISNULL(RTRIM(Prefix),'DBNULL_TEXT') 
                            + ISNULL(RTRIM(FirstName),'DBNULL_TEXT')
                            + ISNULL(RTRIM(MiddleName),'DBNULL_TEXT')  
                            + ISNULL(RTRIM(LastName),'DBNULL_TEXT') 
                            + ISNULL(RTRIM(Suffix),'DBNULL_TEXT')
                            + ISNULL(RTRIM(Fullname),'DBNULL_TEXT')
                            + ISNULL(RTRIM(CompanyName),'DBNULL_TEXT')) AS [NameDirtyHash]
    , 'Dirty' AS [NameIsCleanStatus]
    , NULL AS [NameMasterId]
 
    /*Address*/
    , HASHBYTES('sha2_256', ISNULL(RTRIM(AddressPrimaryStreet),'DBNULL_TEXT') 
                            + ISNULL(RTRIM(AddressPrimarySuite),'DBNULL_TEXT')
                            + ISNULL(RTRIM(AddressPrimaryCity),'DBNULL_TEXT')
                            + ISNULL(RTRIM(AddressPrimaryState),'DBNULL_TEXT')  
                            + ISNULL(RTRIM(AddressPrimaryZip),'DBNULL_TEXT') 
                            + ISNULL(RTRIM(AddressPrimaryCounty),'DBNULL_TEXT')
                            + ISNULL(RTRIM(AddressPrimaryCountry),'DBNULL_TEXT')) AS [AddressPrimaryDirtyHash]
    , 'Dirty' AS [AddressPrimaryIsCleanStatus]
    , NULL AS [AddressPrimaryMasterId]
    , HASHBYTES('sha2_256', ISNULL(RTRIM(AddressOneStreet),'DBNULL_TEXT') 
                            + ISNULL(RTRIM(AddressOneSuite),'DBNULL_TEXT')
                            + ISNULL(RTRIM(AddressOneCity),'DBNULL_TEXT')
                            + ISNULL(RTRIM(AddressOneState),'DBNULL_TEXT')  
                            + ISNULL(RTRIM(AddressOneZip),'DBNULL_TEXT') 
                            + ISNULL(RTRIM(AddressOneCounty),'DBNULL_TEXT')
                            + ISNULL(RTRIM(AddressOneCountry),'DBNULL_TEXT')) AS [AddressOneDirtyHash]
    , 'Dirty' AS [AddressOneIsCleanStatus]
    , NULL AS [AddressOneMasterId]
    , HASHBYTES('sha2_256', ISNULL(RTRIM(AddressTwoStreet),'DBNULL_TEXT') 
                            + ISNULL(RTRIM(AddressTwoSuite),'DBNULL_TEXT')
                            + ISNULL(RTRIM(AddressTwoCity),'DBNULL_TEXT')
                            + ISNULL(RTRIM(AddressTwoState),'DBNULL_TEXT')  
                            + ISNULL(RTRIM(AddressTwoZip),'DBNULL_TEXT')
                            + ISNULL(RTRIM(AddressTwoCounty),'DBNULL_TEXT') 
                            + ISNULL(RTRIM(AddressTwoCountry),'DBNULL_TEXT')) AS [AddressTwoDirtyHash]
    , 'Dirty' AS [AddressTwoIsCleanStatus]
    , NULL AS [AddressTwoMasterId]
    , HASHBYTES('sha2_256', ISNULL(RTRIM(AddressThreeStreet),'DBNULL_TEXT') 
                            + ISNULL(RTRIM(AddressThreeSuite),'DBNULL_TEXT')
                            + ISNULL(RTRIM(AddressThreeCity),'DBNULL_TEXT')
                            + ISNULL(RTRIM(AddressThreeState),'DBNULL_TEXT')  
                            + ISNULL(RTRIM(AddressThreeZip),'DBNULL_TEXT') 
                            + ISNULL(RTRIM(AddressThreeCounty),'DBNULL_TEXT')
                            + ISNULL(RTRIM(AddressThreeCountry),'DBNULL_TEXT')) AS [AddressThreeDirtyHash]
    , 'Dirty' AS [AddressThreeIsCleanStatus]
    , NULL AS [AddressThreeMasterId]
    , HASHBYTES('sha2_256', ISNULL(RTRIM(AddressFourStreet),'DBNULL_TEXT') 
                            + ISNULL(RTRIM(AddressFourSuite),'DBNULL_TEXT')
                            + ISNULL(RTRIM(AddressFourCity),'DBNULL_TEXT')
                            + ISNULL(RTRIM(AddressFourState),'DBNULL_TEXT')  
                            + ISNULL(RTRIM(AddressFourZip),'DBNULL_TEXT')
                            + ISNULL(RTRIM(AddressFourCounty),'DBNULL_TEXT') 
                            + ISNULL(RTRIM(AddressFourCountry),'DBNULL_TEXT')) AS [AddressFourDirtyHash]
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
                            + ISNULL(RTRIM(AddressPrimaryCounty),'DBNULL_TEXT')
                            + ISNULL(RTRIM(AddressPrimaryCountry),'DBNULL_TEXT')) AS [ContactDirtyHash]
     
 
    /*Phone*/
    , HASHBYTES('sha2_256', ISNULL(RTRIM(PhonePrimary),'DBNULL_TEXT')) AS [PhonePrimaryDirtyHash]
    , 'Dirty' AS [PhonePrimaryIsCleanStatus]
    , NULL AS [PhonePrimaryMasterId]
    , HASHBYTES('sha2_256', ISNULL(RTRIM(PhoneHome),'DBNULL_TEXT')) AS [PhoneHomeDirtyHash]
    , 'Dirty' AS [PhoneHomeIsCleanStatus]
    , NULL AS [PhoneHomeMasterId]
    , HASHBYTES('sha2_256', ISNULL(RTRIM(PhoneCell),'DBNULL_TEXT')) AS [PhoneCellDirtyHash]
    , 'Dirty' AS [PhoneCellIsCleanStatus]
    , NULL AS [PhoneCellMasterId]
    , HASHBYTES('sha2_256', ISNULL(RTRIM(PhoneBusiness),'DBNULL_TEXT')) AS [PhoneBusinessDirtyHash]
    , 'Dirty' AS [PhoneBusinessIsCleanStatus]
    , NULL AS [PhoneBusinessMasterId]
    , HASHBYTES('sha2_256', ISNULL(RTRIM(PhoneFax),'DBNULL_TEXT')) AS [PhoneFaxDirtyHash]
    , 'Dirty' AS [PhoneFaxIsCleanStatus]
    , NULL AS [PhoneFaxMasterId]
    , HASHBYTES('sha2_256', ISNULL(RTRIM(PhoneOther),'DBNULL_TEXT')) AS [PhoneOtherDirtyHash]
    , 'Dirty' AS [PhoneOtherIsCleanStatus]
    , NULL AS [PhoneOtherMasterId]
 
    /*Email*/
    , HASHBYTES('sha2_256', ISNULL(RTRIM(EmailPrimary),'DBNULL_TEXT')) AS [EmailPrimaryDirtyHash]
    , 'Dirty' AS [EmailPrimaryIsCleanStatus]
    , NULL AS [EmailPrimaryMasterId]
    , HASHBYTES('sha2_256', ISNULL(RTRIM(EmailOne),'DBNULL_TEXT')) AS [EmailOneDirtyHash]
    , 'Dirty' AS [EmailOneIsCleanStatus]
    , NULL AS [EmailOneMasterId]
    , HASHBYTES('sha2_256', ISNULL(RTRIM(EmailTwo),'DBNULL_TEXT')) AS [EmailTwoDirtyHash]
    , 'Dirty' AS [EmailTwoIsCleanStatus]
    , NULL AS [EmailTwoMasterId]
     
    /*External Attributes*/
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
            'Steelers' AS [SourceDB] --Client Source Database such as Raiders or Raiders_Reporting
            , 'Events' AS [SourceSystem] --Put source name such as TM or CRM_Contact
            , NULL AS [SourceSystemPriority] --Depends on if client uses sourcesystem/sourcesystempriority tables for MDM Rules
 
            /*Standard Attributes*/
            , CAST(SSID AS NVARCHAR(200)) [SSID] -- Required, must be cast as NVARCHAR(200)
            , CAST(NULL AS NVARCHAR (50)) AS [CustomerType]
            , CAST(NULL AS NVARCHAR (50)) AS [CustomerStatus]
            , CAST(NULL AS NVARCHAR (50)) AS [AccountType] 
            , CAST(NULL AS NVARCHAR (50)) AS [AccountRep] 
            , CAST(NULL AS NVARCHAR (50)) AS [CompanyName] 
            , NULL AS [SalutationName]
            , NULL AS [DonorMailName]
            , NULL AS [DonorFormalName]
            , CONVERT(VARCHAR(30),z.Birth_Date, 102) AS [Birthday] -- field is sensitive see writup in sharepoint for an example of how complicated it can get
            , z.Gender AS [Gender] 
            , 0 [MergedRecordFlag]
            , NULL [MergedIntoSSID]
 
            /**ENTITIES**/
            /*Name*/
            , NULL AS [Prefix]
            , z.First_Name AS [FirstName]
            , NULL AS [MiddleName]
            , z.Last_Name AS [LastName]
            , z.Suffix AS [Suffix]
            , NULL AS [Fullname]
            --, c.name_title as [Title]
 
            /*AddressPrimary*/
            , Address_Street	AS [AddressPrimaryStreet] -- dont load suites combine addresses with multiple lines and load to street eg. CASE WHEN ISNULL(address2,'') <> '' THEN z.street + ' ' + z.address2 ELSE z.street END AS [AddressPrimaryStreet]
            , Address_Suite		AS [AddressPrimarySuite] -- ALWAYS LEAVE THIS NULL!!!!!!!!!!!!!!!!
            , Address_City		AS [AddressPrimaryCity] 
            , Address_State		AS [AddressPrimaryState] 
            , Address_Zip		AS [AddressPrimaryZip] 
            , NULL AS [AddressPrimaryCounty]
            , Address_Country	AS [AddressPrimaryCountry] 
             
            , NULL AS [AddressOneStreet]
            , NULL AS [AddressOneSuite] -- ALWAYS LEAVE THIS NULL!!!!!!!!!!!!!!!!
            , NULL AS [AddressOneCity] 
            , NULL AS [AddressOneState] 
            , NULL AS [AddressOneZip] 
            , NULL AS [AddressOneCounty] 
            , NULL AS [AddressOneCountry] 
            , NULL AS [AddressTwoStreet]
            , NULL AS [AddressTwoSuite] -- ALWAYS LEAVE THIS NULL!!!!!!!!!!!!!!!!
            , NULL AS [AddressTwoCity] 
            , NULL AS [AddressTwoState] 
            , NULL AS [AddressTwoZip] 
            , NULL AS [AddressTwoCounty] 
            , NULL AS [AddressTwoCountry] 
            , NULL AS [AddressThreeStreet]
            , NULL AS [AddressThreeSuite] -- ALWAYS LEAVE THIS NULL!!!!!!!!!!!!!!!!
            , NULL AS [AddressThreeCity] 
            , NULL AS [AddressThreeState] 
            , NULL AS [AddressThreeZip] 
            , NULL AS [AddressThreeCounty] 
            , NULL AS [AddressThreeCountry] 
            , NULL AS [AddressFourStreet]
            , NULL AS [AddressFourSuite] -- ALWAYS LEAVE THIS NULL!!!!!!!!!!!!!!!!
            , NULL AS [AddressFourCity] 
            , NULL AS [AddressFourState] 
            , NULL AS [AddressFourZip] 
            , NULL AS [AddressFourCounty]
            , NULL AS [AddressFourCountry] 
 
            /*Phone*/
            , LEFT(Phone_Primary,25) AS [PhonePrimary] -- For Coalescing values make sute they are wrapped in a NULLIF for values that = '' eg COALESCE(NULLIF(z.mobile,''),z.phone) AS [PhonePrimary]
            , LEFT(NULL,25) AS [PhoneHome]
            , LEFT(Phone_Cell,25) AS [PhoneCell]
            , LEFT(NULL,25) AS [PhoneBusiness]
            , LEFT(NULL,25) AS [PhoneFax]
            , LEFT(NULL,25) AS [PhoneOther]
 
            /*Email*/
            , CAST(Email AS NVARCHAR(256)) AS [EmailPrimary]
            , CAST(NULL AS NVARCHAR(256)) AS [EmailOne]
            , CAST(NULL AS NVARCHAR(256)) AS [EmailTwo]
 
            /*Extended Attributes*/
            , NULL AS[ExtAttribute1] --nvarchar(100)
            , NULL AS[ExtAttribute2] --nvarchar(100)
            , NULL AS[ExtAttribute3] --nvarchar(100)
            , NULL AS[ExtAttribute4] --nvarchar(100)
            , NULL AS[ExtAttribute5] --nvarchar(100)
            , NULL AS[ExtAttribute6] --nvarchar(100)
            , NULL AS[ExtAttribute7] --nvarchar(100)
            , NULL AS[ExtAttribute8] --nvarchar(100)
            , NULL AS[ExtAttribute9] --nvarchar(100)
            , NULL AS[ExtAttribute10] --nvarchar(1000)
 
            , NULL AS [ExtAttribute11] --decimal(18,6)
            , NULL AS [ExtAttribute12] --decimal(18,6)
            , NULL AS [ExtAttribute13] --decimal(18,6)
            , NULL AS [ExtAttribute14] --decimal(18,6)
            , NULL AS [ExtAttribute15] --decimal(18,6)
            , NULL AS [ExtAttribute16] --decimal(18,6)
            , NULL AS [ExtAttribute17] --decimal(18,6)
            , NULL AS [ExtAttribute18] --decimal(18,6)
            , NULL AS [ExtAttribute19] --decimal(18,6)
            , NULL AS [ExtAttribute20] --decimal(18,6) 
 
            , NULL AS [ExtAttribute21] --datetime
            , NULL AS [ExtAttribute22] --datetime
            , NULL AS [ExtAttribute23] --datetime
            , NULL AS [ExtAttribute24] --datetime
            , NULL AS [ExtAttribute25] --datetime
            , NULL AS [ExtAttribute26] --datetime
            , NULL AS [ExtAttribute27] --datetime
            , NULL AS [ExtAttribute28] --datetime
            , NULL AS [ExtAttribute29] --datetime
            , NULL AS [ExtAttribute30] --datetime 
            , NULL AS [ExtAttribute31] --nvarchar(max)
            , NULL as [ExtAttribute32] --nvarchar(max)
            , NULL as [ExtAttribute33] --nvarchar(max)
            , NULL as [ExtAttribute34] --nvarchar(max)
            , NULL as [ExtAttribute35] --nvarchar(max)
 
            /*Source Created and Updated*/
            , NULL [SSCreatedBy] --createdby
            , NULL [SSUpdatedBy] --lastmodifiedbyid
            , NULL [SSCreatedDate] --createddate
            , NULL [SSUpdatedDate] --lastmodifiedbyid
            , getdate () as createddate --required fields, do not comment out
            , getdate () as updateddate --required fields, do not comment out
            , NULL [AccountId]
            , 0 AS IsBusiness --can be updated with business logic if there is some to determine business
            , 0 AS IsDeleted --Update if there is logic for records that are deleted from the source, otherwise leave as 0
            , NULL AS [Customer_Matchkey] /*Standard for macthkeys are TM-xxxx, Pac-xxxx depending on source, 
                                            Customer Matchkey needs to have fairly complicated logic. 
                                            See Writup for details. Matchkey must take blank values into account and set those to NULL
                                            in order to avoid unintended matches*/
        --SELECT COUNT(*)           
        FROM etl.Data_Uploader_Customer_Events z WITH (NOLOCK) --Change To Source Table
        WHERE 1=1
        --AND DATEDIFF(DAY,z.lastModified,GETDATE())<=10 OR DATEDIFF(DAY,z.added,GETDATE())<=10 --This needs to be uncommented out and updated to the correct fields after the first load, update the date fields
    ) a
 
)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
GO
